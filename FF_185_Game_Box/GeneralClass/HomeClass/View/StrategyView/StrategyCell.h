//
//  StrategyCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/14.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrategyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *strategyName;

@property (weak, nonatomic) IBOutlet UILabel *strategyAuthor;

@property (weak, nonatomic) IBOutlet UILabel *strategyTime;

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

@property (nonatomic, strong) NSDictionary *dict;

@end
