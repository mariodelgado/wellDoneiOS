//
//  Pump.h
//  WellDoneListMap
//
//  Created by Aparna Jain on 7/6/14.
//  Copyright (c) 2014 FOX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <parse/Parse.h>



typedef const NSString PumpStatusType;

PumpStatusType *PumpStatusGood;
PumpStatusType *PumpStatusBrokenTemp;

@interface Pump : PFObject<PFSubclassing, MKAnnotation>

@property (retain) NSString *name;
@property (retain) PFGeoPoint *location;
@property (retain) NSString *status;
@property (retain) NSString *notes;
@property (retain) NSString *address;
@property (retain) NSNumber *barcode; 


+ (NSString *)parseClassName;
+ (Pump *)pumpWithName:(NSString *)name location:(PFGeoPoint *)location status:(PumpStatusType *)status;
+ (void )getListOfPumpsWithBlock:(PFArrayResultBlock)block;

@end
