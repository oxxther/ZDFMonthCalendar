//
//  MyCalendarView.m
//  改版月历
//
//  Created by hy1 on 16/1/27.
//  Copyright © 2016年 oxxther. All rights reserved.
//

#import "MyCalendarView.h"
#import "Masonry.h"
#import "CalenderAll.h"

#define YEARCOUNT 10
#define MONTHCOUNT 12

//////******用于年份选择******//////
///自定义按钮，调整图片和文字的内容
@interface MCButton : UIButton

@end

@implementation MCButton

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.imageView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height);
}


@end
///

///自定义表视图
@interface MyCell : UITableViewCell

@end

@implementation MyCell

//取消高亮重写这两方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}

@end


static NSString *changeBtnTitle = @"changeBtnTitle";
static NSString *getTapValue = @"getTapValue";

@interface YearListViewController : UITableViewController

@property (nonatomic,assign) NSInteger year;

@end

@implementation YearListViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.year = [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitYear fromDate:[NSDate date]];
    [self.tableView registerClass:[MyCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return YEARCOUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld年",self.year - indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    
    //创建通知内容
    NSDictionary *titleText = @{@"text":text};
    
    NSNotification *noti = [[NSNotification alloc]initWithName:changeBtnTitle object:nil userInfo:titleText];
   
    [[NSNotificationCenter defaultCenter] postNotification:noti];

    
}

@end

///
//////******用于年份选择******//////

//////******用于月份选择******//////
@interface MonthView : UIView

@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIColor *circleColor;
@property (nonatomic, assign) BOOL currentTap;

@end

@implementation MonthView

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit{
    self.currentTap = NO;
    
    _monthLabel = [[UILabel alloc]init];
    _monthLabel.textColor = [UIColor whiteColor];
    [self addSubview:_monthLabel];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

//手势触发
- (void)tap:(UITapGestureRecognizer *)tap{
    MonthView *monthView = (MonthView *)tap.view;
    
    ///*****根据状态刷新视图*****///
    monthView.currentTap = YES;
    
    UIView *bigView = [monthView superview];
    for (UIView *smallView in bigView.subviews) {
        if (smallView.tag != monthView.tag) {
            MonthView *v = (MonthView *)smallView;
            v.currentTap = NO;
        }
        [smallView setNeedsDisplay];
    }
    
    NSString *text = monthView.monthLabel.text;
    //创建通知内容
    NSDictionary *titleText = @{@"text":text};
    
    NSNotification *noti = [[NSNotification alloc]initWithName:getTapValue object:nil userInfo:titleText];
    
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
}

- (void)drawRect:(CGRect)rect{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGRect myRect = CGRectZero;
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);
    CGContextFillRect(ctx, rect);
    
    if (w > h) {
        x = (w - h)/2.;
        myRect = CGRectMake(x, y, h, h);
    }else{
        y = (h - w)/2.;
        myRect = CGRectMake(x, y, w, w);
    }
    
    rect = CGRectInset(myRect, .5, .5);
    
    UIColor *selectColor = nil;
    if (self.currentTap) {
        selectColor = [UIColor yellowColor];
    }else{
        selectColor = self.circleColor;
    }
    
    CGContextSetStrokeColorWithColor(ctx, [selectColor CGColor]);
    CGContextSetFillColorWithColor(ctx, [selectColor CGColor]);
    
    CGContextAddEllipseInRect(ctx, rect);
    CGContextFillEllipseInRect(ctx, rect);
    
    CGContextFillPath(ctx);
}

@end

//////******用于月份选择******//////





@interface MyCalendarView ()<MengbanWindowDelegate>
{
    UIView *_headView;
    UIView *_bodyView;
    MCButton *_btn;
    MengbanWindow *_mbW;
    NSString *_selectYear;
    NSString *_selectMonth;
}
@property (nonatomic ,strong) YearListViewController *ylVC;

@end


@implementation MyCalendarView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:changeBtnTitle object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:getTapValue object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    //初始化界面
    [self commonInit];
    
    return self;
}

- (void)commonInit{
    
    //这里分成两部分
    //1.利用自定义button实现下拉栏弹出效果
    UIView *headView = [[UIView alloc]init];
    _headView = headView;
    
    headView.backgroundColor = [UIColor grayColor];
    
    [self addSubview:headView];
    
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.leading.equalTo(self).with.offset(0);
        make.trailing.equalTo(self).with.offset(0);
        make.height.equalTo(self).multipliedBy(1/3.);
    }];
    
    //设置headView中的内容
    [self setUpHeadView:headView];
    
   
    //2.利用label加tap手势实现点击获取label数字并实现背景颜色绘制
    UIView *bodyView = [[UIView alloc]init];
    _bodyView = bodyView;
    
    bodyView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:bodyView];
    
    [bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
        make.trailing.equalTo(self).with.offset(0);
        make.height.equalTo(self).multipliedBy(2/3.);
    }];
    
    //设置bodyView中的内容
    [self setUpBodyView:bodyView];
    
    //3.创建表视图实例
    self.ylVC = [[YearListViewController alloc]init];
}

