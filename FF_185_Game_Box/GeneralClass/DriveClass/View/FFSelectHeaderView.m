//
//  FFSelectHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/10.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFSelectHeaderView.h"

const NSInteger ButtonTag = 10086;

@interface FFSelectHeaderView () <UIScrollViewDelegate>

/** title button Array */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtonArray;

@property (nonatomic, assign) NSInteger selectTitleIndex;

@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation FFSelectHeaderView {
    CGRect totalFrame;
    CGSize scorllViewContentSize;
    CGRect buttonBounds;
    bool isAnimation;
    UIButton *lastButton;
};

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        totalFrame = frame;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        totalFrame = frame;
        self.headerTitleArray = array;
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.scrollView];
    [self addSubview:self.lineView];
}

- (void)initDataSource {
    _titleSize = CGSizeMake(0, 0);
    _titleNormalColor = [UIColor grayColor];
    _titleSelectColor = [UIColor orangeColor];
    _titleBackGroundColor = [UIColor clearColor];
    _cursorWidthEqualToTitleWidth = YES;
    _selectTitleIndex = 0;
    self.showCursorView = YES;
    totalFrame = CGRectMake(0, 0, kSCREEN_WIDTH, 50);
    self.cursorView.bounds = CGRectMake(0, 0, 0, 3);
}

#pragma mark - responds
- (void)respondsToTitleButton:(UIButton *)sender {
    if (isAnimation) {

    } else {
        self.selectTitleIndex = sender.tag - ButtonTag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFSelectHeaderView:didSelectTitleWithIndex:)]) {
            [self.delegate FFSelectHeaderView:self didSelectTitleWithIndex:sender.tag - ButtonTag];
        }
    }
}


#pragma mark - method
- (void)creatTitleButtonWithTitleArray:(NSArray<NSString *> *)titleArray {
    if (titleArray == nil || titleArray.count == 0) {
        return;
    }
    if (_titleButtonArray.count > 0 && _titleButtonArray.count == titleArray.count) {
        [_titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setTitle:titleArray[idx] forState:(UIControlStateNormal)];
        }];
        return;
    }

    _titleButtonArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    
    [titleArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *button = [self creatButtonWithIndex:idx WidthTitle:obj];

        [_titleButtonArray addObject:button];

        [self.scrollView addSubview:button];
    }];
//    [self.scrollView.layer addSublayer:self.lineLayer];
    [self setSelectTitleIndex:0];
}

- (UIButton *)creatButtonWithIndex:(NSUInteger)idx WidthTitle:(NSString *)title {

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(idx * self.titleSize.width, 0, self.titleSize.width, self.titleSize.height);
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
    button.tag = ButtonTag + idx;
    button.backgroundColor = self.titleBackGroundColor;

    [button addTarget:self action:@selector(respondsToTitleButton:) forControlEvents:(UIControlEventTouchUpInside)];

    return button;
}


@synthesize titleSize = _titleSize;
@synthesize cursorColor = _cursorColor;
@synthesize cursorCenter_Y = _cursorCenter_Y;
#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    totalFrame = frame;
}

- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex {
    _selectTitleIndex = selectTitleIndex;


    if (_cursorWidthEqualToTitleWidth) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [self.titleButtonArray[0].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / self.titleButtonArray.count, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.cursorView.bounds = CGRectMake(0, 0, (retSize.width + 5), _cursorView.bounds.size.height);
    } else {
        self.cursorView.bounds = CGRectMake(0, 0, _cursorView.bounds.size.width, _cursorView.bounds.size.height);
    }


    [self setButtonHighlightedWintIndex:_selectTitleIndex];

    [self.scrollView sendSubviewToBack:self.cursorView];
    isAnimation = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.cursorView.center = CGPointMake(self.titleButtonArray[_selectTitleIndex].center.x, self.cursorView.center.y);
    } completion:^(BOOL finished) {
        isAnimation = NO;
        [self.scrollView sendSubviewToBack:self.cursorView];
    }];
}


- (void)setTitleSize:(CGSize)titleSize {
    if (_canScrollTitle) {
        _titleSize = titleSize;

        self.scrollView.contentSize = CGSizeMake(titleSize.width * self.titleButtonArray.count, totalFrame.size.height);

        [self.titleButtonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * titleSize.width, 0, titleSize.width, titleSize.height);
        }];

        [self setSelectTitleIndex:_selectTitleIndex];
    }
}

- (void)setCursorSize:(CGSize)cursorSize {
    if (!_cursorWidthEqualToTitleWidth) {
        _cursorSize = cursorSize;
        self.cursorView.bounds = CGRectMake(0, 0, cursorSize.width, cursorSize.height);
    }
}

- (void)setHeaderTitleArray:(NSArray *)headerTitleArray {
    _headerTitleArray = headerTitleArray;
    //creat title button
    [self creatTitleButtonWithTitleArray:_headerTitleArray];
}

- (void)setShowCursorView:(BOOL)showCursorView {
    _showCursorView = showCursorView;
    if (showCursorView) {
        [self.scrollView addSubview:self.cursorView];
//        [self.scrollView sendSubviewToBack:self.cursorView];
    } else {
        [self.cursorView removeFromSuperview];
    }
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    self.cursorView.backgroundColor = cursorColor;
}

- (void)setCursorCenter_Y:(CGFloat)cursorCenter_Y {
    _cursorCenter_Y = cursorCenter_Y;
    self.cursorView.center = CGPointMake(self.cursorView.center.x, cursorCenter_Y);
}

- (void)setCursorX:(CGFloat)x {
    CGFloat count = (float)self.titleButtonArray.count;
    x += self.titleButtonArray[0].center.x;
    self.cursorView.center = CGPointMake(x, self.cursorView.center.y);
    NSInteger index = x / (kSCREEN_WIDTH / count);
    [self setButtonHighlightedWintIndex:index];
}

- (void)setButtonHighlightedWintIndex:(NSUInteger)idx {
    if (lastButton) {
        [lastButton setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
    }
    UIButton *button = self.titleButtonArray[idx];

    [button setTitleColor:self.titleSelectColor forState:(UIControlStateNormal)];
    lastButton = button;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (lineColor) {
        self.lineView.frame = CGRectMake(0, self.frame.size.height - 2, kSCREEN_WIDTH, 2);
        self.lineView.backgroundColor = lineColor;
    }
}

#pragma mark - getter
- (CGSize)titleSize {
    if (_titleSize.width == 0 || _titleSize.height == 0) {
        _titleSize = CGSizeMake(totalFrame.size.width / self.headerTitleArray.count, totalFrame.size.height - 4);
    }
    return _titleSize;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] init];
        _cursorView.center = CGPointMake(self.titleButtonArray[0].center.x, totalFrame.size.height - 4);
        _cursorView.backgroundColor = self.cursorColor;
        _cursorView.layer.cornerRadius = 1;
        _cursorView.layer.masksToBounds = YES;
    }
    return _cursorView;
}

- (UIColor *)cursorColor {
    if (!_cursorColor) {
        _cursorColor = [UIColor orangeColor];
    }
    return _cursorColor;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, totalFrame.size.width, totalFrame.size.height)];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (CGFloat)cursorCenter_Y {
    if (_cursorCenter_Y == 0) {
        _cursorCenter_Y = totalFrame.size.height - 4;
    }
    return _cursorCenter_Y;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.bounds = CGRectMake(0, 0, totalFrame.size.width, 2);
    }
    return _lineLayer;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _lineView.backgroundColor = [UIColor clearColor];
    }
    return _lineView;
}



@end





