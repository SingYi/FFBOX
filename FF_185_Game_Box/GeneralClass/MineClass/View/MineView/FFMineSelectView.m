//
//  FFMineSelectView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/7.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMineSelectView.h"

#define BUTTON_TAG 10086

@interface FFMineSelectView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *selectbuttons;

@property (nonatomic, assign) BOOL isSetButton;

@end


@implementation FFMineSelectView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setSelectButtonWith:self.frame];
}

- (void)initializeUserInterface {

}

- (void)initializeDataSource {

}

- (void)setSelectButtonWith:(CGRect)frame {
    if (_isSetButton) {
        return;
    }
    _isSetButton = YES;
    CGFloat height = kSCREEN_WIDTH / 3 * 0.66;
    CGFloat width = kSCREEN_WIDTH / 3;
    NSArray *imageArray = @[@"New_mine_sign",@"New_mine_invite",@"New_mine_service",@"New_mine_package",@"New_mine_collection",@"New_mine_transfer",@"New_mine_changePassword",@"New_mine_about",@"New_mine_sign"];
    [self.selectArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.tag = BUTTON_TAG + idx;

        button.frame = CGRectMake((idx % 3) * width, (idx / 3) * height, width, height);
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(respondsToSelectButton:) forControlEvents:(UIControlEventTouchUpInside)];

        UIImageView *logo = [[UIImageView alloc] init];
        logo.image = [UIImage imageNamed:imageArray[idx]];
        logo.bounds = CGRectMake(0, 0, width / 3, width / 3);
        logo.center = CGPointMake(width / 2, height / 3);
        [button addSubview:logo];

        UILabel *title = [[UILabel alloc] init];
        title.bounds = CGRectMake(0, 0, width, height / 4);
        title.text = obj;
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentCenter;
        [title sizeToFit];
        title.font = [UIFont systemFontOfSize:14];
        title.center = CGPointMake(logo.center.x, height * 0.77);
        [button addSubview:title];


        [self addSubview:button];
    }];

    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(0, height, kSCREEN_WIDTH, 0.5);
    line1.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:line1];

    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(0, height * 2, kSCREEN_WIDTH, 0.5);
    line2.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:line2];

    UIView *line3 = [[UIView alloc] init];
    line3.frame = CGRectMake(width, 0, 0.5, frame.size.height);
    line3.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:line3];

    UIView *line4 = [[UIView alloc] init];
    line4.frame = CGRectMake(width * 2, 0, 0.5, frame.size.height);
    line4.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:line4];
}

- (void)respondsToSelectButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFmineSelectView:didSelectButtonWithIndex:)]) {
        [self.delegate FFmineSelectView:self didSelectButtonWithIndex:(sender.tag - BUTTON_TAG)];
    }
}


@synthesize selectArray = _selectArray;
#pragma mark - setter
- (void)setSelectArray:(NSArray *)selectArray {
    _selectArray = selectArray;

    if (self.selectbuttons.count == _selectArray.count) {
        [_selectArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.selectbuttons[idx] setTitle:obj forState:(UIControlStateNormal)];
        }];
    }
}


#pragma mark - getter
- (NSArray *)selectArray {
    if (!_selectArray) {

        if (_is185) {
            _selectArray = @[@"每日签到",@"邀请好友",@"客服中心",@"我的礼包",@"我的收藏",@"申请转游",@"修改密码",@"关于"];
        } else {
            _selectArray = @[@"每日签到",@"邀请好友",@"客服中心",@"我的礼包",@"我的收藏",@"申请转游",@"修改密码"];
        }
    }


    return _selectArray;
}

- (NSMutableArray<UIButton *> *)selectbuttons {
    if (!_selectbuttons) {
        _selectbuttons = [NSMutableArray array];
    }
    return _selectbuttons;
}



@end
