//
//  ATCAuthVaultSerialization.h
//  Authenticator
//
//  Created by Tong G. on 2/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@import Foundation;

@class ATCAuthVault;

// ATCAuthVaultSerialization class
@interface ATCAuthVaultSerialization : NSObject

#pragma mark - Serializing an Auth Vault

+ ( NSData* ) dataWithEmptyAuthVaultWithMasterPassphrase: ( NSString* )_MasterPassphrase error: ( NSError** )_Error;

#pragma mark - Deserializing a Property List

+ ( ATCAuthVault* ) authVaultWithContentsOfURL: ( NSURL* )_URL error: ( NSError** )_Error;
+ ( ATCAuthVault* ) authVaultWithData: ( NSData* )_Data error: ( NSError** )_Error;

@end // ATCAuthVaultSerialization class