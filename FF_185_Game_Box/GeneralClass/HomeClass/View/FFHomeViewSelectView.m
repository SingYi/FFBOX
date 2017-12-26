//
//  FFCarouselView.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/1.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFHomeViewSelectView.h"

@implementation FFHomeViewSelectView


- (void)setIndex:(NSInteger)index {
    [super setIndex:index];
    [UIView animateWithDuration:0.3 animations:^{
        self.seleView.center = CGPointMake(self.buttons[index].center.x,self.seleView.center.y);
    }];
}



@end
