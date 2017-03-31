//
//  WACustomProtocols.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/22/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WALocationIdChangedDelegate <NSObject>

@required
- (void) didUpdateToLocationId : (long) newLocationId;
@end
