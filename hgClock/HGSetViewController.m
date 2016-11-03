//
//  HGSetViewController.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGSetViewController.h"
#import "HGSession.h"
#import "HGWeekTableViewCell.h"
#import <Masonry/Masonry.h>
@import EventKit;

static NSString * const kWeekCell = @"kWeekCell";

@interface HGSetViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *weekArray;

@end

@implementation HGSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Confirm", nil) style:UIBarButtonItemStylePlain target:self action:@selector(confirm:)];
    self.navigationItem.rightBarButtonItem = confirmItem;

    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height / 2.5));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    if ([[HGSession sharedHGSession] userDefaultForKey:kWeekKey] != [NSNull null]) {
        NSArray *weekArray = [[HGSession sharedHGSession] userDefaultForKey:kWeekKey];
        [weekArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj[@"select"] boolValue] == YES) {
                self.weekArray[idx][@"select"] = @(YES);
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (NSMutableArray *)weekArray
{
    if (!_weekArray) {
        _weekArray = @[
                       @{@"week":NSLocalizedString(@"Sun", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Mon", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Tue", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Wed", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Thu", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Fri", nil), @"select":@(0)}.mutableCopy,
                       @{@"week":NSLocalizedString(@"Sat", nil), @"select":@(0)}.mutableCopy
                       ].mutableCopy;
    }
    return _weekArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        [_tableView registerClass:HGWeekTableViewCell.class forCellReuseIdentifier:kWeekCell];
        _tableView.allowsMultipleSelection = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 2.5)];
        _headerView.backgroundColor = [UIColor whiteColor];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeTime;
        if ([[HGSession sharedHGSession] userDefaultForKey:kClockKey] != [NSNull null]) {
            [_datePicker setDate:[NSDate dateWithTimeIntervalSince1970:[[[HGSession sharedHGSession] userDefaultForKey:kClockKey] longValue]]];
        }
        
        [_headerView addSubview:_datePicker];
        [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView).mas_offset(UIEdgeInsetsMake(0, 15, 0, 15));
        }];
    }
    return _headerView;
}


- (IBAction)confirm:(id)sender
{
    __block BOOL hasSelected = NO;
    [self.weekArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"select"] boolValue] == YES) {
            hasSelected = YES;
            *stop = YES;
        }
    }];
    
    if (!hasSelected) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"WeekAlert", nil) preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    [[HGSession sharedHGSession] setUserDefault:@([self.datePicker.date timeIntervalSince1970]) forKey:kClockKey];
    [[HGSession sharedHGSession] setUserDefault:self.weekArray forKey:kWeekKey];
    
//    [self.weekArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj[@"select"] boolValue] == YES) {
//            UILocalNotification
//        }
//    }]
    
    EKEventStore *es = [[EKEventStore alloc] init];
    [es requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeIntervalSinceNow:20]];
            
            EKEvent *event = [EKEvent eventWithEventStore:es];
            event.title = @"闹铃";
            event.startDate = [NSDate date];
            event.endDate = [NSDate dateWithTimeIntervalSinceNow:30];
            event.allDay = YES;
            [event addAlarm:alarm];
            [es saveEvent:event span:EKSpanThisEvent commit:YES error:nil];
            NSError *err = nil;
            if([es saveEvent:event span:EKSpanThisEvent commit:YES error:&err]){
                NSLog(@"saved!");
            }else{
                NSLog(@"%@",err);
            }
        } else {
                NSLog(@"%@",error);
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeekCell forIndexPath:indexPath];
    cell.titleLb.text = self.weekArray[indexPath.row][@"week"];
    cell.subImg.hidden = ![self.weekArray[indexPath.row][@"select"] boolValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.weekArray[indexPath.row][@"select"] = @(![self.weekArray[indexPath.row][@"select"] boolValue]);
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
