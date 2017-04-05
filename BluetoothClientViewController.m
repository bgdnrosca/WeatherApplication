//
//  BluetoothClientViewController.m
//  WeatherApplication
//
//  Created by Rosca, Bogdan on 4/5/17.
//  Copyright © 2017 Rosca, Bogdan. All rights reserved.
//

#import "BluetoothClientViewController.h"
#import <Masonry/Masonry.h>
#import "CustomActivityIndicator.h"

@interface BluetoothClientViewController ()
- (void) initializeViewComponents;
- (void) discoverButtonClicked:(UIButton*)sender;
@end

@implementation BluetoothClientViewController

UITextView *textView;
UITextView *statusView;
CustomActivityIndicator *spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.data = [[NSMutableData alloc] init];
    [self initializeViewComponents];
    
    
    // Do any additional setup after loading the view.
}

- (void) initializeViewComponents{
    self.view.backgroundColor = [UIColor clearColor];
    self.tabBarController.tabBar.hidden = YES;
    
    UIView *centerView = [[UIView alloc]init];
    UIView *topView = [[UIView alloc] init];
    UIView *bottomView = [[UIView alloc] init];
    
    UILabel *pageTitle = [[UILabel alloc]init];
    pageTitle.text = @"Bluetooth GATT Client";
    pageTitle.textAlignment = NSTextAlignmentCenter;
    topView.backgroundColor = [UIColor clearColor];
    [topView addSubview:pageTitle];
    [pageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(topView);
    }];
    
    UIView *firstItem = [[UIView alloc]init];
    UIView *secondItem = [[UIView alloc]init];
    [centerView addSubview:firstItem];
    [centerView addSubview:secondItem];
    
    //Add post and put buttons
    
    UIButton *discoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [discoverButton addTarget:self action:@selector(discoverButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    discoverButton.layer.cornerRadius = 5;
    [discoverButton setTitle:@"Discover Gatt Server" forState:UIControlStateNormal];
    [discoverButton setBackgroundColor:[UIColor blackColor]];
    [discoverButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
        
    [firstItem addSubview:discoverButton];
    
    [discoverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(2);
    }];
    
    
    
    [firstItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(centerView);
        make.bottom.mas_equalTo(secondItem.mas_top);
    }];
    
    [secondItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(centerView.mas_bottom);
        make.top.mas_equalTo(firstItem.mas_bottom);
        make.height.mas_equalTo(firstItem.mas_height).multipliedBy(4);
        make.left.and.right.mas_equalTo(centerView);
    }];
    
    textView = [[UITextView alloc]init];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textAlignment = NSTextAlignmentJustified;
    [secondItem addSubview:textView];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(firstItem.mas_height).multipliedBy(2);
        UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
        make.edges.equalTo(secondItem).with.insets(padding).with.priorityHigh();
    }];
    
    [self.view addSubview:topView];
    [self.view addSubview:centerView];
    [self.view addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).dividedBy(7);
    }];
    
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.bottom.mas_equalTo(bottomView.mas_top);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(topView);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    statusView = [[UITextView alloc]init];
    [bottomView addSubview:statusView];
    
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(bottomView);
    }];
    
    // Add loading spinner to the page
    spinner = [[CustomActivityIndicator alloc]init];
    [self.view addSubview:spinner];
    [spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(self.view);
    }];

}

- (void) discoverButtonClicked:(UIButton*)sender{
    [spinner startProgress];
    [NSThread sleepForTimeInterval:5];
    [spinner stopProgress];
}

- (void) viewWillDisappear:(BOOL)animated{
    [self.centralManager stopScan];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    // Check state
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:CustomServiceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        [statusView insertText:@"Scanning for gatt server\n\n"];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    [statusView insertText:[NSString stringWithFormat: @"Discovered %@ at %@ \n\n", peripheral.name, RSSI]];
    
    if (self.discoveredPeripheral != peripheral) {
        self.discoveredPeripheral = peripheral;
        
        [statusView insertText:@"Connecting to peripheral\n\n"];
        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [statusView insertText:@"Failed to connect\n\n"];
    [self cleanup];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CustomCharacteristicUUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [statusView insertText:@"Connected to peripheral\n\n"];
    
    [_centralManager stopScan];
    [statusView insertText:@"Scanned stopped\n\n"];
    
    [_data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:CustomServiceUUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CustomCharacteristicUUID]] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:CustomCharacteristicUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [statusView insertText:@"Error in didUpdateValueForCharacteristic\n\n"];
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    [textView insertText:stringFromData];
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        [textView insertText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
        
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        
        [_centralManager cancelPeripheralConnection:peripheral];
    }
    
    [_data appendData:characteristic.value];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:CustomCharacteristicUUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    _discoveredPeripheral = nil;
    
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:CustomServiceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
