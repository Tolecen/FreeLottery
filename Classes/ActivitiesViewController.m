//
//  ActivitiesViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-27.
//
//

#import "ActivitiesViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "ActionView.h"
#import "RuYiCaiNetworkManager.h"
@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController
@synthesize listTableV;
@synthesize timeStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [actsArray release];
    [self.listTableV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary * actoneDict = [NSDictionary dictionaryWithObjectsAndKeys:@"新手任务:累计赚取5000彩豆，即送500彩豆",@"actDescribe",@"no",@"actName",@"4000/5000",@"progress",@"1397559130",@"experTime",@"1",@"type",@"1",@"status", nil];
    NSDictionary * actTwoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"每日签到，即送彩豆",@"actDescribe",@"每日签到",@"actName",@"-1",@"status", @"2",@"type",nil];
    NSDictionary * actThreeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"给我5星好评，送彩豆哦",@"actDescribe",@"五星好评，送彩豆",@"actName",@"-1",@"status",@"3",@"type", nil];
    actsArray = [[NSMutableArray alloc] initWithObjects:actoneDict,actTwoDict,actThreeDict, nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    
//    if (self.isShowBackButton) {
//        [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backAction:) andAutoPopView:NO];
//        
//    }
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [RuYiCaiNetworkManager sharedManager].thirdViewController = self;
    
    self.navigationItem.title = @"活动中心";
    //    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(backAction:) andAutoPopView:NO];
    //    self.navigationItem.title = @"积分换彩";
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, h-44-50-20) style:UITableViewStylePlain];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.rowHeight = 80;
    [self.listTableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.listTableV];
    if([[RuYiCaiNetworkManager sharedManager] testConnection])
    {
        ActionView* actionV = [[ActionView alloc]init];
        if (actionV.actionType) {
            actionV.frame = CGRectMake(0, h - 194, 0, 0);
        }else
        {
            actionV.frame = CGRectMake(0, h - 154, 0, 0);
        }
        [self.view addSubview:actionV];
        [actionV release];
    }
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
//    NSTimeInterval hhh = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"nowTime:%f",hhh);
    NSString * sss = [actsArray[0] objectForKey:@"experTime"];
    if (sss) {
        [self calRemainingTime:sss];
    }
    [self.listTableV reloadData];
    
}
-(void)calRemainingTime:(NSString *)remainTime
{
    NSTimeInterval hhh = [[NSDate date] timeIntervalSince1970];
    NSString * endTimeStr = remainTime;//剩余秒数
    double leftTime = [endTimeStr doubleValue] - hhh;
	if (leftTime > 0)
	{
        int numDay = (int)(leftTime / (3600.0 * 24));
        leftTime -= numDay *(3600*24);
        int numHour = (int)(leftTime / 3600.0);
        leftTime -= numHour * 3600.0;
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
        //		int numSecond = (int)(leftTime);
        if (numDay>0) {
            self.timeStr = [NSString stringWithFormat:@"%02d天%02d时%02d分",numDay,numHour, numMinute];
        }
        else
            self.timeStr = [NSString stringWithFormat:@"%02d时%02d分",
                   numHour, numMinute];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * actV = actsArray[indexPath.row];
    if ([[actV objectForKey:@"type"] isEqualToString:@"1"]) {
        static NSString *cellIdentifier = @"cellIdentifiertypetwo";
        ActivityTypeTwoCell* cell = (ActivityTypeTwoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell)
            cell = [[[ActivityTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = [actV objectForKey:@"actDescribe"];
        cell.progressLabel.text = [actV objectForKey:@"progress"];
        if ([[actV objectForKey:@"status"] isEqualToString:@"0"]) {
            cell.tLabel.textColor = [UIColor grayColor];
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.progressLabel.textColor = [UIColor grayColor];
            cell.timeLabel.textColor = [UIColor grayColor];
            cell.timeLabel.text = @" ";
            [cell.statusImgV setImage:[UIImage imageNamed:@"taskcompleted"]];
        }
        else if ([[actV objectForKey:@"status"] isEqualToString:@"-1"]) {
            cell.tLabel.textColor = [UIColor grayColor];
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.progressLabel.textColor = [UIColor grayColor];
            cell.timeLabel.textColor = [UIColor grayColor];
            cell.timeLabel.text = @" ";
            [cell.statusImgV setImage:[UIImage imageNamed:@"taskexpired"]];
        }
        else
        {
            cell.tLabel.textColor = [UIColor redColor];
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.progressLabel.textColor = [UIColor redColor];
            cell.timeLabel.textColor = [UIColor grayColor];
            cell.timeLabel.text = self.timeStr;
            [cell.statusImgV setImage:nil];
        }
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"cellIdentifiertypeone";
        ActivityTypeOneCell* cell = (ActivityTypeOneCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell)
            cell = [[[ActivityTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageV.image = [UIImage imageNamed:@"act-caidou"];
        cell.nameLabel.text = [actV objectForKey:@"actName"];
        cell.descriptionLabel.text = [actV objectForKey:@"actDescribe"];
        if ([[actV objectForKey:@"type"] isEqualToString:@"2"]) {
            
            [cell.doitBtn setTitle:@"立刻签到" forState:UIControlStateNormal];
            [cell.doitBtn addTarget:self action:@selector(doQianDao) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            [cell.doitBtn setTitle:@"立刻好评" forState:UIControlStateNormal];
            [cell.doitBtn addTarget:self action:@selector(toCommentInAppStore) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([[actV objectForKey:@"status"] isEqualToString:@"0"]) {
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.doitBtn.hidden = YES;
            [cell.statusImgV setImage:[UIImage imageNamed:@"taskcompleted"]];
        }
        else if ([[actV objectForKey:@"status"] isEqualToString:@"-1"]) {
            cell.nameLabel.textColor = [UIColor grayColor];
            cell.doitBtn.hidden = YES;
            [cell.statusImgV setImage:[UIImage imageNamed:@"taskexpired"]];
        }
        else
        {
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.doitBtn.hidden = NO;
            [cell.statusImgV setImage:nil];
        }
        return cell;
    }
    
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSString * sss = [actsArray[0] objectForKey:@"experTime"];
    if (sss) {
        [self calRemainingTime:sss];
    }
    [self.listTableV reloadData];
}
-(void)doQianDao
{
    [m_delegate.activityView activityViewShow];
    [m_delegate.activityView.titleLabel setText:@"签到中..."];
    [self performSelector:@selector(theQianDaoSuccess) withObject:nil afterDelay:2];
}
-(void)theQianDaoSuccess
{
    [m_delegate.activityView disActivityView];
}
-(void)toCommentInAppStore
{
    NSURL *url = [NSURL URLWithString:kAppStorPingFen];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
