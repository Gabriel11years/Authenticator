//
//  ATCMainWindow.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCMainWindow.h"

// ATCMainWindow class
@implementation ATCMainWindow

- ( void ) awakeFromNib
    {
    [ super awakeFromNib ];
    [ self setFrameAutosaveName: [ [ NSBundle mainBundle ].bundleIdentifier stringByAppendingString: @".MainWindow" ] ];
    }

@end // ATCMainWindow class
