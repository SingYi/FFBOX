//
//  FFTodayInviteListViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFInviteModel.h"

typedef enum : NSUInteger {
    today = 0,
    yesterday,
} FFinviteListModel;

@interface FFTodayInviteListViewController : FFBasicViewController


@property (nonatomic, assign) FFinviteListModel inviteListModel;


@end
