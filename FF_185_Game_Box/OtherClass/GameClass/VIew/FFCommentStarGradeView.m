//
//  CommentStarGradeView.m
//  GameBox
//
//  Created by 石燚 on 2017/5/17.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "FFCommentStarGradeView.h"

#define BTNTAG 10086

@interface FFCommentStarGradeView ()

/** 放星星的背景 */
@property (nonatomic, strong) UIView *starBtnBackground;

/** 选中的下标 */
@property (nonatomic, assign) NSInteger index;


@end

@implementation FFCommentStarGradeView





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _starBtnBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20 * 5, 20)];
        
        for (int i = 0; i < 5; i++) {
            UIImageView *starImage = [[UIImageView alloc] init];
            starImage.frame = CGRectMake(30 * i, 0, 20, 20);
            starImage.image = [UIImage imageNamed:@"star_bright"];
            
            starImage.tag = BTNTAG + i;
            
            [_starBtnBackground addSubview:starImage];
        }
        _starGrade = 5.0;
        [self addSubview:_starBtnBackground];
    }
    return self;
}

/** 点击 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [self getTouchPoint:touches];
    
    
    CGFloat sorce = point.x / 30.0;
    
    CGFloat result = 0;

    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImage = [_starBtnBackground viewWithTag:BTNTAG + i];
        if (sorce <= 0) {
            result += 0;
            starImage.image = [UIImage imageNamed:@"star_dark"];
        } else if (sorce > 0 && sorce < 0.5) {
            result += 0.5;
            starImage.image = [UIImage imageNamed:@"star_half"];
        } else if (sorce >= 0.5) {
            result += 1;
            starImage.image = [UIImage imageNamed:@"star_bright"];
        }
        sorce--;
    }
    _starGrade = result;
    
    if (self.starDelegate && [self.starDelegate respondsToSelector:@selector(numberOfSorce:)]) {
        [self.starDelegate numberOfSorce:_starGrade];
    }
}

//滑动需要的。
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [self getTouchPoint:touches];
    
    CGFloat sorce = point.x / 30.0;

    CGFloat result = 0;
    
    for (NSInteger i = 0; i < 5; i++) {
        UIImageView *starImage = [_starBtnBackground viewWithTag:BTNTAG + i];
        if (sorce <= 0) {
            result += 0;
            starImage.image = [UIImage imageNamed:@"star_dark"];
        } else if (sorce > 0 && sorce < 0.5) {
            result += 0.5;
            starImage.image = [UIImage imageNamed:@"star_half"];
        } else if (sorce >= 0.5) {
            result += 1;
            starImage.image = [UIImage imageNamed:@"star_bright"];
        }
        sorce--;
    }
    _starGrade = result;
    
    if (self.starDelegate && [self.starDelegate respondsToSelector:@selector(numberOfSorce:)]) {
        [self.starDelegate numberOfSorce:_starGrade];
    }
}

- (void)setStarGrade:(CGFloat)starGrade {
    _starGrade = 5;
    for (NSInteger i = 0; i < 5; i++) {
        
        UIImageView *starImage = [_starBtnBackground viewWithTag:BTNTAG + i];

        starImage.image = [UIImage imageNamed:@"star_bright"];
    }
}

//滑动需要的。
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.starDelegate && [self.starDelegate respondsToSelector:@selector(numberOfSorce:)]) {
        [self.starDelegate numberOfSorce:_starGrade];
    }
    
}

//取到 手势 在屏幕上点的 位置point
- (CGPoint)getTouchPoint:(NSSet<UITouch *>*)touches{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:_starBtnBackground];
    return point;
    
}


@end
