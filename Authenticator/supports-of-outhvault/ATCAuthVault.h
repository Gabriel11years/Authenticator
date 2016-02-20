//
//  ATCAuthVault.h
//  Authenticator
//
//  Created by Tong G. on 2/19/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// ATCAuthVault class
@interface ATCAuthVault : NSObject
    {
@private
    NSData __strong* backingStore_;
    }

#pragma mark - Creating Auth Vault

- ( instancetype ) initWithMasterPassword: ( NSString* )_Password error: ( NSError** )_Error;
- ( instancetype ) initWithData: ( NSData* )_Data masterPassword: ( NSString* )_Password error: ( NSError** )_Error;

#pragma mark - Persistent

- ( BOOL ) writeToFile: ( NSString* )_Path atomically: ( BOOL )_Atomically;
- ( BOOL ) writeToFile: ( NSString* )_Path options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error;

- ( BOOL ) writeToURL: ( NSURL* )_URL atomically: ( BOOL )_Atomically;
- ( BOOL ) writeToURL: ( NSURL* )_URL options: ( NSDataWritingOptions )_Mask error: ( NSError** )_Error;

@end // ATCAuthVault class