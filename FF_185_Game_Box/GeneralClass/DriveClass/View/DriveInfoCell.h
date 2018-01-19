//
//  DriveInfoCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/12.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DriveInfoCell;

typedef enum : NSUInteger {
    likeButton,
    dislikeButton,
    sharedButton,
    commentButoon,
    noonButton
} CellButtonType;

@protocol DriveInfoCellDelegate <NSObject>

- (void)DriveInfoCell:(DriveInfoCell *)cell didClickIconWithUid:(NSString *)uid;

@optional
- (void)DriveInfoCell:(DriveInfoCell *)cell didClickButtonWithType:(CellButtonType)type;



@end

@interface DriveInfoCell : UITableViewCell

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong, readonly) NSString *dynamicsID;

@property (nonatomic, weak) id<DriveInfoCellDelegate> delegate;

@end








