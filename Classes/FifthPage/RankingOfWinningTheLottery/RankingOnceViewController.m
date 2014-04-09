//
//  RankingOnceViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-5-13.
//
//

#import "RankingOnceViewController.h"
#import "TopWinnerTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define REFRESH_HEADER_HEIGHT 52.0f

@interface RankingOnceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView       *_winTableView;
    NSMutableArray    *_topWinArray;
    BOOL                            isRefresWinner;
    BOOL                            isLoading;
    BOOL                            isDragging;
    NSInteger                             topWay;
    UILabel                         *_refreshLabel;
    UIImageView                     *_refreshImagView;
    UIView                          *_refreshHeaderView;
    UIActivityIndicatorView         *_refreshSpinner;
    UILabel                         *_refreshDate;
    
}
@property (nonatomic ,retain) UITableView       *winTableView;
@property (nonatomic ,retain) NSMutableArray           *topWinArray;
@property (nonatomic, retain) UILabel                         *refreshDate;
@property (nonatomic, retain) UIActivityIndicatorView         *refreshSpinner;
@property (nonatomic, retain) UIView                          *refreshHeaderView;
@property (nonatomic, retain) UIImageView                     *refreshImagView;
@property (nonatomic, retain) UILabel                         *refreshLabel;

- (void)startLoading;
- (void)stopLoading;
- (void)addPullToRefreshHeader;

@end

@implementation RankingOnceViewController
@synthesize winTableView = _winTableView;
@synthesize topWinArray     = _topWinArray;
@synthesize rankingType = _rankingType;

//上拉刷新相关
@synthesize refreshLabel       = _refreshLabel;
@synthesize refreshImagView       = _refreshImagView;
@synthesize refreshHeaderView   =_refreshHeaderView;
@synthesize refreshSpinner      =_refreshSpinner;
@synthesize refreshDate         =_refreshDate;


-(void)dealloc{
    
    [super dealloc];
    [_winTableView release];
    [_topWinArray release];
    [_refreshDate release];
    [_refreshSpinner release];
    [_refreshHeaderView release];
    [_refreshLabel release];
    
}

-(id)initWithRankingType:(RankingType)type{
    self = [super init ];
    if (self) {
        topWay = type;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
#ifndef isBOYA 
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topWinnerOK:) name:@"topWinnerOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed:) name:@"netFailed" object:nil];
#endif

    isRefresWinner = YES;
    isLoading    =NO;
    isDragging = NO;
    
    self.topWinArray = [NSMutableArray array];

    self.winTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)]autorelease];
    
    self.winTableView.rowHeight = 40;
    self.winTableView.delegate = self;
    self.winTableView.dataSource = self;
    self.winTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.winTableView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#efede9"]];
    [self.view addSubview:_winTableView];
    [self addPullToRefreshHeader];
    [self startLoading];//刷新排行
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
#ifndef isBOYA
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"topWinnerOK" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"netFailed" object:nil];
#endif
    
}

