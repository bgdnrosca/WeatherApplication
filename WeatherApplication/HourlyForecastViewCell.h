//
//  HourlyForecastViewCell.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HourlyForecastViewCell : UICollectionViewCell
@property (nonatomic,strong) IBOutlet UIImageView *hourlyIcon;
@property (nonatomic, strong) IBOutlet UILabel *hourLabel;
@property (nonatomic,strong) IBOutlet UILabel *temperatureLabel;
- (void) performAnimation: (bool) rotate;
@end
