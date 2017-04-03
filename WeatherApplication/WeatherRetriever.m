//
//  WeatherRetriever.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WeatherRetriever.h"

@implementation WeatherRetriever

+ (WeatherRetriever*) sharedInstance{
    static WeatherRetriever *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WeatherRetriever alloc]init];
    });
    return sharedInstance;
}


- (void) getWeatherForCity :(long) cityId :(void (^)(WAOpenWeatherModel* weather))customCompletion{
    __block NSString *responseAsString;
    __block NSDictionary *dictionary;
    NSString* url = [NSString stringWithFormat:OpenWatherMapGetWeatherForCityIdUrl, cityId];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        responseAsString = [NSString stringWithFormat:@"%@", response];
        dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        WAOpenWeatherModel *weather = [[WAOpenWeatherModel alloc ]initWithDictionary:dictionary];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:OpenWeatherMapBaseImageUrl, weather.mainIcon]]];
        weather.weatherIcon = [UIImage imageWithData: imageData];
        
        customCompletion(weather);
    }]resume];
    }

- (void) getWeatherForLatitude : (double) latitude : (double) longitude : (void (^)(WAOpenWeatherModel *weather)) customCompletion{
    __block NSString* responseAsString;
    __block NSDictionary* dictionary;
    
    NSString* url = [NSString stringWithFormat:OpenWeatherMapGetWeatherForLocationUrl, latitude, longitude];
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url]completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error){
        if(!error)
        {
            responseAsString = [NSString stringWithFormat:@"%@", response];
            dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            WAOpenWeatherModel *weather = [[WAOpenWeatherModel alloc]initWithDictionary:dictionary];
                        customCompletion(weather);
        }
    }]resume];
}

- (void) getHourlyWeatherDataForCityId:(long) cityId :(void (^)(WAOpenWeatherHourlyModel* hourlyWeather))customCompletion{
    __block NSString *responseAsString;
    __block NSDictionary *dictionary;
    NSString* url = [NSString stringWithFormat:OpenWeatherGetHourlyWeatherForCityIdUrl, cityId];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString: url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            responseAsString = [NSString stringWithFormat:@"%@", response];
            dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            WAOpenWeatherHourlyModel *horlyWeather = [[WAOpenWeatherHourlyModel alloc]initWithDictionary:dictionary];
            customCompletion(horlyWeather);
        }
    }]resume];
}

- (void) getWeatherForMultipleLocations: (NSArray<WACityModel*>*) locations andCustomCompletion: (void (^)(NSArray<WAOpenWeatherModel*>* weatherList)) customCompletion{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *weatherDataArray = [[NSMutableArray alloc]init];
    for(WACityModel *city in locations)
    {
        dispatch_group_enter(group);
        [self getWeatherForCity:city.cityId
        :^(WAOpenWeatherModel* weather){
            [weatherDataArray addObject: weather];
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                          ^{
                              customCompletion(weatherDataArray);
                            });
}

- (void) getHourlyWeatherForMultipleLocations: (NSArray<WACityModel*>*) locations andCustomCompletion: (void (^)(NSArray<WAOpenWeatherHourlyModel*>* weatherList)) customCompletion{
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *weatherDataArray = [[NSMutableArray alloc]init];
    for(WACityModel *city in locations)
    {
        dispatch_group_enter(group);
        [self getHourlyWeatherDataForCityId:city.cityId
                               :^(WAOpenWeatherHourlyModel* weather){
                                   [weatherDataArray addObject: weather];
                                   dispatch_group_leave(group);
                               }];
    }
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                          ^{
                              customCompletion(weatherDataArray);
                          });
}

- (void) makePostCallWithCustomCompletion :(void (^)(NSString* responseAsString))customCompletion{
    __block NSString *responseAsString;
    NSString *post = [NSString stringWithFormat:@"Something"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://httpbin.org/post"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error)
        {
            responseAsString = [NSString stringWithFormat:@"%@", response];
            customCompletion(responseAsString);
            NSLog(@"Connection successful");
            
        }else{
            NSLog(@"Connection failed");
        }
    
    }]resume];
}

@end
