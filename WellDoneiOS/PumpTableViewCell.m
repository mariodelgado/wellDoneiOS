//
//  PumpTableViewCell.m
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "PumpTableViewCell.h"
#import "Pump.h"
#import "MHPrettyDate.h"

@interface PumpTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgPump;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;
@property (weak, nonatomic) IBOutlet UIImageView *brokenIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *notBrokenIndicatorImageView;

@end

@implementation PumpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    float width = self.imgPump.bounds.size.width;
    self.imgPump.layer.cornerRadius = width/2;
    self.imgPump.layer.borderColor =  [UIColor colorWithRed:0.0 / 255.0 green:171.0 / 255.0 blue:243.0 / 255.0 alpha:1].CGColor; //change this to status color of pump
    self.imgPump.layer.borderWidth = 4;
    
    self.lblLastUpdate.layer.opacity = 0;
    self.lblCurrStatus.layer.opacity = 0;
    self.lblName.layer.opacity = 0;
    
    self.imgPump.transform = CGAffineTransformMakeScale(0,0);
    self.brokenIndicatorImageView.transform = CGAffineTransformMakeScale(0, 0);
    self.notBrokenIndicatorImageView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3 delay:0.3 usingSpringWithDamping:.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imgPump.transform = CGAffineTransformMakeScale(1,1);
        self.brokenIndicatorImageView.transform = CGAffineTransformMakeScale(1, 1);
        self.notBrokenIndicatorImageView.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.lblName.layer.opacity = 1;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.lblLastUpdate.layer.opacity = 1;
            } completion:^(BOOL finished) {
                nil;
            }];
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
                self.lblCurrStatus.layer.opacity = 1;
            } completion:^(BOOL finished) {
                nil;
            }];
            
        }];
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPump:(Pump *)pump{
    self.lblName.text = pump.name;
    self.lblCurrStatus.text = pump.status;
    self.lblLastUpdate.text = pump.lastUpdatedAt;
    
    if ([self.lblCurrStatus.text isEqualToString:@"BROKEN"]) {
        self.brokenIndicatorImageView.hidden = NO;
        self.notBrokenIndicatorImageView.hidden = YES;
    } else {
        self.brokenIndicatorImageView.hidden = YES;
        self.notBrokenIndicatorImageView.hidden = NO;
    }


}
@end
