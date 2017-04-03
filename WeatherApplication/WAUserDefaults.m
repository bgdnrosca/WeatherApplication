//
//  WAUserDefaults.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 3/23/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "WAUserDefaults.h"

@implementation WAUserDefaults

+ (void) saveArrayAtKey: (NSString*)key arrayToSave:(NSArray*) array{
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

+ (void) saveArrayToFile: (NSString*) fileName arrayToSave:(NSArray*) array{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    NSError *error = nil;
    [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    NSLog(@"Write returned error: %@", [error localizedDescription]);
}

+ (NSArray*) getArrayFromFile: (NSString*) fileName{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}
@end
