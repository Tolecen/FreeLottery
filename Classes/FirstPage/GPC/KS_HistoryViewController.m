//
//  KS_HistoryViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-16.
//
//

#import "KS_HistoryViewController.h"
#import "KS_HistoryCell.h"
#import "ColorUtils.h"
#import "KS_HeaderViewController.h"
#import "NSLog.h"
#import "RuYiCaiNetworkManager.h"

@interface KS_HistoryViewController ()<UITableViewDelegate,UITableViewDataSource,NextIssueDelegate>
{
    KS_HeaderViewController *_headerViewController;
    UITableView *_tableView;
    NSMutableArray *_winCodes;
}
@property (nonatomic, retain) KS_HeaderViewController *headerViewController;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *winCodes;

@end

@implementation KS_HistoryViewController
@synthesize headerViewController = _headerViewController;
@synthesize tableView = _tableView;
@synthesize winCodes = _winCodes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    [_tableView release];
    [_headerViewController release];
    _headerViewController = nil;
    [_winCodes release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.winCodes = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height) style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [self.tableView release];
    
    self.headerViewController = [[KS_HeaderViewController alloc ] init];
    self.headerViewController.delegate = self;
    self.headerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    UIView *darkLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerViewController.view.frame.size.height - 1, 320, 2)];
    [darkLine setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002321"]];
    [self.headerViewController.view addSubview:darkLine];
    [self.headerViewController.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.tableHeaderView = _headerViewController.view;
    [self.headerViewController release];
    NSLog(@"retain count -- %d",_headerViewController.retainCount);
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.tableView.frame.size.height , 320, 2)];
    [footerView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002321"]];
    self.tableView.tableFooterView = footerView;
    [footerView release ];
    
    NSLog(@"retain count -- %d",_headerViewController.retainCount);

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_headerViewController viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView Delegate and DateSours
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0f;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellKey = @"KSHistoryCell";
    KS_HistoryCell *cell = (KS_HistoryCell *)[tableView dequeueReusableCellWithIdentifier:cellKey];

    if (cell == nil)
    {
        cell = [[KS_HistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellKey] ;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.winCodes count]>indexPath.row) {
        NSMutableDictionary *dic = [self.winCodes objectAtIndex:indexPath.row];
        cell.issue = [dic objectForKey:@"batchCode"];
        cell.winCode = [dic objectForKey:@"winCode"];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    [cell setBackgroundColor:[UIColor clearColor]];

}

#pragma mark - NextIssueDelegate
-(void)refreshWinningHistoryData:(id)data{
    
    self.winCodes = [NSMutableArray arrayWithArray:(NSArray *)data];
    [self.tableView reloadData];
}

-(void)refreshHistoryData:(id)data{
    NSTrace();
    if (_headerViewController) {
        [self.headerViewController refreshHistoryData:data];
    }
    
}
@end
