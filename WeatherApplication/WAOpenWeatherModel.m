//
//  WAOpenWeatherModel.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/10/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WAOpenWeatherModel.h"

@implementation WAOpenWeatherModel{}

- (instancetype) initWithDictionary :(NSDictionary*)dictionary{
    
    self = [super init];
    NSDictionary *mainInfo= [dictionary objectForKey:@"main"];
    self.temperature = [[mainInfo objectForKey:@"temp"] doubleValue];
    self.pressure = [[mainInfo objectForKey:@"pressure"] intValue];
    self.precipitation = [[mainInfo objectForKey:@"humidity"] intValue];
    self.minTemp = [[mainInfo objectForKey:@"temp_min"] doubleValue];
    self.maxTemp = [[mainInfo objectForKey:@"temp_min"] doubleValue];
    
    
    self.locationName = [dictionary objectForKey:@"name"];
    
    //deserialize location
    NSDictionary *coordinates = [dictionary objectForKey:@"coord"];
    self.lat = [[coordinates objectForKey:@"lat"] doubleValue];
    self.lon = [[coordinates objectForKey:@"lon"] doubleValue];
    
    //deserialize weather
    NSDictionary *weather = [[dictionary objectForKey:@"weather"] firstObject];
    self.mainString = [weather objectForKey:@"main"];
    self.mainDescription = [weather objectForKey:@"description"];
    self.mainIcon = [weather objectForKey:@"icon"];
    
    
    self.cityId = [[dictionary objectForKey:@"id" ] longValue];
    
    double timeStampVal = [[dictionary objectForKey:@"dt" ] doubleValue];
    if(timeStampVal)
    {
        NSTimeInterval timestamp = (NSTimeInterval)timeStampVal;
        self.currentDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    
    NSString* imageUrl = [NSString stringWithFormat:OpenWeatherMapBaseImageUrl, self.mainIcon];
    NSError* imageError = nil;
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imageUrl] options:NSDataReadingUncached error:&imageError];
    if(!imageError)
    {
        self.weatherIcon = [UIImage imageWithData: imageData];
    }
    
    return self;
}
@end


