//
//  GTGoogleDirectionsOperation.m
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

#import "GTGoogleDirectionsOperation.h"

static NSString * const GTGoogleMapsDirectionsURLFormat = @"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=%@&sensor=false";

@implementation GTGoogleDirectionsOperation

#pragma mark - Helpers

+ (NSString *)formattedStringFromLocation:(CLLocation *)location
{
    return [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude];
}

#pragma mark - Public APIs

+ (instancetype)operationWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode
{
    return [[self alloc] initWithStartLocation:origin destination:destination travelMode:travelMode];
}

- (instancetype)initWithStartLocation:(CLLocation *)origin destination:(CLLocation *)destination travelMode:(GTTravelMode)travelMode
{
    self = [super init];
    if (self) {
        _origin = origin;
        _travelMode = travelMode;
        _destination = destination;
        _findAlternativeRoutes = YES;
    }
    return self;
}

#pragma mark - Superclass Methods Override

- (void)main
{
    if (!self.isCancelled) {
        NSString *travelMode = NSStringFromGTTravelMode(self.travelMode);
        if (self.travelMode == GTTravelModeSkating) {
            travelMode = NSStringFromGTTravelMode(GTTravelModeWalking);
        }
        
        NSString *origin = [self.class formattedStringFromLocation:self.origin];
        NSString *destination = [self.class formattedStringFromLocation:self.destination];
        NSString *queryURLString = [NSString stringWithFormat:GTGoogleMapsDirectionsURLFormat, origin, destination, travelMode];
        
        if (self.travelMode == GTTravelModeTransit || (self.departureTime && self.arrivalTime)) {
            if (!self.departureTime) {
                self.departureTime = [NSDate date];
            }
            
            NSTimeInterval timeIntervalToArrival = [self.arrivalTime timeIntervalSince1970];
            NSTimeInterval timeIntervalToDeparture = [self.departureTime timeIntervalSince1970];
            
            if (self.departureTime && self.arrivalTime) {
                queryURLString = [NSString stringWithFormat:@"%@&departure_time=%.0f&arrival_time=%.0f", queryURLString, timeIntervalToDeparture, timeIntervalToArrival];
            }
            else if (self.departureTime) {
                queryURLString = [NSString stringWithFormat:@"%@&departure_time=%.0f", queryURLString, timeIntervalToDeparture];
            }
            else if (self.arrivalTime) {
                queryURLString = [NSString stringWithFormat:@"%@&arrival_time=%.0f", queryURLString, timeIntervalToArrival];
            }
        }
        
        queryURLString = [queryURLString stringByAppendingFormat:@"&alternatives=%@", (self.findAlternativeRoutes ? @"true" : @"false")];
        queryURLString = [queryURLString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSArray *results = nil;
        NSError *networkError = nil;
        NSURL *queryURL = [NSURL URLWithString:queryURLString];
        NSData *responseData = [NSData dataWithContentsOfURL:queryURL options:NSDataReadingMappedIfSafe error:&networkError];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                                           options:NSJSONReadingAllowFragments
	                                                                         error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                NSString *status = [jsonDictionary objectForKey:@"status"];
                if (![status isEqualToString:@"OK"] && ![status isEqualToString:@"ZERO_RESULTS"]) {
                    error = [NSError errorWithDomain:@"com.gtranchedone.GTGoogleDirectionsOperation" code:1 userInfo:jsonDictionary];
                }
                else {
                    results = [jsonDictionary objectForKey:@"routes"];
                    NSMutableArray *availableRoutes = [NSMutableArray arrayWithCapacity:results.count];
                    for (NSDictionary *routeDictionary in results) {
                        NSArray *legs = [routeDictionary objectForKey:@"legs"];
                        NSDictionary *leg = [legs firstObject]; // no support for multiple legs at the moments (legs.count > 1 if there are intermediate destinations)
                        NSArray *steps = [leg objectForKey:@"steps"];
                        NSMutableArray *routeSteps = [NSMutableArray arrayWithCapacity:steps.count];
                        for (NSDictionary *stepDictionary in steps) {
                            [routeSteps addObject:[GTRouteStep routeStepWithStepDictionary:stepDictionary]];
                        }
                        NSString *polyline = [[routeDictionary objectForKey:@"overview_polyline"] objectForKey:@"points"];
                        [availableRoutes addObject:[GTRoute routeWithSteps:routeSteps travelMode:self.travelMode polyline:polyline]];
                    }
                    _availableRoutes = [availableRoutes copy];
                }
            }
            else {
                error = jsonError;
            }
        }
        else {
            error = networkError;
        }
        
        _error = [error copy];
    }
}

@end
