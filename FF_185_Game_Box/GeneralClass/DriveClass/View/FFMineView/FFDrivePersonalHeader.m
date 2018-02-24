//
//  FFDrivePersonalHeader.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDrivePersonalHeader.h"
#import "SYKeychain.h"
#import "UIImageView+WebCache.h"

@interface FFDrivePersonalHeader ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

// icon
@property (nonatomic, strong) UIImageView *iconImageView;
// nick name label
@property (nonatomic, strong) UILabel *nickNameLabel;
// nick name
@property (nonatomic, strong) NSString *nickName;
// sex image
@property (nonatomic, strong) UIImageView *sexImage;
// vip image
@property (nonatomic, strong) UIImageView *vipImage;

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *driverLevelLabel;

@end



@implementation FFDrivePersonalHeader {
    NSString *iconUrl;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.62);
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.iconImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.sexImage];
    [self addSubview:self.vipImage];
    [self addSubview:self.driverLevelLabel];
    [self addSubview:self.descriptionLabel];
}

- (void)hideNickName:(BOOL)hide {
    self.nickNameLabel.hidden = hide;
}

#pragma mark - setter
- (void)setModel:(FFDynamicModel *)model {
    _model = model;
    
    syLog(@"mine center model == model");
    // nick name
    [self setNickName:model.present_user_nickName];
    // sex
    [self setSexWith:model.present_user_sex];
    // vip
    [self setVipWith:model.present_user_vip];
    //image
    [self setImageUrl:model.present_user_iconImageUrlString];
    //
    [self setDriverLevelWith:model.present_user_driver_level];
    [self setDescriptionWith:model.present_user_desc];
}


- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
}

- (void)setImageUrl:(NSString *)imageurl {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
}

- (void)setNickName:(NSString *)nickName {
    NSString *string = [NSString stringWithFormat:@" %@ ",nickName];
    _nickName = string;
    self.nickNameLabel.text = string;
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.hidden = NO;
    self.nickNameLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.iconImageView.frame) + self.nickNameLabel.bounds.size.height / 2 + 8);

    self.sexImage.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 10, self.nickNameLabel.center.y);
    self.vipImage.center = CGPointMake(CGRectGetMaxX(self.sexImage.frame) + 10, self.nickNameLabel.center.y);
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexImage.hidden = NO;
        if (str.integerValue == 1) {
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Male"];
            self.sexImage.tintColor = [UIColor blueColor];
        } else if (str.integerValue == 2) {
            self.sexImage.tintColor = [UIColor redColor];
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Female"];
        } else {
            self.sexImage.hidden = YES;
        }
    } else {
        self.sexImage.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.boolValue) {
        self.vipImage.hidden = NO;
    } else {
        self.vipImage.hidden = YES;
    }
}

- (void)setDriverLevelWith:(NSString *)str {
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.driverLevelLabel.hidden = (string.length > 0) ? NO : YES;
    self.driverLevelLabel.text = [NSString stringWithFormat:@"老司机指数 :%@颗星",string];
    [self.driverLevelLabel sizeToFit];
    self.driverLevelLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.nickNameLabel.frame) + self.nickNameLabel.frame.size.height);
}

- (void)setDescriptionWith:(NSString *)str {
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.descriptionLabel.hidden = (string.length > 0) ? NO : YES;
    self.descriptionLabel.text = [NSString stringWithFormat:@"简介 : %@ ",string];
    self.descriptionLabel.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 30);
    self.descriptionLabel.center = CGPointMake(kSCREEN_WIDTH / 2, CGRectGetMaxY(self.driverLevelLabel.frame) + self.driverLevelLabel.frame.size.height);
}

#pragma mark - getter
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.62 + 200)];
        _backgroundImageView.image = [UIImage imageNamed:@"New_mine_header"];
    }
    return _backgroundImageView;
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 5, kSCREEN_WIDTH / 5)];
        _iconImageView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.2);
        _iconImageView.layer.cornerRadius = kSCREEN_WIDTH / 10;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 3;
    }
    return _iconImageView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.hidden = YES;
    }
    return _nickNameLabel;
}

- (UIImageView *)sexImage {
    if (!_sexImage) {
        _sexImage = [[UIImageView alloc] init];
        _sexImage.bounds = CGRectMake(0, 0, 15, 15) ;

    }
    return _sexImage;
}

- (UIImageView *)vipImage {
    if (!_vipImage) {
        _vipImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _vipImage.image = [UIImage imageNamed:@"Community_Vip"];
        _vipImage.hidden = YES;
    }
    return _vipImage;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont boldSystemFontOfSize:16];
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        _descriptionLabel.hidden = YES;
    }
    return _descriptionLabel;
}

- (UILabel *)driverLevelLabel {
    if (!_driverLevelLabel) {
        _driverLevelLabel = [[UILabel alloc] init];
        _driverLevelLabel.font = [UIFont boldSystemFontOfSize:16];
        _driverLevelLabel.textColor = [UIColor whiteColor];
        _driverLevelLabel.hidden = YES;
    }
    return _driverLevelLabel;
}


@end









