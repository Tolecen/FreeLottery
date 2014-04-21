//
//  KS_PickNumberViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-13.
//
//

#import "KS_PickNumberViewController.h"
#import "BackBarButtonItemUtils.h"
#import "Custom_tabbar.h"
#import "ColorUtils.h"
#import "KS_HistoryViewController.h"
#import "NSLog.h"
#import "KSBettingModel.h"
#import "AdaptationUtils.h"
#import "CommonRecordStatus.h"
#import "RYCImageNamed.h"
#import "KSChooseLotteryDelegate.h"
#import "PlayIntroduceViewController.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "QueryLotBetViewController.h"
#import "ColorUtils.h"
#import "HXBX_KSBet_ViewController.h"
#import "KSSumViewController.h"
#import "CollectionMenuViewUtil.h"
#import "UINavigationBarCustomBg.h"


@interface KS_PickNumberViewController ()<SlidingRecognizerDelegate,KSChooseLotteryDelegate>
{
    KS_HistoryViewController *_historyTableView;
    KS_PickNumberMainViewController *_ksPNVC;
    
    KSBettingModel *_ksBettingModel;
    UILabel *_betLabel;
    UILabel *_moneyLabel;
    
    UIView * m_detailView;
}
@property (nonatomic, retain) KS_HistoryViewController *historyTableView;;
@property (nonatomic, retain) KSBettingModel *ksBettingModel;
@property (nonatomic, retain) UILabel *betLabel;
@property (nonatomic, retain) UILabel *moneyLabel;
@end

@implementation KS_PickNumberViewController
@synthesize historyTableView = _historyTableView;
@synthesize ksPNVC = _ksPNVC;
@synthesize ksBettingModel = _ksBettingModel;
@synthesize betLabel = _betLabel;
@synthesize moneyLabel = _moneyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    
    NSLog(@"%lu",(unsigned long)self.historyTableView.retainCount) ;
    [_historyTableView release];
    _historyTableView = nil;
    [_ksPNVC release];
    _ksPNVC = nil;
    self.betViewController = nil;
    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    //[BackBarButtonItemUtils addBackButtonForController:self];
    
    //进入快三界面后将navigationBar的背景颜色改变
    [self.navigationController.navigationBar setNavigationBackgroundColor:[ColorUtils parseColorFromRGB:@"#5b0418"]];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(goToBack) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    
    [BackBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(moreAction)];
    
    NSArray *titles = [NSArray arrayWithObjects:
                       @"和值",
                       @"三同号",
                       @"二同号",
                       @"三不同号",
                       @"二不同号",
                       nil];
    NSArray *noramlImgs = [NSArray arrayWithObjects:
                           @"Item_hz_button_normal_image.png",
                           @"Item_3t_button_normal_image.png",
                           @"Item_2t_button_normal_image.png",
                           @"Item_3bt_button_normal_image.png",
                           @"Item_2bt_button_normal_image.png",
                           nil];
    NSArray *selectedImgs = [NSArray arrayWithObjects:
                             @"Item_hz_button_selected_image.png",
                             @"Item_3t_button_selected_image.png",
                             @"Item_2t_button_selected_image.png",
                             @"Item_3bt_button_selected_image.png",
                             @"Item_2bt_button_selected_image.png",
                             nil];
    
    titleMenuView = [TitleViewButtonItemUtils addTitleMenuViewForController:self menuTitles:titles menuImages:noramlImgs menuSelectedImages:selectedImgs delegate:self];
    
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#003432"]];
    
    self.historyTableView = [[KS_HistoryViewController alloc]init];
    self.historyTableView.view.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_historyTableView.view];
    [self.historyTableView release];
    [self setBottomView];//bottomView
    
    self.ksPNVC = [[KS_PickNumberMainViewController alloc]init];
    self.ksPNVC.delegate = self;
    self.ksPNVC.chooseLotteryDelegate = self;
    self.ksPNVC.pickType = self.pickType;
    self.ksPNVC.indexPath = self.indexPath;
    self.ksPNVC.view.frame = CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height);
    //    self.ksPNVC.pickNumType = self.pickNumType;//出问题时没找着
    
    [self.view addSubview:_ksPNVC.view];
    [self.view bringSubviewToFront:bottomView];
    [self.ksPNVC release];
    
    [self changePlayGUI];

    
    [self setDetailView];//玩法介绍和投注查询View
}


