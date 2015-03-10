//
//  IBTHorizontalTableView.m
//  IBTHorizontalTableView
//
//  Created by Xummer on 15/3/9.
//  Copyright (c) 2015年 Xummer. All rights reserved.
//

#define IBT_DEFAULT_CONTENT_WIDTH   (44.0f)

#import "IBTHorizontalTableView.h"
#import "IBTHorizontalTableViewCell.h"
#import "IBTHorizontalTableViewDataSource.h"
#import "IBTHorizontalTableViewDelegate.h"

@interface IBTHorizontalTableView ()
{
    BOOL m_bIsLayoutingCells;
    NSUInteger m_uiSelectedIndex;
}
@property (strong, nonatomic) NSMutableDictionary* m_visibleCellsDict;
@property (strong, nonatomic) NSMutableSet* m_reusableCells;
@property (strong, nonatomic) NSMutableArray* m_cellFrames;

@end

@implementation IBTHorizontalTableView

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.delegate = self;
    self.contentSize = CGSizeMake(0, CGRectGetHeight(frame));
    self.m_reusableCells = [NSMutableSet set];
    self.m_visibleCellsDict = [NSMutableDictionary dictionary];
    self.m_cellFrames = [NSMutableArray array];
    m_bIsLayoutingCells = NO;
    m_uiSelectedIndex = NSNotFound;
    
    // Add Tap Guesture
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestrue:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!m_bIsLayoutingCells) {
        [self tileView];
    }
}

- (void)dealloc {
    
}

- (void)handleTapGestrue:(UITapGestureRecognizer*)tapGestrue {
    CGPoint touchPoint = [tapGestrue locationInView:self];
    NSArray *cells = _m_visibleCellsDict.allValues;
    
    IBTHorizontalTableViewCell *touchedCell = nil;;
    for (IBTHorizontalTableViewCell *cell in cells) {
        if (CGRectContainsPoint(cell.frame, touchPoint)) {
            touchedCell = cell;
            m_uiSelectedIndex = cell.index;
            cell.selected = YES;
        }
        else {
            cell.selected = NO;
        }
    }
    
    if (touchedCell &&
        [self.m_viewDelegate respondsToSelector:@selector(horizontalTableView:didSelectColumnAtIndex:)])
    {
        [self.m_viewDelegate horizontalTableView:self
                          didSelectColumnAtIndex:touchedCell.index];
    }
}

#pragma mark - Setter
- (void)setDataSource:(id<IBTHorizontalTableViewDataSource>)dataSource {
    self.m_dataSource = dataSource;
    
    if (self.m_viewDelegate) {
        [self calculateAllCellRect];
    }
}

- (void)setViewDelegate:(id<IBTHorizontalTableViewDelegate>)viewDelegate {
    self.m_viewDelegate = viewDelegate;
    
    if (self.m_dataSource) {
        [self calculateAllCellRect];
    }
}

#pragma mark - Public Method
- (IBTHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    IBTHorizontalTableViewCell *cell = nil;
    
    for (IBTHorizontalTableViewCell *recycledCell in _m_reusableCells) {
        if ([identifier isEqualToString:recycledCell.reuseIdentifier]) {
            cell = recycledCell;
            break;
        }
    }
    
    if (cell) {
        [_m_reusableCells removeObject:cell];
    }
    
    return cell;
}

