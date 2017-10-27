//
//  ViewController.m
//  BlueToothDemo
//
//  Created by chenxingwang on 2017/10/26.
//  Copyright © 2017年 chenxingwang. All rights reserved.
//

#import "ViewController.h"
#import <BabyBluetooth/BabyBluetooth.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableview;
@property (nonatomic ,strong) NSMutableArray *BLEIds;
@property (nonatomic ,strong) NSMutableDictionary *dataDict;
@end

@implementation ViewController{

    BabyBluetooth *_baby;
}

static NSString *const worksCellId      = @"worksCellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bbtoothSet];
    [self setupView];
}

- (void)setupView{

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];

    tableView.delegate = self;
    tableView.dataSource = self;

    self.tableview = tableView;

    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:worksCellId];


    [self.view addSubview:_tableview];
}

- (void)setUpData{
}

- (void)bbtoothSet{

    _baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    _baby.scanForPeripherals().begin();
}

- (void)babyDelegate{

    if (!self.BLEIds) {
        self.BLEIds = @[].mutableCopy;
    }

    if (!self.dataDict) {
        self.dataDict = @{}.mutableCopy;
    }

    __weak typeof(self) weakSelf = self;

    [_baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {

        NSLog(@"搜索到了设备:%@",peripheral.name);

        [weakSelf.BLEIds addObject:peripheral.name];

        NSString *key = [NSString stringWithFormat:@"%@",peripheral.name];

        [weakSelf.dataDict setValue:@"" forKey:key];

        [weakSelf.tableview reloadData];
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

#pragma mark -
#pragma mark - UITableViewDelegate && UITableViewDataSource
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:worksCellId forIndexPath:indexPath];

    cell.textLabel.text = _dataDict.allKeys[indexPath.row];

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
