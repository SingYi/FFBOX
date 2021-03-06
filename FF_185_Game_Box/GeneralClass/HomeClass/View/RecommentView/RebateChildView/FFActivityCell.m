//
//  ActivityCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFActivityCell.h"

@interface FFActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel *activityTitle;

@property (weak, nonatomic) IBOutlet UILabel *activityContent;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FFActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.activityTitle.numberOfLines = 2;
    
    
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.activityTitle.text = _dict[@"title"];
    self.activityContent.text = _dict[@"abstract"];
    self.timeLabel.text = _dict[@"release_time"];


    [self.timeLabel sizeToFit];
}




@end










