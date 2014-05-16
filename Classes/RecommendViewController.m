//
//  RecommendViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-12.
//
//

#import "RecommendViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "ThirdPageTabelCellView.h"
#import "RuYiCaiNetworkManager.h"
@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView * tableView;
@end

@implementation RecommendViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.navigationItem.title = @"精品推荐";
    float h = 44;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        h = 64;
    }
    UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    lable.backgroundColor = [UIColor clearColor];
    lable.text = @"精品推荐专区,没有彩豆奖励";
    lable.font = [UIFont systemFontOfSize:12];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,20, self.view.frame.size.width, self.view.frame.size.height-h-20)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 70;
    [_tableView release];
    
//    [[RuYiCaiNetworkManager sharedManager] queryRecommandedAppList:@"list"];
//    [[RuYiCaiNetworkManager sharedManager] queryRecommandedAppList:@"topone"];
    [[RuYiCaiNetworkManager sharedManager] queryShakeActList];
    [[RuYiCaiNetworkManager sharedManager] queryshakeSigninDescription];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryRecommandedAppListOK" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRecommandedAppListOK:) name:@"queryRecommandedAppListOK" object:nil];
}
-(void)queryRecommandedAppListOK:(NSNotification *)noti
{
    appListArray = (NSArray *)[[(NSDictionary *)noti.object objectForKey:@"value"] retain];
    [_tableView reloadData];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifierinfo";
    ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSLog(@"GGGGGGGGGGGG:%d",indexPath.row);
    cell.titleName =[appListArray[indexPath.row] objectForKey:@"title"];
    cell.littleTitleName = @"hhkhkkjkjlk";
    cell.iconImageName = [appListArray[indexPath.row] objectForKey:@"icon"]?[appListArray[indexPath.row] objectForKey:@"icon"]:@"qqq";
    
    
    [cell refresh];
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
