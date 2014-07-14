//
//  Report.h
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/10/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import <Parse/Parse.h>
#import "Pump.h"

@interface Report : PFObject <PFSubclassing>

@property (retain) NSString *reportName;
@property (retain) NSString *reportNote;
@property (retain) Pump *pump;
@property (retain) PFFile *reportImage; 

+ (NSString *)parseClassName;
+ (Report *) reportWithName:(NSString *)reportName note:(NSString*)note pump:(Pump*)pump;
+ (void )getReportsForPump:(Pump*)pump withBlock:(PFArrayResultBlock)block;

@end
