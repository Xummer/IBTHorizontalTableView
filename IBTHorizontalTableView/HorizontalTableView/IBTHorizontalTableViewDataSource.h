//
//  IBTHorizontalTableViewDataSource.h
//  IBTHorizontalTableView
//
//  Created by Xummer on 15/3/9.
//  Copyright (c) 2015年 Xummer. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreGraphics;

@class IBTHorizontalTableView, IBTHorizontalTableViewCell;
@protocol IBTHorizontalTableViewDataSource <NSObject>
- (IBTHorizontalTableViewCell *)horizontalTableView:(IBTHorizontalTableView *)hTableView
     viewForColumnAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfColumnsInHorizontalTableView:(IBTHorizontalTableView *)hTableView;
@end
