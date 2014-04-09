//
//  OtherActivityViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-10.
//
//

#import "OtherActivityViewController.h"

@interface OtherActivityViewController ()

@end

@implementation OtherActivityViewController
@synthesize listTableV;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        otherActivityArray = [[NSArray alloc] initWithObjects:@"注册送彩豆",@"好评送彩豆", nil];
        ifCompleteArray = [[NSArray alloc] initWithObjects:@"1",@"1", nil];
        notCompleteArray = [[NSArray alloc] initWithObjects:@"完成注册，赠送100彩豆",@"完成好评，赠送100彩豆", nil];
        completeArray = [[NSArray alloc] initWithObjects:@"您已完成注册，赠送100彩豆已转为彩金冲入您的账户",@"您已完成好评，赠送100彩豆已转为彩金冲入您的账户", nil];
    }
    return self;
}
-(void)dealloc
{
    [completeArray release];
    [notCompleteArray release];
    [ifCompleteArray release];
    [otherActivityArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.navigationItem.title = @"其他活动";
    
    self.listTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStylePlain];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.rowHeight = 68;
    [self.listTableV setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.listTableV];
    
    
	// Do any additional setup after loading the view.
}
-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return otherActivityArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
    static NSString *cellIdentifier = @"cellIdentifier";
    ThirdPageTabelCellView* cell = (ThirdPageTabelCellView*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
        cell = [[[ThirdPageTabelCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    
    
        
        
    cell.titleName = otherActivityArray[indexPath.row];

    if ([ifCompleteArray[indexPath.row] isEqualToString:@"0"]) {
        cell.littleTitleName = notCompleteArray[indexPath.row];
        cell.littleTitleLabel.textColor = [UIColor grayColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    else
    {
        cell.littleTitleName = completeArray[indexPath.row];
        cell.littleTitleLabel.textColor = [UIColor grayColor];
        cell.titleLabel.textColor = [UIColor grayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.iconImageName = @"ico_c_bank.png";
    [cell refresh];
    
    return cell;
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
