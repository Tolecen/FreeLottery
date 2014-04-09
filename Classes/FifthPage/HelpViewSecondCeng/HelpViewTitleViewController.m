//
//  HelpViewTitleViewController.m
//  RuYiCai
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HelpViewTitleViewController.h"
#import "SBJsonParser.h"
#import "RuYiCaiNetworkManager.h"
#import "HelpContentViewController.h"
#import "BackBarButtonItemUtils.h"
#import "NewMoreCell.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@implementation HelpViewTitleViewController

@synthesize myTableView = m_myTableView;
@synthesize titleArr = m_titleArr;
@synthesize helpType = m_helpType;
@synthesize navigationController = _navigationController;

-(id)initWithHelpType:(HelpType) type{
    if (self = [super init]) {
        self.helpType = type;
    }
    return self;
}
- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    [m_titleArr release], m_titleArr = nil;
    [_navigationController release]; _navigationController = nil;
    [m_titleArr release], m_titleArr = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 107) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.backgroundView = [[UIView alloc]init];
    m_myTableView.backgroundColor  = [UIColor clearColor];
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_myTableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.titleArr = [[[NSMutableArray alloc] initWithCapacity:1]autorelease];
    if (self.helpType == TypeOfGongNengZhiYin) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHelpTitleWithGNZYOK:) name:@"queryHelpTitleWithGNZYOK" object:nil];
    }else if (self.helpType == TypeOfCaiPiaoWanFa){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHelpTitleWithCPWFOK:) name:@"queryHelpTitleWithCPWFOK" object:nil];
    }else if (self.helpType == TypeOfChangJianWenTi){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHelpTitleWithCJWTOK:) name:@"queryHelpTitleWithCJWTOK" object:nil];
    }else if (self.helpType == TypeOfCaiPiaoShuYu){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryHelpTitleWithCPSYOK:) name:@"queryHelpTitleWithCPSYOK" object:nil];
    }
    
    [RuYiCaiNetworkManager sharedManager].netHelpCenterCenter = NET_HELP_QUERY_TITLE;
    [[RuYiCaiNetworkManager sharedManager] queryHelpTitleWithType:[NSString stringWithFormat:@"%d", self.helpType]];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHelpTitleWithGNZYOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHelpTitleWithCPWFOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHelpTitleWithCJWTOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryHelpTitleWithCPSYOK" object:nil];
    

}
- (void)queryHelpTitleOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    [self.titleArr removeAllObjects];
    [self.titleArr addObjectsFromArray:[parserDict objectForKey:@"result"]];//开奖提醒
    
    [self.myTableView reloadData];
}
- (void)queryHelpTitleWithGNZYOK:(NSNotification*)notification{
    NSLog(@"queryHelpTitleWithGNZYOK");
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    NSLog(@"parserDict:%@",parserDict);
    [self.titleArr removeAllObjects];
    [self.titleArr addObjectsFromArray:[parserDict objectForKey:@"result"]];//开奖提醒
//    [self.titleArr addObject:@"赠送彩票"];
    NSLog(@"%@",self.titleArr);
    [self.myTableView reloadData];
}
- (void)queryHelpTitleWithCPWFOK:(NSNotification*)notification{
    NSTrace();
    NSLog(@"queryHelpTitleWithCPWFOK");
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    
    NSLog(@"parserDict:%@",parserDict);
    
    [self.titleArr removeAllObjects];
    [self.titleArr addObjectsFromArray:[parserDict objectForKey:@"result"]];//开奖提醒
    
    [self.myTableView reloadData];
}
- (void)queryHelpTitleWithCJWTOK:(NSNotification*)notification{
    NSLog(@"queryHelpTitleWithCJWTOK");
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    NSLog(@"parserDict:%@",parserDict);
    [self.titleArr removeAllObjects];
    [self.titleArr addObjectsFromArray:[parserDict objectForKey:@"result"]];//开奖提醒
    
    [self.myTableView reloadData];
}
- (void)queryHelpTitleWithCPSYOK:(NSNotification*)notification{
    NSLog(@"queryHelpTitleWithCPSYOK");
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].responseText];
    [jsonParser release];
    NSLog(@"parserDict:%@",parserDict);
    [self.titleArr removeAllObjects];
    [self.titleArr addObjectsFromArray:[parserDict objectForKey:@"result"]];//开奖提醒
    
    [self.myTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [self.titleArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"helpViewTitleViewCell";
    
    NewMoreCell *cell = (NewMoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NewMoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.numberLable setHidden:YES];
    [cell.subLable setHidden:YES];
    cell.titleLable.text  = [[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"title"];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [self setHidesBottomBarWhenPushed:YES];
    
    NSLog(@"didSelectRowAtIndexPath - titleArr:%@",self.titleArr);
    
    if ([self.titleArr count]!= 0) {
        HelpContentViewController* viewController = [[HelpContentViewController alloc] init];
        viewController.title = self.title;//[[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"title"];
        viewController.contentId = [[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"id"];
        viewController.contentTitle = [[self.titleArr objectAtIndex:indexPath.row]objectForKey:@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    

}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMoreCell *moreCell = (NewMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
    moreCell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo_click.png"];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMoreCell *moreCell = (NewMoreCell *)[tableView cellForRowAtIndexPath:indexPath];
    moreCell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        NewMoreCell *moreCell = (NewMoreCell *)[tableView cellForRowAtIndexPath:currentSelectedIndexPath];
        moreCell.accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [tableView deselectRowAtIndexPath:currentSelectedIndexPath animated:NO];
    }
}

@end
