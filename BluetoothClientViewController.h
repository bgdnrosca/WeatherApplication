//
//  BluetoothClientViewController.h
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 4/5/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Constants.h"
#import "PHFComposeBarView.h"
@interface BluetoothClientViewController : UIViewController<CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

//Properties for central role
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) CBCharacteristic *centralWriteCharacteristic;

//Properties for peripheral role
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *peripheralReadCharacteristic;
@property (strong, nonatomic) CBMutableCharacteristic *peripheralWriteCharacteristic;
@property (strong, nonatomic) NSData *dataToSend;
@property (nonatomic, readwrite) NSInteger sendDataIndex;


@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) PHFComposeBarView* composeBarView;
@end
