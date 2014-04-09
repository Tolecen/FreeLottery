//
//  ASettingViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-10.
//
//

#import "ASettingViewController.h"

@interface ASettingViewController ()

@end

@implementation ASettingViewController
@synthesize listTableV;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        titleArrayOne = [[NSArray alloc] initWithObjects:@"关于我们",@"常见问题",@"新手指南", nil];
        titleArrayTwo = [[NSArray alloc] initWithObjects:@"评分支持",@"留言反馈", nil];
        titleArrayThree = [[NSArray alloc] initWithObjects:@"注销账号", nil];
    }
    return self;
}
-(void)dealloc
{
    [titleArrayThree release];
    [titleArrayOne release];
    [titleArrayTwo release];
    [self.listTableV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.navigationItem.title = @"更多";
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.rowHeight = 68;
    self.listTableV.backgroundView = nil;
    self.listTableV.backgroundColor = [UIColor whiteColor];
//    [self.listTableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.listTableV];

	// Do any additional setup after loading the view.
}
-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return titleArrayOne.count;
    }
    else if(section==1)
    {
        return titleArrayTwo.count;
    }
    else
    {
        return titleArrayThree.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    if (indexPath.section==0) {
        cell.textLabel.text = titleArrayOne[indexPath.row];
    }
    else if(indexPath.section==1)
    {
        cell.textLabel.text = titleArrayTwo[indexPath.row];
    }
    else
    {
        cell.textLabel.text = titleArrayThree[indexPath.row];
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                NewVersionIntroduction * newV = [[NewVersionIntroduction alloc] init];
                [self.navigationController pushViewController:newV animated:YES];
                [newV release];
            }
                break;
            case 1:
            {
                ADIntroduceViewController * inv = [[ADIntroduceViewController alloc] init];
                inv.theTextType = TextTypeCommonQuestion;
                [self.navigationController pushViewController:inv animated:YES];
                [inv release];
            }
                break;
            case 2:
            {
                NewFuctionIntroductionView* m_newFuctionInfoView = [[NewFuctionIntroductionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] FirstTime:NO];
                m_newFuctionInfoView.hidden = NO;
                [m_newFuctionInfoView addCloseBtn];
                [self.view addSubview:m_newFuctionInfoView];
                [m_newFuctionInfoView release];
                self.navigationController.navigationBarHidden = YES;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBar:) name:@"showNavBar" object:nil];
            }
                break;

                
            default:
                break;
        }
    }
    else if (indexPath.section==1){
        switch (indexPath.row) {
            case 0:
            {
                NSURL *url = [NSURL URLWithString:kAppStorPingFen];
                if([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
                break;
            case 1:
            {
                FeedBackViewController * feedV = [[FeedBackViewController alloc] init];
                [self.navigationController pushViewController:feedV animated:YES];
                [feedV release];
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定注销登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        
        [alterView addButtonWithTitle:@"确定"];
        alterView.delegate = self;
        alterView.tag = 321;
        [alterView show];
        
        [alterView release];
    }

    
}

-(void)showNavBar:(NSNotification *)noti
{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showNavBar" object:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(321 == alertView.tag)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"myLogOut" object:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
