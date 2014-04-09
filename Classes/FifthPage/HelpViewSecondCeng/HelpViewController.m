//
//  HelpViewController.m
//  RuYiCai
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpViewTitleViewController.h"
#import "RYCImageNamed.h"
#import "BackBarButtonItemUtils.h"
#import "SchiebenViewUitils.h"
#import "FireUIPagedScrollView.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"


@interface HelpViewController ()<SchiebenViewUitilsDelegate,FireUIPagedScrollViewDelegate>
{
    SchiebenViewUitils *schiebenView;
    FireUIPagedScrollView *pageScrollView;
}

@end

@implementation HelpViewController

@synthesize myTableView = m_myTableView;

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    
    [super dealloc];
}
- (id)init
{
    
    [super init];
    return self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    
    pageScrollView = [[FireUIPagedScrollView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 104)];
    pageScrollView.pagerDelegate = self;
    
    [self.view addSubview:pageScrollView];
    
    
    schiebenView = [[SchiebenViewUitils alloc] initWithFrame:CGRectMake(0, 0, 320, 40) andTitles:[NSArray arrayWithObjects:@"功能指引",@"彩票玩法",@"常见问题",@"彩票术语", nil]  andFontSize:14.0f];
    schiebenView.delegate = self;
    [self.view addSubview:schiebenView];
    
    HelpViewTitleViewController* gongNengZhiYinVC = [[HelpViewTitleViewController alloc] initWithHelpType:TypeOfGongNengZhiYin];
    gongNengZhiYinVC.navigationController = self.navigationController;
    gongNengZhiYinVC.title = @"功能指引";
    HelpViewTitleViewController* caiPiaoWanFaVC = [[HelpViewTitleViewController alloc] initWithHelpType:TypeOfCaiPiaoWanFa];
    caiPiaoWanFaVC.navigationController = self.navigationController;
    caiPiaoWanFaVC.title = @"彩票玩法";
    HelpViewTitleViewController* changJianWenTiVC = [[HelpViewTitleViewController alloc] initWithHelpType:TypeOfChangJianWenTi];
    changJianWenTiVC.navigationController = self.navigationController;
    changJianWenTiVC.title = @"常见问题";
    HelpViewTitleViewController* caiPiaoShuYuVC = [[HelpViewTitleViewController alloc] initWithHelpType:TypeOfCaiPiaoShuYu];
    caiPiaoShuYuVC.navigationController = self.navigationController;
    caiPiaoShuYuVC.title = @"彩票术语";
    
    [pageScrollView addPagedViewController:gongNengZhiYinVC];
    [pageScrollView addPagedViewController:caiPiaoWanFaVC];
    [pageScrollView addPagedViewController:changJianWenTiVC];
    [pageScrollView addPagedViewController:caiPiaoShuYuVC];
    
    
    
//    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
//    m_myTableView.delegate = self;
//    m_myTableView.dataSource = self;
//    m_myTableView.backgroundView = [[[UIView alloc]init] autorelease];
//    m_myTableView.backgroundColor  = [UIColor clearColor];
//    [self.view addSubview:m_myTableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [pageScrollView pagedViewWillAppear:animated];
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


- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//
//#pragma mark - Table view data source
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
//{ 
//    return 5;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    if(0 == indexPath.row)
//    {
//        cell.textLabel.text = @"功能指引";
//    }
//    else if(1 == indexPath.row)
//    {
//        cell.textLabel.text = @"特色功能";
//    }
//    else if(2 == indexPath.row)
//    {
//        cell.textLabel.text = @"彩票玩法";
//    }
//    else if(3 == indexPath.row)
//    {
//        cell.textLabel.text = @"常见问题";
//    }
//    else
//    {
//        cell.textLabel.text = @"彩票术语";
//    }
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
//    return cell;
//}
//
//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{    
//    [self setHidesBottomBarWhenPushed:YES];
//    
//    HelpViewTitleViewController* viewController = [[HelpViewTitleViewController alloc] init];
//    switch (indexPath.row) {
//        case 0:
//            viewController.title = @"功能指引";
//            viewController.helpType = 1;
//            break;
//        case 1:
//            viewController.title = @"特色功能";
//            viewController.helpType = 2;
//            break;
//        case 2:
//            viewController.title = @"彩票玩法";
//            viewController.helpType = 3;
//            break;
//        case 3:
//            viewController.title = @"常见问题";
//            viewController.helpType = 4;
//            break;
//        case 4:
//            viewController.title = @"彩票术语";
//            viewController.helpType = 5;
//            break;
//        default:
//            break;
//    }
//    [self.navigationController pushViewController:viewController animated:YES];
//    [viewController release];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}
//
@end
