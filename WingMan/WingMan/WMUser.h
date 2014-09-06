//
//  WMUser.h
//  WingMan
//
//  Created by Stephen Chan on 9/3/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <CoreLocation/CoreLocation.h>

@class WMUser;

@interface WMUser : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) NSNumber *uniqueId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *fbAccessToken;
@property (strong, nonatomic) NSString *fbId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSNumber *male;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

+(WMUser *)user;
-(void)userLoggedIn;
-(void)userLoggedOut;

@end
