//
//  NSTableView+Custom.h
//  ChaoXingCloudDisk
//
//  Created by haifeng on 2018/2/27.
//  Copyright © 2018年 ChaoXing. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 消除警告
 */
@protocol XYTableViewDelegate <NSObject>
@optional
- (NSView   *)xy_noDataView;                //  完全自定义占位图
- (NSImage  *)xy_noDataViewImage;           //  使用默认占位图, 提供一张图片,    可不提供, 默认不显示
- (NSString *)xy_noDataViewMessage;         //  使用默认占位图, 提供显示文字,    可不提供, 默认为暂无数据
- (NSColor  *)xy_noDataViewMessageColor;    //  使用默认占位图, 提供显示文字颜色, 可不提供, 默认为灰色
- (NSNumber *)xy_noDataViewCenterYOffset;   //  使用默认占位图, CenterY 向下的偏移量
@end

@interface NSTableView (Custom)
@property (nonatomic, strong)NSView *backgroundView;
@property(nonatomic,strong)NSMenu *tableItemMenu;
@property (nonatomic, assign)BOOL alt;
@property (nonatomic, assign)BOOL shift;
@end
