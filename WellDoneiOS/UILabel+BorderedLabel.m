//
//  UILabel+BorderedLabel.m
//  experimentWithLabels
//
//  Created by Bhargava, Rajat on 7/4/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "UILabel+BorderedLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation UILabel (BorderedLabel)

- (void)constructBorderedLabelWithText:(NSString *)text
                                 color:(UIColor *)color
                                 angle:(CGFloat)angle
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = 5.f;
    self.layer.cornerRadius = 10.f;
    
   // UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    self.text = [text uppercaseString];
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                 size:30.f];
    self.textColor = color;
    
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                             angle* (M_PI/180));
    
    
}


@end
