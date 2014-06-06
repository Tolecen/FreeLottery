//
//  CustomTabBarViewController.m
//  Boyacai
//
//  Created by viviya on 13-9-28.
//
//

#import "CustomTabBarViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "AdaptationUtils.h"
#import "ExchangeLotteryWithIntegrationViewController.h"


@interface CustomTabBarViewController ()
{
    UIButton  *preSelectedButton;
    UIViewController *currentViewController;
    int  tabViewHeight;
    BOOL shouldNotSwitch;
}
@end

@implementation CustomTabBarViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shownTabView:) name:@"shownTabView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabView:) name:@"hiddenTabView" object:nil];

    }
    return self;
}

- (void)dealloc
{
    [_firstNavController release];
    [_secondNavController release];
    [_thirdNavController release];
    [_fourthNavController release];
    [_fifthNavController release];
    
    [_homeButton release];
    [_secondButton release];
    [_thirdButton release];
    [_forthbutton release];
    [_fifthButton release];
    [_customTabView release];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hiddenTabView" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shownTabView" object:nil];

    [super dealloc];
}


-(id)initViewController
{
    self=[super init];
    if (self) {
        FirstPageViewController *firstViewController=[[[FirstPageViewController alloc]init] autorelease];
//        DrawLotteryPageViewController *secondViewController=[[[DrawLotteryPageViewController alloc]init] autorelease];
        firstViewController.customTabbar = self;
         ActivitiesViewController *secondViewController=[[[ActivitiesViewController alloc]init] autorelease];
        ExchangeLotteryWithIntegrationViewController *thirdViewController=[[[ExchangeLotteryWithIntegrationViewController alloc]init]autorelease];
        thirdViewController.shouldShowTabbar = YES;
        FourthPageViewController *fourthViewController=[[[FourthPageViewController alloc]init] autorelease];
        FifthPageViewController *fifthViewController=[[[FifthPageViewController alloc]init] autorelease];
        _firstNavController=[[UINavigationController alloc]initWithRootViewController:firstViewController];
        
        _secondNavController=[[UINavigationController alloc]initWithRootViewController:thirdViewController];
        _thirdNavController=[[UINavigationController alloc]initWithRootViewController:secondViewController];
        _fourthNavController=[[UINavigationController alloc]initWithRootViewController:fourthViewController];
        _fifthNavController=[[UINavigationController alloc]initWithRootViewController:fifthViewController];
        _firstNavController.navigationBar.barStyle=UIBarStyleBlack;
        _secondNavController.navigationBar.barStyle=UIBarStyleBlack;
        _thirdNavController.navigationBar.barStyle=UIBarStyleBlack;
        _fourthNavController.navigationBar.barStyle=UIBarStyleBlack;
        _fifthNavController.navigationBar.barStyle=UIBarStyleBlack;
        
//        _firstNavController.navigationItem.title=@"购彩大厅";
//        _secondNavController.navigationItem.title=@"合买大厅";
//        _thirdNavController.navigationItem.title=@"开奖中心";
//        _fourthNavController.navigationItem.title=@"用户中心";
//        _fifthNavController.navigationItem.title=@"更多";
        
        preSelectedButton=nil;
        currentViewController=nil;
        shouldNotSwitch=NO;
        tabViewHeight=50;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    btnArray = [[NSArray alloc] initWithObjects:self.homeButton,self.secondButton,self.thirdButton,self.forthbutton, nil];
    
    [AdaptationUtils adaptation:self];
    [self customTabTapped:_homeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
}


- (void)selectTabTapped:(NSString*)str
{
    if ([str isEqualToString:@"0"]) {
      [self customTabTapped:_homeButton];
    }
//     [self customTabTapped:_homeButton];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- NSNotification Center



-(void)hiddenTabView:(NSNotification *)notification
{
    shouldNotSwitch=YES;
    tabViewHeight=0;
    CGRect tabFrame=_customTabView.frame;
    tabFrame.size.height=tabViewHeight;
    _customTabView.frame=tabFrame;
    _customTabView.hidden=YES;
    [self customTabTapped:preSelectedButton];
}

-(void)shownTabView:(NSNotification *)notification
{
    shouldNotSwitch=YES;
    tabViewHeight=50;
    CGRect tabFrame=_customTabView.frame;
    tabFrame.size.height=tabViewHeight;
    _customTabView.frame=tabFrame;
    _customTabView.hidden=NO;
    [self customTabTapped:preSelectedButton];
}

#pragma mark -- 按钮的触发时间

- (IBAction)customTabTapped:(id)sender {
    UIButton *currentSelectButton=(UIButton *)sender;
    int currentTag=currentSelectButton.tag;
    
    preSelectedButton.selected=NO;
    currentSelectButton.selected=YES;

    CGRect viewFrame=CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-tabViewHeight);
    
    switch (currentTag) {
        case 0:
            _firstNavController.view.frame=viewFrame;
            [self setCurrentViewController:_firstNavController];
            break;
        case 1:
            _secondNavController.view.frame=viewFrame;
            [self setCurrentViewController:_secondNavController];
            break;
        case 2:
            _thirdNavController.view.frame=viewFrame;
            [self setCurrentViewController:_thirdNavController];
            break;
        case 3:
            _fourthNavController.view.frame=viewFrame;
            [self setCurrentViewController:_fourthNavController];
            break;
        case 4:
            _fifthNavController.view.frame=viewFrame;
            [self setCurrentViewController:_fifthNavController];
            break;
            
        default:
            break;
    }
    
    preSelectedButton=currentSelectButton;
    
    for (UIButton * btn in btnArray) {
        if (btn.tag!=currentTag) {
            btn.selected = NO;
        }
        else
            btn.selected = YES;
    }
    
}

- (void)customTabSelected:(int)currentTagq {
    int currentTag = currentTagq;
//    if (currentTagq==1) {
        UIButton *currentSelectButton=_thirdButton;
        currentTag=currentSelectButton.tag;
        
        preSelectedButton.selected=NO;
        currentSelectButton.selected=YES;
//    }

    
    CGRect viewFrame=CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height-tabViewHeight);
    
    switch (currentTag) {
        case 0:
            _firstNavController.view.frame=viewFrame;
            [self setCurrentViewController:_firstNavController];
            break;
        case 1:
            _secondNavController.view.frame=viewFrame;
            [self setCurrentViewController:_secondNavController];
            break;
        case 2:
            _thirdNavController.view.frame=viewFrame;
            [self setCurrentViewController:_thirdNavController];
            break;
        case 3:
            _fourthNavController.view.frame=viewFrame;
            [self setCurrentViewController:_fourthNavController];
            break;
        case 4:
            _fifthNavController.view.frame=viewFrame;
            [self setCurrentViewController:_fifthNavController];
            break;
            
        default:
            break;
    }
    
    preSelectedButton=currentSelectButton;
    
    for (UIButton * btn in btnArray) {
        if (btn.tag!=currentTag) {
            btn.selected = NO;
        }
        else
            btn.selected = YES;
    }
    
}




-(void)setCurrentViewController:(UIViewController *) newViewCtrl
{
    if (shouldNotSwitch) { //压站出站时，不需要再次切换
        shouldNotSwitch=NO;
        return;
    }
	if (currentViewController != newViewCtrl)
	{
		if (currentViewController)
        {
			[currentViewController.view removeFromSuperview];
		}
		currentViewController = newViewCtrl;
		[self.view addSubview:currentViewController.view];
        [self.view bringSubviewToFront:_customTabView];
	}
    
}



@end
