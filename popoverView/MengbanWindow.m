//
//  mengbanWindow.m
//  改版月历
//
//  Created by hy1 on 16/1/28.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import "MengbanWindow.h"
#import "CalenderAll.h"

@implementation MengbanWindow

- (void)setBgColor:(UIColor *)bgColor{
    
    _bgColor = bgColor;
    
    self.backgroundColor = bgColor;
}

+ (instancetype)show{
    MengbanWindow *mengbanView = [[MengbanWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    mengbanView.backgroundColor = [UIColor clearColor];
    
    [MCKeyWindow addSubview:mengbanView];
    
    return mengbanView;
}


//点击蒙板时该做的事
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //移除蒙板
    [self removeFromSuperview];
    
    //通知代理方移除菜单
    if ([_delegate respondsToSelector:@selector(didClickMengbanWindow:)]) {
        [_delegate didClickMengbanWindow:self];
    }
}
@end
