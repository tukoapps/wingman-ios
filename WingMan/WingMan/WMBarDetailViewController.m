//
//  WMBarDetailViewController.m
//  WingMan
//
//  Created by Stephen Chan on 9/6/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMBarDetailViewController.h"

@interface WMBarDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet UILabel *wingmanUserCount;


@end

@implementation WMBarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.image.image = self.barImage;
    self.name.text = self.bar.name;
    self.rating.text = [NSString stringWithFormat: @"Rating: %@", self.bar.rating];
    self.reviewCount.text = [NSString stringWithFormat: @"Number of reviews: %@", self.bar.reviewCount];
    self.price.text = [NSString stringWithFormat: @"Price: %@", self.bar.price];
    self.address.text = self.bar.address;
    self.city.text = self.bar.city;
    self.state.text = self.bar.state;
    if (self.bar.currentUsers) {
        self.wingmanUserCount.text = [NSString stringWithFormat:@"%@ Wingman users there", self.bar.currentUsers];
    } else {
        self.wingmanUserCount.text = @"0 Wingman users there";
    }
    [super viewDidLoad];
}

@end
