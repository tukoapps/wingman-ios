//
//  WMTopBarCellView.m
//  WingMan
//
//  Created by Stephen Chan on 9/6/14.
//  Copyright (c) 2014 TukoApps. All rights reserved.
//

#import "WMTopBarCellView.h"

@interface WMTopBarCellView ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *barName;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@end

@implementation WMTopBarCellView

// override WMBarCellView to add background image
-(void)setLogoImage:(UIImage *)image
{
    self.logo.image = image;
}

-(void)setBackgroundImage:(UIImage *)image
{
    self.backgroundView = [[UIImageView alloc] initWithImage:image];
}

- (UIImage*)scaleImage: (UIImage *)image ToSizeKeepAspect:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    CGFloat ws = size.width/image.size.width;
    CGFloat hs = size.height/image.size.height;
    
    if (ws > hs) {
        ws = hs/ws;
        hs = 1.0;
    } else {
        hs = ws/hs;
        ws = 1.0;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(size.width/2-(size.width*ws)/2,
                                           size.height/2-(size.height*hs)/2, size.width*ws,
                                           size.height*hs), image.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
