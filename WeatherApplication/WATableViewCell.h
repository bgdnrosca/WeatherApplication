//
//  WATableViewCell.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAOpenWeatherModel.h"
#import "HourlyForecastViewCell.h"

@interface WATableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* cityLabel;
@property (nonatomic, strong) IBOutlet UIImageView *mainIcon;
@property (nonatomic, strong) IBOutlet UICollectionView *hourlyCollection;
- (void) setCollectionData:(NSArray*) hourlyData;
@end
