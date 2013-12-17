//
//  GTPlacemark.m
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

@interface GTPlacemark ()

@property (nonatomic, readwrite, copy) CLLocation *location;
@property (nonatomic, readwrite, copy) NSString *addressLine;

@property (nonatomic, readwrite, copy) NSString *name; // eg. Apple Inc.
@property (nonatomic, readwrite, copy) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
@property (nonatomic, readwrite, copy) NSString *subThoroughfare; // eg. 1
@property (nonatomic, readwrite, copy) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readwrite, copy) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, readwrite, copy) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readwrite, copy) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readwrite, copy) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, readwrite, copy) NSString *ISOcountryCode; // eg. US
@property (nonatomic, readwrite, copy) NSString *country; // eg. United States
@property (nonatomic, readwrite, copy) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, readwrite, copy) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, readwrite, copy) NSArray *areasOfInterest; // eg. Golden Gate Park

@end


@implementation GTPlacemark

+ (GTPlacemark *)placemarkWithLocation:(CLLocation *)location address:(NSString *)address
{
    return [[self alloc] initWithPlacemarkWithLocation:location address:address];
}

- (instancetype)initWithPlacemarkWithLocation:(CLLocation *)location address:(NSString *)address
{
    self = [super init];
    if (self) {
        [self setupByParsingAddress:address forLocation:location];
    }
    return self;
}

- (void)setupByParsingAddress:(NSString *)address forLocation:(NSString *)location
{
    self.location = location;
    self.addressLine = address;
}

@end
