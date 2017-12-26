//
//  GDCommentTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/4.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFGameCommentCell.h"

@interface FFGameCommentCell ()


@property (weak, nonatomic) IBOutlet UILabel *userID;



@property (weak, nonatomic) IBOutlet UILabel *content;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation FFGameCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUserNick:(NSString *)userNick {
    _userNick = userNick;
    _userID.text = _userNick;
    [_userID sizeToFit];
}

- (void)setContentStr:(NSString *)contentStr {
    _content.text = contentStr;
    _content.numberOfLines = 0;
    [_content sizeToFit];
}

- (void)setTime:(NSString *)time {
    _timeLabel.text = time;
    [_timeLabel sizeToFit];
}










@end
