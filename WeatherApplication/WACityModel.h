//
//  WACityModel.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/22/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WACityModel : NSObject <NSCoding>
- (instancetype) initWithDictionary: (NSDictionary*) dictionary;
- (BOOL)isEqual:(id)other;
@property (nonatomic) NSString *cityName;
@property (nonatomic) long cityId;
@property (nonatomic) NSString *country;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) bool isChecked;
@end

@interface WAServerResponse : NSObject
@property (nonatomic) NSString *responseAsString;
@property (nonatomic) NSError *error;
@end