//////******用于年份选择******//////
///设置headView中的内容
- (void)setUpHeadView:(UIView *)view{
    MCButton *button = [[MCButton alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBtnTitle:) name:changeBtnTitle object:nil];
    
    _btn = button;
    
    [view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    
    button.backgroundColor = [UIColor blueColor];
    
    NSString *titleStr = [NSString stringWithFormat:@"%ld年",[[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitYear fromDate:[NSDate date]]];
    
    _selectYear = titleStr;
    
    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"lunch"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"no"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(showYearList:) forControlEvents:UIControlEventTouchUpInside];
}

//-- showYearList --
- (void)showYearList:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    MengbanWindow *coverView = [MengbanWindow show];
    _mbW = coverView;
    coverView.delegate = self;
    
    CGFloat popW = 100;
    CGFloat popH = 200;
    CGFloat popX = (self.bounds.size.width - 100)*0.5;
    CGFloat popY = CGRectGetMaxY(btn.frame);
    ContentWindow *contentView = [ContentWindow showInRect:CGRectMake(popX, popY, popW, popH)];
    
    contentView.contentView = self.ylVC.tableView;
    
}

#pragma mark - 点击蒙板时
- (void)didClickMengbanWindow:(MengbanWindow *)mengbanWindow{
    //隐藏contentView
    [ContentWindow hide];
    _btn.selected = NO;
}

- (void)changeBtnTitle:(NSNotification *)noti{
    _selectYear = noti.userInfo[@"text"];
    [_btn setTitle: noti.userInfo[@"text"] forState:UIControlStateNormal];
    [ContentWindow hide];
    [_mbW removeFromSuperview];
    _btn.selected = NO;
    
    [self chuanzhi];
}
///
//////******用于年份选择******//////



///设置bodyView中的内容
- (void)setUpBodyView:(UIView *)view{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getTapValue:) name:getTapValue object:nil];
    
    for (int i = 1; i <= MONTHCOUNT; i++) {
        MonthView *monthView = [[MonthView alloc]init];
        monthView.monthLabel.text = [NSString stringWithFormat:@"%d月",i];
        monthView.circleColor = view.backgroundColor;
        monthView.tag = i;
        
        if (monthView.tag == [[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitMonth fromDate:[NSDate date]]) {
            monthView.currentTap = YES;
        }
        
        monthView.backgroundColor = [UIColor clearColor];
        [view addSubview:monthView];
    }
    
    //开始布局
    for (int i = 0; i < view.subviews.count; i++) {
        UIView *v1 = view.subviews[i];
        UIView *v2 = nil;
        UIView *v3 = nil;
        if (i > 0) {
            v2 = view.subviews[i-1];
        }
        if (i > 5) {
            v3 = view.subviews[i%6];
        }
        
        
        if (i == 0) {
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).with.offset(0);
                make.left.equalTo(view).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
            }];
        }else if (i > 0 && i < 5){
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).with.offset(0);
                make.left.equalTo(v2.mas_right).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
                make.width.equalTo(v2.mas_width);

            }];
        }else if (i == 5){
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).with.offset(0);
                make.right.equalTo(view).with.offset(0);
                make.left.equalTo(v2.mas_right).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
                make.width.equalTo(v2.mas_width);
            }];
        }else if (i == 6){
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(v3.mas_bottom).with.offset(0);
                make.left.equalTo(view).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
            }];
        }else if (i > 6 && i < 11){
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(v3.mas_bottom).with.offset(0);
                make.left.equalTo(v2.mas_right).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
                make.width.equalTo(v2.mas_width);
            }];
        }else if (i == 11){
            [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(v3.mas_bottom).with.offset(0);
                make.left.equalTo(v2.mas_right).with.offset(0);
                make.right.equalTo(view).with.offset(0);
                make.height.equalTo(view.mas_height).multipliedBy(0.5);
                make.width.equalTo(v2.mas_width);
            }];
        }
    }
    
}

- (void)getTapValue:(NSNotification *)noti{
    _selectMonth = noti.userInfo[@"text"];
    [self chuanzhi];
}

#pragma mark - 向外界传值
- (void)chuanzhi{
    NSString *yearStr = [_selectYear stringByReplacingOccurrencesOfString:@"年" withString:@""];
    NSString * monthStr = [_selectMonth stringByReplacingOccurrencesOfString:@"月" withString:@""];
    if (monthStr.length < 2) {
        monthStr = [@"0" stringByAppendingString:monthStr];
    }
    NSLog(@"year:%@,month:%@",yearStr,monthStr);

    [self.delegate myCalendarView:self returnYearAndMonth:[yearStr stringByAppendingString:monthStr]];
}

@end
