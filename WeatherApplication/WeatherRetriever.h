//
//  WeatherRetriever.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "WAOpenWeatherModel.h"
#import "WAOpenWeatherHourlyModel.h"
#import "WACityModel.h"

@protocol WALocationDelegate <NSObject>

@optional
- (void) didUpdateLocationsList : (NSArray<WACityModel*>*) newLocationsList;
@end

@interface WeatherRetriever : NSObject
+ (WeatherRetriever*) sharedInstance;
- (void) getWeatherForCity :(long) cityId :(void (^)(WAOpenWeatherModel* weather))customCompletion;
- (void) getWeatherForLatitude : (double) latitude : (double) longitude : (void (^)(WAOpenWeatherModel *weather, NSString *responseAsString)) customCompletion;
- (void) getHourlyWeatherDataForCityId:(long) cityId :(void (^)(WAOpenWeatherHourlyModel* weather))customCompletion;
- (void) getWeatherForMultipleLocations: (NSArray<WACityModel*>*) locations andCustomCompletion: (void (^)(NSArray<WAOpenWeatherModel*>* weatherList)) customCompletion;
- (void) getHourlyWeatherForMultipleLocations: (NSArray<WACityModel*>*) locations andCustomCompletion: (void (^)(NSArray<WAOpenWeatherHourlyModel*>* weatherList)) customCompletion;
- (void) makePostCallWithCustomCompletion :(void (^)(NSString* responseAsString, NSError *error))customCompletion;
- (void) makePutCallWithCustomCompletion :(void (^)(NSString* responseAsString, NSError *error))customCompletion;
@property (retain, nonatomic) id <WALocationDelegate> delegate;
@property NSArray<WACityModel*> *availableLocations;
@end
