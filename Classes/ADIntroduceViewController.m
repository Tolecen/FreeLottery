//
//  ADIntroduceViewController.m
//  Boyacai
//
//  Created by Tolecen on 14-3-7.
//
//

#import "ADIntroduceViewController.h"

@interface ADIntroduceViewController ()

@end

@implementation ADIntroduceViewController
@synthesize theTextType;
@synthesize shouldShowTabbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [self.a release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.a = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44)];
    NSString *path = nil;
    if (theTextType==TextTypeAdIntro) {
        self.navigationItem.title = @"换豆说明";
        path=[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"detailIntroduce"ofType:@"txt"]];
    }
    else if(theTextType==TextTypeCommonQuestion){
        self.navigationItem.title = @"常见问题";
        path=[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"commonQuestion"ofType:@"txt"]];
    }
    else if (theTextType==TextTypeAdwallImportantInfo){
        self.navigationItem.title = @"积分墙重要通知";
        
    }

    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryShakeSigninDescriptionOK:) name:@"WXRQueryShakeSigninDescriptionOK" object:nil];
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    _a.editable = NO;
    _a.font = [UIFont systemFontOfSize:16];
    _a.backgroundColor = [UIColor clearColor];
    if (theTextType==TextTypeAdwallImportantInfo) {
        _a.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"adwallimportantinfo"];
    }
    else if (theTextType==TextTypeShaiZiRule){
        self.navigationItem.title = @"规则说明";
        _a.text = @" ";
        [[RuYiCaiNetworkManager sharedManager] queryshakeSigninDescription:@"gameRule_S0001"];
    }
    else{
        _a.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    [self.view addSubview:_a];
    [data release];
    [path release];
    [_a release];
	// Do any additional setup after loading the view.
}
-(void)queryShakeSigninDescriptionOK:(NSNotification *)noti
{
    NSString* str = noti.object[@"value"];
    NSLog(@"ssss%@",str);
    self.a.text = str;
}
-(void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (theTextType==TextTypeAdIntro) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
