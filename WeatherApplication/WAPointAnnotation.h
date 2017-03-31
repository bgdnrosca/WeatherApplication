//
//  WAPointAnnotation.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WAPointAnnotation : MKPointAnnotation
@property int temperature;
@property (nonatomic, strong) NSString *locationName;
@end
