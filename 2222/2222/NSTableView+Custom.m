//
//  NSTableView+Custom.m
//  ChaoXingCloudDisk
//
//  Created by haifeng on 2018/2/27.
//  Copyright © 2018年 ChaoXing. All rights reserved.
//

#import "NSTableView+Custom.h"
#import <objc/runtime.h>
#import "XYNoDataView.h"
#import "Masonry.h"
static void *backgroundView = &backgroundView;
static void *tableItemMenu = &tableItemMenu;
static void *alt = &alt;
static void *shift = &shift;


@implementation NSTableView (Custom)
-(void)setBackgroundView:(NSView *)view
{
    objc_setAssociatedObject(self, &backgroundView, view, OBJC_ASSOCIATION_RETAIN);
}

-(NSView *)backgroundView
{
    return objc_getAssociatedObject(self, &backgroundView);
}

-(void)setTableItemMenu:(NSMenu *)str
{
    objc_setAssociatedObject(self, &tableItemMenu, str, OBJC_ASSOCIATION_RETAIN);
}

-(NSMenu *)tableItemMenu
{
    return objc_getAssociatedObject(self, &tableItemMenu);
}

-(void)setShift:(BOOL)shift
{
    objc_setAssociatedObject(self, &shift, @(shift), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)shift
{
    return [objc_getAssociatedObject(self, &shift) boolValue];
}

-(void)setAlt:(BOOL)alt
{
    objc_setAssociatedObject(self, &alt, @(alt), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)alt
{
    return [objc_getAssociatedObject(self, &alt) boolValue];
}

/**
 加载时, 交换方法
 */
+ (void)load {
    
    //  只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method reloadData    = class_getInstanceMethod(self, @selector(reloadData));
        Method xy_reloadData = class_getInstanceMethod(self, @selector(xy_reloadData));
        method_exchangeImplementations(reloadData, xy_reloadData);
        
        Method dealloc       = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method xy_dealloc    = class_getInstanceMethod(self, @selector(xy_dealloc));
        method_exchangeImplementations(dealloc, xy_dealloc);
    });
}

/**
 在 ReloadData 的时候检查数据
 */
- (void)xy_reloadData {
    
    [self xy_reloadData];
    
    //  忽略第一次加载
//    if (![self isInitFinish]) {
//        [self xy_havingData:YES];
//        [self setIsInitFinish:YES];
//        return ;
//    }
    //  刷新完成之后检测数据量
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger numberOfSections = [self numberOfRows];
        BOOL havingData = numberOfSections != 0;
        [self xy_havingData:havingData];
    });
}

/**
 展示占位图
 */
- (void)xy_havingData:(BOOL)havingData {
    
    //  不需要显示占位图
    if (havingData) {
        [self freeNoDataViewIfNeeded];
        [self.backgroundView removeFromSuperview];
        self.backgroundView = nil;
        return ;
    }
    
    //  不需要重复创建
    if (self.backgroundView) {
        return ;
    }
    
    //  自定义了占位图
    if ([self.delegate respondsToSelector:@selector(xy_noDataView)]) {
        self.backgroundView = [self.delegate performSelector:@selector(xy_noDataView)];
        return ;
    }
    
    //  使用自带的
    NSImage  *img   = [NSImage imageNamed:@"cxcd_icon.png"];
    NSString *msg   = @"暂无数据";
    NSColor  *color = [NSColor lightGrayColor];
    CGFloat  offset = 0;
    
    //  获取图片
    if ([self.delegate    respondsToSelector:@selector(xy_noDataViewImage)]) {
        img = [self.delegate performSelector:@selector(xy_noDataViewImage)];
    }
    //  获取文字
    if ([self.delegate    respondsToSelector:@selector(xy_noDataViewMessage)]) {
        msg = [self.delegate performSelector:@selector(xy_noDataViewMessage)];
    }
    //  获取颜色
    if ([self.delegate      respondsToSelector:@selector(xy_noDataViewMessageColor)]) {
        color = [self.delegate performSelector:@selector(xy_noDataViewMessageColor)];
    }
    //  获取偏移量
    if ([self.delegate        respondsToSelector:@selector(xy_noDataViewCenterYOffset)]) {
        offset = [[self.delegate performSelector:@selector(xy_noDataViewCenterYOffset)] floatValue];
    }
    
    //  创建占位图
    self.backgroundView = [self xy_defaultNoDataViewWithImage  :img message:msg color:color offsetY:offset];
//    self.backgroundView.frame = self.bounds;
//    [self addSubview:self.backgroundView];
    __weak typeof(self) wkSelf = self;
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.height.equalTo(wkSelf);
    }];
}

