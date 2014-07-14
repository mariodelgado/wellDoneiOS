//
//  SensorData.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/10/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "SensorData.h"
#import  <Parse/PFObject+Subclass.h>

NSString *const SENSOR_DATA = @"SensorData";

@implementation SensorData

@dynamic pump;
@dynamic timeStamp;
@dynamic volume;
@dynamic temperature;
@dynamic pressure;

+ (NSString *)parseClassName {
    return SENSOR_DATA;
}



@end
