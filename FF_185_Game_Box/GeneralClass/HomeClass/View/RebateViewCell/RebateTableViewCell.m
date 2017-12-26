//
//  RebateTableViewCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "RebateTableViewCell.h"

@interface RebateTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *serverName;

@property (weak, nonatomic) IBOutlet UILabel *roleName;

@property (weak, nonatomic) IBOutlet UILabel *amount;


@end


@implementation RebateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.gameName.text = dict[@"gamename"];
    self.serverName.text = dict[@"servername"];
    self.roleName.text = dict[@"rolename"];
    self.amount.text = [NSString stringWithFormat:@"%@",dict[@"game_coin"]];
}





@end














