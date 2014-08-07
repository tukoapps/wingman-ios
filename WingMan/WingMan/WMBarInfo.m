//
//  WMBarInfo.m
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMBarInfo.h"
@interface WMBarInfo()
@end

@implementation WMBarInfo

-(id)initWithId:(int)identifier withName:(NSString *)name withLogoUrl:(NSString *)logoUrl withCoordinates:(CLLocationCoordinate2D)coordinates withCurrentUsers:(int)currentUsers withRating:(NSString *)rating
{
    self = [super init];
    if (self) {
        _name = name;
        _logo = [self getImageForUrl:logoUrl];
        _coordinates = coordinates;
        _uniqueId = identifier;
        _currentUsers = currentUsers;
        _rating = rating;
    }
    return self;
}

-(UIImage *)getImageForUrl:(NSString *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        _logo = [UIImage imageWithData:data];
    }];
    return nil;
}

@end
