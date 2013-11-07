//
//  GTGoogleGeocoder.h
//  GTFoundation
//
//  Created by Gianluca Tranchedone on 4/11/13.
//  Copyright (c) 2013 Gianluca Tranchedone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GTGoogleGeocoder : NSObject

+ (void)geocodeAddress:(NSString *)address withCompletionBlock:(void (^)(CLLocation *location, NSError *error))completionBlock;
+ (void)reverseGeocodeLocationWithCoordinate:(CLLocationCoordinate2D)coordinate completionBlock:(void (^)(CLPlacemark *placemark, NSError *error))completionBlock;
+ (void)searchAddress:(NSString *)address nearLocation:(CLLocation *)location mapsApiKey:(NSString *)apiKey completionBlock:(void (^)(NSArray *results, NSError *error))completionBlock;

@end
