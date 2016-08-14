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
#import "GTSearchActionSheet.h"
#import "GTSearchBar.h"
#import "GTSelectionPanel.h"
#import "GTDatePickPanel.h"
#import "GTDatePickActionSheet.h"
#define GTWarningRecordCellIdentifier @"GTWarningRecordCellIdentifier"

static NSString *kSearchViaUnhandled   = @"未处理报警";
static NSString *kSearchViaTime        = @"按时间段搜索";
static NSString *kSearchViaWarningType = @"按报警类型搜索";
static NSString *kSearchViaDeviceName  = @"按设备搜索";
static NSString *kSearchViaZone        = @"按防区搜索";

@interface GTWarningRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *warningTable;
@property (nonatomic, strong) GTWarningRecordDataManager *dataManager;
@property (nonatomic, strong) GTWarningRecordModel *currentModel;

@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, strong) GTSearchBar *searchBar;
@property (nonatomic, assign) BOOL autoRefresh;
//search keyword
@property (nonatomic, strong) NSMutableDictionary *searchKeywordDict;//和dataManager约定好的数据Dic；

@end

@implementation GTWarningRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self configTableView];
    [self configSearchBar];
    
    if([_typeStr isEqualToString:kSearchViaWarningType])
        [self configSelectionPanel];
    else if ([_typeStr isEqualToString:kSearchViaTime])
        [self configPickDatePanel];
    
    if(_typeStr == nil ||
       [_typeStr isEqualToString:kSearchViaUnhandled])
        [self pullDownToRefresh];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_searchBar) {
        _searchBar.hidden = YES;
        [_searchBar resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_searchBar) {
        _searchBar.hidden = NO;
    }
}

- (void)dealloc
{
    [_searchBar removeFromSuperview];
}

- (instancetype)init
{
    if(self = [super init]) {
        [self enableSearchItem:YES];
        _dataManager = [[GTWarningRecordDataManager alloc] init];
    }
    return self;
}

- (instancetype)initViaType:(NSString *)typeStr;
{
    if(self = [super init]) {
        _typeStr = typeStr;
        
        if([_typeStr isEqualToString:kSearchViaDeviceName]) {
            _dataManager = [[GTWarningRecordDataManager alloc] initWithSearchType:kSearchTypeViaDeviceName];
            _autoRefresh = NO;
        }
        else if ([_typeStr isEqualToString:kSearchViaZone]){
            _dataManager = [[GTWarningRecordDataManager alloc] initWithSearchType:kSearchTypeViaZoneName];
            _autoRefresh = NO;
        }
        else if ([_typeStr isEqualToString:kSearchViaWarningType]) {
            _dataManager = [[GTWarningRecordDataManager alloc] initWithSearchType:kSearchTypeViaWarningType];
            _autoRefresh = NO;
        }
        else if ([_typeStr isEqualToString:kSearchViaUnhandled]) {
            _dataManager = [[GTWarningRecordDataManager alloc] initWithSearchType:kSearchTypeWithUnhandled];
            _autoRefresh = YES;
        }
        else if ([_typeStr isEqualToString:kSearchViaTime]) {
            _dataManager = [[GTWarningRecordDataManager alloc] initWithSearchType:kSearchTypeViaTime];
            _autoRefresh = YES;
        }
        else {
            _dataManager = [[GTWarningRecordDataManager alloc] init];
        }
    }
    return self;
}

- (void)configTableView
{
    _warningTable = macroCreateTableView(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64), [UIColor whiteColor]);
    [self.view addSubview:_warningTable];
    _warningTable.delegate = self;
    _warningTable.dataSource = self;
    [_warningTable registerNib:[UINib nibWithNibName:@"GTWarningRecordCell" bundle:nil] forCellReuseIdentifier:GTWarningRecordCellIdentifier];
    
    _warningTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownToRefresh)];
    _warningTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpToRefresh)];
    _warningTable.mj_footer.hidden = !_autoRefresh;
    _warningTable.mj_header.hidden = !_autoRefresh;
    _warningTable.tableFooterView = [UIView new];
}

- (void)configSearchBar
{
    BOOL shouldDisableEdit = NO;
    NSString *placeholder;
    if([_typeStr isEqualToString:kSearchViaDeviceName])
        placeholder = @"请输入设备名称";
    else if ([_typeStr isEqualToString:kSearchViaZone])
        placeholder = @"请输入防区名称";
    else if ([_typeStr isEqualToString:kSearchViaWarningType]){
        placeholder = @"请选择报警类型进行搜索";
        shouldDisableEdit = YES;
    }
    else
        return;
    
    _searchBar = [[GTSearchBar alloc] initWithPlaceholder:placeholder];
    if(shouldDisableEdit)
        [_searchBar disableEdit];
    [self.navigationController.navigationBar addSubview:_searchBar];
    
    __weak __typeof(self)weakSelf = self;
    [_searchBar setDidEndEditingBlock:^(NSString *keyword) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if(strongSelf.searchBar.hidden == NO) {
            if(![keyword isEmptyString]) {
                strongSelf.dataManager.searchKeywordDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: keyword, keyForSearchKeyword, nil];
                [strongSelf pullDownToRefresh];
            }
            else {
                [MBProgressHUD showText:placeholder inView:strongSelf.view];
            }
        }
    }];
}

