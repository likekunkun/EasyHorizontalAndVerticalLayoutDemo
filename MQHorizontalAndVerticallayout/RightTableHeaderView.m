//
//  RightTableHeaderView.m
//  MQHorizontalAndVerticallayout
//
//  Created by macbook on 16/8/12.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "RightTableHeaderView.h"
#import "UIView+YYAdd.h"

@implementation RightTableHeaderView

- (void)configureWithItem:(id)item
{
    NSArray *datas = item;
    CGFloat widthForItem = 100;
    CGFloat heightForItem = 44;
    UILabel *label = [self viewWithTag:100];
    
    if (label == NULL) {
        for (NSInteger i = 0 ; i < datas.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(widthForItem * i, 0, widthForItem, heightForItem - 3)];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            label.text = datas[i];
            label.tag = 100 + i;
            [self addSubview:label];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.left + 1, heightForItem - 3, label.width - 2 * 1, 3)];
            NSArray *colors = @[[UIColor cyanColor],
                                [UIColor yellowColor]];
            lineView.backgroundColor = colors[i % 2];
            [self addSubview:lineView];
        }
    } else {
        for (int i = 0; i < datas.count; i++) {
            UILabel *label = [self viewWithTag:100 + i];
            label.text = datas[i];
        }
    }
    
}

@end
