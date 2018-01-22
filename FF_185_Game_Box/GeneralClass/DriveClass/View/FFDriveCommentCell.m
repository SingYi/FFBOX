//
//  FFDriveCommentCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/22.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveCommentCell.h"
#import "UIImageView+WebCache.h"

@interface FFDriveCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;

@property (weak, nonatomic) IBOutlet UILabel *replayLabel;

@property (weak, nonatomic) IBOutlet UILabel *toUserNickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FFDriveCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 20;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = [UIColor orangeColor].CGColor;
    self.iconImage.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    if (dict == nil) {
        return;
    }
    _dict = dict;
    [self setIconImageWith:dict[@"uid_iconurl"]];
    [self setNickNameWith:dict[@"uid_nickname"]];
    [self setToUidWith:dict[@"to_uid"]];
}

- (void)setIconImageWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
}

- (void)setNickNameWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.nickNameLabel.text = string;
}

- (void)setToUidWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.integerValue == 0) {
        self.replayLabel.hidden = YES;
        self.toUserNickNameLabel.hidden = YES;
    } else {
        self.replayLabel.hidden = NO;
        self.toUserNickNameLabel.hidden = NO;
    }
}

- (void)setToUserNickNameWith:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    self.toUserNickNameLabel.text = string;
}






@end
