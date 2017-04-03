//
//  WAAnnotationView.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/6/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WAAnnotationView.h"

@implementation WAAnnotationView{
    
}
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                       temperature:(int)temperature location: (NSString*)location{
    self = [super initWithAnnotation: annotation reuseIdentifier:nil];
    self.temperature = temperature;
    self.locationName = location;
    
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *tooltipView = [[UIView alloc]initWithFrame:CGRectMake(-50,-40, 100, 40)];
    tooltipView.backgroundColor = [UIColor blackColor];
    tooltipView.layer.cornerRadius = 10;
    tooltipView.layer.masksToBounds = YES;
    
    UILabel* label1 = [[UILabel alloc]init];
    [label1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [label1.font fontWithSize:12];
    label1.text = self.locationName;
    
    UILabel* label2 = [[UILabel alloc]init];
    [label2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = [UIColor whiteColor];
    label2.text =  [NSString stringWithFormat:@"%d °C", self.temperature];
    label2.font = [label2.font fontWithSize:12];
    [tooltipView addSubview:label1];
    [tooltipView addSubview:label2];
    
    [[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:label2 attribute:NSLayoutAttributeHeight multiplier:1 constant:0] setActive: YES];
    [[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tooltipView attribute:NSLayoutAttributeLeft multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:tooltipView attribute:NSLayoutAttributeLeft multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:tooltipView attribute:NSLayoutAttributeWidth multiplier:1 constant:0] setActive: YES];
    [[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeWidth multiplier:1 constant:0]setActive:YES];
    [[NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:tooltipView attribute:NSLayoutAttributeTop multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:label1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0] setActive:YES];
    
    [[NSLayoutConstraint constraintWithItem:label2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tooltipView attribute:NSLayoutAttributeBottom multiplier:1 constant:0] setActive:YES];
    
    [self addSubview:tooltipView];
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
