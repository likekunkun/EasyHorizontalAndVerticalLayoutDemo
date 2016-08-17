//
//  ViewController.m
//  MQHorizontalAndVerticallayout
//
//  Created by macbook on 16/8/12.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YYAdd.h"
#import "RightTableViewCell.h"
#import "RightTableHeaderView.h"
#import "LeftTableHeaderView.h"

@interface ViewController () <
    UITableViewDelegate,
    UITableViewDataSource>
{
    CGFloat _contentSizeOfX;/**< 计算右侧scrollView的宽度 */
    NSArray *_datas;
}
@property (nonatomic, strong) UITableView *leftTableView;/**<侧边栏*/
@property (nonatomic, strong) UIScrollView *rightScrollView;/**<为了实现右滑的效果而创建*/
@property (nonatomic, strong) UITableView *rightTableView;/**<在rightScrollView上面的tableView*/

@end

#define WidthForItem  100
#define HeightForHeader  44
#define HeightForRow  50
#define WidthForLeft  125
#define SelectColor ColorRGB(207, 207, 207)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上下左右滑动";
    self.view.backgroundColor = ColorWhite;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self requestDatas];
    [self leftTableView];
    [self rightScrollView];
    [self rightTableView];
}

- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WidthForLeft, ScreenHeight - 64) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.bounces = NO;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.backgroundColor = ColorWhite;
        [_leftTableView registerClass:[UITableViewCell class]
               forCellReuseIdentifier:@"left"];
        _leftTableView.separatorColor = ColorTableSeparator;
        if ([_leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_leftTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if ([_leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_leftTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        [self.view addSubview:_leftTableView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_leftTableView.right - .5, 0, .5, ScreenHeight)];
        
        lineView.backgroundColor = ColorTableSeparator;
        [self.view addSubview:lineView];
    }
    return _leftTableView;
}

- (UIScrollView *)rightScrollView
{
    if (!_rightScrollView) {
        _rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.leftTableView.right, self.leftTableView.top, ScreenWidth  - self.leftTableView.width, self.leftTableView.height)];
        _rightScrollView.contentSize = CGSizeMake(_contentSizeOfX, self.leftTableView.height);
        _rightScrollView.bounces = NO;
        _rightScrollView.alwaysBounceVertical = YES;
        _rightScrollView.alwaysBounceHorizontal = NO;
        _rightScrollView.backgroundColor = ColorWhite;
        _rightScrollView.showsVerticalScrollIndicator = NO;
        _rightScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_rightScrollView];
    }
    return _rightScrollView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentSizeOfX, self.leftTableView.height)
                                                       style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.bounces = NO;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.backgroundColor = ColorWhite;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [UIView new];
        [_rightTableView registerClass:[RightTableViewCell class]
                forCellReuseIdentifier:@"right"];
        [self.rightScrollView addSubview:_rightTableView];
    }
    return _rightTableView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _rightTableView) {
        RightTableHeaderView  *headerView = [[RightTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, _contentSizeOfX, HeightForHeader)];
        headerView.backgroundColor = ColorWhite;
        [headerView configureWithItem:@[@"A级", @"B级", @"C级", @"D级", @"E级",
                                        @"F级", @"G级", @"H级", @"I级", @"J级"]];
        return headerView;
    } else {
        LeftTableHeaderView *view = [[LeftTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, WidthForLeft, HeightForHeader)];
        [view configureWithItem:@"统计"];
        return view;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        // 需要判断是哪个tableView
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"left"];
        if (_datas.count > 0) {
            
            cell.textLabel.numberOfLines = 2;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld个人", indexPath.row];
        }
        return cell;
    } else {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"right"];
        [cell configureWithItem:_datas[indexPath.row]];
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return HeightForRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  HeightForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.rightTableView) {
        if (self.leftTableView.contentOffset.y != self.rightTableView.contentOffset.y) {
            self.leftTableView.contentOffset = CGPointMake(0, self.rightTableView.contentOffset.y);
        }
    } else if (scrollView == self.leftTableView) {
        if (self.rightTableView.contentOffset.y != self.leftTableView.contentOffset.y) {
            self.rightTableView.contentOffset = CGPointMake(self.rightTableView.contentOffset.x, self.leftTableView.contentOffset.y);
        }
    }
}

#pragma mark ====== cell点击 =====

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView || tableView == _rightTableView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeTableViewCellBackgroundColor:NO indexPath:indexPath];
        });
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView || tableView == _rightTableView) {
        [self changeTableViewCellBackgroundColor:YES indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView || tableView == _rightTableView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self changeTableViewCellBackgroundColor:NO indexPath:indexPath];
        });
        [self didSelectTableViewCell:tableView indexPath:indexPath];
    }
}

/// cell点击事件
- (void)didSelectTableViewCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
}

- (void)changeTableViewCellBackgroundColor:(BOOL)change indexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell1 = [_leftTableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell2 = [_rightTableView cellForRowAtIndexPath:indexPath];
    if (change) {
        cell1.backgroundColor = SelectColor;
        cell2.backgroundColor = SelectColor;
    } else {
        [UIView animateWithDuration:.2 animations:^{
            cell1.backgroundColor = ColorWhite;
            cell2.backgroundColor = ColorWhite;
        }];
    }
}



#pragma mark ====== 请求数据 =====
- (void)requestDatas
{
    _datas = @[@[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"50", @"400", @"20", @"100", @"80", @"300", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"],
               @[@"100", @"200", @"20", @"100", @"80", @"100", @"200", @"20", @"100", @"80"]];
    NSArray *obj0 = _datas[0];
    _contentSizeOfX = obj0.count * WidthForItem;
}
@end