/**
 默认的占位图
 */
- (NSView *)xy_defaultNoDataViewWithImage:(NSImage *)image message:(NSString *)message color:(NSColor *)color offsetY:(CGFloat)offset {
    //  图片
    NSImageView *imgView = [[NSImageView alloc] init];
    //  文字
    NSTextField *label       = [[NSTextField alloc] init];
    
    XYNoDataView *view   = [[XYNoDataView alloc] init];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self addSubview:view];
    [view addSubview:imgView];
    [view addSubview:label];
    
    //  计算位置, 垂直居中, 图片默认中心偏上.
    CGFloat sW = self.bounds.size.width;
    CGFloat cX = sW / 2;
    CGFloat cY = self.bounds.size.height * (1 - 0.618) + offset;
    CGFloat iW = image.size.width;
    CGFloat iH = image.size.height;
    

     __weak typeof(self) wkSelf = self;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wkSelf.mas_centerX).offset(-iW/2);
        make.top.equalTo(wkSelf.mas_centerY).offset(-60);
//        make.left.mas_equalTo(cX - iW / 2);
//        make.top.mas_equalTo((cY - iH) / 2);
        make.width.mas_equalTo(iW);
        make.height.mas_equalTo(iH);
    }];
//    imgView.frame        = CGRectMake(cX - iW / 2, cY - iH / 2, iW, iH);
    imgView.image        = image;
    
    label.editable = NO;
    label.bordered = NO;
    label.font           = [NSFont systemFontOfSize:17];
    label.textColor      = color;
    label.stringValue    = message;
    label.alignment      = NSTextAlignmentCenter;
    label.frame          = CGRectMake(0, CGRectGetMaxY(imgView.frame) + 24, sW, 30);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.equalTo(imgView.mas_bottom).offset(24);
        make.width.equalTo(wkSelf.mas_width).offset(-20);
        make.height.mas_equalTo(30);
    }];
    
//    //  实现跟随 TableView 滚动
//    [view addObserver:self forKeyPath:kXYNoDataViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
    return view;
}


/**
 监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kXYNoDataViewObserveKeyPath]) {
        
        /**
         在 TableView 滚动 ContentOffset 改变时, 会同步改变 backgroundView 的 frame.origin.y
         可以实现, backgroundView 位置相对于 TableView 不动, 但是我们希望
         backgroundView 跟随 TableView 的滚动而滚动, 只能强制设置 frame.origin.y 永远为 0
         兼容 MJRefresh
         */
//        NSRect frame = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
//        if (frame.origin.y != 0) {
//            frame.origin.y  = 0;
//            self.backgroundView.frame = frame;
//        }
    }
}

#pragma mark - 属性

/// 加载完数据的标记属性名
static NSString * const kXYTableViewPropertyInitFinish = @"kXYTableViewPropertyInitFinish";

/**
 设置已经加载完成数据了
 */
- (void)setIsInitFinish:(BOOL)finish {
    objc_setAssociatedObject(self, &kXYTableViewPropertyInitFinish, @(finish), OBJC_ASSOCIATION_ASSIGN);
}

/**
 是否已经加载完成数据
 */
- (BOOL)isInitFinish {
    id obj = objc_getAssociatedObject(self, &kXYTableViewPropertyInitFinish);
    return [obj boolValue];
}

/**
 移除 KVO 监听
 */
- (void)freeNoDataViewIfNeeded {
    
//    if ([self.backgroundView isKindOfClass:[XYNoDataView class]]) {
//        [self.backgroundView removeObserver:self forKeyPath:kXYNoDataViewObserveKeyPath context:nil];
//    }
}

- (void)xy_dealloc {
    [self freeNoDataViewIfNeeded];
    [self xy_dealloc];
    NSLog(@"TableView + XY 视图正常销毁");
}

-(NSMenu*)menuForEvent:(NSEvent*)event{
    [[self window] makeFirstResponder:self];
    NSPoint menuPoint = [self convertPoint:[event locationInWindow] fromView:nil];
    NSInteger row = [self rowAtPoint:menuPoint];
    
    if (event.type == NSEventTypeRightMouseDown) {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        return self.tableItemMenu;
    }
    if (row >= 0)
    {
        [self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    }
    if (row < 0 )
    {
        return nil;
    }
    else
        return self.tableItemMenu;
}


-(void)flagsChanged:(NSEvent *)event
{
    NSUInteger flags = [event modifierFlags];
    self.shift = ( flags & NSEventModifierFlagShift ) ? YES : NO;
    self.alt = (flags & NSEventModifierFlagCommand) ? YES : NO;
    
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
@end
