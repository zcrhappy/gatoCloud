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
#define GTWarningRecordCellIdentifier @"GTWarningRecordCellIdentifier"

@interface GTWarningRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *warningTable;
@property (nonatomic, strong) GTWarningRecordDataManager *dataManager;
@property (nonatomic, strong) id currentModel;

@end

@implementation GTWarningRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
     _dataManager = [[GTWarningRecordDataManager alloc] init];
    
    [self configTable];
    [self pullDowmToRefresh];
}

- (void)configTable
{
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDowmToRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _warningTable.mj_header = header;
    _warningTable.tableFooterView = [UIView new];
}

- (void)pullDowmToRefresh
{
    __weak __typeof(self)weakSelf = self;
    [_dataManager refreshDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.warningTable.mj_header endRefreshing];
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



- (IBAction)clickBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
