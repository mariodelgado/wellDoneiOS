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
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrStatus;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;

@end

@implementation PumpTableViewCell

- (void)awakeFromNib
{
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPump:(Pump *)pump{
    self.lblName.text = pump.name;
    self.lblCurrStatus.text = pump.status;
    NSDateFormatter *_formatter;
    
    

    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
//    NSString *dateStr = [NSString stringWithFormat:@"%@", pump.updatedAt];
//    self.lblLastUpdate.text = [MHPrettyDate prettyDateFromDate:[_formatter dateFromString:dateStr] withFormat:MHPrettyDateShortRelativeTime];
//    self.lblLastUpdate.text = pump.updatedAt;
    
    
    

}
@end
