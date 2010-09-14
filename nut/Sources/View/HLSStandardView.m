//
//  HLSStandardView.m
//  FIVB
//
//  Created by Samuel Défago on 9/1/10.
//  Copyright 2010 Hortis. All rights reserved.
//

#import "HLSStandardView.h"

#import <objc/runtime.h>

@implementation HLSStandardView

#pragma mark Factory methods

+ (UIView *)view
{
    // Get the class name (inheritance is taken into account)
    NSString *className = [NSString stringWithUTF8String:class_getName([self class])];
    
    // Load from nib file
    NSArray *bundleContents = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
    return [bundleContents objectAtIndex:0];
}

#pragma mark Object creation and destruction

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
