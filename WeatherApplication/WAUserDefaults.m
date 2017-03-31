//
//  WAUserDefaults.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/23/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WAUserDefaults.h"

@implementation WAUserDefaults

+ (void) saveArrayAtKey: (NSString*)key ArrayToSave:(NSArray*) array{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
}
+ (NSArray*) getArrayAtKey: (NSString*)key{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}
+ (void) removeDataAtKey: (NSString*) key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
@end
