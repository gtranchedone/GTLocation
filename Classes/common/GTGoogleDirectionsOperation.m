//
//  GTGoogleDirectionsOperation.m
//  GTLocation
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

@implementation GTGoogleDirectionsOperation

#pragma mark - Helpers

+ (NSString *)formattedLocation:(CLLocation *)location
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
        NSString *directionsBaseUrl = @"http://maps.googleapis.com/maps/api/directions/json?";
        NSString *url = [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=false&mode=%@", directionsBaseUrl,
                         [self.class formattedLocation:self.origin],
                         [self.class formattedLocation:self.destination],
                         NSStringFromGTTravelMode(self.travelMode)];
        
        if (self.travelMode == GTTravelModeTransit || (self.departureTime && self.arrivalTime)) {
            if (!self.departureTime) {
                self.departureTime = [NSDate date];
            }
            
            if (self.departureTime && self.arrivalTime) {
                url = [NSString stringWithFormat:@"%@&departure_time=%.0f&arrival_time=%.0f", url, _departureTime.timeIntervalSince1970, _arrivalTime.timeIntervalSince1970];
            }
            else if (self.departureTime) {
                url = [NSString stringWithFormat:@"%@&departure_time=%.0f", url, _departureTime.timeIntervalSince1970];
            }
            else if (self.arrivalTime) {
                url = [NSString stringWithFormat:@"%@&arrival_time=%.0f", url, _arrivalTime.timeIntervalSince1970];
            }
        }
        
        url = [url stringByAppendingFormat:@"&alternatives=%@", (self.findAlternativeRoutes ? @"true" : @"false")];
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL *queryUrl = [NSURL URLWithString:url];
        
        NSError *error = nil;
        NSArray *results = nil;
        
        NSError *networkError = nil;
        NSData *responseData = [NSData dataWithContentsOfURL:queryUrl options:NSDataReadingMappedIfSafe error:&networkError];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                NSString *status = [jsonDictionary objectForKey:@"status"];
                if (![status isEqualToString:@"OK"] && ![status isEqualToString:@"ZERO_RESULTS"]) {
                    error = [NSError errorWithDomain:@"ch.gtran.GTGoogleDirectionsOperation" code:1 userInfo:jsonDictionary];
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
        [self setFinished:YES];
    }
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    _finished = finished;
    _executing = !finished;
    
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isExecuting
{
    return _executing;
}

- (BOOL)isFinished
{
    return _finished;
}

@end
