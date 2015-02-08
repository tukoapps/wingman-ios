//
//  WMPaddedLabel.m
//  WingMan
//
//  Created by Stephen Chan on 2/8/15.
//  Copyright (c) 2015 TukoApps. All rights reserved.
//

#import "WMPaddedLabel.h"

@implementation WMPaddedLabel

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.paddingLeft = 5;
        self.paddingRight = 5;
    }
    return self;
}

-(void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 5, 0, 5};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
