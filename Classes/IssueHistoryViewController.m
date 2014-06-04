//
//  IssueHistoryViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-30.
//
//

#import "IssueHistoryViewController.h"
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiNetworkManager.h"
@interface GameOrderCell : UITableViewCell
@property (nonatomic,retain)NSDictionary * dataDic;

@property (nonatomic,retain)UILabel * issueNoL;//期号
@property (nonatomic,retain)UIImageView * winCodeIV;//点数
@property (nonatomic,retain)UILabel * awardL;//开奖结果
@property (nonatomic,retain)UILabel * betDetailL;//投注详情
@property (nonatomic,retain)UILabel * issueL;//中奖结果
@end
@implementation GameOrderCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.issueNoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        _issueNoL.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_issueNoL];
        self.winCodeIV = [[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 30, 30)];
        [self.contentView addSubview:_winCodeIV];
        self.awardL = [[UILabel alloc]initWithFrame:CGRectMake(250, 10, 60, 30)];
        _awardL.font = [UIFont systemFontOfSize:18];
        _awardL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_awardL];
        self.betDetailL = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 200, 30)];
        _betDetailL.font = [UIFont systemFontOfSize:16];
        _betDetailL.textColor = [UIColor lightGrayColor];
        _betDetailL.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_betDetailL];
        
        self.issueL = [[UILabel alloc]initWithFrame:CGRectMake(250, 50, 60, 30)];
        _issueL.font = [UIFont systemFontOfSize:16];
        _issueL.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_issueL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _issueNoL.text = [NSString stringWithFormat:@"第 %@ 期",_dataDic[@"issueNo"]];
    if (![_dataDic[@"winCodeDetail"] isKindOfClass:[NSNull class]]) {
        _winCodeIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"little%d",[_dataDic[@"winCodeDetail"] intValue]]];
    }
    if (![_dataDic[@"winCode"] isKindOfClass:[NSNull class]]) {
        if ([_dataDic[@"winCode"] intValue]) {
            _awardL.text = @"猜大赢";
        }else{
            _awardL.text = @"猜小赢";
        }
    }else
    {
        _awardL.text = @"未开奖";
    }
    
    if (![_dataDic[@"betCode"] isKindOfClass:[NSNull class]]) {
        NSArray*issueArr = [_dataDic[@"betCode"] componentsSeparatedByString:@"^"];
        for (NSString * issueStr in issueArr) {
            if (![issueStr isKindOfClass:[NSNull class]]&&![issueStr isEqualToString:@""]) {
                _betDetailL.text = @" ";
                NSArray*arr = [issueStr componentsSeparatedByString:@"|"];
                if ([arr[2] intValue] == 0) {
                    _betDetailL.text = [_betDetailL.text stringByAppendingString: [NSString stringWithFormat:@"压小:%d",[arr[3] intValue]]];
                }else
                {
                     _betDetailL.text = [_betDetailL.text stringByAppendingString:[NSString stringWithFormat:@"压大:%d",[arr[3] intValue]]];
                }
                _issueL.textColor = [UIColor lightGrayColor];
                _issueL.text = @"未中奖";
                if (![_dataDic[@"winCode"] isKindOfClass:[NSNull class]]&&[arr[2] intValue] == [_dataDic[@"winCode"] intValue]) {
                    _issueL.textColor = [UIColor redColor];
                    _issueL.text = @"中奖";
                }
                
            }
        }
    }
}
- (void)dealloc
{
    [_dataDic release];
    [_issueNoL release];
    [_winCodeIV release];
    [_awardL release];
    [_betDetailL release];
    [_issueL release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
@interface IssueHistoryCell : UITableViewCell
@property (nonatomic,retain)NSDictionary * dataDic;

@property (nonatomic,retain)UILabel * issueNoL;//期号
@property (nonatomic,retain)UIImageView * winCodeIV;//点数
@property (nonatomic,retain)UILabel * awardL;//结果
@end
@implementation IssueHistoryCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.issueNoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
        _issueNoL.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_issueNoL];
        self.winCodeIV = [[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 30, 30)];
        [self.contentView addSubview:_winCodeIV];
        self.awardL = [[UILabel alloc]initWithFrame:CGRectMake(210, 10, 90, 30)];
        _awardL.font = [UIFont systemFontOfSize:18];
        _awardL.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_awardL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _issueNoL.text = [NSString stringWithFormat:@"第 %@ 期",_dataDic[@"issueNo"]];
    _winCodeIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"little%d",[_dataDic[@"winCodeDetail"] intValue]]];
    if ([_dataDic[@"winCode"] intValue]) {
        _awardL.text = @"猜大赢";
    }else{
        _awardL.text = @"猜小赢";
    }
    
}
- (void)dealloc
{
    [_dataDic release];
    [_issueNoL release];
    [_winCodeIV release];
    [_awardL release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
@interface IssueHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int curPageIndex;
    int totalPageCount;
}
@property (nonatomic,retain)NSArray *dataArray;
@property (nonatomic,retain)UITableView* tableView;
@property (nonatomic,retain)UILabel * jiluL;
@end

@implementation IssueHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curPageIndex = 0;
        totalPageCount = 0;
        self.type = QueryTypeIssueHistory;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_tableView release];
    [_dataArray release];
    [_jiluL release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	[AdaptationUtils adaptation:self];
    
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-50-64)];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    [_tableView release];
    
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
    
    
    if (_type == QueryTypeIssueHistory) {
        self.navigationItem.title = @"历史开奖";
        _tableView.rowHeight = 50;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryIssueHistoryOK:) name:@"WXRGetAwardStateOK" object:nil];
    }else
    {
        self.navigationItem.title = @"投注记录";
        _tableView.rowHeight = 80;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryIssueHistoryOK:) name:@"WXRqueryGameOrdersOK" object:nil];
    }
    [self queryData];
}
- (void)queryData
{
    if (_type == QueryTypeIssueHistory){
        [[RuYiCaiNetworkManager sharedManager] queryIssueHistoryWithPage:[NSString stringWithFormat:@"%d",curPageIndex] count:@"10"];
    }else{
        [[RuYiCaiNetworkManager sharedManager] queryGameOrdersWithPage:[NSString stringWithFormat:@"%d",curPageIndex] count:@"10"];
    }
}
-(void)queryIssueHistoryOK:(NSNotification*)notification
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
    [self queryData];
    
}
- (void)pageDownClick:(id)sender
{
    if (curPageIndex+1>=totalPageCount) {
        return;
    }
    curPageIndex++;
    [self queryData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)back:(id)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == QueryTypeIssueHistory){
        static NSString *cellIdentifier = @"cellIdentifiertypeone";
        IssueHistoryCell* cell = (IssueHistoryCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell){
            cell = [[[IssueHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.dataDic = _dataArray[indexPath.row];
        return cell;
    }else
    {
        static NSString *cellIdentifier = @"cellIdentifiertypeone";
        GameOrderCell* cell = (GameOrderCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell){
            cell = [[[GameOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.dataDic = _dataArray[indexPath.row];
        return cell;
    }
    
}
@end
