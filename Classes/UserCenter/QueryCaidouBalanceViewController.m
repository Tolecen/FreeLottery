//
//  QueryCaidouBalanceViewController.m
//  Boyacai
//
//  Created by wangxr on 14-4-9.
//
//

#import "QueryCaidouBalanceViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "CustomSegmentedControl.h"
#import "RYCImageNamed.h"
#import <QuartzCore/QuartzCore.h>
#import "RuYiCaiNetworkManager.h"
@interface CaidouCell ()
@property (nonatomic,retain)UILabel * sourceL;//明细
@property (nonatomic,retain)UILabel * timeL;//时间
@property (nonatomic,retain)UILabel * lotPeaL;//数目
@end

@implementation CaidouCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.sourceL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        _sourceL.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_sourceL];
        self.timeL = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 200, 20)];
        [self.contentView addSubview:_timeL];
        _timeL.textColor = [UIColor grayColor];
        _timeL.font = [UIFont systemFontOfSize:15];
        self.lotPeaL = [[UILabel alloc]initWithFrame:CGRectMake(210, 10, 90, 20)];
        _lotPeaL.font = [UIFont systemFontOfSize:15];
        _lotPeaL.textAlignment = NSTextAlignmentRight;
        _lotPeaL.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_lotPeaL];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _sourceL.text = _dataDic[@"source"];
    _timeL.text = _dataDic[@"createTime"];
    
    if ([_dataDic[@"blsign"] intValue]==1) {
        _lotPeaL.textColor = [UIColor colorWithRed:196.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
         _lotPeaL.text = [NSString stringWithFormat:@"+%@个",_dataDic[@"lotPea"]];
    }
    if ([_dataDic[@"blsign"] intValue]==-1) {
        _lotPeaL.textColor = [UIColor colorWithRed:32.0/255.0 green:124.0/255.0 blue:35.0/255.0 alpha:1.0];
        _lotPeaL.text = [NSString stringWithFormat:@"-%@个",_dataDic[@"lotPea"]];
    }
    
}
- (void)dealloc
{
    [_dataDic release];
    [_sourceL release];
    [_timeL release];
    [_lotPeaL release];
    [super dealloc];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end

@interface QueryCaidouBalanceViewController ()<UITableViewDataSource,CustomSegmentedControlDelegate>
{
    int curPageIndex;
    int totalPageCount;
}
@property (nonatomic,retain)UITableView*tableV;
@property (nonatomic,retain)UILabel * pageIndexLabel;
@property (nonatomic,retain)NSArray * dataArray;
@property (nonatomic,retain)NSString * repustStr;
@property (nonatomic,retain)UIImageView* allCountBg;
@property (nonatomic,retain)UILabel* allAmountLabel;
@property (nonatomic,retain)CustomSegmentedControl*segmentView;
@end

@implementation QueryCaidouBalanceViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaodouDetailOK" object:nil];
    [_tableV release];
    [_pageIndexLabel release];
    [_dataArray release];
    [_allCountBg release];
    [_allAmountLabel release];
    [_segmentView release];
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        curPageIndex = 0;
        self.repustStr = @"detail";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaodouDetailOK:) name:@"queryCaodouDetailOK" object:nil];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.segmentView = [[[CustomSegmentedControl alloc]
                         initWithFrame:CGRectMake(5, 5, 310, 30)
                         andNormalImages:[NSArray arrayWithObjects:
                                          @"pea_all_normal.png",
                                          @"pea_get_normal.png",
                                          @"pea_consume_normal.png",nil]
                         andHighlightedImages:[NSArray arrayWithObjects:
                                               @"pea_all_normal.png",
                                               @"pea_get_normal.png",
                                               @"pea_consume_normal.png",nil]
                         andSelectImage:[NSArray arrayWithObjects:
                                         @"pea_all_highlight.png",
                                         @"pea_get_highlight.png",
                                         @"pea_consume_highlight",nil]]autorelease];
    _segmentView.delegate = self;
    [self.view addSubview:_segmentView];
    
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
    
    self.pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height - 103, 160, 30)];
    _pageIndexLabel.text = @"第0页 共0页";
    _pageIndexLabel.textAlignment = UITextAlignmentCenter;
    _pageIndexLabel.backgroundColor = [UIColor clearColor];
    _pageIndexLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_pageIndexLabel];
    [_pageIndexLabel release];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(5, 35, 310, [UIScreen mainScreen].bounds.size.height - 150)];
    _tableV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableV.layer.borderWidth = 1;
    _tableV.hidden = YES;
    [self.view addSubview:_tableV];
    _tableV.dataSource = self;
    _tableV.rowHeight = 60;
    [_tableV release];
    
    self.allCountBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 143, 320, 29)];
    _allCountBg.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:_allCountBg];
    _allCountBg.hidden = YES;
    [_allCountBg release];
    
    self.allAmountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 300, 29)];
    _allAmountLabel.textColor = [UIColor redColor];
    _allAmountLabel.font = [UIFont systemFontOfSize:14.0f];
    _allAmountLabel.backgroundColor = [UIColor clearColor];
    [_allCountBg addSubview:_allAmountLabel];
    [_allAmountLabel release];
    
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
- (void)pageUpClick:(id)sender
{
    if (curPageIndex<=0) {
        return;
    }
    curPageIndex--;
    [[RuYiCaiNetworkManager sharedManager] queryCaidouDetailOfPage:curPageIndex requestType:_repustStr];
}
- (void)pageDownClick:(id)sender
{
    if (curPageIndex+1>=totalPageCount) {
        return;
    }
    curPageIndex++;
    [[RuYiCaiNetworkManager sharedManager] queryCaidouDetailOfPage:curPageIndex requestType:_repustStr];
}
- (void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index
{
    curPageIndex = 0;
    switch (index) {
        case 0:
            self.repustStr = nil;
            break;
        case 1:
            self.repustStr = @"add";
            break;
        case 2:
            self.repustStr = @"cut";
            break;
        default:
            break;
    }
    [[RuYiCaiNetworkManager sharedManager] queryCaidouDetailOfPage:curPageIndex requestType:_repustStr];
    
}
- (void)queryCaodouDetailOK:(NSNotification *)notification
{
    self.dataArray = (NSArray*)notification.userInfo[@"result"];
    totalPageCount = [notification.userInfo[@"totalPage"] intValue];
    _pageIndexLabel.text = [NSString stringWithFormat:@"第%d页 共%d页",curPageIndex+1,totalPageCount];
    _tableV.hidden = NO;
    [_tableV reloadData];
    NSString* sumPea = notification.userInfo[@"sumPea"];
    if (_segmentView.segmentedIndex == 0) {
        _allCountBg.hidden = YES;
        _allAmountLabel.text = @"";
    }
    if (_segmentView.segmentedIndex == 1) {
        _allCountBg.hidden = NO;
        _allAmountLabel.text = [NSString stringWithFormat:@"彩豆获取总数:%@",sumPea];
    }
    if (_segmentView.segmentedIndex == 2) {
        _allCountBg.hidden = NO;
        _allAmountLabel.text = [NSString stringWithFormat:@"彩豆消费总数:%@",sumPea];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifiertypetwo";
    CaidouCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell){
        cell = [[[CaidouCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.dataDic =_dataArray[indexPath.row];
    return cell;
}
@end
