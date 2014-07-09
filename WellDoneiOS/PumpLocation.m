//
//  PumpLocation.m
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import "PumpLocation.h"

@interface PumpLocation()
@property (nonatomic, strong)NSString *pumpName;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;

@end
@implementation PumpLocation

- (id)initWithPumpName:(NSString *)pumpName coordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        self.pumpName = pumpName;
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return self.pumpName;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}
@end
