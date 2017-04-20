//
//  WATableViewCell.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/17/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WATableViewCell.h"

@interface WATableViewCell() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *hourlyData;
@end
@implementation WATableViewCell
NSDateFormatter *hourFormat;
static NSString *cellIdentifier;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.hourlyCollection setDataSource:self];
    [self.hourlyCollection setDelegate: self];
    hourFormat = [[NSDateFormatter alloc]init];
    [hourFormat setDateFormat:@"HH:mm"];
    [[self contentView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0] setActive:YES];
    [[NSLayoutConstraint constraintWithItem:[self contentView] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0] setActive:YES];
    cellIdentifier = @"myCollectionViewCell";
    [self.hourlyCollection registerNib:[UINib nibWithNibName:@"HourlyForecastViewCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];

    
    // Initialization code
}

- (void) setCollectionData:(NSArray*) hourlyData{
    self.hourlyData = hourlyData;
    [self.hourlyCollection reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.hourlyData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WAOpenWeatherModel *cellData = [self.hourlyData objectAtIndex:indexPath.row];
    HourlyForecastViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setWeatherModel: cellData]; 
    return cell;
    
}

@end
