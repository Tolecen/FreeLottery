//
//  BetLotDetailViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-11-9.
//
//

/*标红中奖号码的 查看详情页*/
#import "BetLotDetailViewController.h"
#import "RYCImageNamed.h"
#import "SeeDetailTableViewCell.h"
#import "RuYiCaiCommon.h"
#import "JC_SeeDetailTableViewCell.h"
#import "ZC_SeeDetailTableViewCell.h"
#import "ZC_LCB_SeeDetailTableViewCell.h"
#import "AgainLotBetViewController.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiNetworkManager.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "TitleViewButtonItemUtils.h"

@interface BetLotDetailViewController ()

- (void)getBetDetailOK:(NSNotification*)notification;
//- (NSInteger)getBetResultHeigth:(NSString*)result;//算投注内容的高度

@end

@implementation BetLotDetailViewController

@synthesize lotNo = m_lotNo;
@synthesize orderId = m_orderId;

@synthesize detailType = m_detailType;
//@synthesize winNum =  m_winNum;
@synthesize amountCount = m_amountCount;
//@synthesize contentDic = m_contentDic;
@synthesize contentArray = m_contentArray;
@synthesize myTableView = m_myTableView;
@synthesize betCodeJson = m_betCodeJson;
@synthesize showInTable = m_showInTable;
@synthesize isRepeatBuy;

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getBetDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"viewBackNotification" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBetDetailOK:) name:@"getBetDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBackNotification:) name:@"viewBackNotification" object:nil];
}

- (void)viewBackNotification:(NSNotification*)notification
{
    [m_myTableView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    
    if ([self.lotNo isEqualToString:kLotNoNMK3] && [[self.navigationController.viewControllers objectAtIndex:0] isKindOfClass:[FirstPageViewController class]]) {
        
        //快三返回按钮
        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
        
        //右按钮
        [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(againButtonClick:) andTitle:@"再买一次" normalColor:@"#74061f" higheColor:@"#4f0415" rightButtontFrame:CGRectMake(0, 0, 70, 26)];
    }else{
        
        [BackBarButtonItemUtils addBackButtonForController:self];
        
        if(isRepeatBuy)
        {
            UIButton *rightBarBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 132/2, 30)] autorelease];
            [rightBarBtn addTarget:self action:@selector(againButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"four_btn.png"] forState:UIControlStateNormal];
            [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"four_btn_hover.png"] forState:UIControlStateHighlighted];
            rightBarBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightBarBtn setTitle:@"再买一次" forState:UIControlStateNormal];
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightBarBtn] autorelease];
        }

    }
    
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 12) style:UITableViewStyleGrouped];
    m_myTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    if(self.detailType == DETAILTYPEBET || self.detailType == DETAILTYPEWIN)
    {
        NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
        [tempDic setObject:@"select" forKey:@"command"];
        [tempDic setObject:@"betCodeAnalysis" forKey:@"requestType"];
        [tempDic setObject:self.orderId forKey:@"id"];
        [[RuYiCaiNetworkManager sharedManager] getBetDetailWithDic:tempDic];
    }
    else
    {
        m_myTableView.delegate = self;
        m_myTableView.dataSource = self;
        
        [self setUpTopView];
    }
}

