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
- (void) initiateChatButtonClicked:(UIButton*)sender;
- (void) discoverChatButtonClicked:(UIButton*)sender;
@end

@implementation BluetoothClientViewController
CGRect const kInitialViewFrame = { 0.0f, 0.0f, 320.0f, 480.0f };
UITextView *textView;
UIView *firstItem;
bool isPeripheral;
CustomActivityIndicator *spinner;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[NSMutableData alloc] init];
    [self initializeViewComponents];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillToggle:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillToggle:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    // Do any additional setup after loading the view.
}

- (void) initializeViewComponents{
    self.view.backgroundColor = [UIColor clearColor];
    self.tabBarController.tabBar.hidden = YES;
    
    UIView *centerView = [[UIView alloc]init];
    UIView *topView = [[UIView alloc] init];
    UIView *bottomView = [[UIView alloc] init];
    
    UILabel *pageTitle = [[UILabel alloc]init];
    pageTitle.text = @"Bluetooth Chat";
    pageTitle.textAlignment = NSTextAlignmentCenter;
    topView.backgroundColor = [UIColor clearColor];
    [topView addSubview:pageTitle];
    [pageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(topView);
    }];
    
    firstItem = [[UIView alloc]init];
    UIView *secondItem = [[UIView alloc]init];
    [centerView addSubview:firstItem];
    [centerView addSubview:secondItem];
    
    //Add post and put buttons
    
    UIButton *initiateChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [initiateChatButton addTarget:self action:@selector(initiateChatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    initiateChatButton.layer.cornerRadius = 5;
    [initiateChatButton setTitle:@"Initiate" forState:UIControlStateNormal];
    [initiateChatButton setBackgroundColor:[UIColor blackColor]];
    [initiateChatButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    UIButton *discoverChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [discoverChatButton addTarget:self action:@selector(discoverChatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    discoverChatButton.layer.cornerRadius = 5;
    [discoverChatButton setTitle:@"Discover" forState:UIControlStateNormal];
    [discoverChatButton setBackgroundColor:[UIColor blackColor]];
    [discoverChatButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
    [firstItem addSubview:initiateChatButton];
    [firstItem addSubview:discoverChatButton];
    
    [initiateChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX).dividedBy(2);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(3);
    }];
    
    [discoverChatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(firstItem.mas_centerY);
        make.centerX.mas_equalTo(firstItem.mas_centerX).multipliedBy(1.5);
        make.height.mas_equalTo(firstItem.mas_height).dividedBy(3);
        make.width.mas_equalTo(firstItem.mas_width).dividedBy(3);
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
    
    CGRect frame = CGRectMake(0.0f,
                              20.0f,
                              centerView.frame.size.width,
                              centerView.frame.size.height - 20.0f);
    textView = [[UITextView alloc] initWithFrame:frame];
    [textView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [textView setEditable:NO];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setAlwaysBounceVertical:YES];
    [textView setFont:[UIFont systemFontOfSize:[UIFont labelFontSize]]];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, PHFComposeBarViewInitialHeight, 0.0f);
    [textView setContentInset:insets];
    [textView setScrollIndicatorInsets:insets];
    
    UIView *bubbleView = [[UIView alloc] initWithFrame:CGRectMake(80.0f, 480.0f, 220.0f, 60.0f)];
    [bubbleView setBackgroundColor:[UIColor colorWithHue:206.0f/360.0f saturation:0.81f brightness:0.99f alpha:1]];
    [secondItem addSubview:textView];

    
//    textView = [[UITextView alloc]init];
//    textView.backgroundColor = [UIColor whiteColor];
//    textView.textAlignment = NSTextAlignmentJustified;
//    [secondItem addSubview:textView];
//    
//    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_greaterThanOrEqualTo(firstItem.mas_height).multipliedBy(2);
//        UIEdgeInsets padding = UIEdgeInsetsMake(20, 20, 20, 20);
//        make.edges.equalTo(secondItem).with.insets(padding).with.priorityHigh();
//    }];
    
    [self.view addSubview:topView];
    [self.view addSubview:centerView];
    [self.view addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height).dividedBy(10);
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
    
    // compose bar view
    frame = CGRectMake(0.0f,
                              bottomView.frame.size.height - PHFComposeBarViewInitialHeight,
                              320,
                              PHFComposeBarViewInitialHeight);
    self.composeBarView = [[PHFComposeBarView alloc] initWithFrame:frame];
    [self.composeBarView setMaxCharCount:160];
    [self.composeBarView setMaxLinesCount:5];
    [self.composeBarView setPlaceholder:@"Type something..."];
    [self.composeBarView setDelegate:self];
    
    [[self.composeBarView placeholderLabel] setAccessibilityIdentifier:@"Placeholder"];
    [[self.composeBarView textView] setAccessibilityIdentifier:@"Input"];
    [[self.composeBarView button] setAccessibilityIdentifier:@"Submit"];
    [[self.composeBarView utilityButton] setAccessibilityIdentifier:@"Utility"];

    
    [bottomView addSubview:self.composeBarView];
    
    [self.composeBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(bottomView);
    }];
//    statusView = [[UITextView alloc]init];
//    [bottomView addSubview:statusView];
//    
//    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.and.bottom.mas_equalTo(bottomView);
//    }];
    
    // Add loading spinner to the page
    spinner = [[CustomActivityIndicator alloc]init];
    [self.view addSubview:spinner];
    [spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.and.bottom.mas_equalTo(self.view);
    }];

}

- (void) viewWillDisappear:(BOOL)animated{
    [self.centralManager stopScan];
}


// ------------------------- Central Role ---------------------//


- (void) discoverChatButtonClicked:(UIButton *)sender{
    isPeripheral = FALSE;
    [firstItem setHidden: YES];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [spinner stopProgress];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    // Check state
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        // Scan for devices
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:CustomServiceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning for gatt server\n\n");
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Discovered %@ at %@ \n\n", peripheral.name, RSSI);
    
    if (self.discoveredPeripheral != peripheral) {
        self.discoveredPeripheral = peripheral;
        
        NSLog(@"Connecting to peripheral\n\n");
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Failed to connect\n\n");
    [self cleanup];
}

- (void)cleanup {
    
    // See if we are subscribed to a characteristic on the peripheral
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ReadCharacteristicUUID]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:WriteCharacteristicUUID]]) {
                        if (characteristic.isNotifying) {
                            [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected to peripheral\n\n");
    
    [self.centralManager stopScan];
    NSLog(@"Scanned stopped\n\n");
    
    [self.data setLength:0];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:CustomServiceUUID]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:ReadCharacteristicUUID],[CBUUID UUIDWithString:WriteCharacteristicUUID] ] forService:service];
    }
    // Discover other characteristics
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:ReadCharacteristicUUID]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:WriteCharacteristicUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:WriteCharacteristicUUID]])
            {
                self.centralWriteCharacteristic = characteristic;
            }
        }
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:ReadCharacteristicUUID]] ||
        ![characteristic.UUID isEqual:[CBUUID UUIDWithString:WriteCharacteristicUUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        // Notification has stopped
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    self.discoveredPeripheral = nil;
    
    [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:CustomServiceUUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// ------------------------- Peripheral Role ---------------------//


- (void) initiateChatButtonClicked:(UIButton *)sender{
    isPeripheral = true;
    [firstItem setHidden: YES];
    if(!self.peripheralManager){
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];    }
    NSLog(@"Initiate chat session.\n");
    [spinner stopProgress];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.peripheralReadCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:ReadCharacteristicUUID] properties:CBCharacteristicPropertyRead | CBCharacteristicPropertyNotify  value:nil permissions:CBAttributePermissionsReadable];
        self.peripheralWriteCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:WriteCharacteristicUUID] properties:CBCharacteristicPropertyWriteWithoutResponse | CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsWriteable];
        
        CBMutableService *chatService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:CustomServiceUUID] primary:YES];
        
        chatService.characteristics = @[self.peripheralReadCharacteristic, self.peripheralWriteCharacteristic];
        NSLog(@"Advertisting chat service with two characteristics.\n");
        
        [self.peripheralManager addService:chatService];
        [self.peripheralManager setDelegate:self];
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:CustomServiceUUID]] }];
    }
}
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    for (CBATTRequest *request in requests) {
        NSString *stringFromData = [[NSString alloc]initWithData:[request value] encoding:NSUTF8StringEncoding];
        if ([stringFromData isEqualToString:EndOfMessage]) {
            [textView insertText:[NSString stringWithFormat:@"Received: %@", [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]]];
            [textView insertText:@"\n"];
            [self.data setLength:0];
        }
        else{
            [self.data appendData:[request value]];
        }
    }
    // respond!
    [peripheral respondToRequest:[requests objectAtIndex:0] withResult:CBATTErrorSuccess];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
        [self writeDataToCharacteristic];
}


