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

#pragma mark - Subclassing methods
+ (NSString *)parseClassName {
    return REPORT; 
}



@end
