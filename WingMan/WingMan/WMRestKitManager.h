//
//  WMRestKitManager.h
//  WingMan
//
//  Created by Stephen Chan on 9/4/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
// Manages all RestKit configuration of the application

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <RestKit/RestKit.h>
#import "WMUser.h"
#import "WMBar.h"

@interface WMRestKitManager : NSObject

+(WMRestKitManager *)sharedManager;

@end
