//
//  CaipiaoInformationViewController.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CaipiaoInformationViewController.h"
#import "RuYiCaiAppDelegate.h"
#import "ImageIconTableViewCell.h"
#import "InputTableViewCell.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "SBJsonParser.h"
#import "NewsViewController.h"
#import "Custom_tabbar.h"
#import "EachLotInforTableViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

#define kQuWenKey     @"quwen"
#define kZuCaiKey     @"zucai"
#define kHuDongKey    @"huodong"

@interface CaipiaoInformationViewController (internal)

//- (void)setupNavigationBarStatus;
- (void)loginClick;
- (void)changeUserClick;
- (void)segmentedChange:(id)sender;
- (void)getInformationOK:(NSNotification *)notification;
- (void)getInformationContentOK:(NSNotification *)notification;

@end

@implementation CaipiaoInformationViewController

@synthesize segmented = m_segmented;
@synthesize cusSegmented = _cusSegmented;
@synthesize tableView = m_tableView;
@synthesize typeIdDicArray = m_typeIdDicArray;
 
- (void)dealloc 
{
    [m_segmented release];
    [_cusSegmented release];
    [m_loginStatus release];
    [m_button_Login release];
    
    [m_tableView release], m_tableView = nil;

    [m_typeIdDicArray release], m_typeIdDicArray = nil;
    
    [super dealloc];
}

- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationOK:) name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getInformationContentOK:) name:@"getInformationContentOK" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationOK" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getInformationContentOK" object:nil];
    
    [super viewWillDisappear:animated];    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    //返回按钮
    [BackBarButtonItemUtils addBackButtonForController:self];

    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
	
    NSArray *buttonNames ;
    if([RuYiCaiOR91 isEqualToString:@"RuYiCai"])
    {
        buttonNames = [NSArray arrayWithObjects:@"彩民趣闻", @"专家分析", @"足彩天地", @"博雅公告", nil];
    }
    else
    {
        buttonNames = [NSArray arrayWithObjects:@"彩民趣闻", @"专家分析", @"足彩天地", @"91公告", nil];
    }

//    m_segmented = [[UISegmentedControl alloc] initWithItems:buttonNames];
//    m_segmented.segmentedControlStyle = UISegmentedControlStyleBar;
//	m_segmented.tintColor = [UIColor darkGrayColor];
//    [self.view addSubview:m_segmented];
//    [m_segmented setFrame:CGRectMake(-6, 0, 332, 30)];
//    m_segmented.selectedSegmentIndex = 0;
//    [m_segmented addTarget:self action:@selector(segmentedChange:) forControlEvents:UIControlEventValueChanged];
    
    
    self.cusSegmented = [[[CustomSegmentedControl alloc]initWithFrame:CGRectMake(5, 0, 310, 31)
                                                      andNormalImages:[NSArray arrayWithObjects:
                                                                       @"more_information_cmqw_normal.png",
                                                                       @"more_information_zjtj_normal.png",
                                                                       @"more_information_zctd_normal.png",
                                                                       @"more_information_zngg_normal.png",nil]
                                                 andHighlightedImages:[NSArray arrayWithObjects:
                                                                       @"more_information_cmqw_normal.png",
                                                                       @"more_information_zjtj_normal.png",
                                                                       @"more_information_zctd_normal.png",
                                                                       @"more_information_zngg_normal.png",
                                                                       nil]
                                                       andSelectImage:[NSArray arrayWithObjects:
                                                                       @"more_information_cmqw_click.png",
                                                                       @"more_information_zjtj_click.png",
                                                                       @"more_information_zctd_click.png",
                                                                       @"more_information_zngg_click.png",nil]]autorelease];
    
    self.cusSegmented.delegate = self;
    [self.view addSubview:_cusSegmented];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height - 96) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    m_tableView.rowHeight = 35;
    
    NSMutableArray* tempArray_quWen = [[NSMutableArray alloc] init];
    NSMutableArray* tempArray_zuCai = [[NSMutableArray alloc] init];
    NSMutableArray* tempArray_huoDong = [[NSMutableArray alloc] init];
    m_typeIdDicArray = [[NSMutableDictionary alloc] initWithObjectsAndKeys:tempArray_quWen, kQuWenKey, tempArray_zuCai, kZuCaiKey, tempArray_huoDong, kHuDongKey, nil];
    [tempArray_quWen release];
    [tempArray_zuCai release];
    [tempArray_huoDong release];

    [[RuYiCaiNetworkManager sharedManager] getInformation:1 withLotNo:@""];
}

