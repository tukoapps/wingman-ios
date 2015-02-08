//
//  WMBarCellView.m
//  WingMan
//
//  Created by Stephen Chan on 8/8/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMBarCellView.h"

@interface WMBarCellView()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *barName;
@property (weak, nonatomic) IBOutlet UILabel *currentUsers;

@end

@implementation WMBarCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDataWithInfo:(WMBar *)info
{
    self.barName.text = info.name;
    self.currentUsers.text = [NSString stringWithFormat:@"%d", [info.currentUsers integerValue]];
}

-(void)setLogoImage:(UIImage *)image
{
    self.logo.image = image;
}

-(UIImage *)getImage
{
    return self.logo.image;
}

@end