- (void)configSelectionPanel
{
    GTSelectionPanel *panel = [[GTSelectionPanel alloc] initWithSelectionArray:@[fenceStr, netStr, devStr, fireStr]];
    __weak __typeof(self)weakSelf = self;
    [panel setClickItemBlock:^(NSString *text) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.searchBar.text = text;
        strongSelf.dataManager.searchKeywordDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: text, keyForSearchWarningType, nil];
        [strongSelf pullDownToRefresh];
    }];
    [self.view addSubview:panel];
    if(_warningTable)
        _warningTable.contentInset = UIEdgeInsetsMake(panel.height, 0, 0, 0);
}

- (void)configPickDatePanel
{
    GTDatePickPanel *panel = [[GTDatePickPanel alloc] init];
    __weak __typeof(panel)weakPanel = panel;
    __weak __typeof(self)weakSelf = self;
    [panel setSelectBeginDateBlock:^(NSString *beginDate) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        GTDatePickActionSheet *picker = [GTDatePickActionSheet datePickerWithDate:beginDate];
        [picker show];
        
        [picker setDateChangedBlock:^(NSString *date) {
            weakPanel.leftItem.dateLabel.text = date;
            
            strongSelf.dataManager.searchKeywordDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: weakPanel.leftItem.dateLabel.text, keyForDateBegin, weakPanel.rightItem.dateLabel.text, keyForDateEnd, nil];
            [strongSelf pullDownToRefresh];
        }];
    }];
    
    [panel setSelectEndDateBlock:^(NSString *endDate) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        GTDatePickActionSheet *picker = [GTDatePickActionSheet datePickerWithDate:endDate];
        [picker show];
        
        [picker setDateChangedBlock:^(NSString *date) {
            weakPanel.rightItem.dateLabel.text = date;
            
            strongSelf.dataManager.searchKeywordDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: weakPanel.leftItem.dateLabel.text, keyForDateBegin, weakPanel.rightItem.dateLabel.text, keyForDateEnd, nil];
            [strongSelf pullDownToRefresh];
        }];
    }];
    [self.view addSubview:panel];
    if(_warningTable)
        _warningTable.contentInset = UIEdgeInsetsMake(panel.height, 0, 0, 0);
    
    self.dataManager.searchKeywordDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: panel.leftItem.dateLabel.text, keyForDateBegin, panel.rightItem.dateLabel.text, keyForDateEnd, nil];
    [self pullDownToRefresh];
}



- (void)pullDownToRefresh
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [_warningTable.mj_header setHidden:NO];
    [_warningTable.mj_footer resetNoMoreData];
    
    __weak __typeof(self)weakSelf = self;
    [_dataManager refreshDataWithFinishBlock:^(id response, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        if(!strongSelf.dataManager.hasMore)
            [strongSelf.warningTable.mj_footer endRefreshingWithNoMoreData];
        if(strongSelf.dataManager.isEmpty)
            [MBProgressHUD showText:@"未搜索到报警记录" inView:strongSelf.view];
        
        [strongSelf.warningTable.mj_header endRefreshing];
        [strongSelf.warningTable.mj_footer setHidden:NO];
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

#pragma mark - Search Item
- (void)enableSearchItem:(BOOL)yesOrNo;
{
    if(yesOrNo == YES)
        self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"搜索" target:self action:@selector(didClickSearch:)];
    else
        self.navigationItem.rightBarButtonItem = nil;
}

//创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"GTSearch"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(8.5, 8.5, 8.5, 8.5);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {34, 34}};
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)didClickSearch:(id)sender
{
    NSArray *selectionArr = @[kSearchViaUnhandled, kSearchViaTime, kSearchViaWarningType, kSearchViaDeviceName, kSearchViaZone];
    
    GTSearchActionSheet *actionSheet = [GTSearchActionSheet actionSheetWithSelection:selectionArr];
    [actionSheet show];
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(actionSheet)weakSheet = actionSheet;
    [actionSheet setDidClickBlk:^(NSInteger index) {
        __strong __typeof(weakSheet)strongSheet = weakSheet;
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSheet dismiss];
        NSString *selection = [selectionArr objectAtIndex:index];
        
        GTWarningRecordsViewController *controller = [[GTWarningRecordsViewController alloc] initViaType:selection];
        if([selection isEqualToString:kSearchViaUnhandled] ||
           [selection isEqualToString:kSearchViaTime]) {
            controller.title = selection;
        }
        [strongSelf.navigationController pushViewController:controller animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = [indexPath row];
    
    _currentModel = [_dataManager.dataSource.resultList objectAtIndex:row];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GTWarningDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"GTWarningDetailViewController"];
    detailViewController.model = _currentModel;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    GTWarningDetailViewController *detailViewController = segue.destinationViewController;
//    detailViewController.model = _currentModel;
//}

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
