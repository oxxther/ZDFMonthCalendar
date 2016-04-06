//
//  MyCalendarView.h
//  改版月历
//
//  Created by hy1 on 16/1/27.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCalendarView;
@protocol MyCalendarViewDelegate <NSObject>

- (void)myCalendarView:(MyCalendarView *)calendarView returnYearAndMonth:(NSString *)dateStr;

@end

@interface MyCalendarView : UIView

@property (nonatomic,weak) id<MyCalendarViewDelegate> delegate;

@end
