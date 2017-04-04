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
- (void) postButtonClicked:(UIButton*)sender;
- (void) putButtonClicked:(UIButton*)sender;
- (void) getButtonClicked:(UIButton*)sender;
@end
@implementation ObjectiveCViewController

UIView *centerView;
UIView *topView;
UIView *bottomView;
UITextView *responseLabel;
UILabel *statusLabel;
CustomActivityIndicator *loadingSpinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    centerView = [[UIView alloc]init];
    topView = [[UIView alloc] init];
    bottomView = [[UIView alloc] init];
    
    UILabel *pageTitle = [[UILabel alloc]init];
    pageTitle.text = @"API Test Page";
    pageTitle.textAlignment = NSTextAlignmentCenter;
    topView.backgroundColor = [UIColor whiteColor];
    [topView addSubview:pageTitle];
    [pageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(topView);
    }];
    
    UIView *firstItem = [[UIView alloc]init];
    UIView *secondItem = [[UIView alloc]init];
    [centerView addSubview:firstItem];
    [centerView addSubview:secondItem];
    
    //Add post and put buttons
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton addTarget:self action:@selector(postButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    postButton.layer.cornerRadius = 5;
    [postButton setTitle:@"Post" forState:UIControlStateNormal];
    [postButton setBackgroundColor:[UIColor blackColor]];
    [postButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    UIButton *putButton = [UIButton buttonWithType:UIButtonTypeCustom];
    putButton.layer.cornerRadius = 5;
    [putButton addTarget:self action:@selector(putButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [putButton setTitle:@"Put" forState:UIControlStateNormal];
    [putButton setBackgroundColor:[UIColor blackColor]];
    [putButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    UIButton *getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    getButton.layer.cornerRadius = 5;
    [getButton addTarget:self action:@selector(getButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [getButton setTitle:@"Get" forState:UIControlStateNormal];
    [getButton setBackgroundColor:[UIColor blackColor]];
    [getButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];

    
    [firstItem addSubview:postButton];
    [firstItem addSubview:putButton];
    [firstItem addSubview:getButton];
    
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX).dividedBy(2);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(5);
    }];
    
    [putButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(5);
    }];
    
    [getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX).multipliedBy(1.5);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(5);
    }];
    
    
    [firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(centerView);
        make.bottom.mas_equalTo(secondItem.mas_top);
    }];
    
    [secondItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(centerView.mas_bottom);
        make.top.mas_equalTo(firstItem.mas_bottom);
        make.height.mas_equalTo(firstItem.mas_height).multipliedBy(4);
        make.left.and.right.mas_equalTo(centerView);
    }];
    
    responseLabel = [[UITextView alloc]init];
    responseLabel.backgroundColor = [UIColor whiteColor];
    responseLabel.textAlignment = NSTextAlignmentJustified;
    [secondItem addSubview:responseLabel];
    
    [responseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
        make.height.mas_greaterThanOrEqualTo(firstItem.mas_height).multipliedBy(2);
        make.edges.equalTo(secondItem).with.insets(padding).with.priorityHigh();
    }];
    
    [self.view addSubview:topView];
    [self.view addSubview:centerView];
    [self.view addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).dividedBy(7);
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
    
    statusLabel = [[UILabel alloc]init];
    [bottomView addSubview:statusLabel];
    
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomView).dividedBy(3);
        make.width.mas_equalTo(bottomView).dividedBy(3);
        make.centerX.and.centerY.mas_equalTo(bottomView);
    }];
    
    // Add loading spinner to the page
    loadingSpinner = [[CustomActivityIndicator alloc]init];
    [self.view addSubview:loadingSpinner];
    [loadingSpinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(self.view);
    }];
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

- (void)putButtonClicked:(UIButton*)sender{
    [loadingSpinner startProgress];
    [[WeatherRetriever sharedInstance] makePutCallWithCustomCompletion:^(NSString *responseAsString, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            responseLabel.text = responseAsString;
            [NSThread sleepForTimeInterval:2];
            if(error)
            {
                statusLabel.text = @"Status: Error";
                statusLabel.textColor = [UIColor redColor];
            }
            else{
                statusLabel.text = @"Status: OK";
                statusLabel.textColor = [UIColor greenColor];
            }
            [loadingSpinner stopProgress];
        });
    }];
}

- (void) getButtonClicked:(UIButton*)sender{
    [loadingSpinner startProgress];
    [[WeatherRetriever sharedInstance] getWeatherForLatitude:35 :30 :^(WAOpenWeatherModel *weather, NSString *responseAsString) {
            dispatch_async(dispatch_get_main_queue(), ^{
            responseLabel.text = responseAsString;
            [NSThread sleepForTimeInterval:2];
            if(!weather)
            {
                statusLabel.text = @"Status: Error";
                statusLabel.textColor = [UIColor redColor];
            }
            else{
                statusLabel.text = @"Status: OK";
                statusLabel.textColor = [UIColor greenColor];
            }
            [loadingSpinner stopProgress];
        });
    }];
}

- (void) postButtonClicked:(UIButton*)sender{
    [loadingSpinner startProgress];
    [[WeatherRetriever sharedInstance] makePostCallWithCustomCompletion:^(NSString *responseAsString, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            responseLabel.text = responseAsString;
            [NSThread sleepForTimeInterval:2];
            if(error)
            {
                statusLabel.text = @"Status: Error";
                statusLabel.textColor = [UIColor redColor];
            }
            else{
                statusLabel.text = @"Status: OK";
                statusLabel.textColor = [UIColor greenColor];
            }
            [loadingSpinner stopProgress];
        });
    }];
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