// ------------------------- Peripheral & Central Methods ---------------------//
- (void)writeDataToCharacteristic{
    
    static BOOL sendingEOM = NO;
    
    // end of message?
    if (sendingEOM) {
        BOOL didSend = NO;
        if(isPeripheral)
        {
            didSend = [self.peripheralManager updateValue:[EndOfMessage dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.peripheralReadCharacteristic onSubscribedCentrals:nil];
        }else{
            [self.discoveredPeripheral writeValue:[EndOfMessage dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.centralWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
            didSend = true;
        }

        if (didSend) {
            // It did, so mark it as sent
            sendingEOM = NO;
        }
        // didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're sending data
    // Is there any left to send?
    if (self.sendDataIndex >= self.dataToSend.length) {
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    BOOL didSend = YES;
    
    while (didSend) {
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > 20) amountToSend = 20;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        if(isPeripheral)
        {
            didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.peripheralReadCharacteristic onSubscribedCentrals:nil];
        }else{
            [self.discoveredPeripheral writeValue:chunk forCharacteristic:self.centralWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
            didSend = true;
        }
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            BOOL eomSent = false;
            if(isPeripheral)
            {
                eomSent = [self.peripheralManager updateValue:[EndOfMessage dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.peripheralReadCharacteristic onSubscribedCentrals:nil];
            }else{
                [self.discoveredPeripheral writeValue:[EndOfMessage dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.centralWriteCharacteristic type:CBCharacteristicWriteWithoutResponse];
                eomSent = true;
            }
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            
            return;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error in didUpdateValueForCharacteristic \b");
        return;
    }
    
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    // Have we got everything we need?
    if ([stringFromData isEqualToString:EndOfMessage]) {
        [textView insertText:[NSString stringWithFormat:@"Received: %@", [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]]];
        [textView insertText:@"\n"];
        [self.data setLength:0];
    }
    else{
        [self.data appendData:characteristic.value];
    }
}

//------------- TEXT VIEW ---------------------------------------//

- (void)keyboardWillToggle:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval duration;
    UIViewAnimationCurve animationCurve;
    CGRect startFrame;
    CGRect endFrame;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey]    getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]        getValue:&startFrame];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]          getValue:&endFrame];
    
    NSInteger signCorrection = 1;
    if (startFrame.origin.y < 0 || startFrame.origin.x < 0 || endFrame.origin.y < 0 || endFrame.origin.x < 0)
        signCorrection = -1;
    
    CGFloat widthChange  = (endFrame.origin.x - startFrame.origin.x) * signCorrection;
    CGFloat heightChange = (endFrame.origin.y - startFrame.origin.y) * signCorrection;
    
    
    CGFloat sizeChange = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? widthChange : heightChange;
    
    CGRect newContainerFrame = [[self view] frame];
    newContainerFrame.size.height += sizeChange;
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [[self view] setFrame:newContainerFrame];
                     }
                     completion:NULL];
}

