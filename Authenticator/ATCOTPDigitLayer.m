//
//  ATCOTPDigitLayer.m
//  Authenticator
//
//  Created by Tong G. on 2/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ATCOTPDigitLayer.h"

// ATCOTPDigitLayer class
@implementation ATCOTPDigitLayer

#pragma mark - Initializations

- ( instancetype ) initWithTextString: ( NSString* )_TextString delegate: ( id )_Delegate
    {
    return [ [ [ self class ] alloc ] initWithTextString: _TextString delegate: _Delegate ];
    }

- ( instancetype ) initWithTextString: ( NSString* )_TextString
    {
    if ( self = [ super init ] )
        {
        self.string = _TextString;

        self.fontSize = 30.f;
        self.font = ( __bridge CFTypeRef _Nullable )( [ NSFont fontWithName: @"Courier New Regular" size: self.fontSize ] );
        self.foregroundColor = [ NSColor whiteColor ].CGColor;
        self.alignmentMode = kCAAlignmentCenter;
        }

    return self;
    }

#pragma mark - Drawing

- ( void ) drawInContext: ( CGContextRef )_Ctx
    {
    // TODO:
    }

@end // ATCOTPDigitLayer class
