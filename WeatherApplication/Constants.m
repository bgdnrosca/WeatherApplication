//
//  Constants.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "Constants.h"

@implementation Constants
NSString *const OpenWatherMapGetWeatherForCityIdUrl = @"http://api.openweathermap.org/data/2.5/weather?id=%ld&units=metric&APPID=2361d3183f567a89466b9c1c6934da51";
NSString *const OpenWeatherMapGetWeatherForLocationUrl = @"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=metric&appid=2361d3183f567a89466b9c1c6934da51";
NSString *const OpenWeatherMapBaseImageUrl = @"http://openweathermap.org/img/w/%@.png";
NSString *const OpenWeatherGetHourlyWeatherForCityIdUrl = @"http://api.openweathermap.org/data/2.5/forecast?id=%ld&units=metric&APPID=2361d3183f567a89466b9c1c6934da51";
NSString *const SelectedLocationsKey = @"SelectedLocations";
@end
