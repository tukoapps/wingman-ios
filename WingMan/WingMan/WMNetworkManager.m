//
//  WMNetworkManager.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  This class handles network requests to the Rails API for WingMan.

#import "WMNetworkManager.h"
#import "WMError.h"

@implementation WMNetworkManager

+(NSString *)url
{
    return @"http://www.get-wingman.com/api/v1/bars";
}

- (void)requestAllBars
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:WMNetworkManager.url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSArray *barInfoArray = [self processBarData:data];
        [self.delegate NetworkManagerDidReturnInfo:barInfoArray];
    }];
}

-(NSArray *)processBarData:(NSData *)data
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
    
    if (error != nil) {
        // TODO: better error handling
        NSLog(@"some bars not displayed");
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
        //if (attributes[@"lat"] == nil || ![attributes[@"lat"] doubleValue] || attributes[@"lon"] == nil || ![attributes[@"lon"] doubleValue]) {
            //*dataError = [WMError missingLocationError];
            //return false;
        //}
        return true;
    }
    return false;
}

@end
