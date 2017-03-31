//
//  WeatherModel.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/7/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject
@property (nonatomic, strong) NSString *Location;
@property (nonatomic, strong) NSString *Temperature;
-(instancetype) initWithLocationAndTemperature: (NSString*) location temperature: (int) temperature;
@end
