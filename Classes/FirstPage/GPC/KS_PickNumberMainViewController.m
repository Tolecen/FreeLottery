//
//  KS_PickNumberMainViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-13.
//
//

#import "KS_PickNumberMainViewController.h"
#import "ColorUtils.h"
#import "NSLog.h"
#import "KSSumViewController.h"
#import "KS3SameViewController.h"
#import "KS2SameViewController.h"
#import "KSNoSameViewController.h"
#import "KS3ConnectedViewController.h"
#import "KSBettingLotteryDelegate.h"
#import "KSPlayingStyleSupperViewController.h"
#import "KS_PickNumberViewController.h"
#import "HXBX_KSBet_ViewController.h"
#import "SBJsonParser.h"
#import "CommonRecordStatus.h"

#define PICK_METHOD_VIEW_TAG (123)
@interface KS_PickNumberMainViewController ()
{
    UISwipeGestureRecognizer *_upSwipeGR;
    UISwipeGestureRecognizer *_downSwipeGR;
    UISwipeGestureRecognizer *_downDoubleSwipeGR;
    UIButton *_yilouBtn;
    
    KSSumViewController *_ksSumViewController;
    KS3SameViewController *_ks3sameViewController;
    KS2SameViewController *_ks2sameViewController;
    KSNoSameViewController *_ksNoSameViewController;
    KS3ConnectedViewController *_ks3ConnectedViewController;
    KSPlayingStyleSupperViewController *_ksPlayingStyleSupperViewController;
    id <KSBettingLotteryDelegate> _bettingLotteryDelegate;
    
    UILabel *explainLabel;
    BOOL isShowHistory;
    
}
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer *upSwipeGR;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer *downSwipeGR;
@property (nonatomic, retain) IBOutlet UISwipeGestureRecognizer *downDoubleSwipeGR;
@property (nonatomic, retain) UIButton *yilouBtn;

@property (nonatomic, retain) KSSumViewController *ksSumViewController;
@property (nonatomic, retain) KS3SameViewController *ks3sameViewController;
@property (nonatomic, retain) KS2SameViewController *ks2sameViewController;
@property (nonatomic, retain) KSNoSameViewController *ksNoSameViewController;
@property (nonatomic, retain) KS3ConnectedViewController *ks3ConnectedViewController;


@property (nonatomic, assign) id <KSBettingLotteryDelegate> bettingLotteryDelegate;
@end


@implementation KS_PickNumberMainViewController

@synthesize upSwipeGR = _upSwipeGR;
@synthesize downSwipeGR = _downSwipeGR;
@synthesize downDoubleSwipeGR = _downDoubleSwipeGR;
@synthesize pickType = _pickType;
@synthesize ksSumViewController = _ksSumViewController;
@synthesize ks3sameViewController = _ks3sameViewController;
@synthesize ks2sameViewController = _ks2sameViewController;
@synthesize ksNoSameViewController = _ksNoSameViewController;
@synthesize ks3ConnectedViewController = _ks3ConnectedViewController;
@synthesize ksPlayingStyleSupperViewController = _ksPlayingStyleSupperViewController;
@synthesize yilouBtn = _yilouBtn;
@synthesize delegate = _delegate;
@synthesize bettingLotteryDelegate = _bettingLotteryDelegate;
@synthesize chooseLotteryDelegate = _chooseLotteryDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    
    [_upSwipeGR release];
    [_downDoubleSwipeGR release];
    [_downSwipeGR release];
//    [_ksSumViewController release];
//    [_ks3sameViewController release];
//    [_ks2sameViewController release];
//    [_ksNoSameViewController release];
//    [_ks3ConnectedViewController release];
    self.ksPlayingStyleSupperViewController = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIView *darkLine = [[UIView alloc]initWithFrame:CGRectMake(0, - 1, 320, 2)];
