//
//  WMFacebookManager.m
//  WingMan
//
//  Created by Stephen Chan on 9/3/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMFacebookManager.h"

@implementation WMFacebookManager

+(NSString *)accessToken
{
    return [[FBSession activeSession] accessTokenData];
}

@end
