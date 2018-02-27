//
//  MyViewController.m
//  2222
//
//  Created by 仝兴伟 on 2018/2/27.
//  Copyright © 2018年 仝兴伟. All rights reserved.
//  这是一种添加占位图
// 另一种方式就是使用懒加载的方式去

#import "MyViewController.h"

@interface MyViewController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSTableView *tableview;
@property (nonatomic, strong) NSScrollView *tableviewScrollView;
@property (nonatomic, strong) NSMutableArray *listArray;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    // 方式一
    [self addData];
    [self addTab];
    
    [self.tableview reloadData];

    // 方式二
//    [self.view addSubview:self.tableviewScrollView];
}
- (void)addTab {
    self.tableviewScrollView = [[NSScrollView alloc]initWithFrame:CGRectMake(400, 0, 546, 480)];
    self.tableview = [[NSTableView alloc]initWithFrame:CGRectMake(0, 0, 546, 480)];
    [self.tableview setAutoresizesSubviews:YES];
    self.tableview.headerView = nil;
    self.tableview.rowHeight = 58;
    self.tableview.rowSizeStyle = NSTableViewRowSizeStyleDefault;
    
    NSTableColumn *cloumu = [[NSTableColumn alloc]initWithIdentifier:@"file"];
    cloumu.title = @"";
    cloumu.width = 546;
    [self.tableview addTableColumn:cloumu];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.gridStyleMask = NSTableViewGridNone;
    [self.tableviewScrollView setDocumentView:self.tableview];
    self.tableview.backgroundColor = [NSColor clearColor];
    [self.view addSubview:self.tableviewScrollView];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (self.listArray.count == 0) {
        return 0;
    }
    return self.listArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 58;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableView *cellView = [tableView makeViewWithIdentifier:@"Tableviewcells" owner:self];
    if (cellView == nil) {
        cellView = [[NSTableView alloc]init];
        [cellView setIdentifier:@"Tableviewcells"];
    }
    return cellView;
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
}

- (void) addData {
//    self.listArray = [NSMutableArray arrayWithObjects:@"2", nil];
    
    // 方式二在这里判断  self.listArray的数量如果小于等于0就去让scrollview添加自己定义的占位图
}

// 方式二
/*
- (NSScrollView *)tableviewScrollView {
    if (_tableviewScrollView == nil) {
        _tableviewScrollView = [[NSScrollView alloc]initWithFrame:CGRectMake(400, 0, 546, 480)];
        _tableviewScrollView.contentView.documentView = self.tableview;
    }
    return _tableviewScrollView;
}

- (NSTableView *)tableview {
    if (_tableview == nil) {
        _tableview = [[NSTableView alloc]initWithFrame:CGRectMake(0, 0, 546, 480)];
        [_tableview setAutoresizesSubviews:YES];
        _tableview.headerView = nil;
        _tableview.rowHeight = 58;
        _tableview.rowSizeStyle = NSTableViewRowSizeStyleDefault;
        
        NSTableColumn *cloumu = [[NSTableColumn alloc]initWithIdentifier:@"file"];
        cloumu.title = @"";
        cloumu.width = 546;
        [_tableview addTableColumn:cloumu];
        
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.gridStyleMask = NSTableViewGridNone;
    }
    return _tableview;
}
 */

-(NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return  _listArray;
}
@end
