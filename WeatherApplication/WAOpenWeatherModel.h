//
//  WAOpenWeatherModel.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WAOpenWeatherModel : NSObject
@property (nonatomic) double lon;
@property (nonatomic) double lat;
@property (nonatomic) NSString *locationName;
@property (nonatomic) NSString *mainString;
@property (nonatomic) NSString *mainDescription;
@property (nonatomic) NSString *mainIcon;
@property (nonatomic) double temperature;
@property (nonatomic) int pressure;
@property (nonatomic) int precipitation;
@property (nonatomic) double minTemp;
@property (nonatomic) double maxTemp;
@property (nonatomic) UIImage *weatherIcon;
@property (nonatomic) NSDate *currentDate;
@property (nonatomic) long cityId;
- (instancetype) initWithDictionary :(NSDictionary*)dictionary;
@end

