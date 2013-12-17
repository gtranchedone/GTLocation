//
//  GTGoogleGeocoder.h
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

#import "GTPlacemark.h"

@interface GTGoogleGeocoder : NSObject

///--------------------------------------------------
/// @name Google Place APIs
///--------------------------------------------------

+ (void)searchLocationsMatchingAddress:(NSString *)address apiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock;
+ (void)searchLocationsMatchingAddress:(NSString *)address nearLocation:(CLLocation *)location apiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock;

///--------------------------------------------------
/// @name Google Maps APIs
///--------------------------------------------------

+ (void)geocodeAddress:(NSString *)address withCompletionBlock:(void (^)(CLLocation *location, NSError *error))completionBlock;
+ (void)reverseGeocodeLocationWithCoordinate:(CLLocationCoordinate2D)coordinate completionBlock:(void (^)(CLPlacemark *placemark, NSError *error))completionBlock;

@end
