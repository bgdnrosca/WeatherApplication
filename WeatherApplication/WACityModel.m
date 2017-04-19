//
//  WACityModel.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/22/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WACityModel.h"

@implementation WACityModel

- (instancetype) initWithDictionary: (NSDictionary*) dictionary{
    self = [super init];
    self.cityId = [[dictionary objectForKey:@"_id" ] longValue];
    self.cityName = [dictionary objectForKey:@"name"];
    self.country = [dictionary objectForKey:@"country"];
    NSDictionary *coordDictionary = [dictionary objectForKey:@"coord"];
    self.latitude = [[coordDictionary objectForKey:@"lon"] doubleValue];
    self.longitude = [[coordDictionary objectForKey:@"lat"] doubleValue];
    self.isChecked = false;
    return self;    
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [((WACityModel *)other).cityName isEqualToString:self.cityName];
}

- (NSUInteger)hash {
    return [self.cityName hash];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.cityId = (long)[aDecoder decodeInt64ForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName" ];
        self.country =  [aDecoder decodeObjectForKey:@"country"];
        self.isChecked = [aDecoder decodeBoolForKey:@"isChecked"];
        self.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        self.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt64:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeBool:self.isChecked forKey:@"isChecked"];
    [aCoder encodeDouble:self.latitude forKey:@"latitude"];
    [aCoder encodeDouble:self.longitude forKey:@"longitude"];
}
@end
