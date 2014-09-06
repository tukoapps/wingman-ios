//
//  WMNetworkManager.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  Singleton handling network requests to the Rails API for WingMan.

#import "WMNetworkManager.h"
#ifdef DEBUG
#define BASE_URL (@"http://wingman-stage.herokuapp.com/api/v1/")
#else
#define BASE_URL (@"http://www.get-wingman.com/api/v1/")
#endif

@implementation WMNetworkManager

static NSString *const sessionSubdomain = @"sessions/new?access_token=";
static NSString *const Subdomain = @"sessions/new?access_token=";

+(WMNetworkManager *)sharedInstance
{
    static WMNetworkManager *_sharedInstance = nil;
    dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WMNetworkManager alloc] init];
    });
    return _sharedInstance;
}

-(id)init
{
    if (!self) {
        self = [super init];
    }
    return self;
}

-(void)requestSessionWithAccessToken:(NSString *)accessToken completionBlock:(void (^)(NSDictionary *response, NSError *error))block
{
    NSString *string = [NSString stringWithFormat:@"%@sessions/new?access_token=", BASE_URL];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
}

- (void)requestAllBars:(NSString *)userId
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:BASE_URL]];
    NSLog(@"%@", BASE_URL);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@", connectionError.description);
            [self.delegate NetworkManagerDidReturnInfo:nil error:connectionError];
        } else {
            if (data) {
                NSError *error;
                NSArray *barInfoArray = [self processBarData:data error:&error];
                NSLog(@"%d bars", [barInfoArray count]);
                [self.delegate NetworkManagerDidReturnInfo:barInfoArray error:error];
            }
        }
    }];
}

-(NSArray *)processBarData:(NSData *)data error:(NSError **)processError
{
    NSMutableArray *barInfoArray = [[NSMutableArray alloc] init];
    NSArray *rawData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSError *error;
    for (NSDictionary *barDictionary in rawData) {
        WMBarInfo *barInfo = [self formatBarInfoWithAttributes:barDictionary error:&error];
        if (barInfo) {
            [barInfoArray addObject:barInfo];
        }
    }
    return barInfoArray;
}

-(WMBarInfo *)formatBarInfoWithAttributes:(NSDictionary *)attributes error:(NSError **)dataError
{
    bool isValidated = [self validateBarInfoWithAttributes:attributes error:dataError];
    if (!isValidated) {
        return nil;
    }
    
    int uniqueId = [attributes[@"id"] integerValue];
    //CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([attributes[@"lat"] doubleValue], [attributes[@"lon"] doubleValue]);
    NSString *name = attributes[@"name"];
    NSString *logoUrl = attributes[@"logo_url"];
    int users = [attributes[@"current_users"] integerValue];
    NSString *rating = attributes[@"rating"];
    NSString *price = attributes[@"price"];
    
    // non-fatal error handling
    if (attributes[@"logo_url"] == nil) {
        logoUrl = nil;
    }
    if (attributes[@"current_users"] < 0) {
        users = 0;
    }
    if (attributes[@"rating"] == nil) {
        rating = @"unknown";
    }
    if (attributes[@"price"] == nil) {
        price = @"unknown";
    }
    return [[WMBarInfo alloc] initWithId:uniqueId withName:name withLogoUrl:logoUrl withCoordinates:CLLocationCoordinate2DMake(0, 0) withCurrentUsers:users withRating:rating];
}

-(bool)validateBarInfoWithAttributes:(NSDictionary *)attributes error:(NSError **)dataError
{
    if (dataError != NULL) {
        // TODO: define error conditions - which errors should stop initialization?
        if (attributes[@"id"] == nil) {
            *dataError = [WMError missingIdError];
            return false;
        }
        if (attributes[@"name"] == nil) {
            *dataError = [WMError missingNameError];
            return false;
        }
        /*if (!(attributes[@"lat"] != nil && attributes[@"lon"] != nil && [attributes[@"lat"] doubleValue] && [attributes[@"lon"] doubleValue])) {
            *dataError = [WMError missingLocationError];
            return false;
        }*/
        return true;
    }
    return false;
}

@end
