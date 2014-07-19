//
//  UIView+Animations.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/19/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animations)

-(void) wiggle;
-(void) wiggleWithDuration:(NSTimeInterval)duration angle:(double)degrees repeatCount:(float)count;

@end
