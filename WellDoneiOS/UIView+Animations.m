//
//  UIView+Animations.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/19/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "UIView+Animations.h"
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@implementation UIView (Animations)

-(void) wiggle {
    [self wiggleWithDuration:0.125 angle:2.0 repeatCount:5];
}

-(void) wiggleWithDuration:(NSTimeInterval)duration angle:(double)degrees repeatCount:(float)count {
    
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-degrees));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(degrees));
    
    self.transform = leftWobble;
    
    
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse) animations:^{
        [UIView setAnimationRepeatCount:count];
        self.transform = rightWobble;
    }completion:^(BOOL finished){
    }];
    
}

-(void) animateExitDownWithDuration:(NSTimeInterval)duration frame:(CGRect)newFrame {
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:20 options:0 animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        nil;
    }];
    
}


@end
