//
//  ATCNormalPresentationView.m
//  Authenticator
//
//  Created by Tong G. on 2/24/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCNormalPresentationView.h"

// ATCNormalPresentationView class
@implementation ATCNormalPresentationView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self configureForAutoLayout ];

    return self;
    }

@end // ATCNormalPresentationView class