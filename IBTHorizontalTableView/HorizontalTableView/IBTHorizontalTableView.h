//
//  IBTHorizontalTableView.h
//  IBTHorizontalTableView
//
//  Created by Xummer on 15/3/9.
//  Copyright (c) 2015年 Xummer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBTHorizontalTableViewDataSource.h"
#import "IBTHorizontalTableViewDelegate.h"
#import "IBTHorizontalTableViewCell.h"

@interface IBTHorizontalTableView : UIScrollView < UIScrollViewDelegate >

@property (weak, nonatomic) id<IBTHorizontalTableViewDataSource> m_dataSource;
@property (weak, nonatomic) id<IBTHorizontalTableViewDelegate> m_viewDelegate;

- (id)initWithFrame:(CGRect)frame;
- (void)setDataSource:(id<IBTHorizontalTableViewDataSource>)dataSource;
- (void)setViewDelegate:(id<IBTHorizontalTableViewDelegate>)m_viewDelegate;

- (IBTHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (IBTHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                         forIndex:(NSUInteger)index;
- (CGFloat)contentSizeWidth;
- (void)reloadData;

@end