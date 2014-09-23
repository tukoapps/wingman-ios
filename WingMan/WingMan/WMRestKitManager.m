//
//  WMRestKitManager.m
//  WingMan
//
//  Created by Stephen Chan on 9/4/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
// Manages all RestKit configuration of the application

#import "WMRestKitManager.h"

// set the API URL dynamically based on environment
#define BASE_URL (@"http://www.get-wingman.com/api/v1/")

@implementation WMRestKitManager

+(WMRestKitManager *)sharedManager
{
    static WMRestKitManager *manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        manager = [[WMRestKitManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initRKObjectManagerAndRouter];
        [self initRKObjectMappings];
    }
    return self;
}

-(void)initRKObjectManagerAndRouter
{
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:BASE_URL]];
    RKRouter *router = [[RKRouter alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    objectManager.router = router;
    [objectManager.router.routeSet addRoute:[RKRoute routeWithClass:[WMUser class] pathPattern:[NSString stringWithFormat:@"sessions/new"]   method:RKRequestMethodGET]];
}

-(void)initRKObjectMappings
{
    [self initWMUserObjectMapping];
    [self initWMBarInfoObjectMapping];
    [self initWMEventObjectMapping];
}

-(void)initWMUserObjectMapping
{
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[WMUser class]];
    [userMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"uniqueId",
                                                         @"first_name": @"firstName",
                                                         @"last_name": @"lastName",
                                                         @"fb_access_token": @"fbAccessToken",
                                                         @"fb_id" : @"fbId",
                                                         @"email" : @"email",
                                                         @"male" : @"male",
                                                         @"lat" : @"lat",
                                                         @"lon" : @"lon",
                                                         @"created_at" : @"createdAt",
                                                         @"updated_at" : @"updatedAt"
                                                         }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping method:RKRequestMethodAny pathPattern:@"sessions/new" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

-(void)initWMBarInfoObjectMapping
{
     RKObjectMapping* barMapping = [RKObjectMapping mappingForClass:[WMBar class]];
    [barMapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"uniqueId",
                                                         @"name": @"name",
                                                         @"yelp_id": @"yelpId",
                                                         @"logo_url": @"logoUrl",
                                                         @"image_url" : @"imageUrl",
                                                         @"lat" : @"lat",
                                                         @"lon" : @"lon",
                                                         @"review_count" : @"reviewCount",
                                                         @"rating" : @"rating",
                                                         @"current_users" : @"currentUsers",
                                                         @"price" : @"price",
                                                         @"created_at" : @"createdAt",
                                                         @"updated_at" : @"updatedAt",
                                                         @"address" : @"address",
                                                         @"phone_number" : @"phoneNumber",
                                                         @"city" : @"city",
                                                         @"state" : @"state",
                                                         @"neighborhood" : @"neighborhood",
                                                         @"category" : @"category",
                                                         @"distance" : @"distance",
                                                         @"bearing" : @"bearing"
                                                         }];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:barMapping method:RKRequestMethodAny pathPattern:@"bars" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

-(void)initWMEventObjectMapping
{
    RKObjectMapping *eventMapping = [[RKObjectMapping alloc] initWithClass:[WMEvent class]];
    [eventMapping addAttributeMappingsFromDictionary:@{ @"id" : @"uniqueId",
                                                       @"mobile_user_id" : @"mobileUserId",
                                                       @"bar_id" : @"barId",
                                                       @"elapsed_minutes" : @"elapsedMinutes",
                                                       @"created_at" : @"createdAt",
                                                        @"updated_at" : @"updatedAt"}];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:eventMapping method:RKRequestMethodAny pathPattern:@"locations/new" keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor];
}

-(void)updateUserLocation
{
    //NSDictionary *params = @{@"user_id" : [WMUser user].uniqueId, @"lat" : [WMUser user].lat, @"lon" : [WMUser user].lon };
    NSDictionary *params = @{@"user_id" : [NSNumber numberWithInt:5], @"lat" : [NSNumber numberWithDouble:42.0478396], @"lon" : [NSNumber numberWithDouble:-87.6807489]};
    [[RKObjectManager sharedManager] getObjectsAtPath:@"locations/new" parameters:params
        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            NSLog(@"%@", mappingResult);
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            NSLog(error.description);
        }];
}

@end
