//
//  SetYaoYiYaoViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-12-5.
//
//
#import "SetYaoYiYaoViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RYCImageNamed.h"
#import "Custom_tabbar.h"
#import "NSLog.h"
#import "SwitchTableCell.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

@interface SetYaoYiYaoViewController (internal)

- (void)pressSwitch:(id)sender;

@end

@implementation SetYaoYiYaoViewController

@synthesize myTableView = m_myTableView;

- (void)dealloc
{
    
    [m_myTableView release], m_myTableView = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    m_myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.backgroundColor = [UIColor clearColor];
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
//    UILabel* warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 300, 50)];
//    warnLabel.text = @"提示：只能设置关闭自动登录，如需开启请到登录页面勾选“记住我的登录状态”并登录。";
//    warnLabel.font = [UIFont systemFontOfSize:15.0f];
//    warnLabel.textColor = [UIColor colorWithRed:99.0/255.0 green:103.0/255.0 blue:106.0/255.0 alpha:1.0];
//    warnLabel.backgroundColor = [UIColor clearColor];
//    warnLabel.lineBreakMode = UILineBreakModeWordWrap;
//    warnLabel.numberOfLines = 2;
//    [self.myTableView addSubview:warnLabel];
//    [warnLabel release];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
}


#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
       UIImageView *accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 42)];
        accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [cell addSubview:accessoryImageView];
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150,30 )];
        titleLable.backgroundColor = [UIColor clearColor];
        
        titleLable.tag  = 1001;
        [cell addSubview:titleLable];
        [titleLable release];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    UILabel *titleLable =(UILabel*) [cell viewWithTag:1001];
    titleLable.text = @"摇一摇机选设置";
    
    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(215, 8, 79, 27)];
    if(m_delegate.isStartYaoYiYao)
    {
        swith.on = YES;
    }
    else
    {
        swith.on = NO;
    }
    [swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    [cell addSubview:swith];
    [swith release];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pressSwitch:(id)sender
{
    UISwitch *temp = (UISwitch *)sender;
 
    if (temp.on) {
        [m_delegate setYaoYiYao:YES];
    }
    else
    {
        [m_delegate setYaoYiYao:NO];
    }
}

@end