- (IBTHorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index {
    IBTHorizontalTableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[IBTHorizontalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.index = index;
    return cell;
}

- (void)enqueueTableViewCell:(IBTHorizontalTableViewCell *)cell {
    if (cell) {
        [cell prepareForReuse];
        [_m_reusableCells addObject:cell];
        [cell removeFromSuperview];
    }
}

- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)reloadData {
    [self calculateAllCellRect];
    [self tileView];
}

#pragma mark - Private Method
- (NSUInteger)numberOfCells {
    return [_m_cellFrames count];
}

- (NSRange)visibleRange {
    NSUInteger uiNumberOfCells = [self numberOfCells];
    if (uiNumberOfCells == 0) {
        return NSMakeRange(0, 0);
    }
    
    NSUInteger uiBeginIndex = 0;
    CGFloat fBeginWidth = self.contentOffset.x;
    CGFloat fDisplayBeginWidth = -0.00000001f;
    
    CGFloat fCellW = 0;
    for (NSUInteger i = 0; i < uiNumberOfCells; i++) {
        fCellW = CGRectGetWidth([_m_cellFrames[ i ] CGRectValue]);
        fDisplayBeginWidth += fCellW;
        if (fDisplayBeginWidth > fBeginWidth) {
            uiBeginIndex = i;
            break;
        }
    }
    
    NSUInteger uiEndIndex = uiBeginIndex;
    CGFloat fDisplayEndWidth = self.contentOffset.x + CGRectGetWidth(self.bounds);
    CGFloat fCellX = 0;
    for (NSUInteger i = uiBeginIndex; i < uiNumberOfCells; i++) {
        fCellX = CGRectGetMinX([_m_cellFrames[ i ] CGRectValue]);
        if (fCellX > fDisplayEndWidth) {
            uiEndIndex = i;
            break;
        }
        if (i == uiNumberOfCells - 1) {
            uiEndIndex = i;
            break;
        }
    }
    
    return NSMakeRange(uiBeginIndex, uiEndIndex - uiBeginIndex + 1);
}

- (CGRect)_rectForCellAtColumn:(NSUInteger)index {
    if (index >= [self numberOfCells]) {
        return CGRectZero;
    }
    
    return [_m_cellFrames[ index ] CGRectValue];
}

- (IBTHorizontalTableViewCell *)_cellForColumn:(NSUInteger)index {
    IBTHorizontalTableViewCell *cell = _m_visibleCellsDict[ @(index) ];
    if (!cell) {
        cell = [_m_dataSource horizontalTableView:self viewForColumnAtIndex:index];
    }
    
    return cell;
}

- (void)addCell:(IBTHorizontalTableViewCell *)cell atColumn:(NSUInteger)index {
    [self addSubview:cell];
    cell.index = index;
    _m_visibleCellsDict[ @(index) ] = cell;
}

- (void)calculateAllCellRect {
    NSUInteger uiCellCount = 0;
    if ([self.m_dataSource respondsToSelector:@selector(numberOfColumnsInHorizontalTableView:)]) {
        uiCellCount = [self.m_dataSource numberOfColumnsInHorizontalTableView:self];
    }
    else {
        return;
    }
    
    [_m_cellFrames removeAllObjects];
    
    BOOL bHasFuncCellWidth = [self.m_viewDelegate respondsToSelector:@selector(horizontalTableView:widthForColumnAtIndex:)];
    
    CGFloat fContentWidth = 0;
    CGFloat fCellWidth = 0;
    for (NSUInteger i = 0; i < uiCellCount; i++) {
        fCellWidth = bHasFuncCellWidth ? [self.m_viewDelegate horizontalTableView:self widthForColumnAtIndex:i] : IBT_DEFAULT_CONTENT_WIDTH;
        [_m_cellFrames addObject:[NSValue valueWithCGRect:(CGRect){
            .origin.x = fContentWidth,
            .origin.y = 0,
            .size.width = fCellWidth,
            .size.height = self.contentSize.height
        }]];
        fContentWidth += fCellWidth;
    }
    
    self.contentSize = CGSizeMake(fContentWidth, CGRectGetHeight(self.bounds));
}

- (void)tileView {
    m_bIsLayoutingCells = YES;
    NSRange visibleRange = [self visibleRange];
    for (NSUInteger i = visibleRange.location; i < NSMaxRange(visibleRange); i++) {
        IBTHorizontalTableViewCell *cell = [self _cellForColumn:i];
        [self addCell:cell atColumn:i];
        cell.frame = [_m_cellFrames[ i ] CGRectValue];
        
        cell.selected = i == m_uiSelectedIndex;
    }
    
    NSDictionary* dict = [_m_visibleCellsDict copy];
    NSArray* keys = [dict allKeys];
    for (NSNumber* numIndex  in keys) {
        NSUInteger uiIndex = [numIndex unsignedIntegerValue];
        if (!NSLocationInRange(uiIndex, visibleRange)) {
            IBTHorizontalTableViewCell* cell = dict[ numIndex ];
            [_m_visibleCellsDict removeObjectForKey:numIndex];
            [self enqueueTableViewCell:cell];
        }
    }

    m_bIsLayoutingCells = NO;
}

//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//}

@end
