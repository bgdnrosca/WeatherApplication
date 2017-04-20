//
//  HourlyForecastViewCell.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "HourlyForecastViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface HourlyForecastViewCell()

@end

@implementation HourlyForecastViewCell

- (instancetype) init{
    self = [super init];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc]init];
    [hourFormat setDateFormat:@"HH:mm"];
    RAC(self, hourlyIcon.image) = RACObserve(self, weatherModel.weatherIcon);
    RAC(self, temperatureLabel.text) = [RACObserve(self, weatherModel.temperature) map:^id(NSNumber* value){
        {
            return [NSString stringWithFormat:@"%d °C", (int)[value doubleValue]];
        }
    }];
    RAC(self, temperatureLabel.text) = [RACObserve(self, weatherModel.temperature) map:^id(NSNumber* value){
        {
            return [NSString stringWithFormat:@"%d °C", (int)[value doubleValue]];
        }
    }];
    RAC(self, hourLabel.text) = [RACObserve(self, weatherModel.currentDate) map:^id(NSDate* value){
        {
            return [hourFormat stringFromDate:value];
        }
    }];
    
    [self performAnimation: [self.weatherModel.mainIcon isEqualToString:@"01d"]];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)prepareForReuse{
    self.hourlyIcon.transform = CGAffineTransformIdentity;
    [super prepareForReuse];
}

- (void) performAnimation: (bool) rotate{
    if(rotate)
    {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hourlyIcon.transform = CGAffineTransformMakeRotation(M_PI);
                         }
                         completion:nil];
    }else{
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hourlyIcon.transform = CGAffineTransformMakeScale(1.3,1.3);
                         }
                         completion:nil];
    }

}




@end
/*
@interface CALayer (calayer1)

@end
@implementation CALayer (calayer1)
- (void)removeAllAnimations{
    if([self.delegate isKindOfClass:[HourlyForecastViewCell class]])
        {
            
        }
}

- (void) removeAnimationForKey:(NSString *)key{
    
    if([self.delegate isKindOfClass:[HourlyForecastViewCell class]])
    {
        
    }
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key{
    if([self.delegate isKindOfClass:[UIImageView class]])
        {
            
        }
}

@end
*/
