//
//  GTGoogleGeocoder.m
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

#import "GTGoogleGeocoder.h"

@implementation GTGoogleGeocoder

+ (void)searchAddress:(NSString *)address nearLocation:(CLLocation *)location mapsApiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *, NSError *))completionBlock
{
    NSString *geocodingBaseUrl = nil;
    NSString *url = nil;
    
    if (location) {
        geocodingBaseUrl = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";
        url = [NSString stringWithFormat:@"%@query=%@&language=en&sensor=true&key=%@&location=%f,%f&radius=50000", geocodingBaseUrl, address, apiKey,location.coordinate.latitude, location.coordinate.longitude];
    }
    else {
        geocodingBaseUrl = @"https://maps.googleapis.com/maps/api/place/autocomplete/json?";
        url = [NSString stringWithFormat:@"%@input=%@&language=en&sensor=true&key=%@", geocodingBaseUrl, address, apiKey];
    }
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *queryUrl = [NSURL URLWithString:url];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                    error = [NSError errorWithDomain:@"ch.gtran.GTGoogleGeocoder" code:1 userInfo:jsonDictionary];
                }
                else {
                    results = [jsonDictionary objectForKey:@"results"];
                }
            }
            else {
                error = jsonError;
            }
        }
        else {
            error = networkError;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(results, error);
            }
        });
    });
}

+ (void)geocodeAddress:(NSString *)address withCompletionBlock:(void (^)(CLLocation *, NSError *))completionBlock
{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *url = [NSString stringWithFormat:@"%@address=%@&sensor=true", geocodingBaseUrl, address];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        CLLocation *location = nil;
        
        NSError *networkError = nil;
        NSData *responseData = [NSData dataWithContentsOfURL:queryUrl options:NSDataReadingMappedIfSafe error:&networkError];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                location = [self placemarkFromResponseDictionary:jsonDictionary];
            }
            else {
                error = jsonError;
            }
        }
        else {
            error = networkError;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(location, error);
            }
        });
    });
}

+ (void)reverseGeocodeLocationWithCoordinate:(CLLocationCoordinate2D)coordinate completionBlock:(void (^)(CLPlacemark *, NSError *))completionBlock
{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *formattedCoordinateString = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    NSString *url = [NSString stringWithFormat:@"%@latlng=%@&sensor=true", geocodingBaseUrl, formattedCoordinateString];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLPlacemark *placemark = nil;
        NSError *error = nil;
        
        NSError *networkError = nil;
        NSData *responseData = [NSData dataWithContentsOfURL:queryUrl options:NSDataReadingMappedIfSafe error:&networkError];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                // TODO
            }
            else {
                error = jsonError;
            }
        }
        else {
            error = networkError;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(placemark, error);
            }
        });
    });
}

+ (CLLocation *)placemarkFromResponseDictionary:(NSDictionary *)dictionary {
    NSArray *results = [dictionary objectForKey:@"results"];
    if (results.count) {
        NSDictionary *result = [results objectAtIndex:0];
        
        NSDictionary *geometry = [result objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        NSString *lat = [location objectForKey:@"lat"];
        NSString *lng = [location objectForKey:@"lng"];
        
        return [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue];
    }
    else {
        return nil;
    }
}

@end

