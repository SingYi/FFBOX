//
//  SearchCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFNewCustomizeCell.h"

@interface FFNewCustomizeCell ()

/** 游戏名称 */
@property (weak, nonatomic) IBOutlet UILabel *gameName;
/** 下载次数 */
@property (weak, nonatomic) IBOutlet UILabel *gameNumber;
/** 下载游戏 */
@property (weak, nonatomic) IBOutlet UIButton *gameDownload;
/** 游戏大小 */
@property (weak, nonatomic) IBOutlet UILabel *gameSize;
/** 标签1 */
@property (weak, nonatomic) IBOutlet UILabel *label1;
/** 标签2 */
@property (weak, nonatomic) IBOutlet UILabel *label2;
/** 标签3 */
@property (weak, nonatomic) IBOutlet UILabel *label3;

/** 星级数组 */
@property (nonatomic, strong) NSArray<UIImageView *> *stars;

@property (weak, nonatomic) IBOutlet UIImageView *star1;

@property (weak, nonatomic) IBOutlet UIImageView *star2;

@property (weak, nonatomic) IBOutlet UIImageView *star3;

@property (weak, nonatomic) IBOutlet UIImageView *star4;

@property (weak, nonatomic) IBOutlet UIImageView *star5;


//约束布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rigthLayout;

@end

@implementation FFNewCustomizeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _stars = @[self.star1,self.star2,self.star3,self.star4,self.star5];
    
    self.gameNumber.font = [UIFont systemFontOfSize:14];
    self.gameNumber.textColor = [UIColor lightGrayColor];
    
    self.label1.font = [UIFont systemFontOfSize:12];
    self.label1.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label1.layer.borderWidth = 1;
    self.label1.textColor = RGBCOLOR(197, 188, 100);
    self.label1.text = @"";
    self.label1.layer.cornerRadius = 3;
    self.label1.layer.masksToBounds = YES;
    [self.label1 sizeToFit];
    
    self.label2.font = [UIFont systemFontOfSize:12];
    self.label2.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label2.layer.borderWidth = 1;
    self.label2.textColor = RGBCOLOR(197, 188, 100);
    self.label2.text = @"";
    self.label2.layer.cornerRadius = 3;
    self.label2.layer.masksToBounds = YES;
    [self.label2 sizeToFit];
    
    self.label3.font = [UIFont systemFontOfSize:12];
    self.label3.layer.borderColor = RGBCOLOR(197, 188, 100).CGColor;
    self.label3.layer.borderWidth = 1;
    self.label3.textColor = RGBCOLOR(197, 188, 100);
    self.label3.text = @"";
    self.label3.layer.cornerRadius = 3;
    self.label3.layer.masksToBounds = YES;
    [self.label3 sizeToFit];

    
    self.gameSize.font = [UIFont systemFontOfSize:14];
    self.gameSize.textColor = [UIColor lightGrayColor];
    
    [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"downLoadButton"] forState:(UIControlStateNormal)];
    self.gameDownload.layer.cornerRadius = 4;
    self.gameDownload.layer.masksToBounds = YES;
    
    //414  375  320
    if (kSCREEN_WIDTH == 320) {
        _lefLayout.constant = 8;
        _rigthLayout.constant = 8;
        self.gameName.font = [UIFont systemFontOfSize:13];
        [self.gameName sizeToFit];
    } else if (kSCREEN_WIDTH == 375) {
        _lefLayout.constant = 20;
        _rigthLayout.constant = 20;
        self.gameName.font = [UIFont systemFontOfSize:14];
        [self.gameName sizeToFit];
    } else if (kSCREEN_WIDTH == 414) {
        _lefLayout.constant = 30;
        _rigthLayout.constant = 30;
        self.gameName.font = [UIFont systemFontOfSize:16];
        [self.gameName sizeToFit];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //设置名称
    self.gameName.text = _dict[@"gamename"];
    
    //下载次数
    NSInteger dlNumber = ((NSString *)_dict[@"download"]).integerValue;
    if (dlNumber > 10000) {
        dlNumber = dlNumber / 10000;
        self.gameNumber.text = [NSString stringWithFormat:@"%ld万+次下载",dlNumber];
    } else {
        self.gameNumber.text = [NSString stringWithFormat:@"%ld次下载",dlNumber];
    }
    
    //标签
    NSString *type = _dict[@"types"];
    NSArray *types = [type componentsSeparatedByString:@" "];
    NSInteger i = 0;
    NSArray<UILabel *> *labels = @[self.label1,self.label2,self.label3];
    for (; i < types.count; i ++) {
        labels[i].text = [NSString stringWithFormat:@" %@ ",types[i]];
    }

    //游戏大小
    self.gameSize.text = [NSString stringWithFormat:@"%@M",_dict[@"size"]];
    
    //评分

    CGFloat sorce = ((NSString *)_dict[@"score"]).floatValue;
    if (sorce <= 5.f && sorce >= 0) {
        self.source = ((NSString *)_dict[@"score"]).floatValue;
    } else {
        self.source = 5.f;
    }
    
    
    NSString *islocal = dict[@"isLocal"];
    if ([islocal isEqualToString:@"1"]) {
        [self.gameDownload setTitle:@"打开" forState:(UIControlStateNormal)];
        [self.gameDownload setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"downLoadButton"] forState:(UIControlStateNormal)];
    } else {
        [self.gameDownload setTitle:@"下载" forState:(UIControlStateNormal)];
        [self.gameDownload setTitleColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        [self.gameDownload setBackgroundImage:[UIImage imageNamed:@"button_circle"] forState:(UIControlStateNormal)];
    }
//    syLog(@"%@",_dict);
}

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


- (IBAction)downLoad:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFCustomizeCell:didSelectCellRowAtIndexPathWith:)]) {
        [self.delegate FFCustomizeCell:self didSelectCellRowAtIndexPathWith:self.dict];
    }
}







@end
