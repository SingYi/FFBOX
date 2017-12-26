//
//  GDCommentTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/5/4.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFGameCommentCell : UITableViewCell

/** 用户昵称 */
@property (nonatomic, strong) NSString *userNick;

/** 内容 */
@property (nonatomic, strong) NSString *contentStr;

/** 评论时间 */
@property (nonatomic, strong) NSString *time;

@end
