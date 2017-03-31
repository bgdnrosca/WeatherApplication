//
//  WAOpenWeatherHourlyModel.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAOpenWeatherHourlyModel.h"

@implementation WAOpenWeatherHourlyModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.hourlyList = [[NSMutableArray alloc]init];
    NSArray *hourlyList = [dictionary objectForKey:@"list"];
    for(NSDictionary *hourData in hourlyList)
    {
        [self.hourlyList addObject:[[WAOpenWeatherModel alloc ]initWithDictionary: hourData]];
    }
    
    NSDictionary *cityDictionary = [dictionary objectForKey:@"city"];
    self.cityName = [cityDictionary objectForKey:@"name"];
    return self;
}
@end
