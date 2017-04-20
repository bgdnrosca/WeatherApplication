//
//  AddLocationViewController.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/22/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WAUtil.h"
#import "WANet.h"

@interface AddLocationViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray<WACityModel*> *availableLocations;
    NSMutableArray<WACityModel*> *filteredLocations;
    BOOL isSearching;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
