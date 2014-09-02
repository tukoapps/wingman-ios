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
@property (weak, nonatomic) IBOutlet UIImageView *rating;

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

-(void)setDataWithInfo:(WMBarInfo *)info
{
    self.barName.text = info.name;
    self.currentUsers.text = [NSString stringWithFormat:@"%d currently there", info.currentUsers ];
    [self setRatingImage:[info.rating floatValue]];
}

-(void)setLogoImage:(UIImage *)image
{
    self.logo.image = image;
}

-(void)setRatingImage:(float)rating
{
    if (rating == 0.5) {
        self.rating.image = [UIImage imageNamed:@"no_stars_half"];
    }
    if (rating == 1) {
        self.rating.image = [UIImage imageNamed:@"one_star"];
    }
    if (rating == 1.5) {
        self.rating.image = [UIImage imageNamed:@"one_star_half"];
    }
    if (rating == 2) {
        self.rating.image = [UIImage imageNamed:@"two_stars"];
    }
    if (rating == 2.5) {
        self.rating.image = [UIImage imageNamed:@"two_stars_half"];
    }
    if (rating == 3) {
        self.rating.image = [UIImage imageNamed:@"three_stars"];
    }
    if (rating == 3.5) {
        self.rating.image = [UIImage imageNamed:@"three_stars_half"];
    }
    if (rating == 4) {
        self.rating.image = [UIImage imageNamed:@"four_stars"];
    }
    if (rating == 4.5) {
        self.rating.image = [UIImage imageNamed:@"four_stars_half"];
    }
    if (rating == 5) {
        self.rating.image = [UIImage imageNamed:@"five_stars"];
    }
}

@end
