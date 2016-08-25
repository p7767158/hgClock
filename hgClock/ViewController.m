//
//  ViewController.m
//  hgClock
//
//  Created by zhh on 16/8/23.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "ViewController.h"
#import "HGSetViewController.h"
#import "HGModifyViewController.h"
#import "HGSession.h"
#import "HGGlobal.h"
#import <Masonry/Masonry.h>
#import "HGSetViewController.h"
#import "HGAnimationCircleBtn.h"
#import "FBLCDFontView.h"

@interface ViewController ()

@property (nonatomic, strong) HGAnimationCircleBtn *operateBtn;
@property (nonatomic, strong) FBLCDFontView *clockView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *aMaskView;
@property (nonatomic, strong) UIImageView *bg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(36, 36, 36, 1);
    self.navigationItem.title = NSLocalizedString(@"HgTitle", nil);
    
    _aMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _aMaskView.userInteractionEnabled = YES;
    _aMaskView.layer.cornerRadius = 50.f;
    _aMaskView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7].CGColor;
    _aMaskView.layer.borderWidth = 1.f;
    
    [self.view addSubview:self.bg];
    [self.view addSubview:_aMaskView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.clockView];
    
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.aMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(self.view);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
    }];
    [self.clockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@190);
        make.height.equalTo(@80);
    }];
    
    [self reload];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self reload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reload
{
    [self.operateBtn removeFromSuperview];
    _operateBtn = nil;
    [self.view addSubview:self.operateBtn];
    [self.operateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.aMaskView);
    }];
    
    if ([[HGSession sharedHGSession] userDefaultForKey:kClockKey] != [NSNull null]) {
        [self.operateBtn setAttributedTitle:[HGGlobal makeAttString:NSLocalizedString(@"Modify", nil) withFont:[UIFont systemFontOfSize:16] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        self.clockView.text = [HGGlobal formatTime:[[[HGSession sharedHGSession] userDefaultForKey:kClockKey] longLongValue] withFormat:@"HH:mm"];
        self.tipLabel.hidden = YES;
        self.clockView.hidden = NO;
    } else {
         [self.operateBtn setAttributedTitle:[HGGlobal makeAttString:NSLocalizedString(@"Set", nil) withFont:[UIFont systemFontOfSize:16] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        self.tipLabel.text = NSLocalizedString(@"Tip", nil);
        self.tipLabel.hidden = NO;
        self.clockView.hidden = YES;
    }
}

- (HGAnimationCircleBtn *)operateBtn
{
    if (!_operateBtn) {
        _operateBtn = [[HGAnimationCircleBtn alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _operateBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_operateBtn addTarget:self action:@selector(set:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operateBtn;
}

- (IBAction)set:(id)sender
{
    HGSetViewController *setVC = [[HGSetViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:34];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = UIColorFrom0x(0x00f0ff);
    }
    return _tipLabel;
}

- (FBLCDFontView *)clockView
{
    if (!_clockView) {
        _clockView = [[FBLCDFontView alloc] init];
        _clockView.lineWidth = 4.0;
        _clockView.drawOffLine = NO;
        _clockView.edgeLength = 20;
        _clockView.margin = 10.0;
        _clockView.horizontalPadding = 20;
        _clockView.verticalPadding = 14;
        _clockView.glowSize = 10.0;
        _clockView.backgroundColor = [UIColor clearColor];
        _clockView.glowColor = UIColorFrom0x(0x00ffff);
        _clockView.innerGlowColor = UIColorFrom0x(0x00ffff);
        _clockView.innerGlowSize = 3.0;
    }
    return _clockView;
}

- (UIImageView *)bg
{
    if (!_bg) {
        _bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    }
    return _bg;
}

@end
