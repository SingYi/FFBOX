//
//  FFFlashBackView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/9.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFFlashBackView.h"
#import "FFBasicModel.h"

@interface FFFlashBackView ()

@property (nonatomic, strong) UIView *showView;

@property (nonatomic, strong) UIButton *fixButton;

@end

@implementation FFFlashBackView


static FFFlashBackView *view;
+ (void)show {
    if (view == nil) {
        view = [[FFFlashBackView alloc] init];
    }
    [view makeKeyAndVisible];
}

- (void)hideView {
    [view resignKeyWindow];
    view = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
    UIViewController *vc = [[UIViewController alloc] init];
    self.rootViewController = vc;
    vc.view.backgroundColor = [UIColor clearColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [vc.view addGestureRecognizer:tap];
    [vc.view addSubview:self.showView];

}


#pragma mark responds
- (void)respondsToFixButton {
    NSString *urlStrig = [NSString stringWithFormat:@"https://ipa.185sy.com/ios/fix/ios_app_%@.mobileconfig",Channel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrig]];
    [self resignKeyWindow];
    view = nil;
}

#pragma mark - getter
- (UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH * 0.7, kSCREEN_HEIGHT * 0.5)];
        _showView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _showView.backgroundColor = [UIColor whiteColor];
        _showView.layer.cornerRadius = 8;
        _showView.layer.masksToBounds = YES;
        [_showView addSubview:self.fixButton];
    }
    return _showView;
}

- (UIButton *)fixButton {
    if (!_fixButton) {
        _fixButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _fixButton.frame = CGRectMake(kSCREEN_WIDTH * 0.05, kSCREEN_HEIGHT / 2 - 100, kSCREEN_WIDTH * 0.6, 44);
        [_fixButton setTitle:@"闪退修复" forState:(UIControlStateNormal)];
        _fixButton.backgroundColor = NAVGATION_BAR_COLOR;
        _fixButton.layer.cornerRadius = 4;
        _fixButton.layer.masksToBounds = YES;
        [_fixButton addTarget:self action:@selector(respondsToFixButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _fixButton;
}




@end




