//
//  ListViewController.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherRetriever.h"

@interface ListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, WALocationDelegate>
@property (strong, nonatomic) NSMutableArray *hourlyList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
