//
//  WMBarInfo.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMBar.h"
@interface WMBar()
@end

@implementation WMBar

-(BOOL)isEqual:(id)object
{
    return [self.uniqueId isEqual:[object valueForKey:@"uniqueId"]];
}

@end
