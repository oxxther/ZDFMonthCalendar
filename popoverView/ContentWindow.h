//
//  contentWindow.h
//  改版月历
//
//  Created by hy1 on 16/1/28.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentWindow : UIImageView

//显示下拉菜单
+ (instancetype)showInRect:(CGRect)rect;

//隐藏下拉菜单
+ (void)hide;

///内容视图
@property (nonatomic,weak) UIView *contentView;

@end
