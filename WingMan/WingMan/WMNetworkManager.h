//
//  WMNetworkManager.h
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  Singleton handlign network requests to the Rails API for WingMan.

#import <Foundation/Foundation.h>
#import "WMBarInfo.h"
#import "WMError.h"

@protocol WMNetworkManagerDelegate <NSObject>

-(void)NetworkManagerDidReturnInfo:(NSArray *)barInfo error:(NSError *)error;

@end

@interface WMNetworkManager : NSObject

@property (strong, nonatomic) id<WMNetworkManagerDelegate> delegate;

+(WMNetworkManager)
+(NSString *)url:(NSString *)userId;
-(void)requestAllBars:(NSString *)userId;

@end
