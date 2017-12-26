//
//  GameDetailTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/28.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFGameDetailTableViewCell.h"

@implementation FFGameDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detail.textAlignment = NSTextAlignmentLeft;
    self.detail.numberOfLines = 0;
    self.detail.font = [UIFont systemFontOfSize:14];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
