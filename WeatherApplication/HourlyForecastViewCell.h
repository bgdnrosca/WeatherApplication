//
//  HourlyForecastViewCell.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAOpenWeatherModel.h"

@interface HourlyForecastViewCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView *hourlyIcon;
@property (nonatomic, strong) IBOutlet UILabel *hourLabel;
@property (nonatomic,strong) IBOutlet UILabel *temperatureLabel;
@property (nonatomic,strong) WAOpenWeatherModel *weatherModel;
- (void) performAnimation: (bool) rotate;

@end
