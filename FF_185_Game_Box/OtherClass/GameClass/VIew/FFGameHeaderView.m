//
//  FFGameHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameHeaderView.h"
#import "UIImageView+WebCache.h"
#import "FFGameModel.h"

@interface FFGameHeaderView ()<FFOpenServerSelectViewDelegate>

/** 游戏信息 */
@property (nonatomic, strong) NSDictionary *gameInfo;

/**游戏图标*/
@property (nonatomic, strong) UIImageView *gameLogo;
/**游戏名称标签*/
@property (nonatomic, strong) UILabel *gameNameLabel;
/**下载次数标签*/
@property (nonatomic, strong) UILabel *downLoadNumber;
/**按钮数组*/
@property (nonatomic, strong) NSArray *btnArray;
/** 选择的下标 */
@property (nonatomic, assign) NSInteger index;
/** 游戏评分 */
@property (nonatomic, assign) CGFloat source;
/** 游戏标签 */
@property (nonatomic, strong) NSMutableArray<UILabel *> *typeLabels;
/** 游戏大小 */
@property (nonatomic, strong) UILabel *sizeLabel;
/** QQ群 */
@property (nonatomic, strong) NSString *qqGroup;


/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;

/**分割线*/
@property (nonatomic, strong) UIView *lineView;

/** QQ群按钮 */
@property (nonatomic, strong) UIButton *qqGroupBtn;
/** QQ 群标签 */
@property (nonatomic, strong) UILabel *qqGroupLabel;

/** 评分星级 */
@property (nonatomic, strong) NSMutableArray<UIImageView *> *stars;



@end

@implementation FFGameHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];

    //选择控制器
    [self addSubview:self.selectView];
    //分割线
    [self addSubview:self.lineView];
    //logo
    [self addSubview:self.gameLogo];
    //游戏名称
    [self addSubview:self.gameNameLabel];
    //下载次数
    [self addSubview:self.downLoadNumber];
    //游戏大小
    [self addSubview:self.sizeLabel];
    //设置星级
    [self setStarsArray];
    //设置游戏标签
    [self setTypeLabelsArray];

}

- (void)setUserInterface {
    //设置游戏名称
    [self setGameName:CURRENT_GAME.game_name];
    //设置标签
    [self setGameTypeLabel:CURRENT_GAME.game_type_array];
    //设置游戏评分
    [self setGameSource:CURRENT_GAME.game_score];
    //设置游戏下载次数
    [self setGameDownLoadNumber:CURRENT_GAME.game_download_number.integerValue];
    //设置游戏大小
    [self setGameSize:CURRENT_GAME.game_size];
    //设置 logo
    [self setGameLogoUrl:CURRENT_GAME.game_logo_url];
    //设置 QQ 群
    self.qqGroup = CURRENT_GAME.player_qq_group;
}


#pragma mark - select view delegate
- (void)FFOpenServerSelectView:(FFOpenServerSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameHeaderView:didselectBtnAtIndex:)]) {
        [self.delegate FFGameHeaderView:self didselectBtnAtIndex:idx];
    }
}

#pragma mark - method
- (void)clickQQGroupBtn {
    if (_qqGroup && _qqGroup.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_qqGroup]];
    }
}

#pragma mark - setter
/** 选择标签 */
- (void)setBtnArray:(NSArray *)btnArray {
    _selectView.btnNameArray = btnArray;
}

/** 选择下标 */
- (void)setIndex:(NSInteger)index {
    self.selectView.index = index;
}

/** 游戏评分 */
- (void)setSource:(CGFloat)source {
    _source = source;

    for (NSInteger i = 0; i < 5; i++) {
        if (_source <= 0) {
            self.stars[i].image = [UIImage imageNamed:@"star_dark"];
        } else if (_source > 0 && _source <= 0.5) {
            self.stars[i].image = [UIImage imageNamed:@"star_half"];
        } else if (_source > 0.5) {
            self.stars[i].image = [UIImage imageNamed:@"star_bright"];
        }
        _source--;
    }
}

