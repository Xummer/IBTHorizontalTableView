//
//  ViewController.m
//  IBTHorizontalTableView
//
//  Created by Xummer on 15/3/9.
//  Copyright (c) 2015年 Xummer. All rights reserved.
//

#import "ViewController.h"
#import "IBTHorizontalTableView.h"

static NSString *HorizonCellID = @"HorizonCellID";

@interface ViewController ()
<
    IBTHorizontalTableViewDataSource,
    IBTHorizontalTableViewDelegate
>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    IBTHorizontalTableView *hTableV = [[IBTHorizontalTableView alloc] initWithFrame:(CGRect){
        .origin.x = 0,
        .origin.y = 100,
        .size.width = CGRectGetWidth(self.view.bounds),
        .size.height = 100
    }];
    [self.view addSubview:hTableV];
    hTableV.backgroundColor = [UIColor redColor];
    
    [hTableV setDataSource:self];
    [hTableV setViewDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBTHorizontalTableViewDataSource
- (NSUInteger)numberOfColumnsInHorizontalTableView:(IBTHorizontalTableView *)hTableView {
    return 10;
}

- (IBTHorizontalTableViewCell *)horizontalTableView:(IBTHorizontalTableView *)hTableView
                               viewForColumnAtIndex:(NSUInteger)index {
    IBTHorizontalTableViewCell *cell = [hTableView dequeueReusableCellWithIdentifier:HorizonCellID forIndex:index];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", @(index)];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = [UIColor colorWithWhite:1.0f/(index + 1) alpha:1];
    
    return cell;
}

#pragma mark - IBTHorizontalTableViewDelegate
- (CGFloat)horizontalTableView:(IBTHorizontalTableView *)hTableView
         widthForColumnAtIndex:(NSUInteger)index
{
    return 100;
}

- (void)horizontalTableView:(IBTHorizontalTableView *)hTableView
     didSelectColumnAtIndex:(NSUInteger)index
{
    NSLog(@"%@", @(index));
}

@end
