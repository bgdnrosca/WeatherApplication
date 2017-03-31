//
//  WATabBarController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WATabBarController.h"

@interface WATabBarController ()

@end

@implementation WATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    MainViewController *firstPage = [self createViewcontrollerWithColor:[UIColor redColor]];
    MainViewController *secondPage = [self createViewcontrollerWithColor:[UIColor greenColor]];
    firstPage.title = @"Map View";
    secondPage.title = @"List View";
    self.viewControllers =[NSArray arrayWithObjects:firstPage, secondPage, nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MainViewController *)createViewcontrollerWithColor:(UIColor *)color {
    
    MainViewController *newViewcontroller = [[MainViewController alloc]init];
    newViewcontroller.backgroundColor = color;
    
    return newViewcontroller;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
