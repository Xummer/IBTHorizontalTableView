//
//  IBTHorizontalTableViewDelegate.h
//  IBTHorizontalTableView
//
//  Created by Xummer on 15/3/9.
//  Copyright (c) 2015年 Xummer. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreGraphics;

@class IBTHorizontalTableView;
@protocol IBTHorizontalTableViewDelegate <NSObject>
@optional
- (CGFloat)horizontalTableView:(IBTHorizontalTableView *)hTableView
         widthForColumnAtIndex:(NSUInteger)index;
- (void)horizontalTableView:(IBTHorizontalTableView *)hTableView
     didSelectColumnAtIndex:(NSUInteger)index;
@end
