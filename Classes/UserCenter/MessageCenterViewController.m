//
//  MessageCenterViewController.m
//  Boyacai
//
//  Created by wangxr on 14-4-11.
//
//

#import "MessageCenterViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "RuYiCaiNetworkManager.h"
#import "MessageContentViewController.h"
@interface MessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)UITableView * tableV;
@property (nonatomic,retain)NSArray * dataArray;
@end

@implementation MessageCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = @[@{@"id": @"0",@"title": @"欢迎使用新版本。"}];
    }
    return self;
}
- (void)dealloc
{
    [_tableV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageListOK:) name:@"WXRGetMessageListOK" object:nil];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_tableV];
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [_tableV release];
    [[RuYiCaiNetworkManager sharedManager] getMessageListWithPage:@"0"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMessageListOK:(NSNotification*)info
{
    self.dataArray = info.userInfo[@"value"];
    [_tableV release];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifiertypetwo";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.textLabel.text =[_dataArray[indexPath.row] objectForKey:@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageContentViewController * vc= [[MessageContentViewController alloc]init];
    vc.messageId = [_dataArray[indexPath.row] objectForKey:@"id"];
    vc.navigationItem.title = [_dataArray[indexPath.row] objectForKey:@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
