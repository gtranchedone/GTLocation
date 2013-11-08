//
//  GTRoute.m
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

#import "GTRoute.h"
#import <GTFoundation/NSString+HTML.h>

inline GTTravelMode GTTravelModeFromNSString(NSString *string)
{
    string = [string lowercaseString];
    if ([string isEqualToString:@"walking"]) {
        return GTTravelModeWalking;
    }
    else if ([string isEqualToString:@"cycling"]) {
        return GTTravelModeCycling;
    }
    else if ([string isEqualToString:@"transit"]) {
        return GTTravelModeTransit;
    }
    else {
        return GTTravelModeDriving;
    }
}

inline NSString * NSStringFromGTTravelMode(GTTravelMode travelMode)
{
    switch (travelMode) {
            case GTTravelModeTransit:
            return @"transit";
            
            case GTTravelModeCycling:
            return @"cycling";
            
            case GTTravelModeWalking:
            return @"walking";
            
        default:
            return @"driving";
    }
}

FOUNDATION_STATIC_INLINE NSString * NSStringFromGTTravelModeVehicleType(GTTravelModeVehicleType type)
{
    switch (type) {
            case GTTravelModeVehicleTypeBoat:
            return @"boat";
            
            case GTTravelModeVehicleTypeBus:
            return @"bus";
            
            case GTTravelModeVehicleTypeCatapult:
            return @"catapult";
            
            case GTTravelModeVehicleTypePlane:
            return @"plane";
            
            case GTTravelModeVehicleTypeRocket:
            return @"rocket";
            
            case GTTravelModeVehicleTypeSpaceship:
            return @"spaceship";
            
            case GTTravelModeVehicleTypeSubway:
            return @"subway";
            
            case GTTravelModeVehicleTypeTrain:
            return @"train";
            
        default:
            return nil;
    }
}

FOUNDATION_STATIC_INLINE GTTravelModeVehicleType GTTravelModeVehicleTypeFromNSString(NSString *string)
{
    if (!string.length) {
        return GTTravelModeVehicleTypeNone;
    }
    
    string = [string lowercaseString];
    if ([string isEqualToString:@"boat"]) {
        return GTTravelModeVehicleTypeBoat;
    }
    else if ([string isEqualToString:@"bus"]) {
        return GTTravelModeVehicleTypeBus;
    }
    else if ([string isEqualToString:@"catapult"]) {
        return GTTravelModeVehicleTypeCatapult;
    }
    else if ([string isEqualToString:@"rocket"]) {
        return GTTravelModeVehicleTypeRocket;
    }
    else if ([string isEqualToString:@"spaceship"]) {
        return GTTravelModeVehicleTypeSpaceship;
    }
    else if ([string isEqualToString:@"plane"]) {
        return GTTravelModeVehicleTypePlane;
    }
    else if ([string isEqualToString:@"train"]) {
        return GTTravelModeVehicleTypeTrain;
    }
    else if ([string isEqualToString:@"subway"]) {
        return GTTravelModeVehicleTypeSubway;
    }
    else {
        return GTTravelModeVehicleTypeUndefined;
    }
}

@implementation GTRouteStep

+ (instancetype)routeStepWithStepDictionary:(NSDictionary *)dictionary
{
    return [[self alloc] initWithStepDictionary:dictionary];
}

- (instancetype)initWithStepDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self configureWithDictionary:dictionary];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _distance = [aDecoder decodeDoubleForKey:@"distance"];
        _travelMode = [aDecoder decodeIntegerForKey:@"travelMode"];
        _endLocation = [aDecoder decodeObjectForKey:@"endLocation"];
        _vehicleType = [aDecoder decodeIntegerForKey:@"vehicleType"];
        _startLocation = [aDecoder decodeObjectForKey:@"startLocation"];
        _instructions = [[aDecoder decodeObjectForKey:@"instructions"] copy];
        _expectedTravelDuration = [aDecoder decodeDoubleForKey:@"expectedTravelDuration"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_distance forKey:@"distance"];
    [aCoder encodeInteger:_travelMode forKey:@"travelMode"];
    [aCoder encodeInteger:_vehicleType forKey:@"vehicleType"];
    [aCoder encodeObject:_instructions forKey:@"instructions"];
    [aCoder encodeObject:_endLocation forKey:@"endLocation"];
    [aCoder encodeObject:_startLocation forKey:@"startLocation"];
    [aCoder encodeDouble:_expectedTravelDuration forKey:@"expectedTravelDuration"];
}

