//
//  RankingViewController.m
//  Boyacai
//
//  Created by qiushi on 13-3-18.
//
//

#import "RankingViewController.h"
#import "BackBarButtonItemUtils.h"
#import "RuYiCaiNetworkManager.h"
#import "TopWinnerTableViewCell.h"
#import "AdaptationUtils.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface RankingViewController ()

- (void)startLoading;
- (void)stopLoading;
- (void)addPullToRefreshHeader;
@end

@implementation RankingViewController

@synthesize schiebenView    = m_schiebenView;
@synthesize topWinArray     = m_topWinArray;
@synthesize winTableView    = m_winTableView;
@synthesize rankingScorollView = m_rankingScorollView;
@synthesize refreshLabel       = m_refreshLabel;
@synthesize refreshImagView       = m_refreshImagView;
@synthesize refreshHeaderView   =m_refreshHeaderView;
@synthesize refreshSpinner      =m_refreshSpinner;
@synthesize refreshDate         =m_refreshDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [m_refreshSpinner release];
    [m_refreshHeaderView release];
    [m_refreshImagView release];
    [m_refreshLabel release];
    [m_rankingScorollView release];
    [m_winTableView release];
    [m_topWinArray release];
    [m_schiebenView release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
#ifndef isBOYA
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"topWinnerOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
#endif
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#ifndef isBOYA
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topWinnerOK:) name:@"topWinnerOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
#endif
    [self scrollViewDidEndDecelerating:self.rankingScorollView];
//    [self updateLoginStatus];
//    [self clearBetData];//清空投注数据
//    [self queryOpenState]; //今日开奖、加奖
//    [self setNewButtonFrame];//彩种布局
    
	if ([RuYiCaiNetworkManager sharedManager].hasLogin)//取余额
    {
        [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_BALANCE;
        [[RuYiCaiNetworkManager sharedManager] queryUserBalance];
    }
	
    
    //    if(!m_versionStrArray)
    //    {
    //        m_versionStrArray = [[[RuYiCaiNetworkManager sharedManager] getSoftwareVersionInfo] retain];
    //        m_versionLabel.text = [m_versionStrArray objectAtIndex:0];
    //    }
    //    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
//    [BackBarButtonItemUtils addBackButtonForController:self];
    
    isRefresWinner = YES;
    topWay = 0;
    isLoading    =NO;
    isDragging = NO;
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    [RuYiCaiNetworkManager sharedManager].rankingViewController = self;
//刷新得scorllView 创建
    CGRect frame = CGRectMake(6, 39, 308, [UIScreen mainScreen].bounds.size.height-100);
	m_rankingScorollView = [[UIScrollView alloc] initWithFrame:frame];
	m_rankingScorollView.pagingEnabled = YES;
	m_rankingScorollView.delegate = self;
	m_rankingScorollView.showsHorizontalScrollIndicator = NO;
    
    m_rankingScorollView.backgroundColor = [UIColor clearColor];
    m_rankingScorollView.scrollEnabled = YES;
    m_rankingScorollView.bounces = NO;
    
    
    [self.view addSubview:self.rankingScorollView];
    

    //滑动按钮控件创建
//    self.schiebenView = [[SchiebenViewUitils alloc] initWithFrame:CGRectMake(0, 0, 320, 40) andTitles:[NSArray arrayWithObjects:@"周排行榜",@"月排行榜",@"总排行榜", nil]];
//    m_schiebenView.delegate = self;
//    [self.view addSubview:m_schiebenView];
    
}


