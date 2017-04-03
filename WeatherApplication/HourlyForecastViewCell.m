//
//  HourlyForecastViewCell.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "HourlyForecastViewCell.h"

@interface HourlyForecastViewCell()

@end

@implementation HourlyForecastViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)prepareForReuse{
    self.hourlyIcon.transform = CGAffineTransformIdentity;
    [super prepareForReuse];
}

- (void) performAnimation{
    NSAssert(self.hourlyIcon.image != nil, @"me");
    [UIView animateWithDuration:0.5
                          delay:0
                          options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hourlyIcon.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(M_PI), 1.3, 1.3);
                     }
                     completion:nil];

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
