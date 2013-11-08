//
//  GTRoute.h
//  GTLocation
//
//  The MIT License (MIT)
//
//  Copyright (c) 2013 Gianluca Tranchedone
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NS_ENUM(NSUInteger, GTTravelMode) {
    GTTravelModeWalking,
    GTTravelModeCycling,
    GTTravelModeTransit,
    GTTravelModeDriving
};


typedef NS_ENUM(NSInteger, GTTravelModeVehicleType) {
    GTTravelModeVehicleTypeNone,
    GTTravelModeVehicleTypeBus,
    GTTravelModeVehicleTypeBoat,
    GTTravelModeVehicleTypePlane,
    GTTravelModeVehicleTypeTrain,
    GTTravelModeVehicleTypeSubway,
    GTTravelModeVehicleTypeRocket,
    GTTravelModeVehicleTypeSpaceship, // future proof :-)
    GTTravelModeVehicleTypeCatapult = 888888, // for fun :-)
    GTTravelModeVehicleTypeUndefined = 999999
};

FOUNDATION_EXTERN GTTravelMode GTTravelModeFromNSString(NSString *string);
FOUNDATION_EXTERN NSString * NSStringFromGTTravelMode(GTTravelMode travelMode);

/**
 A GTRouteStep object represents a piace of directions to get from one location to another with a given travel mode.
 */
@interface GTRouteStep : NSObject <NSCoding>

@property (nonatomic, readonly, strong) CLLocation *startLocation;
@property (nonatomic, readonly, strong) CLLocation *endLocation;

@property (nonatomic, readonly, copy) NSString *instructions;
@property (nonatomic, readonly, assign) GTTravelMode travelMode;
@property (nonatomic, readonly, assign) CLLocationDistance distance;
@property (nonatomic, readonly, assign) GTTravelModeVehicleType vehicleType;
@property (nonatomic, readonly, assign) NSTimeInterval expectedTravelDuration;

///--------------------------------------------------
/// @name Creating a Route Step
///--------------------------------------------------

+ (instancetype)routeStepWithStepDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithStepDictionary:(NSDictionary *)dictionary;

@end

/**
 GTRoute represents a route with directions to go from one location to another with a certain travel mode. A route is composed by smaller steps. This are instances of the GTRouteStep class.
 */
@interface GTRoute : NSObject <NSCoding>

@property (nonatomic, readonly, strong) CLLocation *startLocation;
@property (nonatomic, readonly, strong) CLLocation *endLocation;

@property (nonatomic, readonly, copy) NSArray *steps;
@property (nonatomic, readonly, assign) GTTravelMode travelMode;
@property (nonatomic, readonly, assign) NSTimeInterval expectedTravelDuration;

///--------------------------------------------------
/// @name Create a Route
///--------------------------------------------------

+ (instancetype)routeWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode;
- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode;

@end
