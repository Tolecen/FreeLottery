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
@interface QueryCaidouBalanceViewController ()<UITableViewDataSource,CustomSegmentedControlDelegate>
{
    int curPageIndex;
    int totalPageCount;
}
@property (nonatomic,retain)UITableView*tableV;
@property (nonatomic,retain)UILabel * pageIndexLabel;
@property (nonatomic,retain)NSArray * dataArray;
@property (nonatomic,retain)NSString * repustStr;
@end

@implementation QueryCaidouBalanceViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"queryCaodouDetailOK" object:nil];
    [_tableV release];
    [_pageIndexLabel release];
    [_dataArray release];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryCaodouDetailOK:) name:@"queryCaodouDetailOK" object:nil];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    CustomSegmentedControl*segmentView = [[[CustomSegmentedControl alloc]
                         initWithFrame:CGRectMake(5, 5, 310, 30)
                         andNormalImages:[NSArray arrayWithObjects:
                                          @"zhmx_qb_normal.png",
                                          @"zhmx_cz_normal.png",
                                          @"zhmx_tx_normal.png",nil]
                         andHighlightedImages:[NSArray arrayWithObjects:
                                               @"zhmx_qb_normal.png",
                                               @"zhmx_cz_normal.png",
                                               @"zhmx_tx_normal.png",nil]
                         andSelectImage:[NSArray arrayWithObjects:
                                         @"zhmx_qb_click.png",
                                         @"zhmx_cz_cilck.png",
                                         @"zhmx_tx_click.png",nil]]autorelease];
    segmentView.delegate = self;
    [self.view addSubview:segmentView];
    
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
    
    _pageIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, [UIScreen mainScreen].bounds.size.height - 103, 160, 30)];
    _pageIndexLabel.text = @"第0页 共0页";
    _pageIndexLabel.textAlignment = UITextAlignmentCenter;
    _pageIndexLabel.backgroundColor = [UIColor clearColor];
    _pageIndexLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_pageIndexLabel];
    [_pageIndexLabel release];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(5, 35, 310, [UIScreen mainScreen].bounds.size.height - 150)];
    _tableV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tableV.layer.borderWidth = 1;
    [self.view addSubview:_tableV];
    _tableV.dataSource = self;
    [_tableV release];
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
    if (--curPageIndex<0) {
        return;
    }
}
- (void)pageDownClick:(id)sender
{
    if (++curPageIndex+1>totalPageCount) {
        return;
    }
}
- (void)customSegmentedControl:(CustomSegmentedControl *)customSegmentedControl didSelectItemAtIndex:(NSUInteger)index
{
    
}
- (void)queryCaodouDetailOK:(NSNotification *)notification
{
    self.dataArray = (NSArray*)notification.userInfo[@"result"];
    totalPageCount = [notification.userInfo[@"totalPage"] intValue];
    _pageIndexLabel.text = [NSString stringWithFormat:@"第%d页 共%d页",curPageIndex+1,totalPageCount];
    [_tableV reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifiertypetwo";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    
    return cell;
}
@end
