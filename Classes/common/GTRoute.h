//
//  GTRoute.h
//  GTLocation
//
//  Created by Gianluca Tranchedone http://gtranchedone.com
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

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import <GTFoundation/GTFoundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  @abstract An enumeration of possible travel modes.
 *  @discussion The enumeration values match the values supported by the Google Directions APIs.
 */
typedef NS_ENUM(NSUInteger, GTTravelMode) {
    /**
     *  Walking
     */
    GTTravelModeWalking,
    /**
     *  Cycling
     */
    GTTravelModeCycling,
    /**
     *  Public Transports (Bus, Trains, Boats, etc.)
     */
    GTTravelModeTransit,
    /**
     *  Driving
     */
    GTTravelModeDriving
};

/**
 *  @abstract An enumeration available vehicle types.
 *  @discussion The enumation values match the values supported by the Google Directions APIs.
 *  @note The vehicle type can only be used if you use GTTravelModeTransit as your travel mode.
 */
typedef NS_ENUM(NSInteger, GTTravelModeVehicleType) {
    /**
     *  The default value for any object having a vehicleType property.
     */
    GTTravelModeVehicleTypeNone,
    /**
     *  Bus
     */
    GTTravelModeVehicleTypeBus,
    /**
     *  Intercity Bus
     */
    GTTravelModeVehicleTypeIntercityBus,
    /**
     * Trolley Bus
     */
    GTTravelModeVehicleTypeTrolleyBus,
    /**
     *  Tram
     */
    GTTravelModeVehicleTypeTram,
    /**
     *  Train. Matches the RAIL travel mode on the Google Direction APIs.
     */
    GTTravelModeVehicleTypeTrain,
    /**
     *  Metro Rail
     */
    GTTravelModeVehicleTypeMetroRail,
    /**
     *  Mono Rail
     */
    GTTravelModeVehicleTypeMonoRail,
    /**
     *  Heavy Rail
     */
    GTTravelModeVehicleTypeHeavyRail,
    /**
     *  Commuter Train
     */
    GTTravelModeVehicleTypeCommuterTrain,
    /**
     *  High Speed Train
     */
    GTTravelModeVehicleTypeHighSpeedTrain,
    /**
     *  Share Taxi
     *  @note it's not a taxi but a car service that takes you and other passengers somewhere.
     */
    GTTravelModeVehicleTypeShareTaxi,
    /**
     *  Cable Car
     */
    GTTravelModeVehicleTypeCableCar,
    /**
     *  Gandola Lift
     */
    GTTravelModeVehicleTypeGandolaLift,
    /**
     *  Funicular
     */
    GTTravelModeVehicleTypeFunicular,
    /**
     *  Ferry
     */
    GTTravelModeVehicleTypeFerry,
    /**
     *  Plane.
     *  @note This is not supported by the Google Direction APIs (yet).
     */
    GTTravelModeVehicleTypePlane,
    /**
     *  Subway
     */
    GTTravelModeVehicleTypeSubway,
    /**
     *  Future proof :-)
     */
    GTTravelModeVehicleTypeRocket,
    /**
     *  Future proof :-)
     */
    GTTravelModeVehicleTypeSpaceship,
    /**
     *  For fun :-)
     */
    GTTravelModeVehicleTypeCatapult = 888888,
    /**
     *  Unknown Vehicle Type. This is used in case the Google Direction APIs change and this class is not up-to-date.
     *  @note GTTravelModeVehicleTypeUndefined also matches the 'OTHER' vehicle type on the Google Directions APIs.
     */
    GTTravelModeVehicleTypeUndefined = 999999
};

FOUNDATION_EXTERN GTTravelMode GTTravelModeFromNSString(NSString *string);
FOUNDATION_EXTERN NSString * NSStringFromGTTravelMode(GTTravelMode travelMode);
FOUNDATION_EXTERN NSString * NSStringFromGTTravelModeVehicleType(GTTravelModeVehicleType type);

/**
 @abstract A GTRouteStep object represents a subsection of overall directions for getting from one location to another with a given travel mode.
 */
@interface GTRouteStep : NSObject <NSCoding, NSCopying, NSMutableCopying>

/// The start location of the route step.
@property (nonatomic, readonly, strong) CLLocation *startLocation;
/// The end location of the route step.
@property (nonatomic, readonly, strong) CLLocation *endLocation;
/// The travel mode used to calculate the route step.
@property (nonatomic, readonly, assign) GTTravelMode travelMode;

/// Instructions for the user (e.g. 'Take the Subway').
@property (nonatomic, readonly, copy) NSString *instructions;
/// Some extra data returned by Google about the travel mean and vehicle.
@property (nonatomic, readonly, copy) NSDictionary *travelInfo;
/// The route distance in meters represented by the step.
@property (nonatomic, readonly, assign) CLLocationDistance distance;
/// The vehicle type that should be used to travel from the step's startLocation to the endLocation. It only applies when the travelMode is GTTravelModeTransit.
@property (nonatomic, readonly, assign) GTTravelModeVehicleType vehicleType;
/// The estimated time needed to go to travel from the step's startLocation to the endLocation using the step's travelMode.
@property (nonatomic, readonly, assign) NSTimeInterval expectedTravelDuration;

///--------------------------------------------------
/// @name Creating a Route Step
///--------------------------------------------------

/**
 *  @abstract Creates and returns a new GTRouteStep object initialized with the contents of the passed-in dictionary.
 *  @see -[GTRouteStep initWithStepDictionary:]
 *
 *  @param dictionary A dictionary containing the information needed for the user to go from a location to another.
 *  The dictionary format shall match the Google Directions APIs for a route's step.
 *
 *  @return Returns a new GTRouteStep object initialized with the contents of the passed-in dictionary.
 */
