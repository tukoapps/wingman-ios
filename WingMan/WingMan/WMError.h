//
//  WMError.h
//  WingMan
//
//  Created by Stephen Chan on 8/7/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMError : NSError

// API data error conditions
+(NSError *)missingIdError;
+(NSError *)missingNameError;
+(NSError *)missingLocationError;
+(NSError *)missingUsersError;
+(NSError *)missingRatingError;
+(NSError *)missingImageError;

@end
