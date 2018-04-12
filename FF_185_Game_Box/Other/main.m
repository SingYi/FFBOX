//
//  main.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FFAppDelegate.h"


int funcAdd(a,b,c,d,e,f)
{
    int g=a+b+c+d+e+f;
    return g;
}

int funcAdd_arm(a,b,c,d,e,f)
{
    int g=a+b+c+d+e+f;
    return g;
}

int main(int argc, char * argv[]) {

//    int num = funcAdd(1, 2, 3, 4, 5, 6);
//
//    int num2 = funcAdd_arm(1,2,3,4,5,6);
//
//    NSLog(@"%d\n",num);
//
//    int f_address = (int)&funcAdd_arm;
//
//    NSLog(@"%x\n",f_address);
//
//    num = 0;
//    num2 = 0;
//
//    asm(
//        "mov x0,1\t\n"
//        "mov x1,2\t\n"
//        "mov x2,3\t\n"
//        "mov x3,4\t\n"
//        "mov x4,5\t\n"
//        "mov x5,6\t\n"
//        "bl _funcAdd_arm\t\n"
////        "mov %w0,x0\t\n"
//        "mov %1,#2\t\n"
//        :"=r"(num),"=r"(num2)
//        :
//        :
//        );
//
//lable1:
//    NSLog(@"lable1");

    @autoreleasepool {
//        int num1, num2 = 0;
//        num1 = 5;
//        asm(
////            "mov %eax,$num1\n"
////            "mov $num2,%eax\n"
//            "mov %eax, 2"
//            ""
//        );
//
//        printf("number is =========== %d\n",num2);
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([FFAppDelegate class]));



    }


}

