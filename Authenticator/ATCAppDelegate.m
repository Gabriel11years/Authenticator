//
//  ATCAppDelegate.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAppDelegate.h"

// Private Interfaces
@interface ATCAppDelegate ()

@end // Private Interfaces

// ATCAppDelegate class
@implementation ATCAppDelegate

#pragma mark - Conforms to <NSApplicationDelegate>

- ( void ) applicationWillResignActive: ( NSNotification* )_Notif
    {
    [ [ ATCRefreshingTimer sharedTimer ] stopTiming ];
    }

- ( void ) applicationWillBecomeActive: ( NSNotification* )_Notif
    {
    [ [ ATCRefreshingTimer sharedTimer ] startTiming ];
    }

@end // ATCAppDelegate class