- (void)getBetDetailOK:(NSNotification*)notification
{
    NSDictionary*   contentDic = (NSDictionary*)notification.userInfo;
    //    m_contentArray = [[NSMutableArray alloc] initWithCapacity:1];
    //    if([KISDictionaryHaveKey(self.contentDic, @"batchCode") isEqualToString:@""])//没有期号
    //    {
    //        [m_contentArray addObject:[NSString stringWithFormat:@"%@",KISDictionaryHaveKey(self.contentDic, @"lotName")]];
    //    }
    //    else
    //    {
    //        [m_contentArray addObject:[NSString stringWithFormat:@"%@   第%@期",KISDictionaryHaveKey(self.contentDic, @"lotName"), KISDictionaryHaveKey(self.contentDic, @"batchCode")]];
    //    }
    //
    //    [m_contentArray addObject:@"订单号:"];
    //    [m_contentArray addObject:KISDictionaryHaveKey(self.contentDic, @"orderId")];
    //    [m_contentArray addObject:@"倍数:" ];
    //    [m_contentArray addObject:[NSString stringWithFormat:@"%@倍", KISDictionaryHaveKey(self.contentDic, @"lotMulti")]];
    //    [m_contentArray addObject:@"注数:"];
    //    [m_contentArray addObject:[NSString stringWithFormat:@"%@注",KISDictionaryHaveKey(self.contentDic, @"betNum")]];
    //    [m_contentArray addObject:@"付款金额:" ];
    //    [m_contentArray addObject:[NSString stringWithFormat:@"%@元",self.amountCount]];
    //    [m_contentArray addObject:@"中奖金额:"];
    //    [m_contentArray addObject:self.winNum];
    //    [m_contentArray addObject:@"出票状态:"];
    //    [m_contentArray addObject:KISDictionaryHaveKey(self.contentDic, @"stateMemo")];
    //    [m_contentArray addObject:@"购买时间:"];
    //    [m_contentArray addObject:KISDictionaryHaveKey(self.contentDic, @"orderTime")];
    //    if(0 != [KISDictionaryHaveKey(self.contentDic, @"winCode") length])//有开奖号码
    //    {
    //        [m_contentArray addObject:@"开奖号码:"];
    //        [m_contentArray addObject:KISDictionaryHaveKey(self.contentDic, @"winCode")];
    //    }
    [m_contentArray addObject:KISDictionaryHaveKey(contentDic, @"betCodeHtml")];
    if (self.showInTable) {
        self.betCodeJson = KISDictionaryHaveKey(contentDic, @"betCodeJson");
    }
    [self setUpTopView];
    
    //    [self getBetResultHeigth:self.betCodeJson];
    
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [m_myTableView reloadData];
}

- (void)setUpTopView
{
    UIImageView  *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topImage.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:topImage];
    
    UILabel* titltLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titltLabel.textAlignment = UITextAlignmentCenter;
    titltLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titltLabel.textColor = [UIColor brownColor];
    titltLabel.backgroundColor = [UIColor clearColor];
    if([self.contentArray count] > 0)
        titltLabel.text = [self.contentArray objectAtIndex:0];
    [topImage addSubview:titltLabel];
    [titltLabel release];
    [topImage release];
}

