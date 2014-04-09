//
//  HMDTAutoOrderViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-11-13.
//
//

#import "HMDTAutoOrderViewController.h"
#import "SeeDetailTableViewCell.h"
#import "HMDTDetialZhanjiCell.h"
//#import "HMDTAutoOrderLotSetCell.h"
#import "HMDTAutoOrderAmountSetcell.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "RightBarButtonItemUtils.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface HMDTAutoOrderViewController (internal)
- (void)createAutoJoinLoginOK:(NSNotification*)notification;//未登录的处理
- (void)queryLaunchLotStaterCompleteOK:(NSNotification*)notification;
- (void)CheXiaoNotification:(NSNotification*)notification;
- (void)okClick;

- (void)cancelAutoOrderCompleteOK:(NSNotification*)notification;
- (void)sendHttpRequest;
@end


@implementation HMDTAutoOrderViewController
@synthesize starterUserNo = m_starterUserNo;
@synthesize lotNo = m_lotNo;
@synthesize batchCode = m_batchCode;
@synthesize myTableView = m_myTableView;
@synthesize titleButtonState = m_titleButtonState;

@synthesize dataDic = m_dataDic;

@synthesize orderAmountByAllAmount = m_orderAmountByAllAmount;
@synthesize orderCountByAllAmount = m_orderCountByAllAmount;
@synthesize orderAmountByPercent = m_orderAmountByPercent;
@synthesize orderCountByPercent = m_orderCountByPercent;
@synthesize orderMaxAmountByPercent = m_orderMaxAmountByPercent;
@synthesize isByAllAmount = m_isByAllAmount;

@synthesize hasMaxAmountByPercent = m_hasMaxAmountByPercent;
@synthesize ViewType = m_ViewType;
@synthesize creatTimes = m_creatTimes;
@synthesize states = m_states;
@synthesize caseId = m_caseId;
@synthesize forceJoin = m_forceJoin;
#define ButtonStartTag   (101)
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"createAutoJoinLoginOK" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryLaunchLotStaterCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CheXiaoNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelAutoOrderCompleteOK" object:nil];
    
}

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    [m_titleButtonState release], m_titleButtonState = nil;
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createAutoJoinLoginOK:) name:@"createAutoJoinLoginOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryLaunchLotStaterCompleteOK:) name:@"queryLaunchLotStaterCompleteOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CheXiaoNotification:) name:@"CheXiaoNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAutoOrderCompleteOK:) name:@"cancelAutoOrderCompleteOK" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(okClick) andTitle:@"定制"];
    
    m_currentTextFeild = nil;
    NSString* buttonTitle = @"";
    if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {
        self.navigationItem.title = @"修改定制";
        buttonTitle = @"保存修改";
    }
    else
    {
        self.navigationItem.title = @"定制跟单设置";
        buttonTitle = @"立即定制";
    }
    
//    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
//                                        initWithTitle:buttonTitle
//                                        style:UIBarButtonItemStyleBordered
//                                        target:self
//                                        action:@selector(okClick)];
//    self.navigationItem.rightBarButtonItem = okBarButtonItem;
//    [okBarButtonItem release];
    
    m_titleButtonState = [[NSMutableArray alloc] initWithObjects:@"1",@"1"/*,@"1"*/, nil];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, (int)([UIScreen mainScreen].bounds.size.height - 64)) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    [[RuYiCaiNetworkManager sharedManager] queryLaunchLotStater:self.starterUserNo LOTNO:self.lotNo];
}

