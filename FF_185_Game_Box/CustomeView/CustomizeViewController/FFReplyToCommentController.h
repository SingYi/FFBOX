//
//  FFReplyToCommentController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReplyCommentBlock)(NSDictionary *content, BOOL success);

@interface FFReplyToCommentController : UIViewController

@property (nonatomic, strong) NSDictionary *commentDict;
@property (nonatomic, strong) ReplyCommentBlock completion;

+ (instancetype)replyCommentWithCommentDict:(NSDictionary *)dict Completion:(ReplyCommentBlock)completion;

@end