-(void) changePlayGUI{
    
    NSLog(@"%d",self.pickType);
    [titleMenuView.menuView menuImageButtonAction:[titleMenuView.menuView.buttons objectAtIndex:self.pickType]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"retain count ----- %d  ,  %d",self.historyTableView.retainCount,self.retainCount);
    
}

-(void)setBottomView{
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50 -64, 320, 50)];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(10, 10, 60, 30);
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[ColorUtils parseColorFromRGB:@"#fcdcdc"] forState:UIControlStateNormal];
    clearBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [clearBtn addTarget:self action:@selector(clearEvent:) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn addTarget:self action:@selector(clearButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [clearBtn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#11312c"]];
    [bottomView addSubview:clearBtn];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(250, 10, 60, 30);
    [buyBtn setTitle:@"投注" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[ColorUtils parseColorFromRGB:@"#000000"] forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [buyBtn addTarget:self action:@selector(buyEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn addTarget:self action:@selector(buyButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    [buyBtn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d38806"]];
    [bottomView addSubview:buyBtn];
    
    
    self.betLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 78, 30)];
    [self.betLabel setTextColor:[ColorUtils parseColorFromRGB:@"#ffe5c9"]];
    [self.betLabel setBackgroundColor:[UIColor clearColor]];
    [self.betLabel setTextAlignment:NSTextAlignmentRight];
    //[self.betLabel setText:@"共0注"];
    [bottomView addSubview:_betLabel];
    
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(162, 10, 78, 30)];
    [self.moneyLabel setTextColor:[ColorUtils parseColorFromRGB:@"#ffa234"]];
    [self.moneyLabel setBackgroundColor:[UIColor clearColor]];
    [self.moneyLabel setTextAlignment:NSTextAlignmentLeft];
    //[self.moneyLabel setText:@"0元"];
    [bottomView addSubview:_moneyLabel];
    
    
    [bottomView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#011814"]];
    [self.view addSubview:bottomView];
    
    
    //self.ksBettingModel = [KSBettingModel share];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.historyTableView viewWillAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [self.navigationController setNavigationBarHidden:NO];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    
    //[self setHidesBottomBarWhenPushed:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%d",self.navigationController.viewControllers.count) ;
    
//    [self performSelector:@selector(addAction) withObject:nil afterDelay:0.00000000000001];
}

//-(void)addAction{
//    
//    if ([[KSBettingModel share] kSBettingArrayModel].count != 0 && self.navigationController.viewControllers.count != 4) {
//        
//        self.betViewController = [[HXBX_KSBet_ViewController alloc] init];
//        
//        _betViewController.dataSource = [[KSBettingModel share] kSBettingArrayModel];
//        _betViewController.delegate = self.ksPNVC;
//        [self.navigationController pushViewController:_betViewController animated:YES];
//        [_betViewController release];
//        
//    }
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData:(KSLotterysModel *)kSLotterysModel{
    
    NSArray *array = [kSLotterysModel getLotters];
    NSLog(@"%d",[array count]);
    [self.betLabel setText:[NSString stringWithFormat:@"共%d注",[array count]]];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%d彩豆",[array count] * 2 *aas]];
    
}

#pragma mark -TitleViewButtonItemUtilsDelegate
-(void)menuNumberOfRowsInMenu:(NSInteger)num{
    NSLog(@"%d",num);
    self.playType = num;
    
    [self.ksPNVC setPickNumType:num];
    
    //    [[RuYiCaiNetworkManager sharedManager] getInformation:ZHUAN_JIA_TUI_JIAN withLotNo:lotNo];
}

#pragma mark -IBAction
-(IBAction)clearEvent:(id)sender{
    NSTrace();
    
    [sender setBackgroundColor:[ColorUtils parseColorFromRGB:@"#11312c"]];
    
    [sender setBackgroundColor:[ColorUtils parseColorFromRGB:@"#11312c"]];
    
    if (self.ksPNVC && [self.ksPNVC respondsToSelector:@selector(cleanUpLotteryBasketEvent)]) {
        [self.ksPNVC cleanUpLotteryBasketEvent];
    }
    
}


-(void)clearButtonHighlighted:(UIButton *)btn{
    
    [btn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#0c221e"]];
    
}


-(IBAction)buyEvent:(id)sender{
    NSTrace();
    [sender setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d38806"]];

    [self.ksPNVC.ksPlayingStyleSupperViewController changeKsBetingModelData];
    
    if (self.ksPNVC.ksPlayingStyleSupperViewController.isSelectedNumber == YES) {
        
        if (self.controllerBePushFirstOrOtherType == first) {
            self.betViewController = [[HXBX_KSBet_ViewController alloc] init];
            
            _betViewController.dataSource = self.lotterysArray;
            _betViewController.delegate = self.ksPNVC;
            [self.navigationController pushViewController:_betViewController animated:YES];
            [_betViewController release];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    }
    
    
}


-(void)buyButtonHighlighted:(UIButton *)btn{
    
    [btn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#a15d04"]];
}


#pragma mark -摇一摇
-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event
{
    NSTrace();
    if(motion == UIEventSubtypeMotionShake)
    {
        // your code
        if (self.ksPNVC && [self.ksPNVC respondsToSelector:@selector(motionEnded)]) {
            [self.ksPNVC motionEnded];
        }
    }
}

#pragma mark -SlidingRecognizerDelegate - KS_PickNumberMainViewController
-(void)swipeActionRecognized{
    
    NSLog(@"---------------swipeActionRecognized---------------------------");
    
    if(self.historyTableView) [self.historyTableView refreshHistoryData:nil];
    
}

#pragma mark -KSChooseLotteryDelegate
-(void)notifyObserverLotteryHasChange:(KSLotterysModel *)kSLotterysModel{
    NSTrace();
    //    [self reloadData:kSLotterysModel];
    NSArray * array = [kSLotterysModel getLotters];
    [self.betLabel setText:[NSString stringWithFormat:@"共%d注",[array count]]];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%d彩豆",[array count] * 2*aas]];
    
    
}

-(void)notifyObserverCombinationLotteryHasChange:(KSLotterysModel *)kSLotterysModel{
    NSTrace();
    //    NSArray *array = [kSLotterysModel getLotters];
    
    
    
}
-(void)notifyObserverNormalAndCombinationLotteryHasChange:(KSLotterysModel *)kSLotterysModel andKSBettingModel:(KSBettingModel *)ksBettingModel{
    NSTrace();
    
    NSArray *array = [kSLotterysModel getLotters];
    
    kSLotterysModel.amountString = [NSString stringWithFormat:@"%d",[array count] * 200];
    
    self.lotterysArray = ksBettingModel.kSBettingArrayModel;
    
    NSLog(@"%d",[array count]);
    [self.betLabel setText:[NSString stringWithFormat:@"共%d注",[array count]]];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%d彩豆",[array count] * 2*aas]];
    
    if (self.betViewController != nil) {
        [self.betViewController reloadTableViewData];
    }
}
-(void)notifyObserverRemoveObjects{
    NSTrace();
    [self reloadData:[KSLotterysModel new]];
}
-(void)notifyLotteryBasketHasChange:(KSBettingModel *)ksBettingModel{
    NSTrace();
    
    int i = 0;
    self.lotterysArray = [[KSBettingModel share] kSBettingArrayModel];
    
    for (KSLotterysModel *m in ksBettingModel.kSBettingArrayModel) {
        i += [m getCombinationLotterysCount];
        m.amountString = [NSString stringWithFormat:@"%d",[m getCombinationLotterysCount] * 200];
    }
    
    [self.betLabel setText:[NSString stringWithFormat:@"共%d注",i]];
    int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%d彩豆",i * 2*aas]];
    
}

- (void)goToBack
{
    if (self.controllerBePushFirstOrOtherType == first) {
        [[KSBettingModel share] removeAll];
    }
    
    
    if (self.controllerBePushFirstOrOtherType == first) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    }
    
    /*返回时将MenuView隐藏*/
    TitleViewButtonItemUtils * titleView = (TitleViewButtonItemUtils *)self.navigationItem.titleView;
    titleView.openMenu = YES;
    [titleView changeMenuView];
    /*返回时将MenuView隐藏*/
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)moreAction{
    NSLog(@"sdfd");
    
    
    /*返回时将MenuView隐藏*/
    TitleViewButtonItemUtils * titleView = (TitleViewButtonItemUtils *)self.navigationItem.titleView;
    if (titleView.openMenu == YES ) {
        [titleView changeMenuView];
        if (m_detailView.hidden == NO) {
            return;
        }
    }
    /*返回时将MenuView隐藏*/
    [self detailViewButtonClick:nil];
}

- (void)detailViewButtonClick:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = .5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;//{ kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade }
    if(m_detailView.hidden)
    {
        transition.subtype = kCATransitionFromBottom;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = NO;
    }
    else
    {
        transition.subtype = kCATransitionFromTop;//{ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom }
        [m_detailView.layer addAnimation:transition forKey:nil];
        m_detailView.hidden = YES;
    }
}

-(void)setDetailView{
    m_detailView = [[UIView alloc] initWithFrame:CGRectMake(167, 0, 153, 122)];
    m_detailView.backgroundColor = [ColorUtils parseColorFromRGB:@"#004642"];
    
    UIView * frameLeftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 122)] autorelease];
    [frameLeftView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002422"]];
    UIView * frameRightView = [[[UIView alloc] initWithFrame:CGRectMake(152, 0, 1, 122)] autorelease];
    [frameRightView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002422"]];
    UIView * frameTopView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 153, 1)] autorelease];
    [frameTopView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002422"]];
    UIView * frameDownView = [[[UIView alloc] initWithFrame:CGRectMake(0, 121, 153, 1)] autorelease];
    [frameDownView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#002422"]];
    [m_detailView addSubview:frameLeftView];
    //[m_detailView addSubview:frameRightView];
    //[m_detailView addSubview:frameTopView];
    [m_detailView addSubview:frameDownView];
    //    UIImageView* imgBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 140)];
    //    imgBg.image = RYCImageNamed(@"tzy_xlmenu_bg.png");
    //    [imgBg setBackgroundColor:[UIColor clearColor]];
    //    [m_detailView addSubview:imgBg];
    //    [imgBg release];
    
    UIButton* introButton = [[CommonRecordStatus commonRecordStatusManager] creatNewIntroButton:CGRectMake(14, 14, 125, 42)];
    [introButton addTarget:self action:@selector(playIntroButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [introButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    //    UIButton* historyButton = [[CommonRecordStatus commonRecordStatusManager] creatHistoryButton:CGRectMake(0, 47, 145, 47)];
    //    [historyButton addTarget:self action:@selector(historyLotteryClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* QuerybetLotButton = [[CommonRecordStatus commonRecordStatusManager] creatNewQuerybetLotButton:CGRectMake(14, 66, 125, 42)];
    [QuerybetLotButton addTarget:self action:@selector(queryBetLotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [QuerybetLotButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    
    [m_detailView addSubview:introButton];
    //[m_detailView addSubview:historyButton];
    [m_detailView addSubview:QuerybetLotButton];
    [self.view addSubview:m_detailView];
    m_detailView.hidden = YES;
    
}


-(void)touchDown:(UIButton *)button{
    
    [button setBackgroundColor:[ColorUtils parseColorFromRGB:@"#003432"]];
}


- (void)playIntroButtonClick:(id)sender
{
    [sender setBackgroundColor:[ColorUtils parseColorFromRGB:@"#095854"]];
    
    //[self setHidesBottomBarWhenPushed:YES];
    m_detailView.hidden = YES;
    PlayIntroduceViewController* viewController = [[PlayIntroduceViewController alloc] init];
    viewController.lotNo = kLotNoNMK3;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark   右上角 下拉按钮
- (void)queryBetLotButtonClick:(id)sender
{
    [sender setBackgroundColor:[ColorUtils parseColorFromRGB:@"#095854"]];
    m_detailView.hidden = YES;
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_QUERY_LOT_BET;
    [CommonRecordStatus commonRecordStatusManager].QueryBetlotNO = kLotNoNMK3;
    if (![[RuYiCaiNetworkManager sharedManager] hasLogin]) {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    else
    {
        [self setupQueryLotBetViewController];
    }
}


- (void)setupQueryLotBetViewController
{
    //[self setHidesBottomBarWhenPushed:YES];
    QueryLotBetViewController* viewController = [[QueryLotBetViewController alloc] init];
    viewController.navigationItem.title = @"投注查询";
    [viewController setSelectLotNo:kLotNoNMK3];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    
    [[RuYiCaiNetworkManager sharedManager] handleUserCenterClick];
}


-(void)setIndexPath:(NSIndexPath *)indexPath withKSLotterysModel:(KSLotterysModel *)lotterysModel{
    
    self.indexPath = indexPath;
    self.lotterysModel = lotterysModel;
}    

@end