- (void)loginClick
{
    [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
}

- (void)changeUserClick
{
    [[RuYiCaiNetworkManager sharedManager] showChangeUserAlertView];
}

- (void)segmentedChange:(id)sender
{
    NSInteger type = 0;
    switch (self.segmented.selectedSegmentIndex) 
    {
        case 0:
        {
            type = 1;
            if([[self.typeIdDicArray objectForKey:kQuWenKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        }break;
        case 1:
        {
//            type = 2;
        }  break;
        case 2:
        {
            type = 3;
            if([[self.typeIdDicArray objectForKey:kZuCaiKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        } break;
        case 3:
        {
            type = 4;
            if([[self.typeIdDicArray objectForKey:kHuDongKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        } break;
        default:
            break;
    }
    [self.tableView reloadData];  
}

- (void)getInformationOK:(NSNotification *)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
    [jsonParser release];
    
    NSArray* dict = (NSArray*)[parserDict objectForKey:@"news"];
    switch (self.cusSegmented.segmentedIndex)
    {
        case 0:
        {
            [[self.typeIdDicArray objectForKey:kQuWenKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kQuWenKey] addObjectsFromArray:dict];
//            for(int i = 0; i < tableRowNum; i++)
//            {
//                [[self.typeIdDicArray objectForKey:kQuWenKey] insertObject:[[dict objectAtIndex:i] objectForKey:@"newsId"] atIndex:i];

//            }
        }break;
        case 1:
            break;
        case 2:
        {
            [[self.typeIdDicArray objectForKey:kZuCaiKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kZuCaiKey] addObjectsFromArray:dict];

        }break;
        case 3:
        {
            [[self.typeIdDicArray objectForKey:kHuDongKey] removeAllObjects];
            [[self.typeIdDicArray objectForKey:kHuDongKey] addObjectsFromArray:dict];
            
        }break;
        default:
            break;
            
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)getInformationContentOK:(NSNotification *)notification
{
    NewsViewController *newsContent = [[NewsViewController alloc] init];
    newsContent.delegate = self;
    [self.navigationController pushViewController:newsContent animated:YES];
    //[newsContent refreshView];
    [newsContent release];
}

#pragma  mark tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if(0 == self.cusSegmented.segmentedIndex)
    {
         return [[self.typeIdDicArray objectForKey:kQuWenKey] count];
    }
    else if(2 == self.cusSegmented.segmentedIndex)
    {
         return [[self.typeIdDicArray objectForKey:kZuCaiKey] count];
    }
    else if(3 == self.cusSegmented.segmentedIndex)
    {
         return [[self.typeIdDicArray objectForKey:kHuDongKey] count];
    }
    else
        return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myCellIdentifier = @"MyCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCellIdentifier] autorelease];
        UIImageView *sanjiaoimage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 10, 10, 14)];
        sanjiaoimage.image = [UIImage imageNamed:@"accessory_c_normal.png"];
        [cell addSubview:sanjiaoimage];
        [sanjiaoimage release];
    }
    if(self.cusSegmented.segmentedIndex!= 1)
    {
//        SBJsonParser *jsonParser = [SBJsonParser new];
//        NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].newsTitle];
//        [jsonParser release];
//        NSArray* dict = (NSArray*)[[self.typeIdDicArray] objectForKey:@"news"];
//        cell.textLabel.text = [[dict objectAtIndex:indexPath.row] objectForKey:@"title"];

        switch (self.cusSegmented.segmentedIndex)
        {
            case 0:
                cell.textLabel.text = [[[self.typeIdDicArray objectForKey:kQuWenKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
                break;
            case 2:
                cell.textLabel.text = [[[self.typeIdDicArray objectForKey:kZuCaiKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
                break;
            case 3:
                cell.textLabel.text = [[[self.typeIdDicArray objectForKey:kHuDongKey] objectAtIndex:indexPath.row] objectForKey:@"title"];
                break;
            default:
                break;
        }
    }
    else//专家分析
    {
        switch(indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"双色球专家推荐";
                break;
            case 1:
                cell.textLabel.text = @"大乐透专家推荐";
                break;
            case 2:
                cell.textLabel.text = @"福彩3D专家推荐";
                break;
            case 3:
                cell.textLabel.text = @"排列三专家推荐";
                break;
            case 4:
                cell.textLabel.text = @"七乐彩专家推荐";
                break;
            case 5:
                cell.textLabel.text = @"22选5专家推荐";
                break;
            case 6:
                cell.textLabel.text = @"排列五专家推荐";
                break;
            case 7:
                cell.textLabel.text = @"七星彩专家推荐";
                break;
            default:
                break;
        }
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    [self setHidesBottomBarWhenPushed:YES];
    [[m_tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor redColor]];
  
    if(self.cusSegmented.segmentedIndex != 1)
    {
        NSInteger typeID = 0;
        switch (self.cusSegmented.segmentedIndex) {
            case 0:
            {
                typeID = [[[[self.typeIdDicArray objectForKey:kQuWenKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
            }break;
            case 2:
            {
                typeID = [[[[self.typeIdDicArray objectForKey:kZuCaiKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"]intValue];
            }break;
            case 3:
            {
                typeID = [[[[self.typeIdDicArray objectForKey:kHuDongKey] objectAtIndex:indexPath.row] objectForKey:@"newsId"] intValue];
            }break;
            default:
                break;
        }
        
        [[RuYiCaiNetworkManager sharedManager] getInformationContent:typeID];
    }
    else
    {
        EachLotInforTableViewController* viewController = [[EachLotInforTableViewController alloc] init];
        viewController.title = [NSString stringWithString:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
        switch(indexPath.row)
        {
            case 0:
                viewController.lotNo = kLotNoSSQ;
                break;
            case 1:
                viewController.lotNo = kLotNoDLT;
                break;
            case 2:
                viewController.lotNo = kLotNoFC3D;
                break;
            case 3:
                viewController.lotNo = kLotNoPLS;
                break;
            case 4:
                viewController.lotNo = kLotNoQLC;
                break;
            case 5:
                viewController.lotNo = kLotNo22_5;
                break;
            case 6:
                viewController.lotNo = kLotNoPL5;
                break;
            case 7:
                viewController.lotNo = kLotNoQXC;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark - customer segmented delegate
-(void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index{
    NSInteger type = 0;
    switch (index)
    {
        case 0:
        {
            type = 1;
            if([[self.typeIdDicArray objectForKey:kQuWenKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        }break;
        case 1:
        {
            //            type = 2;
        }  break;
        case 2:
        {
            type = 3;
            if([[self.typeIdDicArray objectForKey:kZuCaiKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        } break;
        case 3:
        {
            type = 4;
            if([[self.typeIdDicArray objectForKey:kHuDongKey] count] == 0)
            {
                [[RuYiCaiNetworkManager sharedManager] getInformation:type withLotNo:@""];
            }
        } break;
        default:
            break;
    }
    [self.tableView reloadData];
}


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


- (void) sendTextContent:(NSString*)nsText
{
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
       req.scene = _scene;
    
    [WXApi sendReq:req];
}
@end
