//
//  CustomTabBarController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainViewController *vc1 = [self createViewcontrollerWithColor:[UIColor redColor]];
    MainViewController *vc2 = [self createViewcontrollerWithColor:[UIColor blueColor]];
    MainViewController *vc3 = [self createViewcontrollerWithColor:[UIColor greenColor]];
    MainViewController *vc4 = [self createViewcontrollerWithColor:[UIColor yellowColor]];
    
    vc1.title = @"One";
    vc2.title = @"Two";
    vc3.title = @"Three";
    vc4.title = @"Four";
    
    NSArray *controllers = @[vc1, vc2, vc3, vc4];
    [self setViewControllers:controllers animated:YES];
    // wait five seconds then call selector
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setLessViewcontrollers) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MainViewController *)createViewcontrollerWithColor:(UIColor *)color {
    
    //    ViewController *newViewcontroller = [[ViewController alloc]init];
    //    newViewcontroller.backgroundColor = color;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *newViewcontroller = [storyboard instantiateViewControllerWithIdentifier:@"PlainViewController"];
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
