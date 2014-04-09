//
//  LotterInformationViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-19.
//
//

#import "LotterInformationViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "InputTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "SBJsonParser.h"
#import "NewsViewController.h"
#import "Custom_tabbar.h"
#import "EachLotInforTableViewController.h"
#import "BackBarButtonItemUtils.h"
#import "TitleViewButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define kQuWenKey     @"quwen"
#define kZuCaiKey     @"zucai"
#define kHuDongKey    @"huodong"
#define kTuiJIanKey   @"tuijian"

#define cellBackGroundImageTap (10)
#define cellTextLabelTap (11)

#define TITLE_LABLE_TAG (56787678)

@interface LotterInformationViewController ()<TitleViewButtonItemUtilsDelegate>

@end


@interface LotterInformationViewController (internal)

- (void)getInformationOK:(NSNotification *)notification;
- (void)getInformationContentOK:(NSNotification *)notification;

@end

@interface LotterInformationViewController (action)


@end

@implementation LotterInformationViewController

@synthesize tableView = m_tableView;
@synthesize typeIdDicArray = m_typeIdDicArray;
@synthesize segmentType = _segmentType;

- (void)dealloc
{
    [m_tableView release], m_tableView = nil;
    [m_typeIdDicArray release], m_typeIdDicArray = nil;
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationOK:) name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationContentOK:) name:@"getInformationContentOK" object:nil];
    
    
    
    switch (self.segmentType)
    {
        case caiMinQuWen:
        {
            if([[self.typeIdDicArray objectForKey:kQuWenKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:CAI_MIN_ZHUAN_QU withLotNo:@""];
            }
        }break;
        case zuQiuTianDi:
        {
            if([[self.typeIdDicArray objectForKey:kZuCaiKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:ZU_CAI_TIAN_DI withLotNo:@""];
            }
        } break;
        case zhanNeiGongGao:
        {
            if([[self.typeIdDicArray objectForKey:kHuDongKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:ZHAN_NEI_GONG_GAO withLotNo:@""];
            }
        } break;
        case zhuanJiaTuiJian:
        {
            if([[self.typeIdDicArray objectForKey:kTuiJIanKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:ZHUAN_JIA_TUI_JIAN withLotNo:nil];
            }
        } break;
        default:
            break;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationContentOK" object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self];
    if(self.segmentType == zhuanJiaTuiJian){
        NSLog(@"专家推荐页面加载");
        NSArray *titleArr = [NSArray arrayWithObjects:
                             @"全部推荐",
                             @"双色球",
                             @"大乐透",
                             @"福彩3D",
                             @"排列三",
                             @"七乐彩",
                             @"排列五",
                             @"七星彩",nil];
        [TitleViewButtonItemUtils addTitleViewForController:self menuTitle:titleArr delegate:self];
        
    }
    self.definesPresentationContext = YES;
    
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    
    
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
	
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 66) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 40;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    NSMutableArray* tempArray_quWen = [[NSMutableArray alloc] init];
    NSMutableArray* tempArray_zuCai = [[NSMutableArray alloc] init];
    NSMutableArray* tempArray_huoDong = [[NSMutableArray alloc] init];
    NSMutableArray* tempArray_TuiJian = [[NSMutableArray alloc] init];
    m_typeIdDicArray = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tempArray_quWen, kQuWenKey, tempArray_zuCai, kZuCaiKey, tempArray_huoDong, kHuDongKey,tempArray_TuiJian,kTuiJIanKey, nil];
    [tempArray_quWen release];
    [tempArray_zuCai release];
    [tempArray_huoDong release];
    [tempArray_TuiJian release];
    
    
}

#pragma mark -notification 回调
- (void)getInformationOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"news"];
    switch (self.segmentType)
    {
        case caiMinQuWen:
        {
            [[self.typeIdDicArray objectForKey:kQuWenKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kQuWenKey] addObjectsFromArray:dict];
        }break;
        case zuQiuTianDi:
        {
            [[self.typeIdDicArray objectForKey:kZuCaiKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kZuCaiKey] addObjectsFromArray:dict];
            
        }break;
        case zhanNeiGongGao:
        {
            [[self.typeIdDicArray objectForKey:kHuDongKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kHuDongKey] addObjectsFromArray:dict];
            
        }break;
        case zhuanJiaTuiJian:
        {
            [[self.typeIdDicArray objectForKey:kTuiJIanKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kTuiJIanKey] addObjectsFromArray:dict];
            
        }break;
            
        default:
            break;
            
    }
    
    [self.tableView reloadData];
}

- (void)getInformationContentOK:(NSNotification *)notification
{
    
    NewsViewController *newsContent = [[NewsViewController alloc] init];
    newsContent.title = self.title;
    newsContent.delegate = self;
    [self.navigationController pushViewController:newsContent animated:YES];
    [newsContent release];
}

