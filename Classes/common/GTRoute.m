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
        case GTTravelModeVehicleTypeFerry:
            return @"ferry";
            
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
            return @"rail";
            
        case GTTravelModeVehicleTypeCableCar:
            return @"cablecar";
            
        case GTTravelModeVehicleTypeCommuterTrain:
            return @"commutertrain";
            
        case GTTravelModeVehicleTypeFunicular:
            return @"funicular";
            
        case GTTravelModeVehicleTypeGandolaLift:
            return @"gandolalift";
            
        case GTTravelModeVehicleTypeHeavyRail:
            return @"heavyrail";
            
        case GTTravelModeVehicleTypeHighSpeedTrain:
            return @"highspeedtrain";
            
        case GTTravelModeVehicleTypeIntercityBus:
            return @"intercitybus";
            
        case GTTravelModeVehicleTypeMetroRail:
            return @"metrorail";
            
        case GTTravelModeVehicleTypeMonoRail:
            return @"monorail";
            
        case GTTravelModeVehicleTypeShareTaxi:
            return @"sharetaxi";
            
        case GTTravelModeVehicleTypeTram:
            return @"tram";
            
        case GTTravelModeVehicleTypeTrolleyBus:
            return @"trolleybus";
            
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
    if ([string isEqualToString:@"ferry"]) {
        return GTTravelModeVehicleTypeFerry;
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
    else if ([string isEqualToString:@"rail"]) {
        return GTTravelModeVehicleTypeTrain;
    }
    else if ([string isEqualToString:@"subway"]) {
        return GTTravelModeVehicleTypeSubway;
    }
    else if ([string isEqualToString:@"cablecar"]) {
        return GTTravelModeVehicleTypeCableCar;
    }
    else if ([string isEqualToString:@"commutertrain"]) {
        return GTTravelModeVehicleTypeCommuterTrain;
    }
    else if ([string isEqualToString:@"funicular"]) {
        return GTTravelModeVehicleTypeFunicular;
    }
    else if ([string isEqualToString:@"gandolalift"]) {
        return GTTravelModeVehicleTypeGandolaLift;
    }
    else if ([string isEqualToString:@"heavy_rail"]) {
        return GTTravelModeVehicleTypeHeavyRail;
    }
    else if ([string isEqualToString:@"highspeedtrain"]) {
        return GTTravelModeVehicleTypeHighSpeedTrain;
    }
    else if ([string isEqualToString:@"intercitybus"]) {
        return GTTravelModeVehicleTypeIntercityBus;
    }
    else if ([string isEqualToString:@"metrorail"]) {
        return GTTravelModeVehicleTypeMetroRail;
    }
    else if ([string isEqualToString:@"monorail"]) {
        return GTTravelModeVehicleTypeMonoRail;
    }
    else if ([string isEqualToString:@"sharetaxi"]) {
        return GTTravelModeVehicleTypeShareTaxi;
    }
    else if ([string isEqualToString:@"tram"]) {
        return GTTravelModeVehicleTypeTram;
    }
    else if ([string isEqualToString:@"trolleybus"]) {
        return GTTravelModeVehicleTypeTrolleyBus;
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
        _distance = [aDecoder decodeDoubleForKey:NSStringFromSelector(@selector(distance))];
        _travelMode = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(travelMode))];
        _endLocation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(endLocation))];
        _vehicleType = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(vehicleType))];
        _startLocation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(startLocation))];
        _instructions = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(instructions))] copy];
        _expectedTravelDuration = [aDecoder decodeDoubleForKey:NSStringFromSelector(@selector(expectedTravelDuration))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeDouble:_distance forKey:NSStringFromSelector(@selector(distance))];
    [aCoder encodeInteger:_travelMode forKey:NSStringFromSelector(@selector(travelMode))];
    [aCoder encodeObject:_endLocation forKey:NSStringFromSelector(@selector(endLocation))];
    [aCoder encodeInteger:_vehicleType forKey:NSStringFromSelector(@selector(vehicleType))];
    [aCoder encodeObject:_instructions forKey:NSStringFromSelector(@selector(instructions))];
    [aCoder encodeObject:_startLocation forKey:NSStringFromSelector(@selector(startLocation))];
    [aCoder encodeDouble:_expectedTravelDuration forKey:NSStringFromSelector(@selector(expectedTravelDuration))];
}

