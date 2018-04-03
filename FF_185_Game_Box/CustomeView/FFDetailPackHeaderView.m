//
//  FFDetailPackHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/4/3.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailPackHeaderView.h"
#import "FFDetailPackageModel.h"
#import "UIImageView+WebCache.h"


@interface FFDetailPackHeaderView ()

@property (nonatomic, assign) CGRect currentFrame;

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation FFDetailPackHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentFrame = frame;
        [self initUserInterface];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.logoImageView];

}

- (void)refreshView {
    [self setLogoImageViewWithUrl:[FFDetailPackageModel sharedModel].logo];
}

- (void)setLogoImageViewWithUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]];
    [self.logoImageView sd_setImageWithURL:url];
}

#pragma mark - getter
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _logoImageView.layer.cornerRadius = 6;
        _logoImageView.layer.masksToBounds = YES;
    }
    return _logoImageView;
}












@end
