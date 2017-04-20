//
//  ListViewController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "ListViewController.h"
#import "WATableViewCell.h"


@interface ListViewController ()
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) WeatherRetriever *weatherRetriever;
- (NSArray<WAOpenWeatherModel*>*) processHourlyResponse: (WAOpenWeatherHourlyModel*) hourlyModel;
@end

@implementation ListViewController
static NSDateFormatter *dateFormatter;

- (instancetype) init{
    self = [super init];
    self.title = @"Hourly View";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Hourly View" image:[UIImage imageNamed:@"TabBarList"] selectedImage:[UIImage imageNamed:@"TabBarList"]];
    self.weatherRetriever = [WeatherRetriever sharedInstance];
    self.weatherRetriever.delegate = self;
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyy"];
    self.tableData = [[NSMutableArray alloc]init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate: self];
    [self.tableView reloadData];
    [self.tableView registerNib:[UINib nibWithNibName:@"WATableViewCell"  bundle:nil] forCellReuseIdentifier:@"myCell"];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void) didUpdateLocationsList:(NSArray<WACityModel *> *)newLocationsList{
    [self.weatherRetriever getHourlyWeatherForMultipleLocations:newLocationsList andCustomCompletion: ^(NSArray<WAOpenWeatherHourlyModel*>* hourlyList){
        [self.tableData removeAllObjects];
        for(WAOpenWeatherHourlyModel* weatherForCity in hourlyList)
        {
            [self.tableData addObject:[self processHourlyResponse:weatherForCity]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSArray<WAOpenWeatherModel*>*) processHourlyResponse: (WAOpenWeatherHourlyModel*) hourlyModel{
    
    if(hourlyModel.hourlyList.count == 0)
    {
        return nil;
    }
    NSMutableArray *dailyList = [[NSMutableArray alloc] init];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[hourlyModel.hourlyList.firstObject currentDate]];
    NSInteger currentDate = [components day];
    NSMutableArray<WAOpenWeatherModel*> *dailyWeather = [[NSMutableArray alloc]init];
    for(WAOpenWeatherModel *model in hourlyModel.hourlyList)
    {
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: model.currentDate];
        NSInteger modelDay = [components day];
        
        //Add location name for each model
        model.locationName = hourlyModel.cityName;
        
        if(currentDate == modelDay)
        {
            [dailyWeather addObject: model];
        }
        else{
            [dailyList addObject:dailyWeather];
            dailyWeather = [[NSMutableArray alloc]init];
            [dailyWeather addObject:model];
            currentDate = modelDay;
        }
    }
    // Add the last day to the list
    [dailyList addObject:dailyWeather];
    return dailyList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *sectionList = [self.tableData objectAtIndex:section];
    return sectionList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray *sectionList = [self.tableData objectAtIndex:section];
    return [[[sectionList firstObject] firstObject] locationName];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if(!cell)
    {
       cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    }
    NSMutableArray *city = [self.tableData objectAtIndex:indexPath.section];
    NSMutableArray<WAOpenWeatherModel*> *dailyForecast = [city objectAtIndex:indexPath.row];
    WAOpenWeatherModel *dailyModel = [dailyForecast firstObject];
    cell.cityLabel.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:[dailyModel currentDate]],[dailyModel locationName]];
    [cell setCollectionData:dailyForecast];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

@end
