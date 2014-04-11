//
//  AnalogSeleNumViewController.m
//  RuYiCai
//
//  Created by Zhang Xiaofeng on 12-12-12.
//
//

#import "AnalogSeleNumViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "MissAndOpenView.h"
#import "RYCNormalBetView.h"
#import "NSLog.h"
#import "AdaptationUtils.h"

#define redNumStartTag  (12)
#define blueNumStartTag (112)
#define labelSizeFont   (15)

@interface AnalogSeleNumViewController ()

- (void)setMainView;
- (void)setBottomButtonWithStartRedNum:(NSInteger)startRedNum endRedNum:(NSInteger)endRedNum startBlueNum:(NSInteger)startBlueNum endBlueNum:(NSInteger)endBlueNum twoWei:(BOOL)twoWei;
- (void)querySampleNetOK:(NSNotification*)notification;

@end

@implementation AnalogSeleNumViewController

@synthesize lotNo = m_lotNo;
@synthesize sellWay = m_sellWay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [m_mainScrollView release], m_mainScrollView = nil;
    
    [m_selectAllCountLabel release], m_selectAllCountLabel = nil;
    [m_selectRedNumLabel release], m_selectRedNumLabel = nil;
    [m_selectBlueNumLabel release], m_selectBlueNumLabel = nil;
    
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"querySampleNetOK" object:nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(querySampleNetOK:) name:@"querySampleNetOK" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    UIBarButtonItem* okBarButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"投注"
                                        style:UIBarButtonItemStyleBordered
                                        target:self
                                        action:@selector(betButtonClick:)];
    self.navigationItem.rightBarButtonItem = okBarButtonItem;
    [okBarButtonItem release];
    
    [self setMainView];
    
    NSMutableDictionary*  tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic setObject:@"missValue" forKey:@"command"];
    [tempDic setObject:@"list" forKey:@"requestType"];
    if(KISiPhone5)
        [tempDic setObject:@"12" forKey:@"batchnum"];
    else
        [tempDic setObject:@"10" forKey:@"batchnum"];
    [tempDic setObject:self.sellWay forKey:@"sellway"];
    [tempDic setObject:self.lotNo forKey:@"lotno"];
    
    [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_BASE;
    [[RuYiCaiNetworkManager sharedManager] querySampleLotNetRequest:tempDic isShowProgress:YES];
}

#pragma mark 画图
- (void)querySampleNetOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[CommonRecordStatus commonRecordStatusManager].sampleNetStr];
    [jsonParser release];
    
    NSArray* resultArr = [parserDict objectForKey:@"result"];
    CGFloat viewHeigth;
    if(KISiPhone5)
        viewHeigth = [resultArr count] * ballHeigth + 22;
    else
        viewHeigth = [resultArr count] * ballHeigth;
    MissAndOpenView *missView = [[MissAndOpenView alloc] initWithFrame:CGRectMake(0, 0, batchCodeLabelWidth + (m_redNumCount + m_blueNumCount) * ballHeigth, viewHeigth)];
    missView.dataArray = resultArr;
    missView.lotNo = self.lotNo;
    [m_mainScrollView addSubview:missView];
    [missView release];
}

#pragma mark 创建头部（已选）和底部（button）
- (void)setMainView
{
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    topBg.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:topBg];
    [topBg release];
    
    m_selectAllCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 120, 36)];
    m_selectAllCountLabel.text = @"已选0注,共0元";
    m_selectAllCountLabel.textColor = [UIColor blackColor];
    m_selectAllCountLabel.font = [UIFont systemFontOfSize:labelSizeFont];
    m_selectAllCountLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_selectAllCountLabel];
    
    m_selectRedNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    m_selectRedNumLabel.textColor = [UIColor redColor];
    m_selectRedNumLabel.font = [UIFont systemFontOfSize:labelSizeFont];
    m_selectRedNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_selectRedNumLabel];
    
    m_selectBlueNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    m_selectBlueNumLabel.textColor = [UIColor blueColor];
    m_selectBlueNumLabel.font = [UIFont systemFontOfSize:labelSizeFont];
    m_selectBlueNumLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_selectBlueNumLabel];

    m_mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, 320, [UIScreen mainScreen].bounds.size.height - 64 - 36)];
    m_mainScrollView.backgroundColor = [UIColor clearColor];
    m_mainScrollView.bounces = NO;
    m_mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_mainScrollView];
    
    UIButton* bottomImage = [[UIButton alloc] initWithFrame:CGRectMake(0, m_mainScrollView.frame.size.height - 50, batchCodeLabelWidth, 50)];
    [bottomImage setBackgroundImage:RYCImageNamed(@"bottom_title_bg.png") forState:UIControlStateNormal];
    [bottomImage setTitle:@"选号" forState:UIControlStateNormal];
    [bottomImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bottomImage.titleLabel.font = [UIFont boldSystemFontOfSize:labelSizeFont];
    bottomImage.enabled = NO;
    [m_mainScrollView addSubview:bottomImage];
    [bottomImage release];
    
    if([self.lotNo isEqualToString:kLotNoSSQ])
    {
        [self setBottomButtonWithStartRedNum:1 endRedNum:33 startBlueNum:1 endBlueNum:16 twoWei:YES];
    }
}

