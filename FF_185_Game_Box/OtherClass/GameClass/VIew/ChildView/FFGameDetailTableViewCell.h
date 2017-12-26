//
//  GameDetailTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/28.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFGameDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (nonatomic, assign) BOOL isOpen;

@end
