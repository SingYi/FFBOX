//
//  FFOpenServerSelectView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/31.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFOpenServerSelectView.h"

#define BTNTAG 1400
#define BUTTON_SIZE [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)\
options:NSStringDrawingTruncatesLastVisibleLine |\
NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading\
attributes:attribute context:nil].size

@interface FFOpenServerSelectView()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UIButton *lastBtn;


@end


@implementation FFOpenServerSelectView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.btnNameArray = btnNameArray;
        _isAnimation = NO;
    }
    return self;
}


- (void)setBtnNameArray:(NSArray *)btnNameArray {
    _btnNameArray = btnNameArray;

    _buttons = [NSMutableArray arrayWithCapacity:btnNameArray.count];

    UIFont *font;
    if (btnNameArray.count >= 5) {
        font = [UIFont systemFontOfSize:14];
    } else {
        font = [UIFont systemFontOfSize:18];
    }

    [_btnNameArray enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(idx * kSCREEN_WIDTH / _btnNameArray.count, 0, kSCREEN_WIDTH / self.btnNameArray.count, 44);

        [button setTitle:obj forState:(UIControlStateNormal)];

        button.tag = BTNTAG + idx;
        button.backgroundColor = [UIColor whiteColor];

        [button addTarget:self action:@selector(respondstoBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (idx == 0) {
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            _lastBtn = button;
        } else {
            [button setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        }

        button.titleLabel.font = font;

        [_buttons addObject:button];

        [self addSubview:button];
    }];

    [self addSubview:self.line];
    [self addSubview:self.seleView];
}

- (void)setIndex:(NSInteger)index {
    _index = index;

    if (_lastBtn) {
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)
                                                                    options:NSStringDrawingTruncatesLastVisibleLine |
                                                                            NSStringDrawingUsesLineFragmentOrigin |
                                                                            NSStringDrawingUsesFontLeading
                                                                 attributes:attribute context:nil].size;

    [_buttons[_index] setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    self.seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);

//    [UIView animateWithDuration:0.3 animations:^{
//        self.seleView.center = CGPointMake(_buttons[_index].center.x, self.seleView.center.y);
//    }];


    _lastBtn = _buttons[_index];
}

- (void)setLineColor:(UIColor *)lineColor {
    self.line.backgroundColor = lineColor;
}

- (void)reomveLabelWithX:(CGFloat)x {
    CGFloat count = (float)_buttons.count;
    x += _buttons[0].center.x;
    self.seleView.center = CGPointMake(x, 42.5);
    NSInteger index = x / (kSCREEN_WIDTH / count);
    if (index != _index) {
        [self setSelectButtonWithIndex:index];
    }
}

- (void)setSelectButtonWithIndex:(NSInteger)index {
    _index = index;

    if (_lastBtn) {
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    }

    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [_buttons[_index].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30)
                                                                    options:NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                                 attributes:attribute context:nil].size;

    self.seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
    [_buttons[_index] setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];

    _lastBtn = _buttons[_index];
}




#pragma mark - getter
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 41, kSCREEN_WIDTH, 3)];
        _line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _line;
}


- (UIView *)seleView {
    if (!_seleView) {
        _seleView = [[UIView alloc] init];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [_buttons[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / _buttons.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _seleView.bounds = CGRectMake(0, 0, (retSize.width + 10), 3);
        _seleView.center = CGPointMake(_buttons[0].center.x, 42.5);
        _seleView.backgroundColor = [UIColor orangeColor];
        _seleView.layer.cornerRadius = 1;
        _seleView.layer.masksToBounds = YES;
    }
    return _seleView;
}

#pragma mark - respondstoBtn
- (void)respondstoBtn:(UIButton *)sender {
    if (_isAnimation) {

    } else {
        self.index = sender.tag - BTNTAG;
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFOpenServerSelectView:didSelectBtnAtIndexPath:)]) {
            [self.delegate FFOpenServerSelectView:self didSelectBtnAtIndexPath:sender.tag - BTNTAG];
        }
    }
}





@end