- (void)configureWithDictionary:(NSDictionary *)dictionary
{
    NSDictionary *distanceDictionary = [dictionary objectForKey:@"distance"];
    NSDictionary *durationDictionary = [dictionary objectForKey:@"duration"];
    NSDictionary *endLocationDictionary = [dictionary objectForKey:@"end_location"];
    NSDictionary *startLocationDictionary = [dictionary objectForKey:@"start_location"];
    NSDictionary *transitDetailsDictionary = [dictionary objectForKey:@"transit_details"];
    NSDictionary *vehicleDictionary = [[transitDetailsDictionary objectForKey:@"line"] objectForKey:@"vehicle"];
    
    NSNumber *startLocationLatitude = [startLocationDictionary objectForKey:@"lat"];
    NSNumber *startLocationLongitude = [startLocationDictionary objectForKey:@"lng"];
    
    NSNumber *endLocationLatitude = [endLocationDictionary objectForKey:@"lat"];
    NSNumber *endLocationLongitude = [endLocationDictionary objectForKey:@"lng"];
    
    _distance = [[distanceDictionary objectForKey:@"value"] doubleValue];
    _travelMode = GTTravelModeFromNSString([dictionary objectForKey:@"travel_mode"]);
    _expectedTravelDuration = [[durationDictionary objectForKey:@"value"] doubleValue];
    _instructions = [[dictionary objectForKey:@"html_instructions"] GT_stringByStrippingHTML];
    _endLocation = [[CLLocation alloc] initWithLatitude:[endLocationLatitude doubleValue] longitude:[endLocationLongitude doubleValue]];
    _startLocation = [[CLLocation alloc] initWithLatitude:[startLocationLatitude doubleValue] longitude:[startLocationLongitude doubleValue]];
    
    NSDictionary *transitArrivalStopDictionary = [transitDetailsDictionary objectForKey:@"arrival_stop"];
    if (transitArrivalStopDictionary) {
        _instructions = [_instructions stringByAppendingFormat:@". Arrive at %@", [transitArrivalStopDictionary objectForKey:@"name"]];
    }
    
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
    return [self routeWithSteps:steps travelMode:travelMode polyline:nil];
}

+ (instancetype)routeWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode polyline:(id)polyline
{
    return [[self alloc] initWithSteps:steps travelMode:travelMode polyline:polyline];
}

- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode
{
    return [self initWithSteps:steps travelMode:travelMode polyline:nil];
}

- (instancetype)initWithSteps:(NSArray *)steps travelMode:(GTTravelMode)travelMode polyline:(id)polyline
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
            if (polyline) {
                if ([polyline isKindOfClass:[NSString class]]) {
                    _gMapsPolyline = [polyline copy];
                }
                else if ([polyline isKindOfClass:[MKPolyline class]]) {
                    _polyline = polyline;
                }
            }
            
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
        _steps = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(steps))] copy];
        _travelMode = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(travelMode))];
        _endLocation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(endLocation))];
        _startLocation = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(startLocation))];
        _gMapsPolyline = [[aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gMapsPolyline))] copy];
        _expectedTravelDuration = [aDecoder decodeDoubleForKey:NSStringFromSelector(@selector(expectedTravelDuration))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_steps forKey:NSStringFromSelector(@selector(steps))];
    [aCoder encodeInteger:_travelMode forKey:NSStringFromSelector(@selector(travelMode))];
    [aCoder encodeObject:_endLocation forKey:NSStringFromSelector(@selector(endLocation))];
    [aCoder encodeObject:_startLocation forKey:NSStringFromSelector(@selector(startLocation))];
    [aCoder encodeObject:_gMapsPolyline forKey:NSStringFromSelector(@selector(gMapsPolyline))];
    [aCoder encodeDouble:_expectedTravelDuration forKey:NSStringFromSelector(@selector(expectedTravelDuration))];
}

- (NSString *)description
{
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"<%@: %p> {\n\tstartPoint:%@,\n\tendPoint:%@,\n\ttravelMode:%d,\n\tduration:%.1f,\n\tsteps: [", NSStringFromClass(self.class), &self, self.startLocation, self.endLocation, (int)self.travelMode, self.expectedTravelDuration];
    
    for (GTRouteStep *step in self.steps) {
        [string appendFormat:@"\n\t\t%@", step.description];
    }
    
    [string appendString:@"\n\t]\n}"];
    
    return [string copy];
}

// MKPolyline and it's superclasses do not conform to the NSCoding protocol, therefore, if the self was initialized with initWithCoder: will not have the polyline set.
- (MKPolyline *)polyline
{
    if (_steps.count && !_polyline) {
        // create a c array containing the start and end coordinate of each step
        CLLocationCoordinate2D coordinates[(_steps.count * 2)]; // by 2 as each step should have a start and end location.
        NSInteger coordinatesCount = 0;
        for (GTRouteStep *step in _steps) {
            if (step.startLocation) {
                coordinates[coordinatesCount] = step.startLocation.coordinate;
                coordinatesCount++;
            }
            if (step.endLocation) {
                coordinates[coordinatesCount] = step.endLocation.coordinate;
                coordinatesCount++;
            }
        }
        
        if (coordinatesCount) {
            _polyline = [MKPolyline polylineWithCoordinates:&coordinates[0] count:coordinatesCount];
        }
    }
    
    return _polyline;
}

@end
