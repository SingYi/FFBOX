//
//  FFGameFooterView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFGameFooterView.h"
#import "FFBasicModel.h"

@interface FFGameFooterView ()

/**收藏按钮*/
@property (nonatomic, strong) UIButton *collectionBtn;

/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;

/**分享按钮*/
@property (nonatomic, strong) UIButton *shardBtn;


@end

@implementation FFGameFooterView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    self.backgroundColor = TABBARCOLOR;
    [self addSubview:self.collectionBtn];
    [self addSubview:self.downLoadBtn];

    if ([Channel isEqualToString:@"185"]) {
        [self addSubview:self.shardBtn];
    } else {
        [self.shardBtn removeFromSuperview];
    }
}

#pragma mark - respondToButton
- (void)clickCollectButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameFooterView:clickCollecBtn:)]) {
        [self.delegate FFGameFooterView:self clickCollecBtn:sender];
    }
}

- (void)clickShareButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameFooterView:clickShareBtn:)]) {
        [self.delegate FFGameFooterView:self clickShareBtn:sender];
    }
}

- (void)clickDownLoadButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameFooterView:clickDownLoadBtn:)]) {
        [self.delegate FFGameFooterView:self clickDownLoadBtn:sender];
    }
}

#pragma mark - setter
- (void)setIsCollection:(BOOL)isCollection {
    _isCollection = isCollection;
    if (_isCollection) {
        [self.collectionBtn setImage:[UIImage imageNamed:@"detail_collection"] forState:(UIControlStateNormal)];
    } else {
        [self.collectionBtn setImage:[UIImage imageNamed:@"detail_unCollection"] forState:(UIControlStateNormal)];
    }
}

//- (void)setIsOpen:(BOOL)isOpen {
//    _isOpen = isOpen;
//    if (_isOpen) {
//        [self.downLoadBtn setTitle:@"打开" forState:(UIControlStateNormal)];
//    } else {
//        [self.downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
//    }
//}



#pragma mark - getter
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(0, 0, 50, 50);
        [_collectionBtn setImage:[UIImage imageNamed:@"detail_unCollection"] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(clickCollectButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectionBtn;
}


- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.frame = CGRectMake(60, 3, kSCREEN_WIDTH - 120, 44);
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"gameDetail_downLoad"] forState:(UIControlStateNormal)];
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        [_downLoadBtn addTarget:self action:@selector(clickDownLoadButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _downLoadBtn;
}

- (UIButton *)shardBtn {
    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shardBtn.frame = CGRectMake(kSCREEN_WIDTH - 50, 0, 50, 50);
        [_shardBtn setImage:[UIImage imageNamed:@"detail_shard"] forState:(UIControlStateNormal)];
        [_shardBtn addTarget:self action:@selector(clickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shardBtn;
}

@end
