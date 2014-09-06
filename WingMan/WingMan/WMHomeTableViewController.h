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
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SWRevealViewController.h"
#import "WMRestKitManager.h"
#import "WMBar.h"
#import "WMBarCellView.h"
#import "WMTopBarCellView.h"
#import "WMUser.h"
#import "WMBarDetailViewController.h"

@interface WMHomeTableViewController : UITableViewController 

@end
