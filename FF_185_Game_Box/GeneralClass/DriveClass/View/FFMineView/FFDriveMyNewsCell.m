//
//  FFDriveMyNewsCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/6.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveMyNewsCell.h"
#import "UIImageView+WebCache.h"

#define CELL_STRING NSString *string = [NSString stringWithFormat:@"%@",str]
#define APPENDSTRING(string) [_beginningString stringByAppendingString:string]
#define CELL_DICT(key) dict[APPENDSTRING(key)]
#define CELL_SET_METHOD(name) - (void)setnameWith:(NSString *)str

@interface FFDriveMyNewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dynamicImageView;
@property (weak, nonatomic) IBOutlet UILabel *dynamicNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicContentLabel;



@end

@implementation FFDriveMyNewsCell {
    NSString *_beginningString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.width / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.iconImageView.layer.borderWidth = 2;
}



#pragma mark - setter
- (void)setType:(NSUInteger)type {
    switch (type) {
        case 1:_beginningString = @"c_";
            break;
        case 2:_beginningString = @"cl_";
            break;
        case 3:_beginningString = @"dl_";
            break;
        default:_beginningString = @"c_";
            break;
    }

}
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    syLog(@" === %@",dict);

    //iconImage
    [self setIconImageWith:CELL_DICT(@"uid_iconurl")];
    //nickname
    [self setNickNameWith:CELL_DICT(@"uid_nickname")];
    //time
    [self setTimeWith:_dict[@"create_time"]];
}

/** 设置发起人头像 */
- (void)setIconImageWith:(NSString *)str {
    CELL_STRING;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:nil];
}

/** 设置发起人昵称 */
- (void)setNickNameWith:(NSString *)str {
    CELL_STRING;
    self.nickNameLabel.text = string;
}

- (void)setTimeWith:(NSString *)str  {
    CELL_STRING;
    self.timeLabel.text = string;
}







@end
