//
//  MainViewController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "MapViewController.h"
#import "WAPointAnnotation.h"
#import "WAAnnotationView.h"

@interface MapViewController ()
- (void) updateUIWithNewData:(WAOpenWeatherModel*)model;
- (void) zoomToFitAnnotations:(BOOL)animated;
- (void) updateMapWithNewData:(NSArray<WAOpenWeatherModel*>*) weatherData;
- (bool) didLocationsListChanged: (NSArray*)newLocations;
@property NSMutableArray<WACityModel*>* locations;
@end

@implementation MapViewController
NSArray<WACityModel*> *locations;

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"Map View";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map View" image:[UIImage imageNamed:@"TabBarMap"] selectedImage:[UIImage imageNamed:@"TabBarMap"]];
    [self.mapView setDelegate:self];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView.layer setCornerRadius: 25];
    self.weatherRetriever = [WeatherRetriever sharedInstance];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager setDelegate:self];
       
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];
    
    }
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusButtonHit)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

-(void)plusButtonHit {
    AddLocationViewController *addLocation = [[AddLocationViewController alloc]init];
    [self.navigationController pushViewController:addLocation animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(oldLocation.coordinate.latitude == newLocation.coordinate.latitude)
    {
        return;
    }
    
    [self.weatherRetriever getWeatherForLatitude:newLocation.coordinate.latitude
                                                   :newLocation.coordinate.longitude
                                                :^(WAOpenWeatherModel* weather){
                                                    [self updateUIWithNewData: weather];
                                                   }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSArray<WACityModel*> *savedLocations = [WAUserDefaults getArrayAtKey:SelectedLocationsKey];
    
    if([self didLocationsListChanged:savedLocations])
    {
        [self.weatherRetriever getWeatherForMultipleLocations:locations
                                        andCustomCompletion: ^(NSArray<WAOpenWeatherModel*>* weatherList){
                                                                 [self updateMapWithNewData:weatherList];
                                                                 [self.weatherRetriever.delegate didUpdateLocationsList:locations];
                                                             }];
        [self.mapView removeAnnotations: self.mapView.annotations];
    }
}

- (bool) didLocationsListChanged: (NSArray*)newLocations{
    if(newLocations && locations && [newLocations count] == [locations count])
    {
        NSSet *set1 = [NSSet setWithArray:locations];
        NSSet *set2 = [NSSet setWithArray:newLocations];
        if([set1 isEqualToSet:set2])
        {
            return false;
        }
    }
    locations = newLocations;
    return true;
}


- (void) updateUIWithNewData:(WAOpenWeatherModel*)model{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locationLabel.text = model.locationName;
        self.descriptionLabel.text = model.mainString;
        self.temperatureLabel.text = [NSString stringWithFormat:@"%d °C", (int)model.temperature];
        self.weatherIcon.image = model.weatherIcon;
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*___________________________________________________________________________________________________________________________*/
/*                                                                                                                           */
/*                                                  Map related methods                                                      */
/*___________________________________________________________________________________________________________________________*/


- (void) updateMapWithNewData:(NSArray<WAOpenWeatherModel*>*) weatherData{
    dispatch_async(dispatch_get_main_queue(), ^{
        for(WAOpenWeatherModel* model in weatherData)
        {
            WAPointAnnotation *point = [[WAPointAnnotation alloc] init];
            point.locationName = model.locationName;
            point.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
            point.temperature = model.temperature;
            [self.mapView addAnnotation:point];
        }
        [self zoomToFitAnnotations:YES];
    });
}

- (void) addNewAnnotationPointOnMap: (WAOpenWeatherModel*) model{
    WAPointAnnotation *point = [[WAPointAnnotation alloc] init];
    point.locationName = model.locationName;
    point.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
    point.temperature = model.temperature;
    [self.mapView addAnnotation:point];
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView
           viewForAnnotation:(id<MKAnnotation>)annotation{
    // Fetch all necessary data from the point object
    if(![annotation isKindOfClass:[WAPointAnnotation class]])
    {
        return nil;
    }
    int temp = ((WAPointAnnotation*)annotation).temperature;
    NSString *location = ((WAPointAnnotation*)annotation).locationName;
    
    WAAnnotationView* pin =
    [[WAAnnotationView alloc]initWithAnnotation:annotation
                                    temperature:temp location: location];
    return pin;
}

-(void) zoomToFitAnnotations:(BOOL)animated{
    if([self.mapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in self.mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 2; // Add a little extra space on the sides
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}



@end