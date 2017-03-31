//
//  AppDelegate.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "ListViewController.h"
#import "WAUtil.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;


@end