#pragma mark 再买一次
- (void)againButtonClick:(id)sender
{
    [MobClick event:@"userPage_again_bet"];
    //初始化值
    //上个页面形成：
    //    [RuYiCaiLotDetail sharedObject].moreZuBetCode = KISDictionaryHaveKey(self.contentDic, @"orderInfo");
    //    [RuYiCaiLotDetail sharedObject].oneAmount = KISDictionaryHaveKey(self.contentDic, @"oneAmount");
    //    [RuYiCaiLotDetail sharedObject].lotMulti = KISDictionaryHaveKey(self.contentDic, @"lotMulti");
    //    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%d", ([self.amountCount intValue])/([KISDictionaryHaveKey(self.contentDic, @"lotMulti") intValue])*100];
    
    [RuYiCaiLotDetail sharedObject].lotNo = self.lotNo;
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    
    [RuYiCaiLotDetail sharedObject].batchNum = [NSString stringWithFormat:@"%@", @"1"];
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", [self.amountCount intValue] * 100];
    [RuYiCaiLotDetail sharedObject].batchCode = @"";//期号
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    
    //跳转页面
    AgainLotBetViewController* viewController = [[AgainLotBetViewController alloc] init];
    viewController.lotNo = self.lotNo;
    viewController.lotName = [[CommonRecordStatus commonRecordStatusManager] lotNameWithLotNo:self.lotNo];
    viewController.amount = [NSString stringWithFormat:@"%d", ([self.amountCount intValue])/([[RuYiCaiLotDetail sharedObject].lotMulti intValue])];
//    //        viewController.contentStr = self.betCodeMsg;
    viewController.navigationItem.title = @"再买一次";
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
}
#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section)
        return ([self.contentArray count] - 2)/2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section)
        return @"投注内容";
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if (self.showInTable) {
            return 195;
        }
        else
            return 135;
    }
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath section] == 0)
    {
        static NSString *myIdentifier = @"MyIdentifier_0";
        SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSUInteger rowIndex = [indexPath row];
        NSUInteger arrIndex = rowIndex * 2 + 1;
        cell.cellTitle = (NSString*)[self.contentArray objectAtIndex:arrIndex];
        cell.cellDetailTitle = (NSString*)[self.contentArray objectAtIndex:(arrIndex + 1)];
        cell.isTextView = NO;
        cell.isWebView = NO;
        
        [cell refreshCell];
        return cell;
    }
    else if ([indexPath section] == 1)
    {
        if ([self.lotNo isEqualToString:kLotNoJCLQ_SF] ||
            [self.lotNo isEqualToString:kLotNoJCLQ_RF] ||
            [self.lotNo isEqualToString:kLotNoJCLQ_SFC] ||
            [self.lotNo isEqualToString:kLotNoJCLQ_DXF] ||
            [self.lotNo isEqualToString:kLotNoJCLQ_CONFUSION] ||
            
            [self.lotNo isEqualToString:kLotNoJCZQ_SPF] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_RQ_SPF] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_ZJQ] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_SCORE] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_HALF] ||
            [self.lotNo isEqualToString:kLotNoJCZQ_CONFUSION]||
            
            [self.lotNo isEqualToString:kLotNoBJDC_RQSPF]||
            [self.lotNo isEqualToString:kLotNoBJDC_JQS]||
            [self.lotNo isEqualToString:kLotNoBJDC_Score]||
            [self.lotNo isEqualToString:kLotNoBJDC_HalfAndAll]||
            [self.lotNo isEqualToString:kLotNoBJDC_SXDS])//竞彩  北京单场
        {
            static NSString *myIdentifier = @"MyIdentifier_jc";
            NSArray* resultArray = [self.betCodeJson objectForKey:@"result"];
            /*
             计算 表格的高度，根据 我的投注内容多少来定
             */
            int tableHeight = 0;
            if ([resultArray count] == 0) {
                tableHeight = 180;
            }
            else
            {
                for (int k = 0; k < [resultArray count]; k++) {
                    //                    NSArray* cellbetContentArray = [KISNullValue(resultArray, k,@"betContentHtml") componentsSeparatedByString:@"br"];
                    //                    tableHeight += ([cellbetContentArray count] > 3) ? betContentCellHeight * [cellbetContentArray count] : CellHeight;
                    //
                    //                    NSArray* matchResult_arr = [KISNullValue(resultArray, k,@"matchResult") componentsSeparatedByString:@"br"];
                    //                    if ([matchResult_arr count] == [cellbetContentArray count] - 1) {
                    //                        tableHeight += CellHeight;
                    //                    }
                    //                    NSString* betData = KISNullValue(resultArray, k,@"betContentHtml");
                    //                    NSString* touString = @"<p style=\"line-height:17px\"><font size = \"1.5\">";
                    //                    betData = [touString stringByAppendingString:betData];
                    //                    betData = [betData stringByAppendingString:@"</font></p>"];
                    NSString *betData= [NSString stringWithFormat:@"<p style=\"line-height:17px\"><font size = \"1.5\">%@</font></p>", KISNullValue(resultArray, k,@"betContentHtml")];
                    NSString* isDanMa = [KISNullValue(resultArray, k, @"isDanMa") isEqualToString:@"true"] ? @"<font color=\"yellow\"> (胆)</font>" : @"";
                    betData = [betData stringByAppendingString:isDanMa];
                    
                    CGSize betSize = [betData sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(98, 600)];
                    CGSize resultSize = [KISNullValue(resultArray, k,@"matchResult") sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(62, 600)];//赛果高度
                    
                    //                    BOOL isHaveTotalScoreAndLetScore = ([KISNullValue(resultArray, k,@"letScore") length] != 0 && [KISNullValue(resultArray, k,@"totalScore") length] != 0) ? TRUE : FALSE;// 同时含有预设总分和让分 高度加20
                    
                    int currentCellHeight = 0;
                    if (betSize.height > resultSize.height) {
                        //                        if([[[UIDevice currentDevice] model] isEqualToString:@"iPad"] && betSize.height > 400)//iPad设备数据长时算总少26
                        //                            currentCellHeight = betSize.height < 65 ? CellHeight : (betSize.height + 26);
                        //                        else
                        currentCellHeight = betSize.height < 65 ? CellHeight : betSize.height;
                    }
                    else
                    {
                        currentCellHeight = resultSize.height < 65 ? CellHeight : resultSize.height;
                    }
                    //                    if (isHaveTotalScoreAndLetScore && currentCellHeight < 80) {
                    //                        currentCellHeight = CellHeight + 20;
                    //                    }
                    
                    tableHeight += currentCellHeight;
                }
                tableHeight += 60;
            }
            
            JC_SeeDetailTableViewCell* jc = [[[JC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
            jc.contentStr = self.betCodeJson;
            jc.jc_lotNo = self.lotNo;
            [jc setBackgroundColor:[UIColor whiteColor]];
            
            UIScrollView* scollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, 300, 180)] autorelease];
            [scollview addSubview:jc];
            scollview.contentSize =  CGSizeMake(300, tableHeight);
            [scollview setBackgroundColor:[UIColor whiteColor]];
            
            
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
            if (cell == nil)
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
            [cell.contentView addSubview:scollview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if([self.lotNo isEqualToString:kLotNoSFC] || [self.lotNo isEqualToString:kLotNoJQC] || [self.lotNo isEqualToString:kLotNoRX9] || [self.lotNo isEqualToString:kLotNoLCB])//足彩
        {
            static NSString *myIdentifier = @"MyIdentifier_ZC";
            NSArray* resultArray = [[[self.betCodeJson objectForKey:@"result"] objectAtIndex: 0] objectForKey:@"result"];
            //计算 表格的高度，根据 我的投注内容多少来定
            int tableHeight = 0;
            if ([resultArray count] == 0) {
                tableHeight = 180;
            }
            else
            {
                for (int k = 0; k < [resultArray count]; k++) {
                    tableHeight += zcCellHeight;
                }
                tableHeight += 80;
            }
            
            UIScrollView* scollview = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 8, 300, 180)] autorelease];
            scollview.contentSize =  CGSizeMake(300, tableHeight);
            [scollview setBackgroundColor:[UIColor whiteColor]];
            
            if([self.lotNo isEqualToString:kLotNoLCB] || [self.lotNo isEqualToString:kLotNoJQC])
            {
                ZC_LCB_SeeDetailTableViewCell* zc_lcb = [[[ZC_LCB_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
                zc_lcb.contentStr = self.betCodeJson;
                zc_lcb.isZC_JQC = NO;
                if([self.lotNo isEqualToString:kLotNoJQC])
                {
                    zc_lcb.isZC_JQC = YES;
                }
                [zc_lcb setBackgroundColor:[UIColor whiteColor]];
                [scollview addSubview:zc_lcb];
            }
            else
            {
                ZC_SeeDetailTableViewCell* zc = [[[ZC_SeeDetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 300, tableHeight)] autorelease];
                zc.contentStr = self.betCodeJson;
                [zc setBackgroundColor:[UIColor whiteColor]];
                [scollview addSubview:zc];
            }
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
            if (cell == nil)
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
            [cell.contentView addSubview:scollview];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            static NSString *myIdentifier = @"MyIdentifier_1";
            SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
            if (cell == nil)
                cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.contentStr = [self.contentArray objectAtIndex:[self.contentArray count] - 1];
            cell.isTextView = NO;
            cell.isWebView = YES;
            
            [cell refreshCell];
            return cell;
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//#pragma mark 算投注内容的高度
//- (void)getBetResultHeigth:(NSDictionary*)resultJson
//{
//    if (!resultJson) {
//        return;
//    }
//    NSString* result = @"<p style=\"line-height:17px\"><font size = \"1.5\">";
//    for (int i = 0; i < [[resultJson objectForKey:@"result"] count]; i++) {
//        result = [result stringByAppendingString:[[[resultJson objectForKey:@"result"] objectAtIndex:i] objectForKey:@"betContentHtml"]];
//    }
//    NSString *HTMLData=[NSString stringWithFormat:@"<div id='foo' style='color:white' >%@</font></p></div>",result];
//    NSLog(@"HTMLData::%@", HTMLData);
//    UIWebView*  webView = [[UIWebView alloc] init];
//    webView.delegate = self;
//    [webView loadHTMLString:HTMLData baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
//}
//
////加载完后获取高度
//- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
//
//    JCBetContentHeigth = [htmlHeight intValue] + 500;
//    NSLog(@"%@", htmlHeight);
//}


-(void)back:(UIButton *)button{
    
    [TitleViewButtonItemUtils shutDownMenu];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
@end
