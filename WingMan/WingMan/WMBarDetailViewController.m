//
//  WMBarDetailViewController.m
//  WingMan
//
//  Created by Stephen Chan on 9/6/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMBarDetailViewController.h"
#import "WMPaddedLabel.h"

@interface WMBarDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *name;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *rating;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *music;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *price;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *barDescription;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *address;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *schedule;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *food;
@property (weak, nonatomic) IBOutlet WMPaddedLabel *wingmanUserCount;

@end

@implementation WMBarDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)getBarBackgroundImageForUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            self.image.image = [UIImage imageWithData:data];
            return;
        }
    }];
}

- (void)viewDidLoad
{
    self.image.layer.zPosition = -1000;
    self.logoImage.image = self.barLogo;
    [self getBarBackgroundImageForUrl:self.bar.imageUrl];
    self.name.attributedText = [[NSAttributedString alloc] initWithString:self.bar.name attributes:@{
                                            NSStrokeWidthAttributeName:[NSNumber numberWithFloat:-3.0],
                                            NSStrokeColorAttributeName:[UIColor blackColor],
                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                            }];
    self.rating.attributedText=[[NSAttributedString alloc]
                               initWithString:[NSString stringWithFormat: @"Rating: %@", self.bar.rating]
                               attributes:@{
                                            NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-3.0],
                                            NSStrokeColorAttributeName:[UIColor blackColor],
                                            NSForegroundColorAttributeName:[UIColor whiteColor]
                                            }
                               ];
    if (self.bar.price) {
        self.price.text = [NSString stringWithFormat: @"Avg Drink: $%.2f", [self.bar.price floatValue]];
    } else {
        self.price.text = @"Avg Drink: ";
    }
    self.address.text = self.bar.address;
    if (self.bar.currentUsers) {
        self.wingmanUserCount.text = [NSString stringWithFormat:@"%@+ Wingman users there", self.bar.currentUsers];
    } else {
        self.wingmanUserCount.text = @"0+ Wingman users there";
    }
    if (self.bar.music) {
        self.music.text = [NSString stringWithFormat:@"Music: %@", self.bar.music];
    } else {
        self.music.text = @"Music: ";
    }
    if (self.bar.food) {
        self.food.text = [NSString stringWithFormat:@"Food: %@", self.bar.food];
    } else {
        self.food.text = @"Food: ";
    }
    if (self.bar.schedule && self.bar.schedule.length > 0) {
        self.schedule.text = [NSString stringWithFormat:@"Schedule: %@", self.bar.schedule];
    } else {
        self.schedule.text = @"Schedule: ";
    }
    if (self.bar.barDescription && self.bar.barDescription.length > 0) {
        self.barDescription.text = [NSString stringWithFormat:@"Description: %@", self.bar.barDescription];
    } else {
        self.barDescription.text = @"Description: ";
    }
    
    [super viewDidLoad];
}

@end