- (void)okClick
{
    //隐藏 键盘
    [self hideKeybord];
    if (m_isByAllAmount) {
        if (0 == self.orderAmountByAllAmount.length || 0 >= [self.orderAmountByAllAmount doubleValue])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购金额至少为1元" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if(0 == self.orderCountByAllAmount.length || 0 >= [self.orderCountByAllAmount doubleValue] || 99 < [self.orderCountByAllAmount doubleValue])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"定制次数为1~99次" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    else
    {
        if (0 == self.orderAmountByPercent.length || 0 >= [self.orderAmountByPercent doubleValue] || 100 <= [self.orderAmountByPercent doubleValue])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购百分比1%~99%" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if(0 == self.orderCountByPercent.length || 0 >= [self.orderCountByPercent doubleValue] || 99 < [self.orderCountByPercent doubleValue])
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"定制次数为1~99次" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
        if (self.hasMaxAmountByPercent && (0 == self.orderMaxAmountByPercent.length || 0 >= [self.orderMaxAmountByPercent doubleValue])) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"认购金额上限不能为空或零" withTitle:@"提示" buttonTitle:@"确定"];
            return;
        }
    }
    
    [self sendHttpRequest];
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.section)
        return 42;
    //    else if(1 == indexPath.section)
    //        return 400;
    else
        return 300;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = ButtonStartTag + section;
    
    //0 隐藏 1-- 展开
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 43)];
        image.image = [UIImage imageNamed:@"jclq_sectionlistexpand.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    else
    {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 43)];
        image.image = [UIImage imageNamed:@"jclq_sectionlisthide.png"];
        image.backgroundColor = [UIColor clearColor];
        [button addSubview:image];
        [image release];
    }
    
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.contentEdgeInsets = UIEdgeInsetsMake(13, 25, 0, 0);
    switch (section)
    {
        case 0:
            [button setTitle:@"合买名人信息" forState:UIControlStateNormal];
            break;
            //        case 1:
            //            [button setTitle:@"跟单彩种设置" forState:UIControlStateNormal];
            //            break;
        case 1:
            [button setTitle:@"跟单金额设置" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    //    [button addTarget:self action:@selector(pressTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([[self.titleButtonState objectAtIndex:section] isEqualToString:@"1"])
    {
        if(0 == section)
        {
            if (m_ViewType == CREAT_AUTO_ORDER_VIEW) {
                return 4;
            }
            else
                return 6;
        }
        else
        {
            return 1;
        }
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == [indexPath section])
    {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *CellIdentifiers = @"";
                
                if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {
                    CellIdentifiers = @"cellid_creatAutoOrderCancelButton";
                }
                else
                    CellIdentifiers = @"cell_starter";
                
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                cell.cellTitle = @"发起人：";
                cell.cellDetailTitle = [NSString stringWithFormat:@"%@", [self.dataDic objectForKey:@"starter"]];
                cell.isRedText = NO;
                if ([@"cellid_creatAutoOrderCancelButton" isEqualToString:CellIdentifiers]) {
                    cell.hasButton = HM_CANCEL_ORDER;
                }
                
                [cell refreshCell];
                return cell;
            }
            case 1:
            {
                static NSString *CellIdentifiers2 = @"Cells_removeOrder";
                HMDTDetialZhanjiCell *cell2 = (HMDTDetialZhanjiCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers2];
                if (cell2 == nil) {
                    cell2 = [[[HMDTDetialZhanjiCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers2] autorelease];
                }
                cell2.accessoryType = UITableViewCellAccessoryNone;
                cell2.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell2.cellTitle = @"战  绩：";
                NSDictionary* iconDict = [self.dataDic objectForKey:@"displayIcon"];
                
                cell2.graygoldStar = [KISDictionaryNullValue(iconDict, @"graygoldStar") intValue];
                cell2.goldStar = [KISDictionaryNullValue(iconDict, @"goldStar") intValue];
                cell2.diamond = [KISDictionaryNullValue(iconDict, @"diamond") intValue];
                cell2.graydiamond = [KISDictionaryNullValue(iconDict, @"graydiamond") intValue];
                cell2.graycup = [KISDictionaryNullValue(iconDict, @"graycup") intValue];
                cell2.cup = [KISDictionaryNullValue(iconDict, @"cup") intValue];
                cell2.graycrown = [KISDictionaryNullValue(iconDict, @"graycrown") intValue];
                cell2.crown = [KISDictionaryNullValue(iconDict, @"crown") intValue];
                
                [cell2 refreshCell];
                return cell2;
            }
            case 2:
            {
                static NSString *CellIdentifiers = @"Cell_lotNo";
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                cell.cellTitle = @"彩种：";
                cell.cellDetailTitle = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo];
                cell.isRedText = NO;
                [cell refreshCell];
                return cell;
            }
            case 3:
            {
                static NSString *CellIdentifiers = @"Cell_persons";
                SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                if (cell == nil) {
                    cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                [cell addSubview:writeImage];
                [writeImage release];
                
                cell.cellTitle = @"定制人数：";
                cell.cellDetailTitle = [NSString stringWithFormat:@"%@人",KISDictionaryNullValue(self.dataDic, @"persons")];
                cell.isRedText = NO;
                [cell refreshCell];
                return cell;
            }
            case 4:
            {
                if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {
                    static NSString *CellIdentifiers = @"Cell_creatTime";
                    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                    if (cell == nil) {
                        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                    writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    [cell addSubview:writeImage];
                    [writeImage release];
                    
                    cell.cellTitle = @"定制时间：";
                    cell.cellDetailTitle = self.creatTimes;
                    cell.isRedText = NO;
                    [cell refreshCell];
                    return cell;
                }
            }
                
            case 5:
            {
                if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {
                    static NSString *CellIdentifiers = @"Cell_states";
                    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
                    if (cell == nil) {
                        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
                    }
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 300, 10)];
                    writeImage.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
                    [cell addSubview:writeImage];
                    [writeImage release];
                    
                    cell.cellTitle = @"状态：";
                    cell.cellDetailTitle = self.states;
                    cell.isRedText = NO;
                    [cell refreshCell];
                    return cell;
                }
            }
        }
        return nil;
    }
    //    else if(1 == indexPath.section)
    //    {
    //        static NSString *CellIdentifiers = @"Cell_lotSet";
    //        HMDTAutoOrderLotSetCell *cell = (HMDTAutoOrderLotSetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
    //        if (cell == nil) {
    //            cell = [[[HMDTAutoOrderLotSetCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
    //        }
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        [cell refreshCell];
    //        return cell;
    //    }
    else
    {
        static NSString *CellIdentifiers = @"Cell_amountSet";
        HMDTAutoOrderAmountSetcell *cell = (HMDTAutoOrderAmountSetcell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers];
        if (cell == nil) {
            cell = [[[HMDTAutoOrderAmountSetcell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifiers] autorelease];
        }
        cell.superViewController = self;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refresh];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)createAutoJoinLoginOK:(NSNotification*)notification
{
    [self sendHttpRequest];
    
}
- (void)queryLaunchLotStaterCompleteOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    self.dataDic = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [m_myTableView reloadData];
    
}
- (void)CheXiaoNotification:(NSNotification*)notification
{
    
    [[RuYiCaiNetworkManager sharedManager] cancelAutoOrder:self.caseId];
}
- (void)cancelAutoOrderCompleteOK:(NSNotification*)notification
{
    //撤销订制后，变为创建定制跟单页面
    m_ViewType = CREAT_AUTO_ORDER_VIEW;
    
    self.navigationItem.title = @"定制跟单设置";
//    self.navigationItem.rightBarButtonItem.title = @"立即定制";
    
    [m_myTableView reloadData];
}

