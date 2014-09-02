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

@interface WMBarInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logoUrl;
@property CLLocationCoordinate2D coordinates;
@property int uniqueId;
@property int currentUsers;
@property (strong, nonatomic) NSString *rating;

-(id)initWithId:(int)identifier withName:(NSString *)name withLogoUrl:(NSString *)logoUrl withCoordinates:(CLLocationCoordinate2D)coordinates withCurrentUsers:(int)currentUsers withRating:(NSString *)rating;

@end
