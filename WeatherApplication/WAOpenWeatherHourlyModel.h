//
//  WAOpenWeatherModel.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WAOpenWeatherModel.h"

@interface WAOpenWeatherHourlyModel : NSObject
@property (nonatomic) NSMutableArray<WAOpenWeatherModel*> *hourlyList;
@property (nonatomic) NSDate* dateTime;
- (instancetype) initWithDictionary: (NSDictionary*) response;
@property (nonatomic) NSString *cityName;
@end
