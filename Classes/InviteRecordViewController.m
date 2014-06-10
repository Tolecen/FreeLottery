//
//  InviteRecordViewController.m
//  Boyacai
//
//  Created by wangxr on 14-6-9.
//
//

#import "InviteRecordViewController.h"
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface InviteRecordCell : UITableViewCell
@property (nonatomic,retain)NSDictionary * dataDic;

@property (nonatomic,retain)UILabel * phoneNoL;//手机号
@property (nonatomic,retain)UILabel * timeL;//注册时间
@end
@implementation InviteRecordCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
        self.phoneNoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        _phoneNoL.backgroundColor = [UIColor clearColor];
        _phoneNoL.textColor = [UIColor grayColor];
        _phoneNoL.font = [UIFont systemFontOfSize:18];
        _phoneNoL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_phoneNoL];
        UIView * lineV =[[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 40)];
        lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [self.contentView addSubview:lineV];
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 150, 20)];
        _timeL.font = [UIFont systemFontOfSize:18];
        _timeL.textColor = [UIColor grayColor];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_timeL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _phoneNoL.text = _dataDic[@"inviteeName"];
   
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_dataDic[@"createTime"] doubleValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    [formatter release];
    _timeL.text = confromTimespStr;
}
- (void)dealloc
{
    [_dataDic release];
    [_timeL release];
    [_phoneNoL release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
@interface InviteRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int curPageIndex;
    int totalPageCount;
}
@property (nonatomic,retain)NSArray *dataArray;
@property (nonatomic,retain)UITableView* tableView;
@property (nonatomic,retain)UILabel * jiluL;
@end

@implementation InviteRecordViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [_dataArray release];
    [_jiluL release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"邀请记录";
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * inviteeCntL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
    inviteeCntL.text = [NSString stringWithFormat:@"好友数:%@",_inviteeCnt];
    inviteeCntL.textAlignment = NSTextAlignmentCenter;
    inviteeCntL.textColor = [UIColor grayColor];
    [self.view addSubview:inviteeCntL];
    [inviteeCntL release];
    
    UILabel * awardPeaL = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 150, 20)];
    awardPeaL.text = [NSString stringWithFormat:@"贡献值:%@",_awardPea];
    awardPeaL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:awardPeaL];
    awardPeaL.textColor = [UIColor grayColor];
    [awardPeaL release];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, [UIScreen mainScreen].bounds.size.height-50-64-40)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    _tableView.dataSource = self;
    _tableView.rowHeight = 40;
    [_tableView release];
    _tableView.tableHeaderView = ({
        UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        headView.backgroundColor = [UIColor orangeColor];
        UILabel* phoneNoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
        phoneNoL.backgroundColor = [UIColor clearColor];
        phoneNoL.font = [UIFont systemFontOfSize:18];
        phoneNoL.textAlignment = NSTextAlignmentCenter;
        phoneNoL.text = @"手机号";
        phoneNoL.textColor = [UIColor whiteColor];
        [headView addSubview:phoneNoL];
        UIView * lineV =[[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 40)];
        lineV.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
        [headView addSubview:lineV];
        UILabel*timeL = [[UILabel alloc]initWithFrame:CGRectMake(160, 10, 150, 20)];
        timeL.font = [UIFont systemFontOfSize:18];
        timeL.backgroundColor = [UIColor clearColor];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.text = @"注册时间";
        timeL.textColor = [UIColor whiteColor];
        [headView addSubview:timeL];
        headView;
    });
    
    UIImageView* bottomBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 113, 320, 50)];
    bottomBarImageView.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:bottomBarImageView];
    [bottomBarImageView release];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);
    [leftButton setTitle:@"上一页" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action: @selector(pageUpClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame = CGRectMake(240, [UIScreen mainScreen].bounds.size.height - 103, 70, 30);
    [rightButton setTitle:@"下一页" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"whiteButton_normal.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action: @selector(pageDownClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    self.jiluL = [[UILabel alloc]initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height - 103, 160, 30)];
    _jiluL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_jiluL];
    [_jiluL release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryInviteRecordOK:) name:@"WXRQueryInviteRecord" object:nil];
    [[RuYiCaiNetworkManager sharedManager] queryInviteRecordWithPage:@"0" count:@"10"];
}
- (void)queryInviteRecordOK:(NSNotification *)notification
{
    self.dataArray = notification.object[@"result"];
    totalPageCount = [notification.object[@"totalPage"] intValue];
    _jiluL.text = [NSString stringWithFormat:@"第%d页 共%d页",curPageIndex+1,totalPageCount];
    [_tableView reloadData];
}
- (void)pageUpClick:(id)sender
{
    if (curPageIndex<=0) {
        return;
    }
    curPageIndex--;
    [[RuYiCaiNetworkManager sharedManager] queryInviteRecordWithPage:[NSString stringWithFormat:@"%d",curPageIndex] count:@"10"];
    
}
- (void)pageDownClick:(id)sender
{
    if (curPageIndex+1>=totalPageCount) {
        return;
    }
    curPageIndex++;
    [[RuYiCaiNetworkManager sharedManager] queryInviteRecordWithPage:[NSString stringWithFormat:@"%d",curPageIndex] count:@"10"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifiertypeone";
    InviteRecordCell* cell = (InviteRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell){
        cell = [[[InviteRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.dataDic = _dataArray[indexPath.row];
    return cell;
    
}
@end
