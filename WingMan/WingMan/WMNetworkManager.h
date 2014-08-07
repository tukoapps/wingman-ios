//
//  WMNetworkManager.h
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  This class handles network requests to the Rails API for WingMan.

#import <Foundation/Foundation.h>
#import "WMBarInfo.h"

@protocol WMNetworkManagerDelegate <NSObject>

-(void)NetworkManagerDidReturnInfo:(NSArray *)barInfo;

@end

@interface WMNetworkManager : NSObject

@property (strong, nonatomic) id<WMNetworkManagerDelegate> delegate;

+(NSString *)url;
-(void)requestAllBars;

@end
