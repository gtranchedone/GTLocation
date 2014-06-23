//
//  GTRoute.m
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

#import "GTRoute.h"
#import <objc/runtime.h>

static NSString * GTEncodedDictionaryValueKey = @"GTEncodedDictionaryValueKey";

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
    else if ([string isEqualToString:@"skating"]) {
        return GTTravelModeSkating;
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
            
        case GTTravelModeDriving:
            return @"driving";
            
        case GTTravelModeSkating:
            return @"skating";
    }
}

inline NSString * NSStringFromGTTravelModeVehicleType(GTTravelModeVehicleType type)
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
            
        case GTTravelModeVehicleTypeSkate:
            return @"skate";
            
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
    else if ([string isEqualToString:@"skate"]) {
        return GTTravelModeVehicleTypeSkate;
    }
    else {
        return GTTravelModeVehicleTypeUndefined;
    }
}

@interface GTRouteStep ()

@property (nonatomic, readwrite, strong) CLLocation *startLocation;
@property (nonatomic, readwrite, strong) CLLocation *endLocation;
@property (nonatomic, readwrite, assign) GTTravelMode travelMode;

@property (nonatomic, readwrite, copy) NSString *instructions;
@property (nonatomic, readwrite, copy) NSDictionary *travelInfo;
@property (nonatomic, readwrite, assign) CLLocationDistance distance;
@property (nonatomic, readwrite, assign) GTTravelModeVehicleType vehicleType;
@property (nonatomic, readwrite, assign) NSTimeInterval expectedTravelDuration;

@end

@implementation GTRouteStep

#pragma mark - Superclass Methods Override -
#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%p <%@> %@", &self, NSStringFromClass([self class]), [[self dictionaryValue] description]];
}

#pragma mark Equality

- (NSUInteger)hash
{
    return [[self dictionaryValue] hash];
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual && [object isKindOfClass:[self class]]) {
        isEqual = [[self dictionaryValue] isEqualToDictionary:[object dictionaryValue]];
    }
    
    return isEqual;
}

#pragma mark - Public APIs -

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

#pragma mark - Private APIs -

- (NSDictionary *)dictionaryValue
{
    NSMutableArray *propertyKeys = [NSMutableArray array];
    Class currentClass = self.class;
    
    while ([currentClass superclass]) { // avoid printing NSObject's attributes
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(currentClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if (propName) {
                NSString *propertyName = [NSString stringWithUTF8String:propName];
                [propertyKeys addObject:propertyName];
            }
        }
        free(properties);
        currentClass = [currentClass superclass];
    }
    
    return [self dictionaryWithValuesForKeys:propertyKeys];
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
    
    _travelInfo = [transitDetailsDictionary copy];
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

#pragma mark - NSCoding -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSDictionary *storedDictionary = [aDecoder decodeObjectForKey:GTEncodedDictionaryValueKey];
        [self setValuesForKeysWithDictionary:storedDictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self dictionaryValue] forKey:GTEncodedDictionaryValueKey];
}

#pragma mark - NSCopying -

- (id)copyWithZone:(NSZone *)zone
{
    NSDictionary *dictionaryValue = [self dictionaryValue];
    GTRouteStep *routeStep = [[GTRouteStep alloc] init];
    
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(copy)]) {
            [routeStep setValue:[obj copy] forKey:key];
        }
        else {
            [routeStep setValue:obj forKeyPath:key];
        }
    }];
    
    return routeStep;
}

#pragma mark - NSMutableCopying -

- (id)mutableCopyWithZone:(NSZone *)zone
{
    NSDictionary *dictionaryValue = [self dictionaryValue];
    GTMutableRouteStep *routeStep = [[GTMutableRouteStep alloc] init];
    
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(copy)]) {
            [routeStep setValue:[obj copy] forKey:key];
        }
        else {
            [routeStep setValue:obj forKeyPath:key];
        }
    }];
    
    return routeStep;
}

@end

@implementation GTMutableRouteStep

- (void)setStartLocation:(CLLocation *)location
{
    [super setStartLocation:location];
}

- (void)setEndLocation:(CLLocation *)location
{
    [super setEndLocation:location];
}

- (void)setTravelMode:(GTTravelMode)travelMode
{
    [super setTravelMode:travelMode];
}

- (void)setInstructions:(NSString *)instructions
{
    [super setInstructions:instructions];
}

- (void)setTravelInfo:(NSDictionary *)travelInfo
{
    [super setTravelInfo:travelInfo];
}

- (void)setDistance:(CLLocationDistance)distance
{
    [super setDistance:distance];
}

- (void)setVehicleType:(GTTravelModeVehicleType)vehicleType
{
    [super setVehicleType:vehicleType];
}

- (void)setExpectedTravelDuration:(NSTimeInterval)travelDuration
{
    [super setExpectedTravelDuration:travelDuration];
}

@end

@interface GTRoute ()

@property (nonatomic, readwrite, strong) CLLocation *startLocation;
@property (nonatomic, readwrite, strong) CLLocation *endLocation;
@property (nonatomic, readwrite, assign) GTTravelMode travelMode;

