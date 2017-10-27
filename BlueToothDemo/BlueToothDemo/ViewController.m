//
//  ViewController.m
//  BlueToothDemo
//
//  Created by chenxingwang on 2017/10/26.
//  Copyright © 2017年 chenxingwang. All rights reserved.
//

#import "ViewController.h"
#import <BabyBluetooth/BabyBluetooth.h>

@interface ViewController ()

@end

@implementation ViewController{

    BabyBluetooth *_baby;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _baby = [BabyBluetooth shareBabyBluetooth];

    [self babyDelegate];

    _baby.scanForPeripherals().begin();
}

- (void)babyDelegate{

    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {

        NSLog(@"搜索到了设备:%@",peripheral.name);

    }];


    //过滤器
    //设置查找设备的过滤器
    [_baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
