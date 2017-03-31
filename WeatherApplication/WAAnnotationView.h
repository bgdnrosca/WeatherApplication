//
//  WAAnnotationView.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface WAAnnotationView : MKAnnotationView
@property int temperature;
@property NSString *locationName;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                       temperature:(int)temperature location: (NSString*)location;
@end
