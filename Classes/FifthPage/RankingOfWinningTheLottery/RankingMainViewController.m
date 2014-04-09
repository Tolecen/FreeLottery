//
//  RankingMainViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-5-13.
//
//

#import "RankingMainViewController.h"
#import "FireUIPagedScrollView.h"
#import "SchiebenViewUitils.h"
#import "RankingViewController.h"
#import "RankingOnceViewController.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@interface RankingMainViewController ()<SchiebenViewUitilsDelegate,FireUIPagedScrollViewDelegate>
{
    SchiebenViewUitils *schiebenView;
    FireUIPagedScrollView *pageScrollView;
}

@end

@implementation RankingMainViewController

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
    [AdaptationUtils adaptation:self];
	// Do any additional setup after loading the view.
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    pageScrollView = [[FireUIPagedScrollView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
    pageScrollView.pagerDelegate = self;
    
    [self.view addSubview:pageScrollView];
    
    
    schiebenView = [[SchiebenViewUitils alloc] initWithFrame:CGRectMake(0, 0, 320, 40) andTitles:[NSArray arrayWithObjects:@"周排行榜",@"月排行榜",@"总排行榜", nil] andFontSize:17.0f];
    schiebenView.delegate = self;
    [self.view addSubview:schiebenView];
    
    RankingOnceViewController *weekRankingView = [[[RankingOnceViewController alloc]initWithRankingType:rankingOfWeekType]autorelease];
    RankingOnceViewController *mouthRankingView = [[[RankingOnceViewController alloc]initWithRankingType:RankingOfMouthType]autorelease];
    RankingOnceViewController *totleRankingView = [[[RankingOnceViewController alloc]initWithRankingType:RankingOfTotalType]autorelease];
    
    [pageScrollView addPagedViewController:weekRankingView];
    [pageScrollView addPagedViewController:mouthRankingView];
    [pageScrollView addPagedViewController:totleRankingView];
    
}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -schiebenSegmentedControl delegate
- (void)schiebenSegmentedControl:(SchiebenViewUitils *)schiebenSegmentedControl didSelectItemAtIndex:(NSUInteger)index
{
    [pageScrollView gotoPage:index animated:YES];
}

#pragma mark -FireUIPagedScrollView delegate
-(void)firePagerChanged:(FireUIPagedScrollView *)pager pagesCount:(NSInteger)pagesCount currentPageIndex:(NSInteger)currentPageIndex{
    [schiebenView gotoPage:currentPageIndex AddAnimation:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
