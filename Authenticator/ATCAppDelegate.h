//
//  ATCAppDelegate.h
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

// ATCAppDelegate class
@interface ATCAppDelegate : NSObject <NSApplicationDelegate, ATCAuthVaultPasswordSource>

@end // ATCAppDelegate class