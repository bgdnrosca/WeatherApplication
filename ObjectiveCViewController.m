//
//  ObjectiveCViewController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/31/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "ObjectiveCViewController.h"
#import <Masonry/Masonry.h>
#import "WeatherRetriever.h"
@interface ObjectiveCViewController ()

@end
@implementation ObjectiveCViewController

UIView *centerView;
UIView *topView;
UIView *bottomView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    centerView = [[UIView alloc]init];
    topView = [[UIView alloc] init];
    bottomView = [[UIView alloc] init];
    
    UILabel *pageTitle = [[UILabel alloc]init];
    pageTitle.text = @"Test POST call";
    pageTitle.textAlignment = NSTextAlignmentCenter;
    topView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:pageTitle];
    [pageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(topView);
    }];
    
    UIView *firstItem = [[UIView alloc]init];
    UIView *secondItem = [[UIView alloc]init];
    UIView *thirdItem = [[UIView alloc] init];
    firstItem.backgroundColor = [UIColor greenColor];
    secondItem.backgroundColor = [UIColor blueColor];
    thirdItem.backgroundColor =[UIColor redColor];
    [centerView addSubview:firstItem];
    [centerView addSubview:secondItem];
    [centerView addSubview:thirdItem];
    
    [firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(secondItem);
        make.top.left.and.right.equalTo(centerView);
    }];
    
    [secondItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(firstItem);
        make.top.equalTo(firstItem.mas_bottom);
        make.left.and.right.equalTo(centerView);
    }];
    
    [thirdItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(firstItem);
        make.top.mas_equalTo(secondItem.mas_bottom);
        make.bottom.left.and.right.equalTo(centerView);
    }];
    
    UILabel *bottomTitle = [[UILabel alloc]init];
    bottomTitle.text = @"Bottom Title";
    bottomTitle.numberOfLines = 0;
    bottomTitle.backgroundColor = [UIColor whiteColor];
    bottomTitle.textAlignment = NSTextAlignmentJustified;
    [bottomView addSubview:bottomTitle];
    
    [bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(bottomView);
    }];
    
    [self.view addSubview:topView];
    [self.view addSubview:centerView];
    [self.view addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).dividedBy(6);
        }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(topView);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    [[WeatherRetriever sharedInstance] makePostCallWithCustomCompletion:^(NSString *responseAsString) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            bottomTitle.text = responseAsString;
        });
    }];
        // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //Initialize positions
    CGPoint topViewOrigin = CGPointMake(-topView.bounds.size.width, topView.bounds.origin.y);
    topView.center = topViewOrigin;
    
    [UIView animateWithDuration:2 animations:^{
        CGPoint _center = topView.center;
        _center.x += self.view.bounds.size.width;
        topView.center = _center;
    }];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
