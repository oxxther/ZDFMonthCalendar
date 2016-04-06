//
//  contentWindow.m
//  改版月历
//
//  Created by hy1 on 16/1/28.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import "ContentWindow.h"
#import "CalenderAll.h"

@implementation ContentWindow

+ (instancetype)showInRect:(CGRect)rect{
    ContentWindow *contentView = [[ContentWindow alloc]initWithFrame:rect];
    contentView.userInteractionEnabled = YES;
    contentView.image = [UIImage imageWithStretchableName:@"popover_background"];
    
    [MCKeyWindow addSubview:contentView];
    
    return contentView;
}

+ (void)hide{
    for (UIView *popView in MCKeyWindow.subviews) {
        if ([popView isKindOfClass:self]) {
            [popView removeFromSuperview];
        }
    }
}

//设置内容视图
- (void)setContentView:(UIView *)contentView{
    //先移除之前的内容视图
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    contentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:contentView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算内容视图的尺寸
    CGFloat y = 9;
    CGFloat margin = 5;
    CGFloat x = margin;
    CGFloat w = self.bounds.size.width - 2 * margin;
    CGFloat h = self.bounds.size.height - y - margin;
    
    _contentView.frame = CGRectMake(x, y, w, h);
}


@end
