//
//  ATCOTPEntryTableCellView.m
//  Authenticator
//
//  Created by Tong G. on 2/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPEntryTableCellView.h"

// ATCOTPEntryTableCellView class
@implementation ATCOTPEntryTableCellView

#pragma mark - Dynamic Properties

@dynamic optEntry;

- ( void ) setOptEntry: ( ATCOTPEntry* )_NewEntry
    {
    if ( optEntry_ != _NewEntry )
        {
        optEntry_ = _NewEntry;
        }
    }

- ( ATCOTPEntry* ) optEntry
    {
    return optEntry_;
    }

@end // ATCOTPEntryTableCellView class