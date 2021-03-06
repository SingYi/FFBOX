//
//  UIAlertController+FFAlertController.h
//  FFViewFactory
//
//  Created by 燚 on 2018/1/17.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBackBlock)(NSInteger btnIndex);
typedef void(^dismissBlock)(void);

@interface UIAlertController (FFAlertController)



/**
 * @param viewController       presrent view controller
 * @param alertControllerStyle UIAlertControllerStyle
 * @param title                title
 * @param message              message
 * @param block                call back block
 * @param cancelBtnTitle       cancel button title
 * @param destructiveBtnTitle  destructivew button title
 * @param otherBtnTitles       other button title
 */
+ (UIAlertController *)showAlertControllerWithViewController:(UIViewController*)viewController
                                        alertControllerStyle:(UIAlertControllerStyle)alertControllerStyle
                                                       title:(NSString*)title
                                                     message:(NSString*)message
                                           cancelButtonTitle:(NSString *)cancelBtnTitle
                                      destructiveButtonTitle:(NSString *)destructiveBtnTitle
                                               CallBackBlock:(CallBackBlock)block
                                           otherButtonTitles:(NSString *)otherBtnTitles,...NS_REQUIRES_NIL_TERMINATION;

/**
 * simple show alert
 * @param   title   title
 * @param   message message
 * @param   second  if second is greater than zero , do not deal with alertControler
 */
+ (void)showAlertWithTitle:(NSString *)title
                   Message:(NSString *)message
               dismissTime:(CGFloat)second
              dismissBlock:(dismissBlock)block;


+ (void)showAlertMessage:(NSString *)message
             dismissTime:(CGFloat)second
            dismissBlock:(dismissBlock)block;




@end
