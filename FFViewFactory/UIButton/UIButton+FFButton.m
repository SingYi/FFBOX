//
//  UIButton+FFButton.m
//  FFViewFactory
//
//  Created by 燚 on 2018/1/16.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "UIButton+FFButton.h"
#import <objc/runtime.h>

@implementation UIButton (FFButton)

static NSString *keyOfUseCategoryMethod;//用分类方法创建的button，关联对象的key
static NSString *keyOfBlock;

#pragma mark - creat button
+ (instancetype)createButton {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    return button;
}

+ (instancetype)createButtonWithAction:(tapActionBlock)actionBlock {
    UIButton *button = [UIButton createButton];
    [button addTarget:button action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    /**
     *用runtime中的函数通过key关联对象
     *
     *objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     *id object                     表示关联者，是一个对象，变量名理所当然也是object
     *const void *key               获取被关联者的索引key
     *id value                      被关联者，这里是一个block
     *objc_AssociationPolicy policy 关联时采用的协议，有assign，retain，copy等协议，一般使用OBJC_ASSOCIATION_RETAIN_NONATOMIC
     */
    objc_setAssociatedObject (button , &keyOfUseCategoryMethod , actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );

    return button;
}

+ (instancetype)createButtonFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName action:(tapActionBlock)actionBlock {

    UIButton *button = [UIButton createButtonWithAction:actionBlock];
    button.frame = frame;
    [button setNormalTitle:title image:[UIImage imageNamed:imageName]];

    return button;
}

+ (instancetype)createButtonBounds:(CGRect)bounds center:(CGPoint)center title:(NSString *)title imageName:(NSString *)imageName action:(tapActionBlock)actionBlock {

    UIButton *button = [UIButton createButtonWithAction:actionBlock];
    [button setBounds:bounds center:center];
    [button setNormalTitle:title image:[UIImage imageNamed:imageName]];

    return button;
}

- (void)tapAction:(UIButton*)sender {
    tapActionBlock block = (tapActionBlock)objc_getAssociatedObject(sender, &keyOfUseCategoryMethod);
    if (block) {
        block(sender);
    }
}


- (void)setActionBlock:(tapActionBlock)actionBlock {
    objc_setAssociatedObject (self , &keyOfBlock , actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC );
}

- (tapActionBlock)actionBlock {
    return objc_getAssociatedObject(self, &keyOfBlock);
}

- (void)layoutButtonWithImageStyle:(FFButtonImageStyle)style imageTitleSpace:(CGFloat)space {
    /**
     * titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     * 如果只有title，那它上下左右都是相对于button的，image也是一样；
     * 如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     它们只是image和button相较于原来位置的偏移量，那什么是原来的位置呢？就是没有设置edgeInset时候的位置了。
     如果要image在右边，label在左边，那image的左边相对于button的左边右移了labelWidth的距离，image的右边相对于label的左边右移了labelWidth的距离
     所以，self.oneButton.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);为什么是负值呢？因为这是contentInset，是偏移量，不是距离
     同样的，label的右边相对于button的右边左移了imageWith的距离，label的左边相对于image的右边左移了imageWith的距离
     所以self.oneButton.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
     */
    CGFloat imageWith = self.currentImage.size.width;
    CGFloat imageHeight = self.currentImage.size.height;
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;

    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;

    switch (style) {
        case FFButtonImageOnTop: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space / 2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - space / 2.0, 0);
            break;
        }

        case FFButtonImageOnLeft: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0);
            break;
        }


        case FFButtonImageOnBottom: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - space / 2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space / 2.0, -imageWith, 0, 0);
            break;
        }

        case FFButtonImageOnRight: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space / 2.0, 0, -labelWidth - space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space / 2.0, 0, imageWith + space / 2.0);
            break;
        }

        case FFBUttonImageLabelCenter: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, 0);
            break;
        }

        default:
            break;
    }
    [self setTitleEdgeInsets:labelEdgeInsets];
    [self setImageEdgeInsets:imageEdgeInsets];
}

/** set shadow */
- (void)setShadowWithOffset:(CGSize)shadowOffset
              shadowOpacity:(CGFloat)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
                      color:(UIColor *)shadowColor
                 shadowPath:(UIBezierPath* )shadowPath {

    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowRadius;
    if (shadowColor) {
        self.layer.shadowColor = shadowColor.CGColor;
    }
    if (shadowPath) {
        self.layer.shadowPath = shadowPath.CGPath;
    }

}

- (void)setNormalTitle:(NSString *)title image:(UIImage *)image {
    [self setNormalTitle:title HighlightedTitle:nil NormalImage:image HighlightedImage:nil NormalTitleColor:nil HighlightedTitleColor:nil];
}

- (void)setHighlightedTitle:(NSString *)title image:(UIImage *)image {
    [self setNormalTitle:nil HighlightedTitle:title NormalImage:nil HighlightedImage:image NormalTitleColor:nil HighlightedTitleColor:nil];
}

/** set others */
- (void)setNormalTitle:(NSString *)normalTitle
      HighlightedTitle:(NSString *)highlightedTitle
           NormalImage:(UIImage *)normalImage
      HighlightedImage:(UIImage *)highlightedImage
      NormalTitleColor:(UIColor *)normalTitleColor
 HighlightedTitleColor:(UIColor *)highlightedTitleColor {

    if (normalTitle) {
        [self setTitle:normalTitle forState:(UIControlStateNormal)];
    }
    if (highlightedTitle) {
        [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
    }
    if (normalImage) {
        [self setImage:normalImage forState:(UIControlStateNormal)];
    }
    if (highlightedImage) {
        [self setImage:highlightedImage forState:(UIControlStateHighlighted)];
    }
    if (normalTitleColor) {
        [self setTitleColor:normalTitleColor forState:(UIControlStateNormal)];
    }
    if (highlightedTitleColor) {
        [self setTitleColor:highlightedTitleColor forState:(UIControlStateHighlighted)];
    }

}

- (void)setBounds:(CGRect)bounds center:(CGPoint)center {
    self.bounds = bounds;
    self.center = center;
}


@end





