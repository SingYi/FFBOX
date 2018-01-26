//
//  FFMineViewCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/26.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMineViewCell : UITableViewCell

+ (void)registCellWithTableView:(UITableView *)tableView;
+ (instancetype)dequeueReusableCellWithIdentifierWithTableView:(UITableView *)tableView;





@end
