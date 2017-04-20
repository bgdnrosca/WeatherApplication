//
//  MainViewController.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WANet.h"
#import "WAUtil.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, WALocationDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIView *currentWeatherView;
@property (strong, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (strong, nonatomic) WeatherRetriever *weatherRetriever;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) WAOpenWeatherModel *weatherForCurrentLocation;
@end