#pragma  mark -tableDelegate and tableDateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TopWinnerTableViewCell";
    TopWinnerTableViewCell *cell = (TopWinnerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[TopWinnerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSString *rankingNumImageName = [NSString stringWithFormat:@"ranking_num_%d",indexPath.row + 1];
    cell.numImage.image = RYCImageNamed(rankingNumImageName);
    cell.winName = @"获取中...";
    cell.winNum = @"0";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.num = indexPath.row + 1;
    NSLog(@"%d",[self.topWinArray count]);
    NSLog(@"%d",indexPath.row);
    if ([self.topWinArray count]> indexPath.row) {
        NSDictionary* subDict = (NSDictionary*)[self.topWinArray objectAtIndex:indexPath.row];
        if (subDict) {
            cell.winName = [subDict objectForKey:@"name"];
            cell.winNum = [subDict objectForKey:@"prizeAmt"];
        }
    }
    [cell refresh];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.winTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark -上拉刷新
- (void)addPullToRefreshHeader
{
//屏蔽中奖排行下拉刷新
//    _refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
//    _refreshHeaderView.backgroundColor = [UIColor clearColor];
//    
//    _refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
//    _refreshLabel.backgroundColor = [UIColor clearColor];
//    _refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
//	_refreshLabel.textColor = [UIColor blackColor];
//    _refreshLabel.textAlignment = UITextAlignmentCenter;
//    
//    
//    _refreshImagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
//    _refreshImagView.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
//                                         (REFRESH_HEADER_HEIGHT - 44) / 2,
//                                         27, 44);
//    
//    _refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
//    _refreshSpinner.hidesWhenStopped = YES;
//    
//    _refreshDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 20)];
//    _refreshDate.backgroundColor = [UIColor clearColor];
//    _refreshDate.font = [UIFont boldSystemFontOfSize:12.0];
//	_refreshDate.textColor = [UIColor blackColor];
//    _refreshDate.textAlignment = UITextAlignmentCenter;
//    [_refreshHeaderView addSubview:_refreshDate];
//    
//	[_refreshHeaderView addSubview:_refreshImagView];
//    [_refreshHeaderView addSubview:_refreshSpinner];
//    [_refreshHeaderView addSubview:_refreshLabel];
//    [self.winTableView addSubview:_refreshHeaderView];
    
    
}
- (void)startLoading
{
//屏蔽中奖排行下拉刷新
//    isLoading = YES;
//    
//    // Show the header
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    self.winTableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
//    _refreshLabel.text = @"正在刷新⋯⋯";
//    _refreshImagView.hidden = YES;
//    [_refreshSpinner startAnimating];
//    [UIView commitAnimations];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
//屏蔽中奖排行下拉刷新
//    isLoading = NO;
//    
//    // Hide the header
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
//    self.winTableView.contentInset = UIEdgeInsetsZero;
//    [_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//    [UIView commitAnimations];
//    
//    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
//	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
//	_refreshDate.text = [NSString stringWithFormat:@"最后更新时间：%@", now];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
//屏蔽中奖排行下拉刷新
//    _refreshLabel.text = @"下拉刷新⋯⋯";
//    _refreshImagView.hidden = NO;
//    [_refreshSpinner stopAnimating];
}

- (void)refresh
{
    [[RuYiCaiNetworkManager sharedManager] getTopWinnerInformation];
}

#pragma mark -scroll delegate
//屏蔽中奖排行下拉刷新
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    CGPoint offsetofScrollView = scrollView.contentOffset;
//    
//	NSInteger page = offsetofScrollView.x / scrollView.frame.size.width;
//    
//	
//	if(0 == page)
//	{
//        if (isLoading) return;
//        isDragging = YES;
//	}
//}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (isLoading)
//	{
//        if (self.winTableView.contentOffset.y > 0)
//            self.winTableView.contentInset = UIEdgeInsetsZero;
//        else if (self.winTableView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
//            self.winTableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    }
//	else if (isDragging && self.winTableView.contentOffset.y < 0)
//	{
//        [UIView beginAnimations:nil context:NULL];
//        if (self.winTableView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
//		{
//            _refreshLabel.text = @"松手开始刷新⋯⋯";
//            [_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        }
//		else
//		{
//            _refreshLabel.text = @"下拉刷新⋯⋯";
//            
//            [_refreshImagView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//        }
//        [UIView commitAnimations];
//    }
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//	CGPoint offsetofScrollView = scrollView.contentOffset;
//    
//    //[m_pageController setCurrentPage:offsetofScrollView.x / self.scroll.frame.size.width];
//    
//	NSInteger page = offsetofScrollView.x / scrollView.frame.size.width;
//    
//	CGRect rect = CGRectMake(page * scrollView.frame.size.width, 0,
//                             scrollView.frame.size.width, scrollView.frame.size.height);
//    [scrollView scrollRectToVisible:rect animated:YES];
//}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (isLoading) return;
//    isDragging = NO;
//    if (self.winTableView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
//	{
//        // Released above the header
//        [self startLoading];
//    }
//}
#pragma mark -notification
- (void)topWinnerOK:(NSNotification*)notification{
    NSLog(@"topWinnerOK");
    [self stopLoading];
    
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].TopWinnerInformation];
    [jsonParser release];
    
    switch (topWay)
    {
        case 0:
            self.topWinArray = (NSMutableArray*)[parserDict objectForKey:@"weekArray"];
            break;
        case 1:
            self.topWinArray = (NSMutableArray*)[parserDict objectForKey:@"monthArray"];
            break;
        case 2:
            self.topWinArray = (NSMutableArray*)[parserDict objectForKey:@"totalArray"];
            break;
        default:
            break;
    }
    [self.winTableView reloadData];
    
    NSLog(@"aaa %@",self.topWinArray);
}
- (void)netFailed:(NSNotification*)notification
{
    NSLog(@"netFailed");
    [self stopLoading];
}

#pragma  mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