- (void)composeBarViewDidPressButton:(PHFComposeBarView *)composeBarView {
    NSString *text = [NSString stringWithFormat:@"Sent:%@\n", [composeBarView text]];
    self.dataToSend = [[composeBarView text] dataUsingEncoding:NSUTF8StringEncoding];
    [textView insertText:text];
    self.sendDataIndex = 0;
    [self writeDataToCharacteristic];
    [composeBarView setText:@"" animated:YES];
    [composeBarView resignFirstResponder];
}

- (void)composeBarViewDidPressUtilityButton:(PHFComposeBarView *)composeBarView {
    [self prependTextToTextView:@"Utility button pressed"];
}

- (void)composeBarView:(PHFComposeBarView *)composeBarView
   willChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame
              duration:(NSTimeInterval)duration
        animationCurve:(UIViewAnimationCurve)animationCurve
{
    [self prependTextToTextView:[NSString stringWithFormat:@"Height changing by %ld", (long)(endFrame.size.height - startFrame.size.height)]];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, endFrame.size.height, 0.0f);
    UITextView *textView = [self textView];
    [textView setContentInset:insets];
    [textView setScrollIndicatorInsets:insets];
}

- (void)composeBarView:(PHFComposeBarView *)composeBarView
    didChangeFromFrame:(CGRect)startFrame
               toFrame:(CGRect)endFrame{
    [self prependTextToTextView:@"Height changed"];
}

- (void)prependTextToTextView:(NSString *)text {
    NSString *newText = [text stringByAppendingFormat:@"\n\n%@", [[self textView] text]];
    [[self textView] setText:newText];
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
