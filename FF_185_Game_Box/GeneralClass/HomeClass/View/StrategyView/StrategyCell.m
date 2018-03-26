//
//  StrategyCell.m
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "StrategyCell.h"

@implementation StrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.strategyName.text = dict[@"title"];
    self.gameName.text = dict[@"author"];
    self.strategyTime.text = dict[@"release_time"];
    self.strategyAuthor.text = dict[@"gamename"];
    
}


@end







