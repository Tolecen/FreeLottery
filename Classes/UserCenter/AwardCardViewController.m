//
//  AwardCardViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-5-14.
//
//

#import "AwardCardViewController.h"

@interface AwardCardViewController ()

@end

@implementation AwardCardViewController
@synthesize tableV = _tableV;
@synthesize dataArray = _dataArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.dataArray = @[@{@"id": @"0",@"name": @"赠送18彩豆",@"description":@"通过签到赠送18彩豆"}];
    }
    return self;
}
-(void)dealloc
{
    [_tableV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_tableV];
    _tableV.rowHeight = 80;
    _tableV.dataSource = self;
    _tableV.delegate = self;
    [_tableV release];

	// Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * cardDict = _dataArray[indexPath.row];
    static NSString *cellIdentifier = @"cellIdentifiertypeone";
    ActivityTypeOneCell* cell = (ActivityTypeOneCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
        cell = [[[ActivityTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = [cardDict objectForKey:@"name"];
    cell.descriptionLabel.text = [cardDict objectForKey:@"description"];
    cell.imageV.backgroundColor = [UIColor redColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
    AwardCardDetailViewController * awV = [[AwardCardDetailViewController alloc] init];
    awV.navigationItem.title = @"任务卡详情";
    [self.navigationController pushViewController:awV animated:YES];
    
    [awV release];

}

- (void)back:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