//    [darkLine setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002321"]];
//    [self.view addSubview:darkLine];
    NSLog(@"%d",self.retainCount) ;
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#004b47"]];
    self.upSwipeGR = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipeActionRecognized:)]autorelease];
    self.upSwipeGR.direction = UISwipeGestureRecognizerDirectionUp;
    
    self.downSwipeGR = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipeActionRecognized:)]autorelease];
    [self.downSwipeGR setNumberOfTouchesRequired:1];
    self.downSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;
    
    self.downDoubleSwipeGR = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipeActionRecognized:)]autorelease];
    [self.downDoubleSwipeGR setNumberOfTouchesRequired:2];
    
    self.downDoubleSwipeGR.direction = UISwipeGestureRecognizerDirectionDown;

    
    [self.view addGestureRecognizer:_downSwipeGR];
    [self.view addGestureRecognizer:_downDoubleSwipeGR];
    [self.view addGestureRecognizer:_upSwipeGR];

    [self setupTopView];
    //[self setPickNumType:self.pickType];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMissDateOK:) name:@"getMissDateOK" object:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
}


-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewDidApper");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getMissDateOK" object:nil];

}


- (void)viewDidUnload
{

    [self.view removeGestureRecognizer:_upSwipeGR];
    [self.view removeGestureRecognizer:_downSwipeGR];
    [self.view removeGestureRecognizer:_downDoubleSwipeGR];
    
    [self setUpSwipeGR:nil];
    [self setDownSwipeGR:nil];
    [self setDownDoubleSwipeGR:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 玩法界面
#pragma mark - 切换界面
-(void)setPickNumType:(PickNumType)n{
    NSTrace();
    
    //切换玩法时自动收起最近5期历史开奖
    if (isShowHistory) {
        [self upSwipeActionRecognized:nil];
    }
    
    if ( n!= _pickNumType) {
        _pickNumType = n;
    }
    
    [self removePlayingMethodView];
    switch (_pickNumType) {
        case PickNumHZ:
            [self addSumPlayingMethodView];
            ((KS_PickNumberViewController *) self.chooseLotteryDelegate).pickType = PickNumHZ;
            break;
        case PickNumST:
            [self add3SameView];
            ((KS_PickNumberViewController *) self.chooseLotteryDelegate).pickType = PickNumST;
            break;
        case PickNumET:
            [self set2SameView];
            ((KS_PickNumberViewController *) self.chooseLotteryDelegate).pickType = PickNumET;
            break;
        case PickNumSBT:
            [self setNoSameView];
            ((KS_PickNumberViewController *) self.chooseLotteryDelegate).pickType = PickNumSBT;
            break;
        case PickNumEBT:
            [self set3ConnectedView];
            ((KS_PickNumberViewController *) self.chooseLotteryDelegate).pickType = PickNumEBT;
            break;
        default:
            break;
    }
    [self setGeneralPlayStyleView];
    [self isYiLou];
    
    NSLog(@"class === %@",NSStringFromClass([self.ksPlayingStyleSupperViewController class]));
}
-(void)setupTopView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 320, [UIScreen mainScreen].bounds.size.height - 180)];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:view];
    [view release];
    self.yilouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.yilouBtn setBackgroundImage:[UIImage imageNamed:@"yilou_normal.png"] forState:UIControlStateNormal];
    [self.yilouBtn setBackgroundImage:[UIImage imageNamed:@"yilou_highlight.png"] forState:UIControlStateHighlighted];
    [self.yilouBtn setBackgroundImage:[UIImage imageNamed:@"yilou_highlight.png"] forState:UIControlStateSelected];
