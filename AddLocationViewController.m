//
//  AddLocationViewController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/22/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "AddLocationViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface AddLocationViewController ()
@end

@implementation AddLocationViewController
NSMutableArray<WACityModel*> *selectedLocations;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activtyIndicator = [[CustomActivityIndicator alloc]init];
    [self.view addSubview:self.activtyIndicator];
    [self.activtyIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.and.bottom.mas_equalTo(self.view);
    }];
    [self.activtyIndicator startProgress];
    availableLocations = [[NSMutableArray alloc]init];
    filteredLocations = [[NSMutableArray alloc] init];
    [self initializeListOfAvailableLocations];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

-(void) initializeListOfAvailableLocations
{
    selectedLocations = [[NSMutableArray alloc] initWithArray:[WAUserDefaults getArrayFromFile:SelectedLocationsKey]];
    
    RACSignal *getLocationFromFileSignal = [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber>  _Nonnull subscriber) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"city.list" ofType:@"json"];
        NSString *jsonAsString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSData *data = [jsonAsString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableArray *cityList = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableContainers error:nil];
        
        for(NSDictionary *cityModel in cityList)
        {
            WACityModel *model = [[WACityModel alloc] initWithDictionary:cityModel];
            for(WACityModel* savedModel in selectedLocations)
            {
                if(model.cityId == savedModel.cityId)
                {
                    model.isChecked = true;
                }
            }
            [availableLocations addObject:model];
        }
        [subscriber sendCompleted];
    }];
    
    [getLocationFromFileSignal subscribeCompleted:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activtyIndicator stopProgress];
            [self.tableView reloadData];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isSearching) {
        return [filteredLocations count];
    }
    else {
        return [selectedLocations count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];

    WACityModel *currentModel = nil;
    if(isSearching)    {
        currentModel = [filteredLocations objectAtIndex:indexPath.row];
    }
    else{
        currentModel = [selectedLocations objectAtIndex:indexPath.row];
    }
    [cell.textLabel setText: [currentModel cityName]];
    
    if (currentModel.isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)searchTableList {
    NSString *searchString = self.searchBar.text;
    
    for (WACityModel *city in availableLocations) {
        NSComparisonResult result = [city.cityName compare:searchString options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [filteredLocations addObject:city];
        }
    }
    [[self tableView]reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    WACityModel *currentModel = nil;
    if(isSearching)    {
        if(indexPath.row < filteredLocations.count)
        {
            currentModel = [filteredLocations objectAtIndex:indexPath.row];
        }
    }
    else{
        if(indexPath.row < selectedLocations.count)
        {
            currentModel = [selectedLocations objectAtIndex:indexPath.row];
        }
    }
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        currentModel.isChecked = true;
        [selectedLocations addObject:currentModel];
    }else {
        newCell.accessoryType = UITableViewCellAccessoryNone;
        currentModel.isChecked = false;
        [selectedLocations removeObject:currentModel];
    }
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [filteredLocations removeAllObjects];
    isSearching = YES;
    
    if([searchText length] == 0) {
        isSearching = NO;
        [[self tableView ]reloadData];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchTableList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        [WAUserDefaults saveArrayToFile: SelectedLocationsKey arrayToSave:selectedLocations];
    }
}

@end
