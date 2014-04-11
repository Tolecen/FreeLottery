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
@interface MessageCenterViewController ()
@property (nonatomic,retain)UITableView * tableV;
@end

@implementation MessageCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
//    _tableV.hidden = YES;
    [self.view addSubview:_tableV];
//    _tableV.dataSource = self;
//    _tableV.delegate = self;
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
@end
