//
//  CustomActivityIndicator.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 4/3/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "CustomActivityIndicator.h"

@implementation CustomActivityIndicator
UIImageView *runningMan;

- (instancetype) init{
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    runningMan = [[UIImageView alloc]init];
    NSMutableArray *images = [[NSMutableArray alloc]init];
    for(int i=1; i<=11; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"running_%d", i];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    runningMan.animationImages = images;
    runningMan.animationDuration = 1;
    [self addSubview: runningMan];
    
    [runningMan mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.mas_equalTo(self);
        make.height.and.width.mas_equalTo(80);
    }];
    return self;
}

- (void) startProgress{
    self.layer.hidden = NO;
    [runningMan startAnimating];
}

- (void) stopProgress{
    //Simulate delays
    self.layer.hidden = YES;
    [runningMan stopAnimating];
}
@end
