//
//  SensorData.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/10/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <Parse/Parse.h>
#import "Pump.h"

@interface SensorData : PFObject <PFSubclassing>

@property (retain) Pump *pump;
@property (retain) NSDate *timeStamp;
@property          float volume;
@property          float temprature;
@property          float pressure;

+ (NSString *)parseClassName;

@end