- (void)setQqGroup:(NSString *)qqGroup {
    if (qqGroup && qqGroup.length != 0) {
        _qqGroup = qqGroup;
        [self addSubview:self.qqGroupBtn];
        [self addSubview:self.qqGroupLabel];
    } else {
        _qqGroup = nil;
        [self.qqGroupLabel removeFromSuperview];
        [self.qqGroupBtn removeFromSuperview];
    }
}

#pragma mark - setter
- (void)setGameInfo:(NSDictionary *)gameInfo {
    //设置游戏名称
    [self setGameName:gameInfo[@"gamename"]];
    //设置标签
    [self setGameTypeLabel:[((NSString *)gameInfo[@"types"]) componentsSeparatedByString:@" "]];
    //设置游戏评分
    [self setGameSource:gameInfo[@"score"]];
    //设置游戏下载次数
    [self setGameDownLoadNumber:((NSString *)gameInfo[@"download"]).integerValue];
    //设置游戏大小
    [self setGameSize:gameInfo[@"size"]];
    //设置 logo
    [self setGameLogoUrl:[NSString stringWithFormat:IMAGEURL,gameInfo[@"logo"]]];
    //设置 QQ 群
    self.qqGroup = gameInfo[@"qq_group"];
}

/** 设置游戏名称 */
- (void)setGameName:(NSString *)gameName {
    self.gameNameLabel.text = gameName;
    [self.gameNameLabel sizeToFit];
}

/** 设置标签 */
- (void)setGameTypeLabel:(NSArray *)types {
    NSInteger j = 0;
    for (; j < (types.count < 3 ? types.count : 3); j++) {
        self.typeLabels[j].text = [NSString stringWithFormat:@" %@ ",types[j]];
        if (j == 0) {
            self.typeLabels[j].frame = CGRectMake(CGRectGetMaxX(self.gameNameLabel.frame) + 4, 15, 15, 15);
        } else {
            self.typeLabels[j].frame = CGRectMake(CGRectGetMaxX(self.typeLabels[j - 1].frame) + 2, 15, 15, 15);
        }
        [self.typeLabels[j] sizeToFit];
    }
    for (; j < self.typeLabels.count; j++) {
        self.typeLabels[j].text = @"";
        [self.typeLabels[j] sizeToFit];
    }
}

/** 设置游戏评分 */
- (void)setGameSource:(id)source {
    self.source = [NSString stringWithFormat:@"%@",source].floatValue;
}

/** 设置下载次数 */
- (void)setGameDownLoadNumber:(NSInteger)downLoad {
    if (downLoad > 10000) {
        self.downLoadNumber.text = [NSString stringWithFormat:@"%ld万+次下载",downLoad / 10000];
        [self.downLoadNumber sizeToFit];
    } else {
        self.downLoadNumber.text = [NSString stringWithFormat:@"%ld次下载",downLoad];
        [self.downLoadNumber sizeToFit];
    }
}

/** 设置游戏大小 */
- (void)setGameSize:(id)size {
    self.sizeLabel.text = [NSString stringWithFormat:@"%@M",size];
    [self.sizeLabel sizeToFit];
}

/** 设置 logo */
- (void)setGameLogoUrl:(NSString *)url {
    [self.gameLogo sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"image_downloading"]];
}

#pragma mark - getter
- (FFHomeViewSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFHomeViewSelectView alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 44) WithBtnArray:@[@"详情",@"评论",@"礼包",@"开服"]];
        _selectView.lineColor = [UIColor whiteColor];
        _selectView.delegate = self;
    }
    return _selectView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, kSCREEN_WIDTH, 1)];
        _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _lineView;
}

- (UIImageView *)gameLogo {
    if (!_gameLogo) {
        _gameLogo = [[UIImageView alloc]init];
        _gameLogo.bounds = CGRectMake(0, 0, 60, 60);
        _gameLogo.center = CGPointMake(50, 40);
        _gameLogo.backgroundColor = [UIColor whiteColor];

    }
    return _gameLogo;
}

