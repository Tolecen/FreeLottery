//
//  LotterPeopleZoneViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-18.
//
//

#import "LotterPeopleZoneViewController.h"
#import "LotterPeopleZoneCell.h"
#import "BackBarButtonItemUtils.h"
#import "RuYiCaiNetworkManager.h"
#import "LotterInformationViewController.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"


@interface LotterPeopleZoneViewController ()<UITableViewDataSource,UITableViewDelegate>
{
@private UITableView *_tableView;
@private NSMutableDictionary *_titleDic;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableDictionary *titleDic;
@end

@interface LotterPeopleZoneViewController (internal)

- (void)getLotteryZoneInformation:(NSNotification *)notification;

@end

@implementation LotterPeopleZoneViewController
@synthesize tableView = _tableView;

@synthesize titleDic = _titleDic;

-(void)dealloc{
    [_tableView release];
    [_titleDic release];
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLotteryZoneInformation:) name:@"getLotteryZoneInformation" object:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    self.tableView = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 96) style:UITableViewStylePlain]autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    [[RuYiCaiNetworkManager sharedManager] getInformation:1 withLotNo:@""];
    self.titleDic = [NSMutableDictionary dictionary];
    
    [[RuYiCaiNetworkManager sharedManager] getInformation:CAI_MIN_ZHUAN_QU withLotNo:@"" maxresult:2];
    [[RuYiCaiNetworkManager sharedManager] getInformation:ZHUAN_JIA_TUI_JIAN withLotNo:@"" maxresult:2];
    [[RuYiCaiNetworkManager sharedManager] getInformation:ZU_CAI_TIAN_DI withLotNo:@"" maxresult:2];
    [[RuYiCaiNetworkManager sharedManager] getInformation:ZHAN_NEI_GONG_GAO withLotNo:@"" maxresult:2];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getLotteryZoneInformation" object:nil];
}
#pragma  mark tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"LotterPeopleCell";
    LotterPeopleZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[LotterPeopleZoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];

    }

    cell.contentString2 = @"查询中...";
    cell.contentString1 = @"查询中...";
    switch (indexPath.row + 1) {
        case CAI_MIN_ZHUAN_QU:
        {
            cell.iconImage = [UIImage imageNamed:@"cai_min_qu_wen.png"];
            cell.titleString = @"彩民趣闻";
        }
            break;
        case ZHUAN_JIA_TUI_JIAN:
        {
            cell.iconImage = [UIImage imageNamed:@"zhuan_jia_tui_jian.png"];
            cell.titleString = @"专家推荐";
        }
            break;
        case ZU_CAI_TIAN_DI:
        {
            cell.iconImage = [UIImage imageNamed:@"zu_cai_tian_di.png"];
            cell.titleString = @"足彩天地";
        }
            break;
        case ZHAN_NEI_GONG_GAO:
        {
            cell.iconImage = [UIImage imageNamed:@"zhan_nei_gong_gao.png"];
            cell.titleString = @"站内公告";
        }
            break;
            
        default:
            break;
    }
    
    
    //更新网络数据
    NSArray *titArr = [self.titleDic objectForKey:[NSString stringWithFormat:@"%d",(indexPath.row + 1)]];
    if (titArr) {
        for (int i = 0; i<[titArr count]; i++) {
            if (i == 0) {
                cell.contentString1 = [titArr objectAtIndex:i];
            }else{
                cell.contentString2 = [titArr objectAtIndex:i];
            }
        }

    }
    
    [cell refreshDate];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [RuYiCaiNetworkManager sharedManager].isRefreshUserCenter = YES;
    
    LotterInformationViewController *viewController = [[LotterInformationViewController alloc]init];
    
    NSLog(@"%d",indexPath.row);
    
    switch (indexPath.row+1) {
        case CAI_MIN_ZHUAN_QU:
            viewController.title = @"彩民趣闻";
            viewController.segmentType = caiMinQuWen;
            break;
        case ZHUAN_JIA_TUI_JIAN:
            viewController.title = @"专家推荐";
            viewController.segmentType = zhuanJiaTuiJian;
            break;
        case ZU_CAI_TIAN_DI:
            viewController.title = @"足球天地";
            viewController.segmentType = zuQiuTianDi;
            break;
        case ZHAN_NEI_GONG_GAO:
            viewController.title = @"站内公告";
            viewController.segmentType = zhanNeiGongGao;
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];

}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didHighlightRowAtIndexPath：%d",indexPath.row);
    LotterPeopleZoneCell *airCell = (LotterPeopleZoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    airCell.backGroundImageView.image = [UIImage imageNamed:@"lotter_people_zone_cell_back_ground_img_highlight.png"];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didUnhighlightRowAtIndexPath：%d",indexPath.row);
    LotterPeopleZoneCell *airCell = (LotterPeopleZoneCell *)[tableView cellForRowAtIndexPath:indexPath];
    airCell.backGroundImageView.image = [UIImage imageNamed:@"lotter_people_zone_cell_back_ground_img_normal.png"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSIndexPath *currentSelectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        NSLog(@"currentSelectedIndexPath：%d",currentSelectedIndexPath.row);
        LotterPeopleZoneCell *airCell = (LotterPeopleZoneCell *)[self.tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        airCell.backGroundImageView.image = [UIImage imageNamed:@"lotter_people_zone_cell_back_ground_img_normal.png"];
        [self.tableView deselectRowAtIndexPath:currentSelectedIndexPath animated:NO];
    }
}

//获取标题截取信息
-(void)getLotteryZoneInformation:(NSNotification *)notification{
    NSLog(@"getLotteryZoneInformation");
    NSObject *obj = [notification object];
    NSString *titleType = (NSString*)obj;

    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
    [jsonParser release];
    
    NSArray* arr = (NSArray*)[parserDict objectForKey:@"news"];

    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i < [arr count]; i++) {
        NSMutableDictionary *dict = [arr objectAtIndex:i];
        NSString *title = [dict objectForKey:@"title"];
        NSLog(@"%@",title);
        [titleArray addObject:title];
    }
    
    [self.titleDic setObject:titleArray forKey:titleType];
    [self.tableView reloadData];
    
}
#pragma mark--微信分享需要的代理方法
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
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
