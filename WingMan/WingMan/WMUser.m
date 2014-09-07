//
//  WMUser.m
//  WingMan
//
//  Created by Stephen Chan on 9/3/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMUser.h"

@interface WMUser ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WMUser

-(instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+(WMUser *)user
{
    static WMUser *user = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        user = [[WMUser alloc] init];
    });
    return user;
}

-(void)initLocationManager
{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    self.locationManager = manager;
    manager.delegate = self;
    [manager startMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocationCoordinate2D locationCoordinate = [[locations lastObject] coordinate];
    self.lat = [NSNumber numberWithDouble:locationCoordinate.latitude];
    self.lon = [NSNumber numberWithDouble:locationCoordinate.longitude];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WMUserUpdatedLocation" object:nil];
}

-(void)userLoggedIn
{
    [[RKObjectManager sharedManager] getObject:self path:nil parameters:@{@"access_token" :[[FBSession activeSession] accessTokenData].accessToken} success:
         ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
             NSLog(@"%@", self.firstName);
             [[NSNotificationCenter defaultCenter] postNotificationName:@"WMUserFetchedUser" object:nil];
             [self initLocationManager];
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
             NSLog(@"%@", error);
    }];
}

-(void)userLoggedOut
{
    // set all user properties to nil
    self.uniqueId = nil;
    self.firstName = nil;
    self.lastName = nil;
    self.fbAccessToken = nil;
    self.fbId = nil;
    self.email = nil;
    self.male = nil;
    self.lat = nil;
    self.lon = nil;
    self.createdAt = nil;
    self.updatedAt = nil;
    self.locationManager = nil;
}

@end