//    [self.yilouBtn addTarget:self action:@selector(yilouEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.yilouBtn.frame = CGRectMake(10, 16, 18, 18);
    [self.view addSubview:_yilouBtn];
    
    UIButton * pressYiLouButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pressYiLouButton.frame = CGRectMake(0, 0, 35, 50);
    
    [pressYiLouButton addTarget:self action:@selector(yilouEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:pressYiLouButton];
    
    
    UILabel *yilouLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 15, 40, 20)];
    [yilouLabel setText:@"遗漏值"];
    [yilouLabel setTextAlignment:NSTextAlignmentLeft];
    [yilouLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [yilouLabel setBackgroundColor:[UIColor clearColor]];
    [yilouLabel setTextColor:[ColorUtils parseColorFromRGB:@"#c3e8e9"]];
    [self.view addSubview:yilouLabel];
    [yilouLabel release];
    explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 15, 150, 20)];
    [explainLabel setBackgroundColor:[UIColor clearColor]];
    [explainLabel setText:@"猜开奖号码相加的和"];
    [explainLabel setTextAlignment:NSTextAlignmentCenter];
    [explainLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [explainLabel setTextColor:[ColorUtils parseColorFromRGB:@"#c3e8e9"]];
    [self.view addSubview:explainLabel];
    
    UIImageView *yaoyiyaoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yaoyiyao.png"]];
    yaoyiyaoImageView.frame = CGRectMake(221, 15, 21, 21);
    [self.view addSubview:yaoyiyaoImageView];
    [yaoyiyaoImageView release];
//    UILabel *yaoyiyaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 20, 80, 20)];
//    yaoyiyaoLabel.text = @"摇一摇机选";
//    yaoyiyaoLabel.font = [UIFont boldSystemFontOfSize:12.0f];
//    [yaoyiyaoLabel setBackgroundColor:[UIColor clearColor]];
//    [yaoyiyaoLabel setTextColor:[ColorUtils parseColorFromRGB:@"#478582"]];
//    [self.view addSubview:yaoyiyaoLabel];
//    

    UIButton *yaoyiyaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [yaoyiyaoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [yaoyiyaoButton setTitle:@"摇一摇机选" forState:UIControlStateNormal];
    [yaoyiyaoButton setFrame:CGRectMake(237, 1, 80, 49)];
    [yaoyiyaoButton setBackgroundColor:[UIColor clearColor]];
    [yaoyiyaoButton setTitleColor:[ColorUtils parseColorFromRGB:@"#478582"] forState:UIControlStateNormal];
    [yaoyiyaoButton setTitleColor:[ColorUtils parseColorFromRGB:@"#478582"] forState:UIControlStateHighlighted];
    [yaoyiyaoButton addTarget:self action:@selector(yaoYiYaoEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yaoyiyaoButton];
}
#pragma mark - 切换移除
- (void)removePlayingMethodView{
    self.bettingLotteryDelegate = nil;
    UIView *view = [self.view viewWithTag:PICK_METHOD_VIEW_TAG];
    [view removeFromSuperview];
}

#pragma mark - 和值界面
- (void)addSumPlayingMethodView
{
    self.ksPlayingStyleSupperViewController = [[[KSSumViewController alloc] init] autorelease];
    [explainLabel setText:@"猜开奖号码相加的和"];
}

#pragma mark 三同号
- (void)add3SameView
{
    self.ksPlayingStyleSupperViewController = [[[KS3SameViewController alloc]init]autorelease];
    [explainLabel setText:@"猜豹子号（3个相同号）"];
}

#pragma mark 二同号界面
- (void)set2SameView{
    
    self.ksPlayingStyleSupperViewController = [[[KS2SameViewController alloc]init]autorelease];
    [explainLabel setText:@"猜对子号（有2个号相同）"];
}
#pragma mark 不同号界面
- (void)setNoSameView{

    self.ksPlayingStyleSupperViewController = [[[KSNoSameViewController alloc]init]autorelease];
    [explainLabel setText:@""];

}

#pragma mark 三连号通选
- (void)set3ConnectedView
{
    self.ksPlayingStyleSupperViewController = [[[KS3ConnectedViewController alloc]init]autorelease];
    [explainLabel setText:@""];

}

- (void)setGeneralPlayStyleView{
    NSTrace();
    self.ksPlayingStyleSupperViewController.chooseLotteryDelegate = self.chooseLotteryDelegate;
    self.ksPlayingStyleSupperViewController.indexPath = self.indexPath;
    self.ksPlayingStyleSupperViewController.view.frame = CGRectMake(0, 50, 320, [UIScreen mainScreen].bounds.size.height - 160);
    [self.view addSubview:_ksPlayingStyleSupperViewController.view];
    self.bettingLotteryDelegate = _ksPlayingStyleSupperViewController;
    [self.ksPlayingStyleSupperViewController.view setTag:PICK_METHOD_VIEW_TAG];
}


#pragma mark - IBAction
//上滑
- (IBAction)upSwipeActionRecognized:(id)sender {
    NSLog(@"up-SwipeActionRecognized");
    
    isShowHistory = NO;
    
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.frame = (CGRect){self.view.frame.origin.x, 60, self.view.frame.size};
        }];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(swipeActionRecognized)]) {
        [_delegate swipeActionRecognized];
    }
}
//下滑
- (IBAction)downSwipeActionRecognized:(id)sender {

    isShowHistory = YES;
    
    NSUInteger numberOfTouchesRequired = [(UISwipeGestureRecognizer *)sender numberOfTouchesRequired];
    
    NSLog(@"numberOfTouchesRequired:%d",numberOfTouchesRequired);
    
    if(UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
    {
        
        if (numberOfTouchesRequired == 1) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.frame = (CGRect){self.view.frame.origin.x, 262, self.view.frame.size};
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.view.frame = (CGRect){self.view.frame.origin.x, 364, self.view.frame.size};
            }];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(swipeActionRecognized)]) {
        [_delegate swipeActionRecognized];
    }
}
-(void)showYilou{
    if ([_bettingLotteryDelegate conformsToProtocol:@protocol(KSBettingLotteryDelegate)]) {
        [self.bettingLotteryDelegate bettingLotteryViewShowYiLou:YES];
    }
}
-(void)hiddenYilou{
    if ([_bettingLotteryDelegate conformsToProtocol:@protocol(KSBettingLotteryDelegate)]) {
        [self.bettingLotteryDelegate bettingLotteryViewShowYiLou:NO];
    }
}
-(void)isYiLou{
    if ([self.yilouBtn isSelected]) {
        [self showYilou];
    }else{
        [self hiddenYilou];
    }
}
-(IBAction)yilouEvent:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.isSelected) {
        btn.selected = NO;
        _yilouBtn.selected = NO;
        [self hiddenYilou];
    }else{
        btn.selected = YES;
        _yilouBtn.selected = YES;
        [self showYilou];
    }
}
-(IBAction)yaoYiYaoEvent:(id)sender{
    [self motionEnded];
}
#pragma mark -摇一摇
-(void)motionEnded{
    NSTrace();
    
    if (isShowHistory) {
        [self upSwipeActionRecognized:nil];
    }
    
    KS_PickNumberViewController * controller = ((KS_PickNumberViewController *)self.chooseLotteryDelegate);
    
    if (controller.navigationController.viewControllers.count == 3) {//tableView页面摇一摇执行方法
        [self.ksPlayingStyleSupperViewController changeKsBetingModelData];
//        [((KS_PickNumberViewController *)self.chooseLotteryDelegate).betViewController reloadTableViewData];
        
        HXBX_KSBet_ViewController * betController = [controller.navigationController.viewControllers objectAtIndex:2];
        [betController reloadTableViewData];
        
        return ;
    }
    
    //选号页面摇一摇执行下面方法
    if ([_bettingLotteryDelegate conformsToProtocol:@protocol(KSBettingLotteryDelegate)]) {
        
        [self.bettingLotteryDelegate bettingLotteryViewMotionEnded];
    }
}
#pragma mark -清空号码
-(void)cleanUpLotteryBasketEvent{
    NSTrace();
    if ([_bettingLotteryDelegate conformsToProtocol:@protocol(KSBettingLotteryDelegate)]) {
        
        [self.bettingLotteryDelegate cleanUpLotteryBasket];
    }
    
}



- (void)getMissDateOK:(NSNotification*)notification{
    
    NSLog(@"class === %@",NSStringFromClass([self.ksPlayingStyleSupperViewController class]));
    
    NSString * parserString = [CommonRecordStatus commonRecordStatusManager].netMissDate;
    
    [self.ksPlayingStyleSupperViewController getMissNumber:parserString];
}


@end
