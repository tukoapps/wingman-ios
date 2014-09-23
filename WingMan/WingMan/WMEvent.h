//
//  WMEvent.h
//  WingMan
//
//  Created by Stephen Chan on 9/20/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMEvent : NSObject

@property (strong, nonatomic) NSNumber *uniqueId;
@property (strong, nonatomic) NSNumber *mobileUserId;
@property (strong, nonatomic) NSNumber *barId;
@property (strong, nonatomic) NSDate *elapsedMinutes;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

@end