@property (nonatomic, readwrite, copy) NSArray *steps;
@property (nonatomic, readwrite, strong) MKPolyline *polyline;
@property (nonatomic, readwrite, copy) NSString *gMapsPolyline;
@property (nonatomic, readwrite, assign) NSTimeInterval expectedTravelDuration;

@end

@implementation GTRoute

#pragma mark - Superclass Methods Override -
#pragma mark Description

- (NSString *)description
{
    return [NSString stringWithFormat:@"%p <%@> %@", &self, NSStringFromClass([self class]), [[self dictionaryValue] description]];
}

#pragma mark Equality

- (NSUInteger)hash
{
    return [[self dictionaryValue] hash];
}

- (BOOL)isEqual:(id)object
{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual && [object isKindOfClass:[self class]]) {
        isEqual = [[self dictionaryValue] isEqualToDictionary:[object dictionaryValue]];
    }
    
    return isEqual;
}

#pragma mark - Public APIs -

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
        // NOTE: hack
        if (travelMode == GTTravelModeSkating) {
            for (GTRouteStep *step in steps) {
                step.expectedTravelDuration *= 2;
                step.travelMode = travelMode;
            }
        }
        
        // Initialize the route
        self.steps = steps;
        self.travelMode = travelMode;
        
        if (polyline) {
            if ([polyline isKindOfClass:[NSString class]]) {
                self.gMapsPolyline = [polyline copy];
            }
            else if ([polyline isKindOfClass:[MKPolyline class]]) {
                self.polyline = polyline;
            }
        }
    }
    return self;
}

- (void)setSteps:(NSArray *)steps
{
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
        _endLocation = [[_steps lastObject] endLocation];
        _startLocation = [[_steps firstObject] startLocation];
    }
    else {
        [NSException raise:@"com.gtranchedone.GTRoute" format:@"Attempt to initialize a GTRoute object with instances of classes other than GTRouteStep: %@", steps];
    }
}

#pragma mark - Private APIs -

- (NSDictionary *)dictionaryValue
{
    NSMutableArray *propertyKeys = [NSMutableArray array];
    Class currentClass = self.class;
    
    while ([currentClass superclass]) { // avoid printing NSObject's attributes
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList(currentClass, &outCount);
        for (i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propName = property_getName(property);
            if (propName) {
                NSString *propertyName = [NSString stringWithUTF8String:propName];
                [propertyKeys addObject:propertyName];
            }
        }
        free(properties);
        currentClass = [currentClass superclass];
    }
    
    return [self dictionaryWithValuesForKeys:propertyKeys];
}

#pragma mark - NSCoding -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        NSDictionary *storedDictionary = [aDecoder decodeObjectForKey:GTEncodedDictionaryValueKey];
        [self setValuesForKeysWithDictionary:storedDictionary];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self dictionaryValue] forKey:GTEncodedDictionaryValueKey];
}

#pragma mark - NSCopying -

- (id)copyWithZone:(NSZone *)zone
{
    NSDictionary *dictionaryValue = [[self dictionaryValue] copy];
    GTRoute *route = [[GTRoute alloc] init];
    
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(copy)]) {
            [route setValue:[obj copy] forKey:key];
        }
        else {
            if ([obj isKindOfClass:[MKPolyline class]]) {
                MKPolyline *polyline = (MKPolyline *)obj;
                MKPolyline *copiedPolyline = [MKPolyline polylineWithPoints:polyline.points count:polyline.pointCount];
                [route setValue:copiedPolyline forKeyPath:key];
            }
            else {
                [route setValue:obj forKeyPath:key];
            }
        }
    }];
    
    return route;
}

#pragma mark - NSMutableCopying -

- (id)mutableCopyWithZone:(NSZone *)zone
{
    NSDictionary *dictionaryValue = [[self dictionaryValue] copy];
    GTMutableRoute *route = [[GTMutableRoute alloc] init];
    
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj respondsToSelector:@selector(copy)]) {
            [route setValue:[obj copy] forKey:key];
        }
        else {
            if ([obj isKindOfClass:[MKPolyline class]]) {
                MKPolyline *polyline = (MKPolyline *)obj;
                MKPolyline *copiedPolyline = [MKPolyline polylineWithPoints:polyline.points count:polyline.pointCount];
                [route setValue:copiedPolyline forKeyPath:key];
            }
            else {
                [route setValue:obj forKeyPath:key];
            }
        }
    }];
    
    return route;
}
#pragma mark - Setters and Getters -

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

@implementation GTMutableRoute

- (void)setSteps:(NSArray *)steps
{
    [super setSteps:steps];
}

- (void)setTravelMode:(GTTravelMode)travelMode
{
    [super setTravelMode:travelMode];
}

- (void)setPolyline:(id)polyline
{
    [super setPolyline:polyline];
}

- (void)setGMapsPolyline:(NSString *)gMapsPolyline
{
    [super setGMapsPolyline:gMapsPolyline];
}

@end
