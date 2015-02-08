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
    /*{"id":921,"name":"The Celtic Knot Public House","yelp_id":null,"logo_url":"http://www.drankbank.com/images/cal/celtic_knot_public_house_evanston_il.png","image_url":"http://s3-media4.fl.yelpcdn.com/bphoto/IurKHxpNEVYNmvvDhlQWHg/l.jpg","lat":"42.0479","lon":"-87.680155","review_count":null,"rating":"3.5","price":"3.0","created_at":"2014-09-11T02:18:02.320Z","updated_at":"2015-01-22T04:50:18.271Z","phone_number":"(847) 864-1679","address":"626 Church St Evanston, IL 60201","category":"champagne_bars","description":"","music":"","food":"","drink_price":null,"schedule":"","distance":0.0307560888281247,"bearing":"84.192949393135","current_users":0}*/
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
                                                         @"drink_price" : @"price",
                                                         @"created_at" : @"createdAt",
                                                         @"updated_at" : @"updatedAt",
                                                         @"address" : @"address",
                                                         @"phone_number" : @"phoneNumber",
                                                         @"category" : @"category",
                                                         @"distance" : @"distance",
                                                         @"bearing" : @"bearing",
                                                         @"description" : @"barDescription",
                                                         @"schedule" : @"schedule",
                                                         @"music" : @"music",
                                                         @"food" : @"food"
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
    WMUser *currentUser = [WMUser user];
    if ([currentUser uniqueId] && [currentUser lat] && [currentUser lon]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id" : [[WMUser user] uniqueId], @"lat" : [[WMUser user] lat], @"lon" : [[WMUser user] lon]}];
        [[RKObjectManager sharedManager] getObjectsAtPath:@"locations/new" parameters:params
            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                NSLog(@"%@", mappingResult);
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                NSLog(error.description);
            }];
    }
}

@end
