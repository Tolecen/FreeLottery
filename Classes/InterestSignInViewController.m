//
//  InterestSignInViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-12.
//
//

#import "InterestSignInViewController.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
#import "ColorUtils.h"
#import "AnimationView.h"
#import "RuYiCaiNetworkManager.h"
#import "EGOImageButton.h"
@interface InterestSignInViewController ()
{
    BOOL canShake;
    int location;
    RuYiCaiAppDelegate*m_delegate;
}
@property (nonatomic,retain)NSString* openURL;
@property (nonatomic,retain)UILabel * descriptionsL;
@property (nonatomic,retain)UILabel * promptL;
@property (nonatomic,retain)NSString* selectedID;
@property (nonatomic,retain)NSString* selectedName;
@property (nonatomic,retain)AnimationView * animationV;
@end

@implementation InterestSignInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        canShake = NO;
    }
    return self;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_descriptionsL release];
    [_promptL release];
    [_animationV release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
    [AdaptationUtils adaptation:self]; 
    [self.navigationController.navigationBar setBackground];
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"摇一摇,签到有惊喜";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:({
        UIButton * backB = [UIButton buttonWithType:UIButtonTypeCustom];
        backB.frame = CGRectMake(0, 0, 25, 25);
        [backB setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [backB addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        backB;
    })];
    float h = 44;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0){
        h = 64;
    }
    UIImageView * backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-h)];
    backgroundView.image = [UIImage imageNamed:@"background"];
    [self.view addSubview:backgroundView];
    [backgroundView release];
    
    UIImageView * textImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, backgroundView.frame.size.height-200, 320, 200)];
    textImageV.image = [UIImage imageNamed:@"textBG"];
    [self.view addSubview:textImageV];
    [textImageV release];
    self.promptL = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 320, 60)];
    _promptL.backgroundColor = [UIColor clearColor];
    _promptL.numberOfLines = 0;
    _promptL.textAlignment = NSTextAlignmentCenter;
    _promptL.textColor = [UIColor redColor];
    [textImageV addSubview:_promptL];
    [_promptL release];
    self.descriptionsL =[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 300, 100)];
    _descriptionsL.backgroundColor = [UIColor clearColor];
    _descriptionsL.textColor = [UIColor blackColor];
    _descriptionsL.font = [UIFont systemFontOfSize:13];
    _descriptionsL.numberOfLines = 0;
    [textImageV addSubview:_descriptionsL];
    [_descriptionsL release];
    
    UIImageView * yaoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(108, self.view.frame.size.height/4, 104, 104)];
    yaoImageView.image = [UIImage imageNamed:@"yao"];
    [backgroundView addSubview:yaoImageView];
    [yaoImageView release];
    
    self.animationV = [[AnimationView alloc]initWithFrame:backgroundView.frame];
    _animationV.sound = YES;
    [self.view addSubview:_animationV];
    [_animationV release];
    [[RuYiCaiNetworkManager sharedManager] queryRecommandedAppList:@"topone"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryRecommandedAppTopOneOK:) name:@"queryRecommandedAppListOK" object:nil];
    if (_ActID) {
        [[RuYiCaiNetworkManager sharedManager] queryShakeActList];
        [[RuYiCaiNetworkManager sharedManager] queryshakeSigninDescription];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryShakeActListOK:) name:@"WXRQueryShakeActListOK" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryShakeSigninDescriptionOK:) name:@"WXRQueryShakeSigninDescriptionOK" object:nil];
        _promptL.text = @"您就可劲的摇吧，摇到啥就送啥\n要的频率很重要啊";
    }else
    {
        _promptL.text = @"今日已签到";
        textImageV.frame = CGRectMake(0, backgroundView.frame.size.height-100, 320, 200);
    }
    
}
- (void)openMyURL
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_openURL]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: _openURL]];
    }
}
-(void)queryRecommandedAppTopOneOK:(NSNotification *)noti
{
    NSString* str = [noti.object[@"value"] objectForKey:@"background"];
    self.openURL = [noti.object[@"value"] objectForKey:@"downloadUrl"];
    EGOImageButton* button = [[EGOImageButton alloc]initWithFrame:CGRectMake(0, 0, 320, 80)];
    button.imageURL = [NSURL URLWithString:str];
    [button addTarget:self action:@selector(openMyURL) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)queryShakeActListOK:(NSNotification *)noti
{
    canShake = YES;
    NSArray * arr = noti.object[@"result"];
    if (arr&&arr.count>0) {
        NSMutableArray * mutableArr = [NSMutableArray array];
        for (int i = 0; i < arr.count; i++) {
            NSDictionary * dic = arr[i];
            [mutableArr addObject:dic[@"name"]];
            if ([dic[@"selected"] intValue] == 1) {
                location = i;
                self.selectedID = dic[@"id"];
                self.selectedName = dic[@"name"];
            }
        }
        _animationV.subviewsArray = mutableArr;
    }
}
-(void)queryShakeSigninDescriptionOK:(NSNotification *)noti
{
    NSString* str = noti.object[@"value"];
    _descriptionsL.text = str;
}
- (void)doShakeCheckOK:(NSNotification *)noti
{
    [m_delegate.activityView disActivityView];
    NSString* str = [noti.object[@"result"] objectForKey:@"retMsg"];
    [_animationV showCardWithTitle:_selectedName content:str Target:self action:@selector(back:)];
}
- (void)doShakeCheckFail:(NSNotification *)noti
{
    [m_delegate.activityView disActivityView];
    canShake = YES;
    [_animationV setNeedStop:NO];
}
- (void)back:(id)sender
{
    if (_animationV.animation) {
        return;
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(interestSignInViewControllerDidCancel:)]) {
        [_delegate interestSignInViewControllerDidCancel:self];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake&&!_animationV.animation&&canShake) {
        [_animationV starAnimation];
        [self performSelector:@selector(stopAnimation) withObject:nil afterDelay:6];
    }
}
- (void)stopAnimation
{
    [_animationV stopAnimationWithSubviewsLocation:location completion:^{
        NSLog(@"stop");
        canShake = NO;
        
        [[RuYiCaiNetworkManager sharedManager] doShakeCheckInWithActID:_selectedID AndCheckID:_ActID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doShakeCheckOK:) name:@"WXRDoShakeCheckOK" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doShakeCheckFail:) name:@"WXRDoShakeCheckFail" object:nil];
        [m_delegate.activityView activityViewShow];
        [m_delegate.activityView.titleLabel setText:@"签到中..."];
    }];
}
@end
