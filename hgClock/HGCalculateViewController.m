//
//  HGCalculateViewController.m
//  hgClock
//
//  Created by zhh on 16/8/24.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGCalculateViewController.h"
#import "HGGlobal.h"
#import <Masonry/Masonry.h>

static const int kTime = 1000;
static const int kCalculateTimes = 5;

@interface HGCalculateViewController ()

@property (nonatomic, strong) UILabel *timerLb;
@property (nonatomic, strong) UILabel *problemLb;
@property (nonatomic, strong) UITextField *resultTf;

@property (nonatomic, assign) NSInteger result;
@property (nonatomic, assign) NSInteger currentTimes;
@property (nonatomic, strong) NSArray *operatorArray;
@property (nonatomic, assign) BOOL resultFalse;
@property (nonatomic, assign) BOOL isComplete;

@end

@implementation HGCalculateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(36, 36, 36, 1);
    
    [self.view addSubview:self.timerLb];
    [self.view addSubview:self.problemLb];
    [self.view addSubview:self.resultTf];
    
    [self.timerLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.centerX.equalTo(self.view);
    }];
    [self.problemLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-40);
        make.top.equalTo(self.view).offset(190);
    }];
    [self.resultTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.problemLb);
        make.left.equalTo(self.problemLb.mas_right);
    }];
    
    [self.resultTf becomeFirstResponder];
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)start
{
    self.currentTimes = 0;
    [self dispatchSetTimer];
    [self nextProblemWithIndex:(int)self.currentTimes];
}

- (void)nextProblemWithIndex:(int)index
{
    NSInteger firstPara = [self getOnePara];
    char opeartor = [self getOperator];
    NSInteger secPara = [self getOnePara];
    
    switch (opeartor) {
        case '+':
            self.result = firstPara + secPara;
            break;
        case '-': {
            if (firstPara < secPara) {
                NSInteger temp = firstPara;
                firstPara = secPara;
                secPara = temp;
            }
            self.result = firstPara - secPara;
        }
            break;
        case '*':
            self.result = firstPara * secPara;
            break;
        case '/': {
            while (firstPara % secPara) {
                firstPara = [self getOnePara];
                secPara = [self getOnePara];
            }
            self.result = firstPara / secPara;
        }
            break;
        default:
            break;
    }
    if (index == 0) {
        self.problemLb.text = [NSString stringWithFormat:@"%d %c %d = ", (int)firstPara, opeartor, (int)secPara];
    } else {
        [self setProblemWithString:[NSString stringWithFormat:@"%d %c %d = ", (int)firstPara, opeartor, (int)secPara]];
    }
}

- (void)setProblemWithString:(NSString *)problem
{
    [UIView animateWithDuration:0.1 animations:^{
        self.problemLb.alpha = 0;
        self.resultTf.alpha = 0;
    } completion:^(BOOL finished) {
        self.problemLb.text = problem;
        self.resultTf.text = @"";
        [UIView animateWithDuration:0.1 animations:^{
            self.problemLb.alpha = 1;
            self.resultTf.alpha = 1;
        }];
    }];
}

- (NSArray *)operatorArray
{
    if (!_operatorArray) {
        _operatorArray = @[@"+", @"-", @"*", @"/"];
    }
    return _operatorArray;
}

- (UILabel *)timerLb
{
    if (!_timerLb) {
        _timerLb = [[UILabel alloc] init];
        _timerLb.font = [UIFont fontWithName:@"DigifaceWide" size:34];
        _timerLb.textColor = UIColorFrom0x(0x00f0ff);
    }
    return _timerLb;
}

- (void)dispatchSetTimer
{
    __block int time = kTime;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (time == 0 || self.resultFalse) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ExcuseMe", nil) message:NSLocalizedString(@"TimeAlert", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *againAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OnceAgain", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   //restart
                    self.resultFalse = NO;
                    self.resultTf.text = @"";
                    [self start];
                }];
                [alertController addAction:againAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        if (self.isComplete) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //success
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"TimeAlert", nil) preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *againAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OnceAgain", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //restart
                    self.isComplete = NO;
                    self.resultTf.text = @"";
                    [self start];
                }];
                [alertController addAction:againAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.timerLb.text = [NSString stringWithFormat:@"%.2f", time / 100.f];
            time--;
        });
    });
    dispatch_resume(timer);
}

- (NSInteger)getOnePara
{
    return 1 + arc4random() % 9;
}

- (char)getOperator
{
    return [self.operatorArray[arc4random() % 4] characterAtIndex:0];
}

- (UILabel *)problemLb
{
    if (!_problemLb) {
        _problemLb = [[UILabel alloc] init];
        _problemLb.font = [UIFont fontWithName:@"DigifaceWide" size:34];
        _problemLb.textColor = UIColorFrom0x(0x00f0ff);
    }
    return _problemLb;
}

- (UITextField *)resultTf
{
    if (!_resultTf) {
        _resultTf = [[UITextField alloc] init];
        [_resultTf addTarget:self action:@selector(judgeResult:) forControlEvents:UIControlEventEditingChanged];
        _resultTf.font = [UIFont fontWithName:@"DigifaceWide" size:34];
        _resultTf.textColor = UIColorFrom0x(0x00f0ff);
        _resultTf.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _resultTf;
}

- (IBAction)judgeResult:(id)sender
{
    int resultLen = self.result >= 10 ? 2 : 1;
    if (self.resultTf.text.length == resultLen) {
        if (self.resultTf.text.integerValue == self.result) {
            self.currentTimes++;
            if (self.currentTimes >= kCalculateTimes) {
                self.isComplete = YES;
                return;
            }
            [self nextProblemWithIndex:(int)self.currentTimes];
        } else {
            self.resultFalse = YES;
        }
    }
}

@end
