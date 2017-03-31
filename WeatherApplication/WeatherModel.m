//
//  WeatherModel.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/7/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel
- (instancetype) initWithLocationAndTemperature:(NSString *)location temperature:(int) temperature{
    self.Location = location;
    self.Temperature = [NSString stringWithFormat:@"%d ° C", temperature];
    return self;
}
@end
