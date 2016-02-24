//
//  ATCNormalPresentationViewController.h
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCAuthVault.h"

@class ATCQRCodeScannerWindowController;

// ATCNormalPresentationViewController class
@interface ATCNormalPresentationViewController : NSViewController
    <NSTableViewDataSource, NSTableViewDelegate, ATCAuthVaultPasswordSource>
    {
@private
    ATCAuthVault __strong* authVault_;
    NSMutableOrderedSet <ATCAuthVaultItem*>* otpEntries_;

    ATCQRCodeScannerWindowController __strong* QRCodeScannerWindow_;
    }

@property ( weak ) IBOutlet NSTableView* optEntriesTableView;

#pragma mark - IBActions

- ( IBAction ) scanQRCodeOnScreenAction_: ( id )_Sender;

@end // ATCNormalPresentationViewController class