- (void)sendHttpRequest
{
    if ([RuYiCaiNetworkManager sharedManager].hasLogin)
	{
        NSString* joinType = @"";
        if (self.isByAllAmount) {
            joinType = @"0";
        }
        else
        {
            joinType = @"1";
        }
        
        if (self.isByAllAmount) {
            double orderAmountByAllAmount = [self.orderAmountByAllAmount doubleValue];
            orderAmountByAllAmount *= 100;
            
            if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {//修改定制跟单
                [[RuYiCaiNetworkManager sharedManager] modifyAutoOrder:self.caseId JOINAMT:[NSString stringWithFormat:@"%0.0lf", orderAmountByAllAmount] JOINTYPE:joinType PERCENT:@"" MAXAMT:@"" FORCEJOIN:(m_forceJoin ? @"1" : @"0")];
            }
            else//创建定制跟单
            {
                [[RuYiCaiNetworkManager sharedManager] createAutoJoin:
                 self.starterUserNo
                                                                LOTNO:self.lotNo
                                                              JOINAMT:[NSString stringWithFormat:@"%0.0lf", orderAmountByAllAmount]
                                                                TIMES:self.orderCountByAllAmount
                                                             JOINTYPE:joinType
                                                              PERCENT:@""
                                                               MAXAMT:@"" FORCEJOIN:(m_forceJoin ? @"1" : @"0")];
            }
        }
        else
        {
            double orderMaxAmountByPercent = [self.orderMaxAmountByPercent doubleValue];
            orderMaxAmountByPercent *= 100;
            
            if (m_ViewType == MODIFY_AUTO_ORDER_VIEW) {//修改定制跟单
                [[RuYiCaiNetworkManager sharedManager] modifyAutoOrder:self.caseId JOINAMT:@"" JOINTYPE:joinType PERCENT:self.orderAmountByPercent MAXAMT:(self.hasMaxAmountByPercent ? [NSString stringWithFormat:@"%0.0lf", orderMaxAmountByPercent] : @"") FORCEJOIN:(m_forceJoin ? @"1" : @"0")];
            }
            else
            {
                [[RuYiCaiNetworkManager sharedManager] createAutoJoin:self.starterUserNo  LOTNO:self.lotNo JOINAMT:@"" TIMES:self.orderCountByPercent JOINTYPE:joinType PERCENT:self.orderAmountByPercent MAXAMT:(self.hasMaxAmountByPercent ? [NSString stringWithFormat:@"%0.0lf", orderMaxAmountByPercent] : @"") FORCEJOIN:(m_forceJoin ? @"1" : @"0")];
            }
        }
	}
	else
	{
		[RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_AUTO_ORDER_LOGIN;
		[[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
	}
}

#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length > 0) {
        UniChar chr = [string characterAtIndex:0];
        if (chr >= '0' && chr <= '9')//是数字
        {
            if('0' == chr && 0 == range.location)
            {
                return NO;
            }
        }
        else
            return NO;
    }
    if(textField.tag == 10000)//按因定金额定制 金额
    {
        if (range.location >= 9) {
            return NO;
        }
    }
    else if(textField.tag == 10001)//按因定金额定制 次数
    {
        if (range.location >= 3) {
            return NO;
        }
    }
    else if(textField.tag == 10002)//按百分比定制 百分比
    {
        if (range.location >= 3) {
            return NO;
        }
    }
    else if(textField.tag == 10003)//按百分比定制  最大限制金额
    {
        if (range.location >= 9) {
            return NO;
        }
    }
    else if(textField.tag == 10004)////按百分比定制 次数
    {
        if (range.location >= 3) {
            return NO;
        }
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    float centerY = self.myTableView.center.y;
    NSLog(@"%f",centerY);//252
    m_currentTextFeild = textField;
    if((KISiPhone5 && centerY != 52) || (!KISiPhone5 && centerY != 8))
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.myTableView.center;
        center.y = (KISiPhone5 ? 52 : 8);
        self.myTableView.center = center;
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField.tag == 10000)//按因定金额定制 金额
    {
        self.orderAmountByAllAmount = textField.text;
    }
    else if(textField.tag == 10001)//按因定金额定制 次数
    {
        self.orderCountByAllAmount = textField.text;
    }
    else if(textField.tag == 10002)//按百分比定制 百分比
    {
        self.orderAmountByPercent = textField.text;
    }
    else if(textField.tag == 10003)//按百分比定制 v最大限制金额
    {
        self.orderMaxAmountByPercent = textField.text;
    }
    else if(textField.tag == 10004)////按百分比定制 次数
    {
        self.orderCountByPercent = textField.text;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeybord];
    return YES;
}

- (void)hideKeybord
{
    NSInteger centerY = self.myTableView.center.y;
    NSLog(@"%d", centerY);
    if (m_currentTextFeild != nil) {
        [self textFieldDidEndEditing:m_currentTextFeild];
        m_currentTextFeild = nil;
    }
    if((KISiPhone5 && centerY != 252) || (!KISiPhone5 && centerY != 208))
    {
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        CGPoint center = self.myTableView.center;
        center.y = (KISiPhone5 ? 252 : 208);
        self.myTableView.center = center;
        [UIView commitAnimations];
    }
    //刷新 金额设置cell
    NSIndexPath *updatapath = [NSIndexPath indexPathForRow:0 inSection:1];
    NSArray *updatapaths = [NSArray arrayWithObject:updatapath];
    [self.myTableView reloadRowsAtIndexPaths:updatapaths withRowAnimation:NO];
    
}
@end