- (UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        _gameNameLabel = [[UILabel alloc]init];
        _gameNameLabel.frame = CGRectMake((CGRectGetMaxX(self.gameLogo.frame) + 8), (CGRectGetMinY(self.gameLogo.frame)), kSCREEN_WIDTH * 0.3, 20);

        _gameNameLabel.font = [UIFont systemFontOfSize:16];
        _gameNameLabel.text = @"游戏名称";

    }
    return _gameNameLabel;
}

- (UILabel *)downLoadNumber {
    if (!_downLoadNumber) {
        _downLoadNumber = [[UILabel alloc]init];
        _downLoadNumber.frame = CGRectMake((CGRectGetMaxX(self.gameLogo.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), kSCREEN_WIDTH * 0.3, 20);
        _downLoadNumber.font = [UIFont systemFontOfSize:14];
        _downLoadNumber.textColor = [UIColor lightGrayColor];
        _downLoadNumber.text = @"200亿+ 下载";
    }
    return _downLoadNumber;
}

- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.bounds = CGRectMake(0, 0, 50, 30);
        _downLoadBtn.center = CGPointMake(kSCREEN_WIDTH - 50, 40);
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downLoadBtn setBackgroundColor:[UIColor orangeColor]];
    }
    return _downLoadBtn;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] init];
        _sizeLabel.frame = CGRectMake((CGRectGetMaxX(self.downLoadNumber.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), 50, 20);
        _sizeLabel.font = [UIFont systemFontOfSize:14];
        _sizeLabel.textColor = [UIColor lightGrayColor];
    }
    return _sizeLabel;
}

/** 设置评分星级数组 */
- (void)setStarsArray {
    _stars = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starView = [[UIImageView alloc] init];
        starView.frame = CGRectMake(CGRectGetMaxX(self.gameLogo.frame) + 8 + (i * 10), CGRectGetMaxY(self.gameNameLabel.frame) + 5, 10, 10);
        starView.image = [UIImage imageNamed:@"star_bright"];
        [_stars addObject:starView];
        [self addSubview:starView];
    }
}

/** 设置游戏类型标签 */
- (void)setTypeLabelsArray {
    _typeLabels = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {

        UILabel *label = [[UILabel alloc] init];


        label.font = [UIFont systemFontOfSize:12];
        label.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
        label.layer.borderWidth = 1;
        label.textColor = RGBCOLOR(197, 188, 100);
        label.text = @"";
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        [label sizeToFit];

        [_typeLabels addObject:label];
        [self addSubview:label];
    }
}

- (UILabel *)qqGroupLabel {
    if (!_qqGroupLabel) {
        _qqGroupLabel = [[UILabel alloc] init];
        _qqGroupLabel.textAlignment = NSTextAlignmentCenter;
        _qqGroupLabel.frame = CGRectMake((CGRectGetMaxX(self.sizeLabel.frame) + 8), (CGRectGetMaxY(self.gameNameLabel.frame) + 20), (kSCREEN_WIDTH - CGRectGetMaxX(self.sizeLabel.frame)  - 8), 20);
        _qqGroupLabel.font = [UIFont systemFontOfSize:14];
        _qqGroupLabel.text = @"玩家QQ群";
    }
    return _qqGroupLabel;
}

- (UIButton *)qqGroupBtn {
    if (!_qqGroupBtn) {
        _qqGroupBtn = [[UIButton alloc] init];
        _qqGroupBtn.bounds = CGRectMake(0, 0, 30, 30);
        _qqGroupBtn.center = CGPointMake(self.qqGroupLabel.center.x, 35);
        [_qqGroupBtn setImage:[UIImage imageNamed:@"detail_qqGroup"] forState:(UIControlStateNormal)];
        [_qqGroupBtn addTarget:self action:@selector(clickQQGroupBtn) forControlEvents:(UIControlEventTouchUpInside)];

        //        _qqGroupBtn.backgroundColor = [UIColor blackColor];

    }
    return _qqGroupBtn;
}





@end










