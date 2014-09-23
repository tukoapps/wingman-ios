//
//  WMSideBarTableViewController.h
//  WingMan
//
//  Created by Stephen Chan on 7/27/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "WMUser.h"

@class WMSideBarTableViewController;

@protocol WMSideBarTableViewControllerDelegate <NSObject>

-(void)WMSideBarWillAppear;
-(void)WMSideBarWillDisappear;

@end

@interface WMSideBarTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) id<WMSideBarTableViewControllerDelegate> delegate;

@end
