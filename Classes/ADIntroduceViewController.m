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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [AdaptationUtils adaptation:self];
    //    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    UITextView*a = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320,self.view.frame.size.height)];
    NSString *path = nil;
    if (theTextType==TextTypeAdIntro) {
        self.navigationItem.title = @"换彩说明";
        path=[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"detailIntroduce"ofType:@"txt"]];
    }
    else if(theTextType==TextTypeCommonQuestion){
        self.navigationItem.title = @"常见问题";
        path=[[NSString alloc]initWithString:[[NSBundle mainBundle]pathForResource:@"commonQuestion"ofType:@"txt"]];
    }
    else if (theTextType==TextTypeAdwallImportantInfo){
        self.navigationItem.title = @"积分墙重要通知";
        
    }
    

    
    NSData* data = [[NSData alloc]initWithContentsOfFile:path];
    a.editable = NO;
    a.font = [UIFont systemFontOfSize:16];
    a.backgroundColor = [UIColor clearColor];
    if (theTextType==TextTypeAdwallImportantInfo) {
        a.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"adwallimportantinfo"];
    }
    else{
        a.text = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    [self.view addSubview:a];
    [data release];
    [path release];
    [a release];
	// Do any additional setup after loading the view.
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
