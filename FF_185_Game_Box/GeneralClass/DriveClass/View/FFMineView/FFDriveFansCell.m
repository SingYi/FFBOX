//
//  FFDriveFansCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/31.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveFansCell.h"
#import "UIImageView+WebCache.h"

@interface FFDriveFansCell()


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexImage;

@property (weak, nonatomic) IBOutlet UIImageView *vipImage;


@end

@implementation FFDriveFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = self.iconImage.bounds.size.width / 2;
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.iconImage.layer.borderWidth = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    //icon
    [self setIcon:dict[@"icon_url"]];
    //nick name
    [self setNickName:dict[@"nickname"]];
    //vip
    [self setVip:dict[@"vip"]];
    //sex
    [self setSex:dict[@"sex"]];
    //numbers
    [self setNumbers:dict[@"fans_counts"]];
}

- (void)setIcon:(NSString *)str {
    NSString *url = [NSString stringWithFormat:@"%@",str];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)setNickName:(NSString *)str {
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@",str];
}

- (void)setVip:(NSString *)str {
    NSString *string = [NSString stringWithFormat:@"%@",str];
    if (string.integerValue == 1) {
        self.vipImage.hidden = NO;
    } else {
        self.vipImage.hidden = YES;
    }
}

- (void)setSex:(NSString *)str {
    if ([str isKindOfClass:[NSString class]]) {
        self.sexImage.hidden = NO;
        if (str.integerValue == 1) {
            self.sexImage.tintColor = [UIColor blueColor];
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Male"];
        } else {
            self.sexImage.tintColor = [UIColor redColor];
            self.sexImage.image = [UIImage imageNamed:@"Community_Sex_Female"];
        }
    } else {
        self.sexImage.hidden = YES;
    }
}

- (void)setNumbers:(NSString *)str {
    self.numbersLabel.text = [NSString stringWithFormat:@"粉丝数(%@)",str];
}



@end