#pragma  mark tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(caiMinQuWen == self.segmentType)
    {
        return [[self.typeIdDicArray objectForKey:kQuWenKey] count];
    }
    else if(zuQiuTianDi == self.segmentType)
    {
        return [[self.typeIdDicArray objectForKey:kZuCaiKey] count];
    }
    else if(zhanNeiGongGao == self.segmentType)
    {
        return [[self.typeIdDicArray objectForKey:kHuDongKey] count];
    }else if(zhuanJiaTuiJian == self.segmentType)
    {
        return [[self.typeIdDicArray objectForKey:kTuiJIanKey] count];
    }
    else
        return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        
        
        UIImageView *backGroundImageView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cell_c_gengduo.png"]]autorelease];
        backGroundImageView.frame = CGRectMake(0, 0, 320,41);
        backGroundImageView.tag = cellBackGroundImageTap;
        [cell addSubview:backGroundImageView];
        
        UILabel *textLabel = [[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 20)]autorelease];
        textLabel.tag = cellTextLabelTap;
        [textLabel setBackgroundColor:[UIColor clearColor]];
        textLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [textLabel setTextColor:[UIColor blackColor]];
        [cell addSubview:textLabel];
        
        UIImageView *sanjiaoimage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 16, 6, 8)];
        sanjiaoimage.image = [UIImage imageNamed:@"cell_accessory_style.png"];
        [cell addSubview:sanjiaoimage];
        [sanjiaoimage release];
    }
    
    switch (self.segmentType)
    {
        case caiMinQuWen:{
            UILabel *textLabel = (UILabel *)[cell viewWithTag:cellTextLabelTap];
            textLabel.text = [[[self.typeIdDicArray objectForKey:kQuWenKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
            break;
        case zuQiuTianDi:{
            UILabel *textLabel = (UILabel *)[cell viewWithTag:cellTextLabelTap];
            textLabel.text = [[[self.typeIdDicArray objectForKey:kZuCaiKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
            break;
        case zhanNeiGongGao:{
            UILabel *textLabel = (UILabel *)[cell viewWithTag:cellTextLabelTap];
            textLabel.text = [[[self.typeIdDicArray objectForKey:kHuDongKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
            break;
        case zhuanJiaTuiJian:{
            UILabel *textLabel = (UILabel *)[cell viewWithTag:cellTextLabelTap];
            textLabel.text = [[[self.typeIdDicArray objectForKey:kTuiJIanKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
            break;
        default:
            break;
    }
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:cellTextLabelTap];
    textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [[m_tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor redColor]];
    
    
    NSInteger typeID = 0;
    switch (self.segmentType) {
        case caiMinQuWen:
        {
            typeID = [[[[self.typeIdDicArray objectForKey:kQuWenKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
        }break;
        case zuQiuTianDi:
        {
            typeID = [[[[self.typeIdDicArray objectForKey:kZuCaiKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"]intValue];
        }break;
        case zhanNeiGongGao:
        {
            typeID = [[[[self.typeIdDicArray objectForKey:kHuDongKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
        }break;
        case zhuanJiaTuiJian:
        {
            typeID = [[[[self.typeIdDicArray objectForKey:kTuiJIanKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
        }break;
        default:
            break;
    }
    [[RuYiCaiNetworkManager sharedManager] getInformationContent:typeID];
}

#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -TitleViewButtonItemUtilsDelegate
-(void)menuNumberOfRowsInMenu:(NSInteger)num{
    NSLog(@"%d",num);
    NSString *lotNo = nil;
    switch(num)
    {
        case 0:
            break;
        case 1:
            lotNo = kLotNoSSQ;
            break;
        case 2:
            lotNo = kLotNoDLT;
            break;
        case 3:
            lotNo = kLotNoFC3D;
            break;
        case 4:
            lotNo = kLotNoPLS;
            break;
        case 5:
            lotNo = kLotNoQLC;
            break;
        case 6:
            lotNo = kLotNoPL5;
            break;
        case 7:
            lotNo = kLotNoQXC;
            break;
        default:
            break;
    }
    [[RuYiCaiNetworkManager sharedManager] getInformation:ZHUAN_JIA_TUI_JIAN withLotNo:lotNo];
}

#pragma mark 微信分享
- (void)doAuth
{
    SendAuthReq* req = [[[SendAuthReq alloc] init] autorelease];
    req.scope = @"post_timeline";
    req.state = @"xxx";
    
    [WXApi sendReq:req];
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}

-(void) onSentTextMessage:(BOOL) bSent
{
    // 通过微信发送消息后， 返回本App
    NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
    
    NSString *strMsg = [NSString stringWithFormat:@"发送文本消息结果:%u", bSent];
    if ([strMsg isEqualToString:@"0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:@"分享失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}
@end

