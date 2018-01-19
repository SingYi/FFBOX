//
//  FFDetailHeaderView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/19.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "XLPhotoBrowser.h"

@interface FFDetailHeaderView() <XLPhotoBrowserDelegate>

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *sexView;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *imageContentView;
@property (nonatomic, strong) UIView *grayLayer;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end

@implementation FFDetailHeaderView {
    CGFloat imageviewWidth;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    [self addSubview:self.iconView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.sexView];
    [self addSubview:self.vipView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.imageContentView];
}



#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {

    if (dict) {
        _dict = dict;
    } else {
        return;
    }


    //icon
    [self setIconImageWith:dict[@"user"][@"icon_url"]];
    //nick name
    [self setNickNameWith:dict[@"user"][@"nick_name"]];
    //sex
    [self setSexWith:dict[@"user"][@"sex"]];
    //sex
    [self setVipWith:dict[@"user"][@"sex"]];
    //time label
    [self setTimeWith:dict[@"dynamics"][@"create_time"]];
    //content
    [self setcontentWith:dict[@"dynamics"][@"content"]];
    //images
    id array = dict[@"dynamics"][@"imgs"];
    if (array == nil || ![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }
    [self setImagesWith:array];

}

- (void)setIconImageWith:(NSString *)url {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
}

- (void)setNickNameWith:(NSString *)Str {
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",Str];
    [self.nickNameLabel sizeToFit];
    self.nickNameLabel.center = CGPointMake(self.nickNameLabel.center.x, 25);
    self.sexView.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 15, 25);
    self.vipView.center = CGPointMake(CGRectGetMaxX(self.sexView.frame), 25);
}

- (void)setSexWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]] && str!= nil && str.boolValue) {
        self.vipView.hidden = NO;
    } else {
        self.vipView.hidden = YES;
    }
}

- (void)setVipWith:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexView.hidden = NO;
        if (str.integerValue == 1) {
            self.sexView.image = [UIImage imageNamed:@"Community_Sex_Male"];
        } else {
            self.sexView.image = [UIImage imageNamed:@"Community_Sex_Female"];
        }
    } else {
        self.sexView.hidden = YES;
    }
}

- (void)setTimeWith:(NSString *)str {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:str.integerValue];
    NSString *timeString = [formatter stringFromDate:date];
    self.timeLabel.text  = timeString;
    [self.timeLabel sizeToFit];
}

- (void)setcontentWith:(NSString *)content {
    self.contentLabel.frame = CGRectMake(10, 80, kSCREEN_WIDTH - 20, 40);
    self.contentLabel.text = [NSString stringWithFormat:@"%@",content];
    [self.contentLabel sizeToFit];

    self.imageContentView.frame = CGRectMake(10, CGRectGetMaxY(self.contentLabel.frame) + 10, kSCREEN_WIDTH - 20, 30);
}

- (void)setImagesWith:(NSArray *)images {
    CGFloat imageContentHeight;
    syLog(@"images === %@",images);
    if (images != nil && images.count != 0) {
        switch (images.count) {
            case 1: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 2: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 3: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth;
                break;
            }
            case 4: {
                imageviewWidth = (kSCREEN_WIDTH - 10) / 3 - 5;
                imageContentHeight = imageviewWidth * 2 + 5;
                break;
            }

            default: {
                //                imageviewWidth = imageContentViewWidth / 2 - 5;
                imageContentHeight = 2;
            }
                break;
        }
    } else {
        imageContentHeight = 2;
    }
    [self setImageViewWith:images];

    CGRect frame = self.imageContentView.frame;
    frame.size.height = imageContentHeight;
    self.imageContentView.frame = frame;

    self.frame = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.imageContentView.frame) + 20);
    self.grayLayer.frame = CGRectMake(0, self.frame.size.height - 10, kSCREEN_WIDTH, 20);
    [self addSubview:self.grayLayer];
}

- (void)setImageViewWith:(NSArray *)images {
    if (_imageViews != nil) {
        for (UIImageView *view in _imageViews) {
            [view removeFromSuperview];
        }
    }

    _imageViews = [NSMutableArray arrayWithCapacity:images.count];
    _images = [NSMutableArray arrayWithCapacity:images.count];
    if (images.count > 0) {
        [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = idx + 10086;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];

            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage new] options:(SDWebImageHighPriority) completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {

                if (image != nil) {
                    [_images addObject:image];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                        [[[SDWebImageManager sharedManager] imageCache]storeImage:image forKey:obj completion:nil];

                    });
                }

            }];

            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            CGFloat y = 0;
            CGFloat x = 2.5 + (imageviewWidth + 5) * idx;
            if (images.count == 4 && idx < 2) {
                y = 0;
                x = 2.5 + (imageviewWidth + 5) * idx;
            } else if (images.count == 4 && idx >= 2) {
                y = imageviewWidth + 5;
                x = 2.5 + (imageviewWidth + 5) * (idx - 2);
            } else {

            }

            imageView.frame = CGRectMake(x, y, imageviewWidth, imageviewWidth);
            [_imageViews addObject:imageView];
            [self.imageContentView addSubview:imageView];
        }];
    }


}


- (void)clickImage:(UITapGestureRecognizer *)sender {
    syLog(@"点击图片");

    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:self.images currentImageIndex:sender.view.tag - 10086];
    browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式

    // 设置长按手势弹出的地步ActionSheet数据,不实现此方法则没有长按手势
//    [browser setActionSheetWithTitle:@"这是一个类似微信/微博的图片浏览器组件" delegate:self cancelButtonTitle:nil deleteButtonTitle:@"删除" otherButtonTitles:@"发送给朋友",@"保存图片",@"收藏",@"投诉",nil];

}

#pragma mark - getter
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(10, 10, 60, 60);
        _iconView.layer.cornerRadius = 30;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.borderColor = [UIColor orangeColor].CGColor;
        _iconView.layer.borderWidth = 4;
    }
    return _iconView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 30, 30)];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.textColor = [UIColor blackColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nickNameLabel;
}

- (UIImageView *)sexView {
    if (!_sexView) {
        _sexView = [[UIImageView alloc] init];
        _sexView.bounds = CGRectMake(0, 0, 15, 15);
        _sexView.center = CGPointMake(CGRectGetMaxX(self.nickNameLabel.frame) + 15, CGRectGetMidY(self.nickNameLabel.frame));
    }
    return _sexView;
}

- (UIImageView *)vipView {
    if (!_vipView) {
        _vipView = [[UIImageView alloc] init];
        _vipView.bounds = CGRectMake(0, 0, 15, 15);
        _vipView.center = CGPointMake(CGRectGetMaxX(self.sexView.frame) + 15, self.sexView.center.y);
    }
    return _vipView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 20, 20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kSCREEN_WIDTH - 20, 40)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:17];
    }
    return _contentLabel;
}

- (UIView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [[UIView alloc] init];
    }
    return _imageContentView;
}

- (UIView *)grayLayer {
    if (!_grayLayer) {
        _grayLayer = [[UIView alloc] init];
        _grayLayer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _grayLayer.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 20);
    }
    return _grayLayer;
}




@end











