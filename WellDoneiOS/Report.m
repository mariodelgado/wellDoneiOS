//
//  Report.m
//  WellDoneiOS
//
//  Created by Bhargava, Rajat on 7/10/14.
//  Copyright (c) 2014 welldone. All rights reserved.
//

#import "Report.h"
#import  <Parse/PFObject+Subclass.h>

NSString *const REPORT = @"Report";

@implementation Report

@dynamic reportName;
@dynamic reportNote;
@dynamic pump;
@dynamic reportImage;

#pragma mark - Subclassing methods
+ (NSString *)parseClassName {
    return REPORT; 
}

+ (Report *) reportWithName:(NSString *)reportName note:(NSString*)note pump:(Pump*)pump {
    Report *report = [[Report alloc]init];
    report.reportName = reportName;
    report.reportNote = note;
    report.pump = pump;
    return report; 
    
}

+ (void )getReportsForPump:(Pump*)pump withBlock:(PFArrayResultBlock)block {
    PFQuery *reportsPerPump = [Report query];
    [reportsPerPump whereKey:@"pump" equalTo:pump];
    [reportsPerPump findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects,error);
    }];
}



@end