- (void)setBottomButtonWithStartRedNum:(NSInteger)startRedNum endRedNum:(NSInteger)endRedNum startBlueNum:(NSInteger)startBlueNum endBlueNum:(NSInteger)endBlueNum twoWei:(BOOL)twoWei
{
    m_redNumCount = endRedNum - startRedNum + 1;
    m_blueNumCount = endBlueNum - startBlueNum + 1;
    for (int i = 0; i < m_redNumCount; i++)
    {
        UIButton*  redNumButton = [[UIButton alloc] initWithFrame:CGRectMake(batchCodeLabelWidth + i * ballHeigth, m_mainScrollView.frame.size.height - 50, ballHeigth, 50)];
        [redNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [redNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        redNumButton.titleLabel.font = [UIFont boldSystemFontOfSize:labelSizeFont];
        if(twoWei)
        {
            [redNumButton setTitle:[NSString stringWithFormat:@"%02d", (startRedNum + i)] forState:UIControlStateNormal];
        }
        else
        {
            [redNumButton setTitle:[NSString stringWithFormat:@"%d", (startRedNum + i)] forState:UIControlStateNormal];
        }
        redNumButton.tag = redNumStartTag + i;
        [redNumButton setBackgroundImage:RYCImageNamed(@"bottom_num_normal.png") forState:UIControlStateNormal];
        [redNumButton setBackgroundImage:RYCImageNamed(@"bottom_num_redbg.png") forState:UIControlStateSelected];
        [redNumButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_mainScrollView addSubview:redNumButton];
        [redNumButton release];
    }
    for (int j = 0; j < m_blueNumCount; j++)
    {
        UIButton*  blueNumButton = [[UIButton alloc] initWithFrame:CGRectMake((batchCodeLabelWidth + m_redNumCount * ballHeigth)+ j * ballHeigth, m_mainScrollView.frame.size.height - 50, ballHeigth, 50)];
        [blueNumButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [blueNumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        blueNumButton.titleLabel.font = [UIFont boldSystemFontOfSize:labelSizeFont];
        if(twoWei)
        {
            [blueNumButton setTitle:[NSString stringWithFormat:@"%02d", (startBlueNum + j)] forState:UIControlStateNormal];
        }
        else
        {
            [blueNumButton setTitle:[NSString stringWithFormat:@"%d", (startBlueNum + j)] forState:UIControlStateNormal];
        }
        blueNumButton.tag = blueNumStartTag + j;
        [blueNumButton setBackgroundImage:RYCImageNamed(@"bottom_num_normal.png") forState:UIControlStateNormal];
        [blueNumButton setBackgroundImage:RYCImageNamed(@"bottom_num_bluebg.png") forState:UIControlStateSelected];
        [blueNumButton addTarget:self action:@selector(numButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_mainScrollView addSubview:blueNumButton];
        [blueNumButton release];
    }
    m_mainScrollView.contentSize = CGSizeMake(batchCodeLabelWidth + (m_redNumCount + m_blueNumCount) * ballHeigth, [UIScreen mainScreen].bounds.size.height - 64 - 36);
}

- (void)numButtonClick:(id)sender
{
    UIButton* tempButton = (UIButton*)sender;
    if(tempButton.selected)
    {
        tempButton.selected = NO;
    }
    else
    {
        tempButton.selected = YES;
    }
    NSString*  redStr = @"";
    int nRedCount = 0;
    int nBlueCount = 0;
    for (int i = 0; i < m_redNumCount; i++)
    {
        UIButton* redButton = (UIButton*)[self.view viewWithTag:redNumStartTag + i];
        if(redButton.selected)
        {
            if(redStr.length > 0)
                redStr = [redStr stringByAppendingFormat:@",%@",[redButton currentTitle]];
            else
                redStr = [redStr stringByAppendingString:[redButton currentTitle]];
            nRedCount ++;
        }
    }
    NSString*  blueStr = @"";
    for (int j = 0; j < m_blueNumCount; j++)
    {
        UIButton* blueButton = (UIButton*)[self.view viewWithTag:blueNumStartTag + j];
        if(blueButton.selected)
        {
            if(blueStr.length > 0)
                blueStr = [blueStr stringByAppendingFormat:@",%@",[blueButton currentTitle]];
            else
                blueStr = [blueStr stringByAppendingString:[blueButton currentTitle]];
            nBlueCount ++;
        }
    }
    if(blueStr.length > 0 && redStr.length > 0)
        redStr = [redStr stringByAppendingString:@","];
    
    //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
    int numZhu = RYCChoose(6, nRedCount) * RYCChoose(1, nBlueCount);
    //金额 = 注数 * 倍数 *（2元）* 期数
    int numCost = numZhu * 2;
    
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    
    NSString* allAmountStr = [NSString stringWithFormat:@"已选%d注,共%d彩豆:", numZhu, numCost*aas];
    CGSize allAmountSize = [allAmountStr sizeWithFont:[UIFont systemFontOfSize:labelSizeFont]];
    m_selectAllCountLabel.frame = CGRectMake(5, 0, allAmountSize.width, 36);
    m_selectAllCountLabel.text = allAmountStr;
    
    CGSize redSize = [redStr sizeWithFont:[UIFont systemFontOfSize:labelSizeFont]];
    float  redWidth = redSize.width > (320 - 5 - allAmountSize.width) ? (320 - 5 - allAmountSize.width) : redSize.width;
    m_selectRedNumLabel.frame = CGRectMake(5 + allAmountSize.width, 0, redWidth, 36);
    m_selectRedNumLabel.text = redStr;
    m_selectBlueNumLabel.frame = CGRectMake(5 + allAmountSize.width + redSize.width, 0, 320 - 5 - redSize.width - allAmountSize.width, 36);
    m_selectBlueNumLabel.text = blueStr;
}

#pragma mark 投注
- (void)betButtonClick:(id)sender
{
    [RuYiCaiLotDetail sharedObject].sellWay = @"4";//模拟选号
    if([self.lotNo isEqualToString:kLotNoSSQ])
    {
        [self betSSQ];
    }
}

- (void)betSSQ
{
    NSString* betCode = @"";
    NSString* disBetCode = @"";
    NSMutableArray* redNumArr = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    NSMutableArray* blueNumArr = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    for (int i = 0; i < m_redNumCount; i++)
    {
        UIButton* redButton = (UIButton*)[self.view viewWithTag:redNumStartTag + i];
        if(redButton.selected)
        {
            [redNumArr addObject:[redButton currentTitle]];
        }
    }
    for (int j = 0; j < m_blueNumCount; j++)
    {
        UIButton* blueButton = (UIButton*)[self.view viewWithTag:blueNumStartTag + j];
        if(blueButton.selected)
        {
            [blueNumArr addObject:[blueButton currentTitle]];
        }
    }
    int nRedCount = [redNumArr count];
    int nBlueCount = [blueNumArr count];
    if(nRedCount < 6 || nBlueCount < 1)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请至少选择一注进行投注！\n（6个红球加1个蓝球）" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    if (nRedCount > 6 && nBlueCount > 1)  //复式
        betCode = [betCode stringByAppendingString:@"3001*"];
    else if (nRedCount > 6)  //红复式，篮球等于1
        betCode = [betCode stringByAppendingString:@"1001*"];
    else if (nBlueCount > 1)  //蓝复式
        betCode = [betCode stringByAppendingString:@"2001*"];
    else  //单式
        betCode = [betCode stringByAppendingString:@"0001"];
    
    for (int i = 0; i < nRedCount; i++)
    {
        int nValue = [[redNumArr objectAtIndex:i] intValue];
        betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        
        if (i == (nRedCount - 1))
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    betCode = [betCode stringByAppendingFormat:@"~"];
    disBetCode = [disBetCode stringByAppendingFormat:@"|"];
    
    for (int i = 0; i < nBlueCount; i++)
    {
        int nValue = [[blueNumArr objectAtIndex:i] intValue];
        betCode = [betCode stringByAppendingFormat:@"%02d", nValue];
        if (i == (nBlueCount - 1))
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d", nValue];
        else
            disBetCode = [disBetCode stringByAppendingFormat:@"%02d,", nValue];
    }
    betCode = [betCode stringByAppendingFormat:@"^"];
    
    //注数 = zuhe(6,用户选中红球数量) * zuhe(1,用户选中蓝球数量)
    int numZhu = RYCChoose(6, nRedCount) * RYCChoose(1, nBlueCount);
    //金额 = 注数 * 倍数 *（2元）* 期数
    int numCost = numZhu * 2;
                   
//   [redNumArr release], redNumArr = nil;
//   [blueNumArr release], blueNumArr = nil;

//    [RuYiCaiLotDetail sharedObject].sellWay = @"0";
    [RuYiCaiLotDetail sharedObject].disBetCode = disBetCode;
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoSSQ;
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%d", numCost * 100];
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
	[RuYiCaiLotDetail sharedObject].zhuShuNum = [NSString stringWithFormat:@"%d",numZhu];
    
    if(numCost > kMaxBetCost)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单个方案注数不能超过10000注" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    [self setHidesBottomBarWhenPushed:YES];
	RYCNormalBetView* viewController = [[RYCNormalBetView alloc] init];
	viewController.navigationItem.title = @"双色球投注";
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}
@end
