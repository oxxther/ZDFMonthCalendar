//
//  mengbanWindow.h
//  改版月历
//
//  Created by hy1 on 16/1/28.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MengbanWindow;

//设置协议
@protocol MengbanWindowDelegate <NSObject>

///点击蒙板时调用
- (void)didClickMengbanWindow:(MengbanWindow *)mengbanWindow;

@end



@interface MengbanWindow : UIView

///显示蒙板
+ (instancetype)show;

///自定蒙板的颜色
@property (nonatomic, strong) UIColor *bgColor;

//声明代理
@property (nonatomic, weak) id<MengbanWindowDelegate> delegate;

@end
