//
//  Pump.m
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//


#import <Parse/PFObject+Subclass.h>
#import "Pump.h"

const PumpStatusType *PumpStatusGood = @"GOOD";
const PumpStatusType *PumpStatusBrokenTemp = @"BROKEN_TEMP";
NSString *const PUMP = @"Pump";

@interface Pump ()

@end

@implementation Pump

@dynamic name;
@dynamic location;
@dynamic status;
@dynamic notes;
@dynamic address;
@dynamic barcode;

+ (NSString *)parseClassName {
    return PUMP;
}

- (void)setLocation:(PFGeoPoint *)location {
    NSLog(@"set location!");
    [self setObject:location forKey:@"location"];
}

+ (Pump *)pumpWithName:(NSString *)name location:(PFGeoPoint *)location status:(PumpStatusType *)status {
    Pump *p = [[Pump alloc] init];
    p.name = name;
    p.location = location;
    p.status = (NSString *) status;
    return p;
}

- (CLLocationCoordinate2D)coordinate {
    // A little hacky for now. Ideally we'd create this once, but I don't know when objects are instantiated by Parse yet
    return CLLocationCoordinate2DMake(self.location.latitude, self.location.longitude);
}

- (NSString *)title {
    return self.name;
}

#pragma mark - PF Query Method
+ (void )getListOfPumpsWithBlock:(PFArrayResultBlock)block {
    PFQuery *pumpQuery = [Pump query];
    [pumpQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        block(objects, error);
    
    }];
   
}



@end