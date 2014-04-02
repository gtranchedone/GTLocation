//
//  GTPlacemark.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GTPlacemark : NSObject

@property (nonatomic, readonly, copy) CLLocation *location;
@property (nonatomic, readonly, copy) NSString *addressLine;

@property (nonatomic, readonly, copy) NSString *name; // eg. Apple Inc.
@property (nonatomic, readonly, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
@property (nonatomic, readonly, copy) NSString *subThoroughfare; // eg. 1
@property (nonatomic, readonly, copy) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readonly, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, readonly, copy) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readonly, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readonly, copy) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, readonly, copy) NSString *ISOcountryCode; // eg. US
@property (nonatomic, readonly, copy) NSString *country; // eg. United States
@property (nonatomic, readonly, copy) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, readonly, copy) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, readonly, copy) NSArray *areasOfInterest; // eg. Golden Gate Park

+ (GTPlacemark *)placemarkWithLocation:(CLLocation *)location address:(NSString *)address __unavailable;

@end