- (void)topWinnerOK:(NSNotification*)notification
{
    //    [self.winTableView removeFromSuperview];
    //    [self.winTableView release];
    
    [self stopLoading];
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].TopWinnerInformation];
    [jsonParser release];
    
    switch (topWay)
    {
        case 0:
            self.topWinArray = (NSArray*)[parserDict objectForKey:@"weekArray"];
            break;
        case 1:
            self.topWinArray = (NSArray*)[parserDict objectForKey:@"monthArray"];
            break;
        case 2:
            self.topWinArray = (NSArray*)[parserDict objectForKey:@"totalArray"];
            break;
        default:
            break;
    }
    self.winTableView.dataSource = self;
    [self.winTableView reloadData];
    
    NSLog(@"aaa %@",self.topWinArray);
    //    [self.winTableView removeFromSuperview];
    //     [self.scroll addSubview:self.winTableView];
    //[self.winTableView reloadData];
    //[refreshHeaderView removeFromSuperview];
    //[refreshHeaderView release];
    //[self addPullToRefreshHeader];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGPoint offsetofScrollView = scrollView.contentOffset;
    
    //[m_pageController setCurrentPage:offsetofScrollView.x / self.scroll.frame.size.width];
    
	NSInteger page = offsetofScrollView.x / self.rankingScorollView.frame.size.width;

        if(isRefresWinner)
        {
            m_winTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 308, [UIScreen mainScreen].bounds.size.height-100)];
            
            self.winTableView.rowHeight = 41;
            self.winTableView.delegate = self;
            [self.rankingScorollView addSubview:self.winTableView];
            
            m_topWinArray = [[NSArray alloc] init];
            [self addPullToRefreshHeader];
            
            [[RuYiCaiNetworkManager sharedManager] getTopWinnerInformation];
            
            isRefresWinner = NO;
        }

	CGRect rect = CGRectMake(page * self.rankingScorollView.frame.size.width, 0,
                             self.rankingScorollView.frame.size.width, self.rankingScorollView.frame.size.height);
    [self.rankingScorollView scrollRectToVisible:rect animated:YES];
}
#ifndef isBOYA
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint offsetofScrollView = scrollView.contentOffset;
    
	NSInteger page = offsetofScrollView.x / self.rankingScorollView.frame.size.width;
	
	if(0 == page)
	{
        if (isLoading) return;
        isDragging = YES;
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading)
	{
        if (self.winTableView.contentOffset.y > 0)
            self.winTableView.contentInset = UIEdgeInsetsZero;
        else if (self.winTableView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.winTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
	else if (isDragging && self.winTableView.contentOffset.y < 0)
	{
        [UIView beginAnimations:nil context:NULL];
        if (self.winTableView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
		{
            m_refreshLabel.text = @"松手开始刷新⋯⋯";
            [m_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
		else
		{
            m_refreshLabel.text = @"下拉刷新⋯⋯";
            
            [m_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (self.winTableView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
	{
        // Released above the header
        [self startLoading];
    }
}
#endif


//#pragma mark -schiebenSegmentedControl delegate
//- (void)schiebenSegmentedControl:(SchiebenViewUitils *)schiebenSegmentedControl didSelectItemAtIndex:(NSUInteger)index
//{
//        if (index==0)
//        {
//            topWay=0;
//            [self pushZhouButton];
//        }else if(index==1)
//        {
//            topWay=1;
//            [self pushYueButton];
//        }else if(index==2)
//        {
//            topWay=2;
//            [self pushZongButton];
//        }
//}
//
//#pragma mark 三个按钮分别触发得事件
//- (void)pushZhouButton
//{
//        
//        SBJsonParser *jsonParser = [SBJsonParser new];
//        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].TopWinnerInformation];
//        [jsonParser release];
//        
//        self.topWinArray = (NSArray*)[parserDict objectForKey:@"weekArray"];
//        [self.winTableView reloadData];
//     
//}
//- (void)pushYueButton
//{
//        SBJsonParser *jsonParser = [SBJsonParser new];
//        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].TopWinnerInformation];
//        [jsonParser release];
//        
//        self.topWinArray = (NSArray*)[parserDict objectForKey:@"monthArray"];
//        [self.winTableView reloadData];
//  
//}
//
//- (void)pushZongButton
//{
//
//        SBJsonParser *jsonParser = [SBJsonParser new];
//        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].TopWinnerInformation];
//        [jsonParser release];
//        
//        self.topWinArray = (NSArray*)[parserDict objectForKey:@"totalArray"];
//        [self.winTableView reloadData];
//   
//}
//
#pragma  mark tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topWinArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    TopWinnerTableViewCell *cell = (TopWinnerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[TopWinnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
    }
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.numImage.image = RYCImageNamed(@"num1.png");
            break;
        }
        case 1:
        {
            cell.numImage.image = RYCImageNamed(@"num2.png");
            break;
        }
        case 2:
        {
            cell.numImage.image = RYCImageNamed(@"num3.png");
            break;
        }
        default:
        {
            cell.numImage.image = RYCImageNamed(@"numother.png");
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num = indexPath.row + 1;
    NSDictionary* subDict = (NSDictionary*)[self.topWinArray objectAtIndex:indexPath.row];
    cell.winName = [subDict objectForKey:@"name"];
    cell.winNum = [subDict objectForKey:@"prizeAmt"];
    [cell refresh];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.winTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark 上拉刷新
- (void)addPullToRefreshHeader
{
    m_refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    m_refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    m_refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
    m_refreshLabel.backgroundColor = [UIColor clearColor];
    m_refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
	m_refreshLabel.textColor = [UIColor blackColor];
    m_refreshLabel.textAlignment = UITextAlignmentCenter;
    
    
    m_refreshImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    m_refreshImagView.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                    (REFRESH_HEADER_HEIGHT - 44) / 2,
                                    27, 44);
    
    m_refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
    m_refreshSpinner.hidesWhenStopped = YES;
    
    m_refreshDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 20)];
    m_refreshDate.backgroundColor = [UIColor clearColor];
    m_refreshDate.font = [UIFont boldSystemFontOfSize:12.0];
	m_refreshDate.textColor = [UIColor blackColor];
    m_refreshDate.textAlignment = UITextAlignmentCenter;
    [m_refreshHeaderView addSubview:m_refreshDate];
    
	[m_refreshHeaderView addSubview:m_refreshImagView];
    [m_refreshHeaderView addSubview:m_refreshSpinner];
    [m_refreshHeaderView addSubview:m_refreshLabel];
    [self.winTableView addSubview:m_refreshHeaderView];
}

- (void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.winTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    m_refreshLabel.text = @"正在刷新⋯⋯";
    m_refreshImagView.hidden = YES;
    [m_refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.winTableView.contentInset = UIEdgeInsetsZero;
    [m_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
	m_refreshDate.text = [NSString stringWithFormat:@"最后更新时间：%@", now];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    m_refreshLabel.text = @"下拉刷新⋯⋯";
    m_refreshImagView.hidden = NO;
    [m_refreshSpinner stopAnimating];
}

- (void)refresh
{
    [[RuYiCaiNetworkManager sharedManager] getTopWinnerInformation];
}

- (void)netFailed:(NSNotification*)notification
{
	[self stopLoading];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
