//
//  UserBindDetileVC.m
//  Boyacai
//
//  Created by qiushi on 13-9-26.
//
//

#import "UserBindDetileVC.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"

@interface UserBindDetileVC ()

@end

@implementation UserBindDetileVC

@synthesize nameLable  = _nameLable;
@synthesize ceridLable = _ceridLable;
@synthesize nameStr = _nameStr;
@synthesize ceridStr = _ceridStr;

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
	// Do any additional setup after loading the view.
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#f4f2ee"];
    UILabel *labelName = [[UILabel alloc]  initWithFrame:CGRectMake(20, 45, 85, 21)];
    labelName.font = [UIFont systemFontOfSize:15];
    labelName.backgroundColor = [UIColor clearColor];
    labelName.text = @"您的姓名:";
    labelName.textColor = [UIColor blackColor];
    [self.view addSubview:labelName];
    [labelName release];
    
    self.nameLable = [[[UILabel alloc] initWithFrame:CGRectMake(110, 45, 120, 21)] autorelease];
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor blackColor];
    _nameLable.text = self.nameStr;
    [self.view addSubview: self.nameLable];
    UILabel *label2 = [[UILabel alloc]  initWithFrame:CGRectMake(20, 80, 85, 21)];
    label2.textColor = [UIColor blackColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:15];
    label2.text = @"证件号码:";
    [self.view addSubview:label2];
    
    self.ceridLable = [[[UILabel alloc] initWithFrame:CGRectMake(110,80, 160, 21)] autorelease];
    self.ceridLable.backgroundColor = [UIColor clearColor];
    self.ceridLable.textColor = [UIColor blackColor];
    self.ceridLable.font = [UIFont systemFontOfSize:15];
    self.ceridLable.text = self.ceridStr;
    [self.view addSubview: self.ceridLable];
    
    UILabel *infoLable = [[UILabel alloc]  initWithFrame:CGRectMake(20, 115, 240, 36)];
    infoLable.backgroundColor = [UIColor clearColor];
    infoLable.lineBreakMode = UILineBreakModeWordWrap;
    infoLable.numberOfLines = 0;
    infoLable.text = @"您的账户已经绑定，如有疑问请联系客服咨询。";
    infoLable.font = [UIFont systemFontOfSize:15];
    infoLable.textColor = [UIColor blackColor];
    [self.view addSubview:infoLable];
    [infoLable release];
    
    

    UILabel *kefuLable = [[UILabel alloc]  initWithFrame:CGRectMake(20, 155, 85, 36)];
    kefuLable.backgroundColor = [UIColor clearColor];
    kefuLable.text = @"客服电话:";
    kefuLable.font = [UIFont systemFontOfSize:15];
    kefuLable.textColor = [ColorUtils parseColorFromRGB:@"#7a746b"];
    [self.view addSubview:kefuLable];
    [kefuLable release];
    
    UIButton *buttonService = [[UIButton alloc] initWithFrame:CGRectMake(110, 155, 150, 36)];
    buttonService.tag = 2;
    [buttonService setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonService setTitle:@"400-856-1000" forState:UIControlStateNormal];
    buttonService.titleLabel.font = [UIFont systemFontOfSize:15];
    buttonService.backgroundColor = [UIColor clearColor];
    [buttonService addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonService];
    
}

-(void) buttonClicked:(id)sender
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"])
    {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
    
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
    
//    [self dismissWithClickedButtonIndex:0 animated:YES];
    
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
