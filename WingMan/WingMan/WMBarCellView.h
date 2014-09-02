//
//  WMBarCellView.h
//  WingMan
//
//  Created by Stephen Chan on 8/8/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMBarInfo.h"

@interface WMBarCellView : UITableViewCell

-(void)setDataWithInfo:(WMBarInfo *)info;
-(void)setLogoImage:(UIImage *)image;

@end
