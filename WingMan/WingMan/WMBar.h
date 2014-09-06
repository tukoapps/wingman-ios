//
//  WMBarInfo.h
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  The data representation of a bar

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WMBar : NSObject

@property (strong, nonatomic) NSNumber *uniqueId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *yelpId;
@property (strong, nonatomic) NSURL *logoUrl;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSNumber *lat;
@property (strong, nonatomic) NSNumber *lon;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSNumber *currentUsers;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *neighborhood;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSNumber *bearing;

@end
