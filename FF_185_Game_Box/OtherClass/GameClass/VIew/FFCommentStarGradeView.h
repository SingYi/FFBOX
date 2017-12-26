//
//  CommentStarGradeView.h
//  GameBox
//
//  Created by 石燚 on 2017/5/17.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FFCommentStarGradeViewDelegate <NSObject>

- (void)numberOfSorce:(CGFloat)Sorce;

@end

@interface FFCommentStarGradeView : UIView

@property (nonatomic, weak) id<FFCommentStarGradeViewDelegate> starDelegate;

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, assign) CGFloat starGrade;

@end