+ (instancetype)routeStepWithStepDictionary:(NSDictionary *)dictionary;

/**
 *  @abstract Creates and returns a new GTRouteStep object initialized with the contents of the passed-in dictionary.
 *
 *  @param dictionary A dictionary containing the information needed for the user to go from a location to another.
 *  The dictionary format shall match the Google Directions APIs for a route's step.
 *
 *  @return Returns a new GTRouteStep object initialized with the contents of the passed-in dictionary.
 */
- (instancetype)initWithStepDictionary:(NSDictionary *)dictionary;

@end

@interface GTMutableRouteStep : GTRouteStep

- (void)setStartLocation:(CLLocation *)location;
- (void)setEndLocation:(CLLocation *)location;
- (void)setTravelMode:(GTTravelMode)travelMode;

- (void)setInstructions:(NSString *)instructions;
- (void)setTravelInfo:(NSDictionary *)travelInfo;
- (void)setDistance:(CLLocationDistance)distance;
- (void)setVehicleType:(GTTravelModeVehicleType)vehicleType;
- (void)setExpectedTravelDuration:(NSTimeInterval)travelDuration;

@end

/**
 @abstract GTRoute represents a route with directions to go from one location to another with a certain travel mode.
 @discussion A route is composed by smaller steps. This are instances of the GTRouteStep class.
 */
@interface GTRoute : NSObject <NSCoding, NSCopying, NSMutableCopying> {
    @private
    MKPolyline *_polyline;
}

///--------------------------------------------------
/// @name Retrieving the Route setup data
///--------------------------------------------------

/// The start location of the route.
@property (nonatomic, readonly, strong) CLLocation *startLocation;
/// The end location of the route.
@property (nonatomic, readonly, strong) CLLocation *endLocation;
/// The travel mode used to calculate the route. Each of the route steps many have a different travel mode (e.g. Walking or Bus or Subway for GTTravelModeTransit).
@property (nonatomic, readonly, assign) GTTravelMode travelMode;

///--------------------------------------------------
/// @name Retrieving the Route directions data
///--------------------------------------------------

/// An array of GTRouteStep objects representing each a small piece of the journey.
@property (nonatomic, readonly, copy) NSArray *steps;
/// A MKPolyline object representing the Route that you can add as an overlay on a MKMapView object.
@property (nonatomic, readonly, strong) MKPolyline *polyline;
/// A string representing  Route's polyline as returned by the Google Directions APIs. It can be used to draw directions on a GMSMapView (Google Maps SDK).
@property (nonatomic, readonly, copy) NSString *gMapsPolyline;
/// The expected travel duration
@property (nonatomic, readonly, assign) NSTimeInterval expectedTravelDuration;

///--------------------------------------------------
/// @name Create a Route
///--------------------------------------------------

/**
 *  @abstract Returns a newly created GTRoute object initialized with the passed-in values.
 *  @note Each of the route steps many have a different travel mode (e.g. Walking or Bus or Subway for GTTravelModeTransit).
 *  @see +[GTRoute routeWithSteps:travelMode:polyline:]
 *
 *  @param steps      An array of GTRouteStep objects representing each a small piece of the journey.
 *  @param travelMode The travel mode used to calculate the route.
 *
 *  @return A newly created GTRoute object initialized with the passed-in values.
 */
+ (instancetype)routeWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode;

/**
 *  @abstract Returns a newly created GTRoute object initialized with the passed-in values.
 *  @note Each of the route steps many have a different travel mode (e.g. Walking or Bus or Subway for GTTravelModeTransit).
 *  @see -[GTRoute initWithSteps:travelMode:polyline:]
 *
 *  @param steps      An array of GTRouteStep objects representing each a small piece of the journey.
 *  @param travelMode The travel mode used to calculate the route.
 *  @param polyline   A string representing  Route's polyline as returned by the Google Directions APIs.
 *
 *  @return A newly created GTRoute object initialized with the passed-in values.
 */
+ (instancetype)routeWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode polyline:(id)polyline;

/**
 *  @abstract Returns a newly created GTRoute object initialized with the passed-in values.
 *  @note Each of the route steps many have a different travel mode (e.g. Walking or Bus or Subway for GTTravelModeTransit).
 *  @see -[GTRoute initWithSteps:travelMode:polyline:]
 *
 *  @param steps      An array of GTRouteStep objects representing each a small piece of the journey.
 *  @param travelMode The travel mode used to calculate the route.
 *
 *  @return A newly created GTRoute object initialized with the passed-in values.
 */
- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode;

/**
 *  @abstract Returns a newly created GTRoute object initialized with the passed-in values.
 *  @note Each of the route steps many have a different travel mode (e.g. Walking or Bus or Subway for GTTravelModeTransit).
 *
 *  @param steps      An array of GTRouteStep objects representing each a small piece of the journey.
 *  @param travelMode The travel mode used to calculate the route.
 *  @param polyline   A string representing  Route's polyline as returned by the Google Directions APIs.
 *
 *  @return A newly created GTRoute object initialized with the passed-in values.
 */
- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode polyline:(id)polyline;

@end

@interface GTMutableRoute : GTRoute

- (void)setSteps:(NSArray *)steps;
- (void)setTravelMode:(GTTravelMode)travelMode;

- (void)setPolyline:(id)polyline;
- (void)setGMapsPolyline:(NSString *)gMapsPolyline;

@end
