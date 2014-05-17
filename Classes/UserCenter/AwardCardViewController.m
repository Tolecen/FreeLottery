//
//  AwardCardViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-5-14.
//
//

#import "AwardCardViewController.h"

@interface AwardCardViewController ()

@end

@implementation AwardCardViewController
@synthesize tableV = _tableV;
@synthesize dataArray = _dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = [[NSArray alloc] init];
    }
    return self;
}
-(void)dealloc
{
    [self.dataArray release];
    [_tableV release];
    [super dealloc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryActListOK:) name:@"queryActListOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryActListFail) name:@"queryActListFail" object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryActListOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryActListFail" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-50-64)];
    [self.view addSubview:_tableV];
    _tableV.rowHeight = 70;
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [_tableV release];
    
    UIImageView* bottomBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 113, 320, 50)];
    bottomBarImageView.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:bottomBarImageView];
    [bottomBarImageView release];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);
    [leftButton setTitle:@"上一页" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action: @selector(pageUpClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(240, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);
    [rightButton setTitle:@"下一页" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action: @selector(pageDownClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];


    [[RuYiCaiNetworkManager sharedManager] queryMyAwardCardListWithPage:@"0"];
	// Do any additional setup after loading the view.
}
-(void)queryActListOK:(NSNotification *)noti
{
    _dataArray = [(NSArray *)[(NSDictionary *)noti.object objectForKey:@"result"] retain];
    totalPageCount = [[(NSDictionary *)noti.object objectForKey:@"totalPage"] intValue];
    [_tableV reloadData];
}
-(void)queryActListFail
{
    UILabel * sss = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
    [sss setBackgroundColor:[UIColor clearColor]];
    [sss setText:@"暂无记录"];
    [sss setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:sss];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cardDict = _dataArray[indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifiertypeone";
    ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
        cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleName = [cardDict objectForKey:@"name"];
    NSString * timeStr = [cardDict objectForKey:@"partakeTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateS = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000]];
    [formatter release];
    cell.littleTitleName = [dateS stringByAppendingString:@" 获得"];
    cell.iconImageName = [cardDict objectForKey:@"icon"];
    [cell refresh];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cardDict = _dataArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    AwardCardDetailViewController * awV = [[AwardCardDetailViewController alloc] init];
    awV.navigationItem.title = @"任务卡详情";
    awV.nameStr = [cardDict objectForKey:@"name"];
    NSString * timeStr = [cardDict objectForKey:@"partakeTime"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* dateS = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]/1000]];
    [formatter release];
    awV.timeStr = [dateS stringByAppendingString:@" 获得"];
    awV.awardStr = [cardDict objectForKey:@"award"];
    awV.desStr = [cardDict objectForKey:@"description"];
    
    [self.navigationController pushViewController:awV animated:YES];
    
    [awV release];

}
- (void)pageUpClick:(id)sender
{
    if (curPageIndex<=0) {
        return;
    }
    curPageIndex--;
    [[RuYiCaiNetworkManager sharedManager] queryMyAwardCardListWithPage:[NSString stringWithFormat:@"%d",curPageIndex]];
}
- (void)pageDownClick:(id)sender
{
    if (curPageIndex+1>=totalPageCount) {
        return;
    }
    curPageIndex++;
    [[RuYiCaiNetworkManager sharedManager] queryMyAwardCardListWithPage:[NSString stringWithFormat:@"%d",curPageIndex]];
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
