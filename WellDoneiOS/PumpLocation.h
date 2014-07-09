//
//  PumpLocation.h
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PumpLocation : NSObject<MKAnnotation>

-(id)initWithPumpName: (NSString *)pumpName coordinate:(CLLocationCoordinate2D)coordinate;

@end
