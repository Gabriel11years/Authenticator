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

- ( instancetype ) initWithData: ( NSData* )_Data error: ( NSError** )_Error;

@end // ATCAuthVault class