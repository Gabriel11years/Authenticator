//
//  ATCAuthVaultSerialization.m
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVaultSerialization.h"

#import "ATCAuthVault.h"

// ATCAuthVault + ATCFriends
@interface ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList_: ( NSDictionary* )_PlistDict;

@end // ATCAuthVault + ATCFriends

// Private Interfaces
@interface ATCAuthVaultSerialization ()

+ ( NSString* ) checkSumOfData_: ( NSData* )_Data;
+ ( BOOL ) hasValidFlags_: ( NSData* )_Data;

@end // Private Interfaces

unsigned int kVeriFlags[ 16 ] = { 0x28019719, 0xABF4A5AF, 0x975A4C4F, 0x516C46D6
                                , 0x00000344, 0x435BD34D, 0x61636374, 0x7E7369F7
                                , 0xAAAAFC3D, 0x696F6E54, 0x4B657953, 0xABF78FB0
                                , 0x64BACA19, 0x41646454, 0x9AAF297A, 0xC5BFBC29
                                };

NSString* const kUnitedTypeIdentifier = @"home.bedroom.TongKuo.Authenticator.AuthVault";

NSString* const kVersionKey = @"auth-vault-version";
NSString* const kUUIDKey = @"uuid";
NSString* const kCreatedDateKey = @"created-date";
NSString* const kModifiedDateKey = @"modified-date";
NSString* const kPrivateBLOBKey = @"private-blob";
NSString* const kCheckSumKey = @"check-sum";

// ATCAuthVaultSerialization class
@implementation ATCAuthVaultSerialization

#pragma mark - Serializing an Auth Vault

