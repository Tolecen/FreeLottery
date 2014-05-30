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
@interface IssueHistoryViewController ()

@end

@implementation IssueHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[AdaptationUtils adaptation:self];
    self.navigationItem.title = @"猜大小,赢双倍彩豆";
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
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
