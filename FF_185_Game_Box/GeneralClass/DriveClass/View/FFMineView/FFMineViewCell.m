//
//  FFMineViewCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFMineViewCell.h"

#define CELL_IDE @"FFDriveMineCell"

@implementation FFMineViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark  ===============================================================
+ (void)registCellWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:CELL_IDE];
}

+ (instancetype)dequeueReusableCellWithIdentifierWithTableView:(UITableView *)tableView {
    FFMineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    return cell;
}









@end
