//
//  imageCollectionViewCell.h
//  collectionsViewDemo
//
//  Created by Bhargava, Rajat on 7/12/14.
//  Copyright (c) 2014 RNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
