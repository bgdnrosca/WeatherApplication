//
//  WATabBarController.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface WATabBarController : UITabBarController
- (MainViewController *)createViewcontrollerWithColor:(UIColor *)color;
@end
