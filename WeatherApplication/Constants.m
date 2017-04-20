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
NSString *const CustomServiceUUID = @"171bd16c-ab9c-4bb8-96e6-71aa5a1ee70d";
NSString *const ReadCharacteristicUUID = @"5d6207f4-856d-4c5d-a0d9-3698c936765f";
NSString *const WriteCharacteristicUUID = @"5d6207f4-856c-4c5d-a0d9-3698c936765f";
NSString *const EndOfMessage = @"0000\n";
NSString *const LocationListChangedNotification = @"LocationListChangedNotification";
@end
