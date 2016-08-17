//
//  LeftTableHeaderView.m
//  MQHorizontalAndVerticallayout
//
//  Created by macbook on 16/8/12.
//  Copyright © 2016年 QIYIKE. All rights reserved.
//

#import "LeftTableHeaderView.h"
#import "UIView+YYAdd.h"

@interface LeftTableHeaderView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation LeftTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ColorWhite;
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 44)];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor greenColor];
        [self addSubview:self.label];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.label.left + 1, 44 - 3, self.label.width - 2 * 1, 3)];
        lineView.backgroundColor = [UIColor redColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)configureWithItem:(id)item
{
    self.label.text = item;
}

@end
