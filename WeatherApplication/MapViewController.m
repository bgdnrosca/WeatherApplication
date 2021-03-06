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
#import "ObjectiveCViewController.h"
#import "BluetoothClientViewController.h"
#import "DynamicTypeViewController.h"
#import "AddLocationViewController.h"
#import "CustomControls.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>

@interface MapViewController ()
- (void) updateUIWithNewData:(WAOpenWeatherModel*)model;
- (void) zoomToFitAnnotations:(BOOL)animated;
- (void) updateMapWithNewData:(NSArray<WAOpenWeatherModel*>*) weatherData;
- (bool) didLocationsListChanged: (NSArray*)newLocations;
- (void) imageTap:(UIImageView*) sender;
- (void) addAnimationToWeatherLabels;
@property NSMutableArray<WACityModel*>* locations;
@property (nonatomic, strong) CustomActivityIndicator* loadingSpinner;
@end

@implementation MapViewController
NSArray<WACityModel*> *locations;
int imageTapCount;

static void *currentWeatherContext = &currentWeatherContext;

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
    
    self.weatherIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [self.weatherIcon addGestureRecognizer: tapGesture];
    self.loadingSpinner = [[CustomActivityIndicator alloc]init];
    [self.view addSubview:self.loadingSpinner];
    [self.loadingSpinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.and.bottom.mas_equalTo(self.view);
    }];
    [self.loadingSpinner startProgress];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusButtonHit)];
    self.navigationItem.rightBarButtonItem = plusButton;
    
    
    //PARALLAX thing
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    // Add both effects to your view
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addMotionEffect:group];
    
    self.weatherForCurrentLocation = [[WAOpenWeatherModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureView];
}

- (void)configureView
{
    self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.locationLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.temperatureLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray<WACityModel*> *savedLocations = [WAUserDefaults getArrayFromFile:SelectedLocationsKey];
    self.tabBarController.tabBar.hidden = NO;
    imageTapCount = 0;
    if([self didLocationsListChanged:savedLocations])
    {
        [[self loadingSpinner] startProgress];
        [self.weatherRetriever getWeatherForMultipleLocations:locations
                                          andCustomCompletion: ^(NSArray<WAOpenWeatherModel*>* weatherList){
                                              [self updateMapWithNewData:weatherList];
                                              [self.weatherRetriever.delegate didUpdateLocationsList:locations];
                                          }];
        [self.mapView removeAnnotations: self.mapView.annotations];
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationListChangedNotification
                                                            object:self];
    }
    
    //Implement KVO for current weather
    [self.weatherForCurrentLocation addObserver:self forKeyPath:@"locationName" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:currentWeatherContext];
    [self.weatherForCurrentLocation addObserver:self forKeyPath:@"temperature" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:currentWeatherContext];
    [self.weatherForCurrentLocation addObserver:self forKeyPath:@"mainString" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:currentWeatherContext];
    [self.weatherForCurrentLocation addObserver:self forKeyPath:@"weatherIcon" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:currentWeatherContext];

}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self configureView];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(context == currentWeatherContext){
        if([keyPath isEqualToString:@"locationName"])
        {
            self.locationLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
        }
        else if([keyPath isEqualToString:@"temperature"])
        {
            double newTemperature = [change[NSKeyValueChangeNewKey] doubleValue];
            self.temperatureLabel.text = [NSString stringWithFormat:@"%d °C", (int)newTemperature];
        }
        else if([keyPath isEqualToString:@"mainString"])
        {
            self.descriptionLabel.text = [change objectForKey:NSKeyValueChangeNewKey];
        }
        else if([keyPath isEqualToString:@"weatherIcon"])
        {
            self.weatherIcon.image = [change objectForKey:NSKeyValueChangeNewKey];
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.weatherForCurrentLocation removeObserver:self forKeyPath:@"locationName"];
    [self.weatherForCurrentLocation removeObserver:self forKeyPath:@"temperature"];
    [self.weatherForCurrentLocation removeObserver:self forKeyPath:@"mainString"];
    [self.weatherForCurrentLocation removeObserver:self forKeyPath:@"weatherIcon"];

}

-(void)plusButtonHit {
    AddLocationViewController *addLocation = [[AddLocationViewController alloc]init];
    [self.navigationController pushViewController:addLocation animated:NO];
//    ObjectiveCViewController *addLocation = [[ObjectiveCViewController alloc]init];
//    [self.navigationController pushViewController:addLocation animated:YES];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(oldLocation.coordinate.latitude == newLocation.coordinate.latitude)
    {
        return;
    }
    [[self loadingSpinner] startProgress];
    [self.weatherRetriever getWeatherForLatitude:newLocation.coordinate.latitude
                                                   :newLocation.coordinate.longitude
                                                :^(WAOpenWeatherModel* weather, NSString* responseAsString){
                                                    [self updateUIWithNewData: weather];
                                                   }];
    
}

- (void) addAnimationToWeatherLabels{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.currentWeatherView];
    
    UIGravityBehavior* gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[self.weatherIcon, self.locationLabel, self.temperatureLabel, self.descriptionLabel]];
    UICollisionBehavior* collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self.weatherIcon, self.locationLabel, self.temperatureLabel, self.descriptionLabel]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    UIDynamicItemBehavior *elasticityBehavior =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self.weatherIcon, self.locationLabel, self.temperatureLabel, self.descriptionLabel]];
    elasticityBehavior.elasticity = 1.0f;
    
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:collisionBehavior];
    [self.animator addBehavior:elasticityBehavior];
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
        [self.animator removeAllBehaviors];
        self.weatherForCurrentLocation.mainString = model.mainString;
        self.weatherForCurrentLocation.locationName = model.locationName;
        self.weatherForCurrentLocation.temperature = model.temperature;
        self.weatherForCurrentLocation.weatherIcon = model.weatherIcon;
//        self.locationLabel.text = model.locationName;
//        self.descriptionLabel.text = model.mainString;
//        self.temperatureLabel.text = [NSString stringWithFormat:@"%d °C", (int)model.temperature];
//        self.weatherIcon.image = model.weatherIcon;
        [self.loadingSpinner stopProgress];
        [self addAnimationToWeatherLabels];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) imageTap:(UIImageView *)sender{
    imageTapCount++;
    if(imageTapCount == 2)
    {
//        ObjectiveCViewController *addLocation = [[ObjectiveCViewController alloc]init];
//        [self.navigationController pushViewController:addLocation animated:YES];
//        BluetoothClientViewController *addLocation = [[BluetoothClientViewController alloc]init];
//        [self.navigationController pushViewController:addLocation animated:YES];
        DynamicTypeViewController *dynamicTypeViewController = [[DynamicTypeViewController alloc] init];
        [self.navigationController pushViewController:dynamicTypeViewController animated:YES];
    }
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
        [self.loadingSpinner stopProgress];
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
