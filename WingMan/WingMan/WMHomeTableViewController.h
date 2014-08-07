//
//  WMHomeTableViewController.h
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//
//  This is the home controller class for WingMan.
//  As of now, all bars in the area are shown as the
//  API has not been fully developed yet.

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "WMNetworkManager.h"
#import "WMBarInfo.h"

@interface WMHomeTableViewController : UITableViewController <WMNetworkManagerDelegate>

-(void)NetworkManagerDidReturnInfo:(NSArray *)barInfo;

@end
