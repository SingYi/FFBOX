//
//  FFDrivePersonalHeader.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/30.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDrivePersonalHeader.h"
#import "SYKeychain.h"

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

@property (nonatomic, strong) UIBarButtonItem *editButton;


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
}

#pragma mark - responds
- (void)respondsToEditButton {

}

- (void)hideNickName:(BOOL)hide {
    self.nickNameLabel.hidden = hide;
}



#pragma mark - setter


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;

    NSDictionary *dynamics = dict[@"dynamics"];
    NSDictionary *user = dict[@"user"];
    if (dynamics == nil && user == nil) {
        dynamics = dict;
        user = nil;
    }
    // nick name
    [self setNickName:user[@"nick_name"]];
    // sex
    [self setSexWith:user[@"sex"]];
    // vip
    [self setVipWith:user[@"vip"]];
}

- (void)setIconImage:(UIImage *)iconImage {
    self.iconImageView.image = iconImage;
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
        } else {
            self.sexImage.tintColor = [UIColor redColor];
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Female"];
        }
    } else {
        self.sexImage.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && str!= nil && str.boolValue) {
        self.vipImage.hidden = NO;
    } else {
        self.vipImage.hidden = YES;
    }
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
    }
    return _vipImage;
}

- (UIBarButtonItem *)editButton {
    if (!_editButton) {
        _editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToEditButton)];
    }
    return _editButton;
}



@end









