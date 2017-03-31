//
//  WAUserDefaults.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/23/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WAUserDefaults : NSObject
+ (void) saveArrayAtKey: (NSString*)key ArrayToSave:(NSArray*) array;
+ (NSArray*) getArrayAtKey: (NSString*)key;
+ (void) removeDataAtKey: (NSString*) key;
@end
