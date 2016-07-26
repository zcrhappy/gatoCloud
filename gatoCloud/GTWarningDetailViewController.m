//
//  GTWarningDetailViewController.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/23.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTWarningDetailViewController.h"
#import "GTWarningRecordCompleteModel.h"
#import "GTWarningDetailCommonCell.h"
#import "GTWarningDetailStateCell.h"
#import "GTWarningDetailCommentCell.h"
#import "GTWarningDetailDoneCell.h"
#import "GTShareActionSheet.h"

#define GTWarningDetailCommonCellIdentifier @"GTWarningDetailCommonCellIdentifier"
#define GTWarningDetailStateCellIdentifier @"GTWarningDetailStateCellIdentifier"
#define GTWarningDetailCommentCellIdentifier @"GTWarningDetailCommentCellIdentifier"
#define GTWarningDetailDoneCellIdentifier @"GTWarningDetailDoneCellIdentifier"
#define GTWarningDetailAddressCellIdentifier @"GTWarningDetailAddressCellIdentifier"

NSString *warnType = @"报警类型";
NSString *zoneName = @"防区名称";
NSString *contact = @"紧急联系人";
NSString *telephone = @"联系电话";
NSString *zoneLoc = @"防区地理位置信息";
NSString *warnState = @"报警状态";
NSString *comment = @"备注";
NSString *done = @"确定";

@interface GTWarningDetailViewController()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *detailTable;
@property (nonatomic, strong) NSArray *rowArray;
@end

@implementation GTWarningDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _rowArray = [NSArray arrayWithObjects:warnType, zoneName, contact, telephone, zoneLoc, warnState, comment, done, nil];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    NSString *rowName = [_rowArray objectAtIndex:index];
    
    if([rowName isEqualToString:warnType]) {
        GTWarningDetailCommonCell *cell = (GTWarningDetailCommonCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailCommonCellIdentifier forIndexPath:indexPath];
        
        NSDictionary *warningTypeDict = [GTWarningRecordCompleteModel warningTypeDict];
        [cell setupCommonCellWithTitle:warnType content:[warningTypeDict objectForKey:_model.WARNTYPE]];
        return cell;
    }
    else if([rowName isEqualToString:zoneName]) {
        GTWarningDetailCommonCell *cell = (GTWarningDetailCommonCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailCommonCellIdentifier forIndexPath:indexPath];
        [cell setupCommonCellWithTitle:zoneName content:_model.zonename];
        return cell;
    }
    else if([rowName isEqualToString:contact]) {
        GTWarningDetailCommonCell *cell = (GTWarningDetailCommonCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailCommonCellIdentifier forIndexPath:indexPath];
        [cell setupCommonCellWithTitle:contact content:_model.zonecontactor];
        return cell;
    }
    else if([rowName isEqualToString:telephone]) {
        GTWarningDetailCommonCell *cell = (GTWarningDetailCommonCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailCommonCellIdentifier forIndexPath:indexPath];
        [cell setupCommonCellWithTitle:telephone content:_model.zonephone];
        return cell;
    }
    else if([rowName isEqualToString:zoneLoc]) {
        GTWarningDetailCommonCell *cell = (GTWarningDetailCommonCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailAddressCellIdentifier forIndexPath:indexPath];
        [cell setupCommonCellWithTitle:zoneLoc content:_model.zoneLoc];
        return cell;
    }
    else if([rowName isEqualToString:warnState]) {
        GTWarningDetailStateCell *cell = (GTWarningDetailStateCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailStateCellIdentifier forIndexPath:indexPath];
        [cell setupState:_model.ISTATE];
        return cell;
    }
    else if([rowName isEqualToString:comment]) {
        GTWarningDetailCommentCell *cell = (GTWarningDetailCommentCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailCommentCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    else if([rowName isEqualToString:done]) {
        GTWarningDetailDoneCell *cell = (GTWarningDetailDoneCell *)[tableView dequeueReusableCellWithIdentifier:GTWarningDetailDoneCellIdentifier forIndexPath:indexPath];
        return cell;
    }

    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    NSString *rowName = [_rowArray objectAtIndex:index];
    
    if([rowName isEqualToString:warnType])
        return 55;
    if([rowName isEqualToString:zoneName])
        return 55;
    if([rowName isEqualToString:contact])
        return 55;
    if([rowName isEqualToString:telephone])
        return 55;
    if([rowName isEqualToString:zoneLoc])
        return 74;
    if([rowName isEqualToString:warnState])
        return 66;
    if([rowName isEqualToString:comment])
        return 165;
    if([rowName isEqualToString:done])
        return 66;
    
    return 0;
}

#pragma mark - click action

- (IBAction)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickShare:(id)sender
{
    GTShareActionSheet *actionSheet = [[GTShareActionSheet alloc] initWithShareDestination:nil parentViewController:self];
    [actionSheet show];
}


@end