+ ( NSData* ) dataWithEmptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase
                                                 error: ( NSError** )_Error
    {
    NSParameterAssert( ( _MasterPassphrase.length ) >= 6 );

    NSError* error = nil;
    NSData* vaultData = nil;

    NSURL* cachesDirURL = nil;
    if ( ( cachesDirURL = [ [ NSFileManager defaultManager ]
                                URLForDirectory: NSCachesDirectory
                                       inDomain: NSUserDomainMask
                              appropriateForURL: nil
                                         create: YES
                                          error: &error ] ) )
        {
        NSURL* tmpKeychainURL = [ cachesDirURL URLByAppendingPathComponent: [ NSString stringWithFormat: @"%@.dat", TKNonce() ] ];

        WSCKeychain* tmpKeychain =
            [ [ WSCKeychainManager defaultManager ] createKeychainWithURL: tmpKeychainURL
                                                               passphrase: _MasterPassphrase
                                                           becomesDefault: NO
                                                                    error: &error ];
        if ( tmpKeychain )
            {
            NSMutableDictionary* plistDict = [ NSMutableDictionary dictionary ];

            // auth-vault-version key
            ATCAuthVaultVersion version = ATCAuthVault_v1_0;
            NSData* versionDat = [ NSData dataWithBytes: &version length: sizeof version ];
            [ plistDict addEntriesFromDictionary: @{ kVersionKey : @( version ).stringValue } ];

            // uuid key
            NSString* uuid = TKNonce();
            NSData* uuidDat = [ uuid dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ kUUIDKey : uuid } ];

            // created-date key
            NSTimeInterval createdDate = [ [ NSDate date ] timeIntervalSince1970 ];
            NSData* createdDateDat = [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ];
            [ plistDict addEntriesFromDictionary: @{ kCreatedDateKey : @( createdDate ) } ];

            // modified-date key
            NSTimeInterval modifiedDate = createdDate;
            NSData* modifiedDateDat = [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ];
            [ plistDict addEntriesFromDictionary: @{ kModifiedDateKey : @( modifiedDate ) } ];

            // BLOB key
            NSData* tmpKeychainDat = [ [ NSData dataWithContentsOfURL: tmpKeychainURL ]
                base64EncodedDataWithOptions: NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ];
            [ plistDict addEntriesFromDictionary: @{ kPrivateBLOBKey : tmpKeychainDat } ];

            // digest key
            NSMutableArray* subCheckSums = [ NSMutableArray arrayWithCapacity: 5 ];
            [ subCheckSums addObject: [ self checkSumOfData_: versionDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: uuidDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: createdDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: modifiedDateDat ] ];
            [ subCheckSums addObject: [ self checkSumOfData_: tmpKeychainDat ] ];

            NSData* subCheckSumsDat = [ [ subCheckSums componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
            [ plistDict addEntriesFromDictionary: @{ kCheckSumKey : [ self checkSumOfData_: subCheckSumsDat ] } ];

            NSData* plistData = [ NSPropertyListSerialization dataWithPropertyList: plistDict
                                                                            format: NSPropertyListBinaryFormat_v1_0
                                                                           options: 0
                                                                             error: &error ];

            NSMutableData* tmpVaultData = [ NSMutableData dataWithBytes: kVeriFlags length: sizeof kVeriFlags ];

            [ tmpVaultData appendData: [ plistData base64EncodedDataWithOptions:
                NSDataBase64Encoding76CharacterLineLength | NSDataBase64EncodingEndLineWithCarriageReturn ] ];

            vaultData = [ tmpVaultData copy ];
            }
        }

    if ( error )
        if ( _Error )
            *_Error = error;

    return vaultData;
    }

#pragma mark - Deserializing a Property List

+ ( ATCAuthVault* ) authVaultWithContentsOfURL: ( NSURL* )_URL
                                         error: ( NSError** )_Error
    {
    if ( ![ _URL.scheme isEqualToString: @"file" ] )
        return NO;

    NSError* error = nil;
    ATCAuthVault* authVault = nil;

    NSData* data = [ NSData dataWithContentsOfURL: _URL options: 0 error: &error ];
    if ( data )
        authVault = [ self authVaultWithData: data error: &error ];

    if ( error )
        *_Error = error;

    return authVault;
    }

+ ( ATCAuthVault* ) authVaultWithData: ( NSData* )_Data
                                error: ( NSError** )_Error
    {
    NSError* error = nil;
    ATCAuthVault* authVault = nil;

    NSData* contentsOfURL = _Data;
    if ( contentsOfURL )
        {
        if ( [ self hasValidFlags_: contentsOfURL ] )
            {
            NSData* base64DecodedData = [ [ NSData alloc ]
                initWithBase64EncodedData: [ contentsOfURL subdataWithRange: NSMakeRange( sizeof kVeriFlags, contentsOfURL.length - sizeof kVeriFlags ) ]
                                  options: NSDataBase64DecodingIgnoreUnknownCharacters ];
            if ( base64DecodedData )
                {
                NSPropertyListFormat propertyListFormat = 0;

                NSDictionary* plistDict = [ NSPropertyListSerialization
                    propertyListWithData: base64DecodedData
                                 options: 0
                                  format: &propertyListFormat
                                   error: &error ];
                if ( plistDict )
                    {
                    if ( propertyListFormat == NSPropertyListBinaryFormat_v1_0 )
                        {
                        ATCAuthVaultVersion version = ( ATCAuthVaultVersion )[ plistDict[ kVersionKey ] intValue ];
                        NSData* versionDat = [ NSData dataWithBytes: &version length: sizeof version ];

                        NSString* uuid = plistDict[ kUUIDKey ];
                        NSData* uuidDat = [ uuid dataUsingEncoding: NSUTF8StringEncoding ];

                        NSTimeInterval createdDate = [ plistDict[ kCreatedDateKey ] doubleValue ];
                        NSData* createdDateDat = [ NSData dataWithBytes: &createdDate length: sizeof( createdDate ) ];

                        NSTimeInterval modifiedDate = [ plistDict[ kModifiedDateKey ] doubleValue ];
                        NSData* modifiedDateDat = [ NSData dataWithBytes: &modifiedDate length: sizeof( modifiedDate ) ];

                        NSData* BLOB = plistDict[ kPrivateBLOBKey ];

                        NSMutableArray* subCheckSums = [ NSMutableArray arrayWithCapacity: 5 ];
                        [ subCheckSums addObject: [ self checkSumOfData_: versionDat ] ];
                        [ subCheckSums addObject: [ self checkSumOfData_: uuidDat ] ];
                        [ subCheckSums addObject: [ self checkSumOfData_: createdDateDat ] ];
                        [ subCheckSums addObject: [ self checkSumOfData_: modifiedDateDat ] ];
                        [ subCheckSums addObject: [ self checkSumOfData_: BLOB ] ];

                        NSData* subCheckSumsDat = [ [ subCheckSums componentsJoinedByString: @"&" ] dataUsingEncoding: NSUTF8StringEncoding ];
                        NSString* lhsCheckSum = [ self checkSumOfData_: subCheckSumsDat ];
                        NSString* rhsCheckSum = plistDict[ kCheckSumKey ];

                        if ( [ lhsCheckSum isEqualToString: rhsCheckSum ] )
                            {
                            NSLog( @"YES! 🍉" );

                            authVault = [ [ ATCAuthVault alloc ] initWithPropertyList_: plistDict ];
                            }
                        }
                    else
                        ; // TODO: To construct an error object that contains the information about the format is invalid
                    }
                }
            else
                ; // TODO: To construct an error object that contains the information about this failure
            }
        else
            ; // TODO: To construct an error object that contains the information about this failure
        }

    return authVault;
    }

#pragma mark - Private Interfaces

+ ( NSString* ) checkSumOfData_: ( NSData* )_Data
    {
    unsigned char buffer[ CC_SHA512_DIGEST_LENGTH ];
    CCHmac( kCCHmacAlgSHA512, kUnitedTypeIdentifier.UTF8String, kUnitedTypeIdentifier.length, _Data.bytes, _Data.length, buffer );

    NSData* macData = [ NSData dataWithBytes: buffer length: CC_SHA512_DIGEST_LENGTH ];
    NSString* digest =
        [ [ macData base64EncodedStringWithOptions: 0 ]
            stringByAddingPercentEncodingWithAllowedCharacters: [ NSCharacterSet alphanumericCharacterSet ] ];

    return digest;
    }

+ ( BOOL ) hasValidFlags_: ( NSData* )_Data
    {
    if ( _Data.length < sizeof kVeriFlags )
        return NO;

    BOOL hasValidFlags = YES;

    NSData* flagsSubData = [ _Data subdataWithRange: NSMakeRange( 0, sizeof kVeriFlags ) ];
    for ( int _Index = 0; _Index < sizeof kVeriFlags; _Index += sizeof( int ) )
        {
        unsigned int flag = 0U;
        [ flagsSubData getBytes: &flag range: NSMakeRange( _Index, sizeof( int ) ) ];

        if ( flag != kVeriFlags[ ( _Index / sizeof( int ) ) ] )
            {
            hasValidFlags = NO;
            break;
            }
        }

    return hasValidFlags;
    }

@end // ATCAuthVaultSerialization class

// ATCAuthVault + ATCFriends
@implementation ATCAuthVault ( ATCFriends )

#pragma mark - Initializations

- ( instancetype ) initWithPropertyList_: ( NSDictionary* )_PlistDict
    {
    if ( self = [ super init ] )
        ;

    return self;
    }

@end // ATCAuthVault + ATCFriends