//
//  ActivitiesViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-27.
//
//

#import "ActivitiesViewController.h"
#import "RuYiCaiAppDelegate.h"
@interface ActivitiesViewController ()

@end

@implementation ActivitiesViewController
@synthesize listTableV;
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
    NSDictionary * actoneDict = [NSDictionary dictionaryWithObjectsAndKeys:@"新手任务:累计赚取5000彩豆，即送500彩豆",@"actDescribe",@"no",@"actName",@"4000/5000",@"progress",@"3245678900",@"experTime",@"1",@"type", nil];
    NSDictionary * actTwoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"每日签到，即送彩豆",@"actDescribe",@"每日签到",@"actName",@"1",@"status", @"2",@"type",nil];
    NSDictionary * actThreeDict = [NSDictionary dictionaryWithObjectsAndKeys:@"给我5星好评，送彩豆哦",@"actDescribe",@"五星好评，送彩豆",@"actName",@"1",@"ststus",@"3",@"type", nil];
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
	// Do any additional setup after loading the view.
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
        
        return cell;
    }
    
    
}
-(void)doQianDao
{
    [m_delegate.activityView activityViewShow];
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
