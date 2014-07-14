//
//  imageCollectionViewCell.m
//  collectionsViewDemo
//
//  Created by Bhargava, Rajat on 7/12/14.
//  Copyright (c) 2014 RNB. All rights reserved.
//


#import "ImageCollectionViewCell.h"

@interface ImageCollectionViewCell()



@end

@implementation ImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UINib *nib = [UINib nibWithNibName:@"cvCell" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        
        UIView *subview = objects[0];
        self.frame = subview.frame;
        [self addSubview:objects[0]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
