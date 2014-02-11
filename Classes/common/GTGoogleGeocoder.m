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

#pragma mark - Public APIs -
#pragma mark Google Place APIs

+ (void)searchLocationsMatchingAddress:(NSString *)address apiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock
{
    [self searchLocationsMatchingAddress:address nearLocation:nil apiKey:apiKey completionBlock:completionBlock];
}

+ (void)searchLocationsMatchingAddress:(NSString *)address nearLocation:(CLLocation *)location apiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock
{
    NSString *geocodingBaseUrl = @"https://maps.googleapis.com/maps/api/place/textsearch/json?";
    NSString *urlString = [NSString stringWithFormat:@"%@query=%@&language=en&sensor=true&key=%@", geocodingBaseUrl, address, apiKey];
    
    if (location) {
        urlString = [urlString stringByAppendingFormat:@"&location=%f,%f&radius=50000", location.coordinate.latitude, location.coordinate.longitude];
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    [self performQueryWithURL:[NSURL URLWithString:urlString] address:address completionBlock:completionBlock];
}

#pragma mark Google Maps APIs

+ (void)geocodeAddress:(NSString *)address withCompletionBlock:(void (^)(CLLocation *, NSError *))completionBlock
{
    NSString *geocodingBaseUrl = @"http://maps.googleapis.com/maps/api/geocode/json?";
    NSString *urlString = [NSString stringWithFormat:@"%@address=%@&sensor=true", geocodingBaseUrl, address];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    NSURL *queryUrl = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        CLLocation *location = nil;
        
        NSError *networkError = nil;
        NSData *responseData = [NSData dataWithContentsOfURL:queryUrl options:NSDataReadingMappedIfSafe error:&networkError];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                location = [self locationFromResponseDictionary:jsonDictionary];
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

#pragma mark - Private APIs -

+ (void)performQueryWithURL:(NSURL *)queryURL address:(NSString *)address completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock
{
    address = [address lowercaseString];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:queryURL cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *responseData, NSURLResponse *response, NSError *networkError) {
        NSError *error = nil;
        NSMutableArray *results = [NSMutableArray array];
        
        if (responseData && !networkError) {
            NSError *jsonError = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
            
            if (jsonDictionary && !jsonError) {
                NSString *status = [jsonDictionary objectForKey:@"status"];
                if (![status isEqualToString:@"OK"] && ![status isEqualToString:@"ZERO_RESULTS"]) {
                    error = [NSError errorWithDomain:@"ch.gtran.GTGoogleGeocoder" code:1 userInfo:jsonDictionary];
                }
                else {
                    NSArray *googleResults = [jsonDictionary objectForKey:@"results"];
                    [googleResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        __block NSInteger numberOfWords = 0;
                        __block NSInteger numberOfMatches = 0;
                        NSString *name = [[obj objectForKey:@"name"] lowercaseString];
                        
                        [name enumerateSubstringsInRange:NSMakeRange(0, name.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                            numberOfWords++;
                            if ([address rangeOfString:substring].location != NSNotFound) {
                                numberOfMatches++;
                            }
                        }];
                        
                        if (numberOfMatches > (numberOfWords / 2)) {
                            [results addObject:[self locationFromResponseDictionary:obj]];
                        }
                    }];
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
    }];
    [task resume];
}

+ (CLLocation *)locationFromResponseDictionary:(NSDictionary *)dictionary {
    NSArray *results = [dictionary objectForKey:@"results"];
    if (results.count) {
        dictionary = [results objectAtIndex:0];
    }
    
    if (dictionary) {
        NSDictionary *geometry = [dictionary objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        NSNumber *lat = [location objectForKey:@"lat"];
        NSNumber *lng = [location objectForKey:@"lng"];
        
        if (lat && lng) {
            return [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lng.doubleValue];
        }
        else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

@end