- (void)configureWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *distanceDictionary = [dictionary objectForKey:@"distance"];
    NSDictionary *durationDictionary = [dictionary objectForKey:@"duration"];
    NSDictionary *endLocationDictionary = [dictionary objectForKey:@"end_location"];
    NSDictionary *startLocationDictionary = [dictionary objectForKey:@"start_location"];
    NSDictionary *vehicleDictionary = [[[dictionary objectForKey:@"transit_details"] objectForKey:@"line"] objectForKey:@"vehicle"];
    
    NSNumber *startLocationLatitude = [startLocationDictionary objectForKey:@"lat"];
    NSNumber *startLocationLongitude = [startLocationDictionary objectForKey:@"lng"];
    
    NSNumber *endLocationLatitude = [endLocationDictionary objectForKey:@"lat"];
    NSNumber *endLocationLongitude = [endLocationDictionary objectForKey:@"lng"];
    
    _distance = [[distanceDictionary objectForKey:@"value"] doubleValue];
    _travelMode = GTTravelModeFromNSString([dictionary objectForKey:@"travel_mode"]);
    _expectedTravelDuration = [[durationDictionary objectForKey:@"value"] doubleValue];
    _instructions = [[dictionary objectForKey:@"html_instructions"] stringByStrippingHTML];
    _endLocation = [[CLLocation alloc] initWithLatitude:[endLocationLatitude doubleValue] longitude:[endLocationLongitude doubleValue]];
    _startLocation = [[CLLocation alloc] initWithLatitude:[startLocationLatitude doubleValue] longitude:[startLocationLongitude doubleValue]];
    
    if (vehicleDictionary.count) {
        NSString *vehicleType = [vehicleDictionary objectForKey:@"type"];
        _vehicleType = GTTravelModeVehicleTypeFromNSString(vehicleType);
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> {travelMode:%@, duration: %.0fs, distance: %.0fm, instructions: %@}", NSStringFromClass(self.class), &self, NSStringFromGTTravelMode(self.travelMode), self.expectedTravelDuration, self.distance, self.instructions];
}

@end


@implementation GTRoute

+ (instancetype)routeWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode
{
    return [[self alloc] initWithSteps:steps travelMode:travelMode];
}

- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode
{
    self = [super init];
    if (self) {
        BOOL stepsAreValid = YES;
        for (id step in steps) {
            if (![step isKindOfClass:[GTRouteStep class]]) {
                stepsAreValid = NO;
                break;
            }
            else {
                _expectedTravelDuration += ((GTRouteStep *)step).expectedTravelDuration;
            }
        }
        
        if (stepsAreValid) {
            _steps = [steps copy];
            _travelMode = travelMode;
            _endLocation = [[_steps lastObject] endLocation];
            _startLocation = [[_steps firstObject] startLocation];
        }
        else {
            [NSException raise:@"ch.gtran.GTRoute" format:@"Attempt to initialize a GTRoute object with instances of classes other than GTRouteStep: %@", steps];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _steps = [[aDecoder decodeObjectForKey:@"steps"] copy];
        _travelMode = [aDecoder decodeIntegerForKey:@"travelMode"];
        _endLocation = [aDecoder decodeObjectForKey:@"endLocation"];
        _startLocation = [aDecoder decodeObjectForKey:@"startLocation"];
        _expectedTravelDuration = [aDecoder decodeDoubleForKey:@"expectedTravelDuration"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_steps forKey:@"steps"];
    [aCoder encodeInteger:_travelMode forKey:@"travelMode"];
    [aCoder encodeObject:_endLocation forKey:@"endLocation"];
    [aCoder encodeObject:_startLocation forKey:@"startLocation"];
    [aCoder encodeDouble:_expectedTravelDuration forKey:@"expectedTravelDuration"];
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p> {\n\tstartPoint:%@,\n\tendPoint:%@,\n\ttravelMode:%d,\n\tduration:%.1f,\n\tsteps: [", NSStringFromClass(self.class), &self, self.startLocation, self.endLocation, self.travelMode, self.expectedTravelDuration];
    
    for (GTRouteStep *step in self.steps) {
        [string appendFormat:@"\n\t\t%@", step.description];
    }
    
    [string appendString:@"\n\t]\n}"];
    
    return [string copy];
}

@end
