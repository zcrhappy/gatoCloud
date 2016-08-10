//
//  GTWarningRecordsViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/20.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningRecordsViewController.h"
#import "GTWarningRecordDataManager.h"
#import "GTWarningRecordCell.h"
#import "GTWarningDetailViewController.h"
#import "MJRefresh.h"
#define GTWarningRecordCellIdentifier @"GTWarningRecordCellIdentifier"

@interface GTWarningRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *warningTable;
@property (nonatomic, strong) GTWarningRecordDataManager *dataManager;
@property (nonatomic, strong) GTWarningRecordModel *currentModel;

@end

@implementation GTWarningRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
     _dataManager = [[GTWarningRecordDataManager alloc] init];
    
    [self configTable];
    [self pullDownToRefresh];
}

- (void)configTable
{
    _warningTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    _warningTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];
    _warningTable.tableFooterView = [UIView new];
}

- (void)pullDownToRefresh
{
    [_warningTable.mj_footer resetNoMoreData];
    
    __weak __typeof(self)weakSelf = self;
    [_dataManager refreshDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(!strongSelf.dataManager.hasMore)
           [strongSelf.warningTable.mj_footer endRefreshingWithNoMoreData];
        
        [strongSelf.warningTable.mj_header endRefreshing];
        [strongSelf.warningTable reloadData];
    }];
}

- (void)pullUpToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [_dataManager loadMoreDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(!strongSelf.dataManager.hasMore)
            [strongSelf.warningTable.mj_footer endRefreshingWithNoMoreData];
        else
            [strongSelf.warningTable.mj_footer endRefreshing];
        [strongSelf.warningTable reloadData];
    }];
}

#pragma mark - TabelView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataManager.dataSource.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GTWarningRecordCell *cell = (GTWarningRecordCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningRecordCellIdentifier forIndexPath:indexPath];
    [cell setupWithModel:_dataManager.dataSource indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
    _currentModel = [_dataManager.dataSource.resultList objectAtIndex:row];
    [self performSegueWithIdentifier:@"pushToWarningDetailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    GTWarningDetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.model = _currentModel;
}

- (IBAction)unwindToWarningRecordsViewController:(UIStoryboardSegue *)unwindSegue
{
    NSInteger row = [_dataManager.dataSource.resultList indexOfObject:_currentModel];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    _currentModel = ((GTWarningDetailViewController *)(unwindSegue.sourceViewController)).model;
    [_warningTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


- (IBAction)clickBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
