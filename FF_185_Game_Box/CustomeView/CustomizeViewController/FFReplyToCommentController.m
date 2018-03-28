//
//  FFReplyToCommentController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/23.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFReplyToCommentController.h"
#import "FFGameModel.h"
#import "UIAlertController+FFAlertController.h"

#define MODEL FFMyNewsModel

@interface FFReplyToCommentController () <UITextViewDelegate>


@property (nonatomic, strong) UITextView *textView;

/** 发表评论 */
@property (nonatomic, strong) UIBarButtonItem *commentButton;

@property (nonatomic, strong) UILabel *messageLabel;


@end

@implementation FFReplyToCommentController

+ (instancetype)replyCommentWithCommentDict:(NSDictionary *)dict Completion:(ReplyCommentBlock)completion {
    FFReplyToCommentController *controller = [[FFReplyToCommentController alloc] init];
    controller.commentDict = dict;
    controller.completion = completion;
    return controller;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView resignFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"回复评论";
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = self.commentButton;
}

#pragma mark - respondsToCommentButton
- (void)respondsToCommentButton {
    [self.textView resignFirstResponder];
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@"点击评论~"]) {
        [UIAlertController showAlertMessage:@"消息不能为空哦~" dismissTime:0.7 dismissBlock:nil];
        return;
    }

    //回复评论
    NSString *toUid = [NSString stringWithFormat:@"%@",self.commentDict[@"uid"]];
    NSString *isFake = [NSString stringWithFormat:@"%@",self.commentDict[@"is_fake"]];
    [CURRENT_GAME sendCommentWithText:self.textView.text ToUid:toUid is_fake:isFake Completion:^(NSDictionary *content, BOOL success) {
        if (self.completion) {
            self.completion(content, success);
        }
    }];


}

#pragma mark - textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"点击评论~"]) {
        textView.font = [UIFont systemFontOfSize:16];
        textView.textAlignment = NSTextAlignmentJustified;
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        [self respondsToCommentButton];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma mark - setter
- (void)setCommentDict:(NSDictionary *)commentDict {
    _commentDict = commentDict;

    self.textView.text = @"点击评论~";
    self.messageLabel.text = [NSString stringWithFormat:@"回复评论:%@",commentDict[@"content"]];
    self.textView.textColor = [UIColor lightGrayColor];
}


#pragma mark - getter
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, kSCREEN_WIDTH, 30)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor lightGrayColor];
    }
    return _messageLabel;
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.bounds = CGRectMake(0, 0, kSCREEN_WIDTH - 20, (kSCREEN_WIDTH - 20) * 0.618);
        _textView.center = CGPointMake(kSCREEN_WIDTH / 2, 120 + (kSCREEN_WIDTH - 20) * 0.309);


        _textView.textAlignment = NSTextAlignmentJustified;

        _textView.textColor = [UIColor lightGrayColor];
        // 设置自动纠错方式
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        // 设置自动大写方式
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.text = @"点击评论~";

        _textView.returnKeyType = UIReturnKeySend;

        _textView.backgroundColor = [UIColor whiteColor];

        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 2;
        _textView.layer.cornerRadius = 8;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}


- (UIBarButtonItem *)commentButton {
    if (!_commentButton) {
        _commentButton = [[UIBarButtonItem alloc] initWithTitle:@"回复" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToCommentButton)];
    }
    return _commentButton;
}








@end
