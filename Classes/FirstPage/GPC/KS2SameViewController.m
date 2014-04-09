//
//  KS2SameViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-2.
//
//

#import "KS2SameViewController.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "ColorUtils.h"
#import "UIButtonEx.h"
#import "SBJsonParser.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiNetworkManager.h"
#import "KS_PickNumberViewController.h"

#define LOTTERY_SAME_BTN_TAG(tag) (3457+tag)
#define LOTTERY_NO_SAME_BTN_TAG(tag) (3557+tag)
#define LOTTERY_CHECK_BTN_TAG(tag) (3657+tag)

//不同号 label tag
#define LOTTERY_NO_SAME_NUM_LABEL_TAG (3757)
//复选标签 tag
#define LOTTERY_CHECK_IMAGE_TAG (3758)
//复选说明 tag
#define LOTTERY_CHECK_LABEL_TAG (3759)

@interface KS2SameViewController ()
{
    UIButtonEx *_lotterySameNumButton[6];
    UIButtonEx *_lotteryNoSameNumButton[6];
    UIButtonEx *_lotteryCheckNumButton[6];
    
    UILabel *_lotterySameNumYiLouLabel[6];
    UILabel *_lotteryNoSameNumYiLouLabel[6];
    UILabel *_lotteryCheckNumYiLouLabel[6];
    
    UIScrollView *_scrollView;
    NSMutableDictionary *_selectedDic;//0 为未选中 1为选中
    KSLotterysModel *_ksLotterysDXModel;//单选号码集合
    KSLotterysModel *_ksLotterysFXModel;//复选号码集合
    KSBettingModel *_ksBetingModel;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) KSLotterysModel *ksLotterysDXModel;
@property (nonatomic, retain) KSLotterysModel *ksLotterysFXModel;
@property (nonatomic, retain) KSBettingModel *ksBetingModel;

@end

@implementation KS2SameViewController
@synthesize scrollView = _scrollView;
@synthesize selectedDic = _selectedDic;
@synthesize ksLotterysDXModel = _ksLotterysDXModel;
@synthesize ksLotterysFXModel = _ksLotterysFXModel;
@synthesize ksBetingModel = _ksBetingModel;

#pragma mark -LifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    self.ksBetingModel = nil;
    self.ksLotterysDXModel = nil;
    self.ksLotterysFXModel = nil;
    self.selectedDic = nil;
    self.scrollView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    //初始化所有按钮为未选中
    self.selectedDic = [NSMutableDictionary dictionary];
    self.ksLotterysDXModel = [[[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_DAN_XUAN_PALY_STYLE] autorelease];
    self.ksLotterysFXModel = [[[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_FU_XUAN_PALY_STYLE] autorelease];
    self.ksBetingModel = [[[KSBettingModel alloc]init] autorelease];
    [self.ksBetingModel addLotterys:_ksLotterysDXModel];
    [self.ksBetingModel addLotterys:_ksLotterysFXModel];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 360)];
    if (KISiPhone5) {
        self.scrollView.contentSize = CGSizeMake(320,  360);
    }else{
        self.scrollView.contentSize = CGSizeMake(320,  420);
    }
    self.scrollView.delaysContentTouches=YES;
    self.scrollView.canCancelContentTouches=NO;
    [self.view addSubview:_scrollView];
    [self.scrollView release];
    [super viewDidLoad];
    
    if (self.indexPath != nil && (((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE || ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE)) {
        
        NSLog(@"%d",self.indexPath.row);
        for (KSLotteryModel * model in [[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row] lotterys]) {
            if (model.buttonTag >= 3457 && model.buttonTag < 3557) {
                
                    [self redioNumEvent:_lotterySameNumButton[model.buttonTag - 3457]];
                
            }else if(model.buttonTag >= 3557 && model.buttonTag < 3657){
                
                [self redioNumEvent:_lotteryNoSameNumButton[model.buttonTag - 3557]];
            }else if(model.buttonTag >= 3657 && model.buttonTag < 3663){
                [self redioNumEvent:_lotteryCheckNumButton[model.buttonTag - 3657]];
            }
        }
    }
    
    
    if (((KS_PickNumberViewController *)self.chooseLotteryDelegate).navigationController.viewControllers.count != 3) {
    
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
        NSString * parameter1 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_01"];//二同号单选遗漏请求参数
        
        NSString * parameter2 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_30"];//二同号复选遗漏请求参数
        NSString * requestParameter = [NSString stringWithFormat:@"%@|%@",parameter1,parameter2];
        [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithString:requestParameter];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -OVER LOAD
-(void)setupChooseLotterView{
    
    UIImageView *labelImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ks_label.png"]];
    [labelImg setFrame:CGRectMake(0, 0, 48, 27)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 38, 17)];
    [label setText:@"单选"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [label setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [labelImg addSubview:label];
    [self.scrollView addSubview:labelImg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelImg.frame.origin.x + labelImg.frame.size.width + 10, labelImg.frame.origin.y + 5, 260, labelImg.frame.size.height -10)];
    [titleLabel setTextColor:[ColorUtils parseColorFromRGB:@"#478582"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setText:@"选择同号和不同号的组合，奖金80元"];
    [self.scrollView addSubview:titleLabel];
    
    UILabel *sameNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, 320, 35)];
    [sameNumLabel setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [sameNumLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [sameNumLabel setBackgroundColor:[UIColor clearColor]];
    [sameNumLabel setTextAlignment:NSTextAlignmentCenter];
    [sameNumLabel setText:@"同号"];
    [self.scrollView addSubview:sameNumLabel];
    
    for (int i = 0 ; i<6; i++) {
        _lotterySameNumButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%6 * 50, sameNumLabel.frame.size.height + sameNumLabel.frame.origin.y + 5, 47, 40)];
        
        [_lotterySameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_normal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_lotterySameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_lotterySameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
        [_lotterySameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotterySameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotterySameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        [_lotterySameNumButton[i] setTitle:[NSString stringWithFormat:@"%d%d",i+1,i+1] forState:UIControlStateNormal];
        _lotterySameNumButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_lotterySameNumButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotterySameNumButton[i] addTarget:self action:@selector(redioNumEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_lotterySameNumButton[i] setTargetWhenSelectedChange:self action:@selector(ballDXButtonSelected:)];
        [_lotterySameNumButton[i] setTag:LOTTERY_SAME_BTN_TAG(i)];
        [self.scrollView addSubview:_lotterySameNumButton[i]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]];
        
        _lotterySameNumYiLouLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(_lotterySameNumButton[i].frame.origin.x,
                                                                         _lotterySameNumButton[i].frame.origin.y + _lotterySameNumButton[i] .frame.size.height ,
                                                                         _lotterySameNumButton[i].frame.size.width,
                                                                         30)];
        [_lotterySameNumYiLouLabel[i] setHidden:YES];
        [_lotterySameNumYiLouLabel[i] setBackgroundColor:[UIColor clearColor]];
        [_lotterySameNumYiLouLabel[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lotterySameNumYiLouLabel[i] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [_lotterySameNumYiLouLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [_lotterySameNumYiLouLabel[i] setText:@"22"];
        [self.scrollView addSubview:_lotterySameNumYiLouLabel[i]];

    }

    UILabel *noSameNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _lotterySameNumButton[0].frame.origin.y + _lotterySameNumButton[0].frame.size.height + 5, 320, 35)];
    [noSameNumLabel setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [noSameNumLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [noSameNumLabel setBackgroundColor:[UIColor clearColor]];
    [noSameNumLabel setTextAlignment:NSTextAlignmentCenter];
    [noSameNumLabel setText:@"不同号"];
    [noSameNumLabel setTag:LOTTERY_NO_SAME_NUM_LABEL_TAG];
    [self.scrollView addSubview:noSameNumLabel];
    
    for (int i = 0 ; i<6; i++) {
        _lotteryNoSameNumButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%6 * 50, noSameNumLabel.frame.size.height + noSameNumLabel.frame.origin.y + 5, 47, 40)];
        
        [_lotteryNoSameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_normal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_lotteryNoSameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_lotteryNoSameNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
        [_lotteryNoSameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryNoSameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryNoSameNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        [_lotteryNoSameNumButton[i] setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        _lotteryNoSameNumButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_lotteryNoSameNumButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotteryNoSameNumButton[i] addTarget:self action:@selector(redioNumEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryNoSameNumButton[i] setTargetWhenSelectedChange:self action:@selector(ballDXButtonSelected:)];
        [_lotteryNoSameNumButton[i] setTag:LOTTERY_NO_SAME_BTN_TAG(i)];
        [self.scrollView addSubview:_lotteryNoSameNumButton[i]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]];
        
        _lotteryNoSameNumYiLouLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                                  _lotteryNoSameNumButton[i].frame.origin.x,
                                                                                  _lotteryNoSameNumButton[i].frame.origin.y + _lotteryNoSameNumButton[i] .frame.size.height + 2,
                                                                                _lotteryNoSameNumButton[i].frame.size.width,
                                                                                30)];
        [_lotteryNoSameNumYiLouLabel[i] setHidden:YES];
        [_lotteryNoSameNumYiLouLabel[i] setBackgroundColor:[UIColor clearColor]];
        [_lotteryNoSameNumYiLouLabel[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lotteryNoSameNumYiLouLabel[i] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [_lotteryNoSameNumYiLouLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [_lotteryNoSameNumYiLouLabel[i] setText:@"22"];
        [self.scrollView addSubview:_lotteryNoSameNumYiLouLabel[i]];
        
    }
    
    UIImageView *checkLabelImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ks_label.png"]];
    [checkLabelImg setFrame:CGRectMake(0, _lotteryNoSameNumButton[0].frame.size.height + _lotteryNoSameNumButton[0].frame.origin.y + 15, 48, 27)];
    [checkLabelImg setTag:LOTTERY_CHECK_IMAGE_TAG];
    UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 38, 17)];
    [checkLabel setText:@"复选"];
    [checkLabel setBackgroundColor:[UIColor clearColor]];
    [checkLabel setTextAlignment:NSTextAlignmentLeft];
    [checkLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [checkLabel setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [checkLabelImg addSubview:checkLabel];
    [self.scrollView addSubview:checkLabelImg];
    
    
    UILabel *titleCheckLabel = [[UILabel alloc]initWithFrame:CGRectMake(checkLabelImg.frame.origin.x + checkLabelImg.frame.size.width + 10, checkLabelImg.frame.origin.y + 5, 260, checkLabelImg.frame.size.height -10)];
    [titleCheckLabel setTag:LOTTERY_CHECK_LABEL_TAG];
    [titleCheckLabel setTextColor:[ColorUtils parseColorFromRGB:@"#478582"]];
    [titleCheckLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [titleCheckLabel setBackgroundColor:[UIColor clearColor]];
    [titleCheckLabel setTextAlignment:NSTextAlignmentLeft];
    [titleCheckLabel setText:@"猜开奖中两个指定的相同号码,奖金15元"];
    [self.scrollView addSubview:titleCheckLabel];
    
    
    for (int i = 0 ; i<6; i++) {
        _lotteryCheckNumButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%6 * 50, titleCheckLabel.frame.size.height + titleCheckLabel.frame.origin.y + 20, 47, 40)];
        
        [_lotteryCheckNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_normal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [_lotteryCheckNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [_lotteryCheckNumButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
        [_lotteryCheckNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryCheckNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryCheckNumButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        [_lotteryCheckNumButton[i] setTitle:[NSString stringWithFormat:@"%d%d*",i+1,i+1] forState:UIControlStateNormal];
        _lotteryCheckNumButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_lotteryCheckNumButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotteryCheckNumButton[i] addTarget:self action:@selector(checkNumEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryCheckNumButton[i] setTargetWhenSelectedChange:self action:@selector(ballFXButtonSelected:)];
        [_lotteryCheckNumButton[i] setTag:LOTTERY_CHECK_BTN_TAG(i)];
        [self.scrollView addSubview:_lotteryCheckNumButton[i]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]];
        
        _lotteryCheckNumYiLouLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                                  _lotteryCheckNumButton[i].frame.origin.x,
                                                                                  _lotteryCheckNumButton[i].frame.origin.y + _lotteryCheckNumButton[i] .frame.size.height + 2,
                                                                                  _lotteryCheckNumButton[i].frame.size.width,
                                                                                  30)];
        [_lotteryCheckNumYiLouLabel[i] setHidden:YES];
        [_lotteryCheckNumYiLouLabel[i] setBackgroundColor:[UIColor clearColor]];
        [_lotteryCheckNumYiLouLabel[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lotteryCheckNumYiLouLabel[i] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [_lotteryCheckNumYiLouLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [_lotteryCheckNumYiLouLabel[i] setText:@"22"];
        [self.scrollView addSubview:_lotteryCheckNumYiLouLabel[i]];
        
    }
}
-(void)changeFrameByIsYiLou:(BOOL)yilou{
    
    NSTrace();
    int spacing = 5;
    
    //非遗漏
    do {
        if (yilou) {
            break;
        }
        if (KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  360);
        if (!KISiPhone5) self.scrollView.contentSize = CGSizeMake(320, 420);
        
    } while (NO);
    
    //遗漏
    do {
        if (!yilou) {
            break;
        }
        spacing = 30;
        if (KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  408 );
        if (!KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  490 );
        
    } while (NO);
    
    
    
    //不同号标签
    UILabel *noSameNumLabel = (UILabel *)[self.scrollView viewWithTag:LOTTERY_NO_SAME_NUM_LABEL_TAG];
    [noSameNumLabel setFrame:CGRectMake(0, _lotterySameNumButton[0].frame.origin.y + _lotterySameNumButton[0].frame.size.height + spacing, 320, 35)];
        
        
    for (int i = 0; i< 6; i++) {
        //不同号按钮
        [_lotteryNoSameNumButton[i] setFrame:CGRectMake(11 + i%6 * 50, noSameNumLabel.frame.size.height + noSameNumLabel.frame.origin.y + 5, 47, 40)];
        //不同号遗漏
        [_lotteryNoSameNumYiLouLabel[i] setFrame:CGRectMake(
                                                            _lotteryNoSameNumButton[i].frame.origin.x,
                                                            _lotteryNoSameNumButton[i].frame.origin.y + _lotteryNoSameNumButton[i] .frame.size.height ,
                                                            _lotteryNoSameNumButton[i].frame.size.width,
                                                            30)];
    }
        
    //复选标签
    UIImageView *checkLabelImg = (UIImageView *)[self.scrollView viewWithTag:LOTTERY_CHECK_IMAGE_TAG];
    [checkLabelImg setFrame:CGRectMake(0, _lotteryNoSameNumButton[0].frame.size.height + _lotteryNoSameNumButton[0].frame.origin.y + 10 + spacing, 48, 27)];
    //复选说明
    UILabel *titleCheckLabel = (UILabel *)[self.scrollView viewWithTag:LOTTERY_CHECK_LABEL_TAG];
    [titleCheckLabel setFrame:CGRectMake(checkLabelImg.frame.origin.x + checkLabelImg.frame.size.width + 10, checkLabelImg.frame.origin.y + 5, 260, checkLabelImg.frame.size.height -10)];
        
    for (int i = 0; i< 6; i++) {
        //复选选号
        [_lotteryCheckNumButton[i] setFrame:CGRectMake(11 + i%6 * 50, titleCheckLabel.frame.size.height + titleCheckLabel.frame.origin.y + 20, 47, 40)];
            
        //复选遗漏
        [_lotteryCheckNumYiLouLabel[i] setFrame:CGRectMake(
                                                            _lotteryCheckNumButton[i].frame.origin.x,
                                                            _lotteryCheckNumButton[i].frame.origin.y + _lotteryCheckNumButton[i] .frame.size.height ,
                                                            _lotteryCheckNumButton[i].frame.size.width,
                                                            30)];
        
        
        if (yilou) [_lotteryCheckNumYiLouLabel[i] setHidden:NO];
        if (yilou) [_lotterySameNumYiLouLabel[i] setHidden:NO];
        if (yilou) [_lotteryNoSameNumYiLouLabel[i] setHidden:NO];
        
        if (!yilou) [_lotteryCheckNumYiLouLabel[i] setHidden:YES];
        if (!yilou) [_lotterySameNumYiLouLabel[i] setHidden:YES];
        if (!yilou) [_lotteryNoSameNumYiLouLabel[i] setHidden:YES];
    }
    

}

-(void)notifyLotteryHasChange:(KSLotterysModel *)ksLotterysModel{
    [super notifyLotteryHasChange:ksLotterysModel];
}
-(void)setupLotterMap{

    for (int i = 0; i< 6; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d%d",i+1,i+1]];
        [lotteryModel setGroup:@"1"];
        lotteryModel.buttonTag = LOTTERY_SAME_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]];
    }
    
    for (int i = 0; i< 6; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d",i+1]];
        [lotteryModel setGroup:@"2"];
        lotteryModel.buttonTag = LOTTERY_NO_SAME_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]];
    }
    for (int i = 0; i< 6; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d%d*",i+1,i+1]];
        lotteryModel.buttonTag = LOTTERY_CHECK_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]];
    }
    
    [super setupLotterMap];
}
-(void)cleanUpLotteryBasket{
    NSTrace();
    for (int i = 0; i<6; i++) {
        [_lotterySameNumButton[i] setSelected:NO];
        [_lotteryNoSameNumButton[i] setSelected:NO];
        [_lotteryCheckNumButton[i] setSelected:NO];
    }
}

#pragma mark -IBACTION
-(IBAction)ballDXButtonSelected:(id)sender{
    NSTrace();
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    if (btn.isSelected) {
        [self.ksLotterysDXModel removeLotter:lottery];
    }else{
        [self.ksLotterysDXModel addLottery:lottery];
    }
    
    
//    [self notifyLotteryHasChange:_ksLotterysDXModel];
//    [self notifyCombinationLotteryHasChange:_ksLotterysDXModel];
//    [self notifyNoramlAndCombinationLotteryHasChange:_ksLotterysDXModel];
    
    [self.ksBetingModel updateFromOldLotterys:_ksLotterysDXModel];
    [self notifyLotteryBasketHasChange:_ksBetingModel];
    
}
-(IBAction)ballFXButtonSelected:(id)sender{
    NSTrace();
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    if (btn.isSelected) {
        [self.ksLotterysFXModel removeLotter:lottery];
    }else{
        [self.ksLotterysFXModel addLottery:lottery];
    }
    
    [self.ksBetingModel updateFromOldLotterys:_ksLotterysFXModel];
    [self notifyLotteryBasketHasChange:_ksBetingModel];
    
}
-(IBAction)theMutexOfButton:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSInteger tag ;
    if (btn.tag >= 3457 && btn.tag < 3557) {
        tag = btn.tag+100; //获取单选按钮 tag
    }else{
        tag = btn.tag-100; //获取复选按钮 tag
    }
    
    UIButton *mutexBtn = (UIButton *)[self.scrollView viewWithTag:tag];
    [mutexBtn setSelected:NO];
    [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",mutexBtn.tag]];
    
}
-(IBAction)redioNumEvent:(id)sender{

    UIButton *btn = (UIButton *)sender;
    if (btn.isSelected) {
        btn.selected = NO;
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    }else{
        btn.selected = YES;
        [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        [self theMutexOfButton:sender];
    }
}

-(IBAction)checkNumEvent:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.isSelected) {
        btn.selected = NO;
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    }else{
        btn.selected = YES;
        [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    }
}
#pragma mark -KSBettingLotteryDelegate 摇一摇实现
-(void)bettingLotteryViewMotionEnded{
    NSTrace();

    //清空原有选中的彩票
    for (int i = 0; i<6; i++) {
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]];
        UIButton *checkbtn = _lotteryCheckNumButton[i];
        [checkbtn setSelected:NO];
        UIButton *samebtn = _lotterySameNumButton[i];
        [samebtn setSelected:NO];
        UIButton *noSamebtn = _lotteryNoSameNumButton[i];
        [noSamebtn setSelected:NO];
    }
    //随机选择一注
    int randomChooseNum = 0;//已选择个数
//    int randomMaxNum = 2;//最大选择个数
    int randomNum = 0;//随意数
    int randomRangeNum = 6;//随机范围

    NSMutableArray *numArr = [[NSMutableArray alloc]initWithCapacity:2];

    randomNum = arc4random() % randomRangeNum;
    
    randomChooseNum = arc4random() % randomRangeNum;
    
    while (randomNum == randomChooseNum) {
        randomChooseNum = arc4random() % randomRangeNum;
    }
    NSLog(@"randomRangeNum:%d",randomNum);
    
    [numArr addObject:[NSNumber numberWithInt:randomNum]];
    [numArr addObject:[NSNumber numberWithInt:randomChooseNum]];
    
    //同号 不同号 各一个数字，但是需要互斥
    [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG([[numArr objectAtIndex:0]intValue])]];
    UIButton *sameNumBtn = (UIButton *)[self.scrollView viewWithTag:LOTTERY_SAME_BTN_TAG([[numArr objectAtIndex:0]intValue])];
    [sameNumBtn setSelected:YES];
    
    [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG([[numArr objectAtIndex:1]intValue])]];
    UIButton *noSameNumBtn = (UIButton *)[self.scrollView viewWithTag:LOTTERY_NO_SAME_BTN_TAG([[numArr objectAtIndex:1]intValue])];
    [noSameNumBtn setSelected:YES];

}


-(void)changeKsBetingModelData{
    
    if (self.indexPath == nil) {
        [self addLotterysModel];
    }else{
        [self exchangeLotterysModel];
    }

}


-(void)exchangeLotterysModel{

    KSLotterysModel * lotterysModelDX = [[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_DAN_XUAN_PALY_STYLE];
    KSLotterysModel * lotterysModelFX = [[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_FU_XUAN_PALY_STYLE];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]]];
        }
        
    }
    
    KSLotteryModel * lottery = [[[KSLotteryModel alloc] init] autorelease];
    
    [lottery setLotteryNum:@"#"];
    [lottery setGroup:@"#"];
    
    [lotterysModelDX.lotterys addObject:lottery];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]]];
        }
        
    }
    
    int i = 0, j = 0 ;
    
    for (KSLotteryModel * m in lotterysModelDX.lotterys) {
        if ([m.group isEqualToString:@"1"])
            i ++ ;
        if ([m.group isEqualToString:@"2"])
            j ++ ;
    }
    
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]]];
        }
        
    }
    
    KSLotterysModel * lotterysModel = [[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row];
    
    if (lotterysModel.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j != 0) {
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
    }else if (lotterysModel.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j == 0 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
    }else if(lotterysModel.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j == 0 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        
        return ;
    }
    
    if (lotterysModel.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE && [lotterysModelFX.lotterys count] != 0) {
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
    }else if (lotterysModel.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE && [lotterysModelFX.lotterys count] == 0 && i * j != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE && i * j == 0 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        
        return ;
        
    }else if(lotterysModel.playStyle != ER_TONG_HAO_FU_XUAN_PALY_STYLE && lotterysModel.playStyle != ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j != 0 && [lotterysModelFX.lotterys count] != 0){
        
        //其他玩法跳过来的
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
    }else if(lotterysModel.playStyle != ER_TONG_HAO_FU_XUAN_PALY_STYLE && lotterysModel.playStyle != ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j == 0 && [lotterysModelFX.lotterys count] != 0){
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
    }else if(lotterysModel.playStyle != ER_TONG_HAO_FU_XUAN_PALY_STYLE && lotterysModel.playStyle != ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j != 0 && [lotterysModelFX.lotterys count] == 0){
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle != ER_TONG_HAO_FU_XUAN_PALY_STYLE && lotterysModel.playStyle != ER_TONG_HAO_DAN_XUAN_PALY_STYLE && i * j == 0 && [lotterysModelFX.lotterys count] == 0){
        
        //随机
        [self bettingLotteryViewMotionEnded];
        
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        
        return ;
    }

    
    if (i * j != 0) {
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * j * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"二同号单选 %d注 %d元",i * j,i * j * 2];
    }
    
    
    self.isSelectedNumber = YES;
    
    if ([lotterysModelFX.lotterys count] != 0) {
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"二同号复选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
    }
    
}


-(void)appendDXBetingNumber:(KSLotterysModel *)DXlotterysModel{
    
    if ([DXlotterysModel lotterys].count == 3) {
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"010001"];
        NSLog(@"=====%@",DXlotterysModel.betCodeString);
        KSLotteryModel * lotteryM1 = [[DXlotterysModel lotterys] objectAtIndex:0];
        
        KSLotteryModel * lotteryM2 = [[DXlotterysModel lotterys] objectAtIndex:2];
        
        if ([lotteryM1.lotteryNum integerValue]/11 < [lotteryM2.lotteryNum integerValue]) {
            for (KSLotteryModel * model in [DXlotterysModel lotterys]) {
                NSLog(@"======%@",model.lotteryNum);
                if ([model.group isEqualToString:@"1"]) {
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d%02d",[model.lotteryNum integerValue]/11,[model.lotteryNum integerValue]/11];
                    
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@",model.lotteryNum];
                    
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }else if([model.group isEqualToString:@"2"]){
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d^",[model.lotteryNum integerValue]];
                    
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@",DXlotterysModel.betNumberString,model.lotteryNum];
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }else{
                    DXlotterysModel.betNumberString = [DXlotterysModel.betNumberString stringByAppendingFormat:@"%@",model.lotteryNum];
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }
            }
        }else{
            [[DXlotterysModel lotterys] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                KSLotteryModel * model = obj;
                if ([model.group isEqualToString:@"1"]) {
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d%02d^",[model.lotteryNum integerValue]/11,[model.lotteryNum integerValue]/11];
                    
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@",DXlotterysModel.betNumberString,((KSLotteryModel *)[[DXlotterysModel lotterys] objectAtIndex:2]).lotteryNum];
                    
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }else if([model.group isEqualToString:@"2"]){
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]];
                    
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@",((KSLotteryModel *)[[DXlotterysModel lotterys] objectAtIndex:0]).lotteryNum];
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }else{
                    DXlotterysModel.betNumberString = [DXlotterysModel.betNumberString stringByAppendingFormat:@"%@",((KSLotteryModel *)[[DXlotterysModel lotterys] objectAtIndex:1]).lotteryNum];
                    NSLog(@"%@",DXlotterysModel.betNumberString);
                    
                }

                
            }];
        }
        
        
        
    }else{
        
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"710001"];
        DXlotterysModel.betNumberString = @"";
        int i = 0;
        for (KSLotteryModel * model in [DXlotterysModel lotterys]) {
            NSLog(@"====%@====%@",model.group,model.lotteryNum);
            if ([model.group isEqualToString:@"1"]) {
                DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]/11];
                DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
            }else if([model.group isEqualToString:@"2"]){
                if (i != [[DXlotterysModel lotterys] count] - 1) {
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]];
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
                }else{
                    DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d^",[model.lotteryNum integerValue]];
                    DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
                }
                
            }else if([model.group isEqualToString:@"#"]){
                DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%@",@"*"];
                DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
            }
            
            i ++ ;
        }
    }
    
    NSLog(@"=====%@",DXlotterysModel.betCodeString);
}


-(void)appendFXBetingNumber:(KSLotterysModel *)FXlotterysModel{
    
    FXlotterysModel.betCodeString = [NSString stringWithFormat:@"300001%02d",[FXlotterysModel lotterys].count];
    FXlotterysModel.betNumberString = @"";
    
    int i = 0;
    for (KSLotteryModel * model in [FXlotterysModel lotterys]) {
        if (i != [FXlotterysModel lotterys].count - 1) {
            FXlotterysModel.betCodeString = [FXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]/11];
            FXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",FXlotterysModel.betNumberString,model.lotteryNum];
        }else{
            FXlotterysModel.betCodeString = [FXlotterysModel.betCodeString stringByAppendingFormat:@"%02d^",[model.lotteryNum integerValue]/11];
            FXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",FXlotterysModel.betNumberString,model.lotteryNum];
        }
        
        i ++ ;
    }
    
    NSLog(@"=====%@",FXlotterysModel.betCodeString);

}


-(void)addLotterysModel{

    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_DAN_XUAN_PALY_STYLE] autorelease];
    KSLotterysModel * lotterysModelFX = [[[KSLotterysModel alloc] initWithPlayStyle:ER_TONG_HAO_FU_XUAN_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_SAME_BTN_TAG(i)]]];
        }
        
    }
    
    KSLotteryModel * lottery = [[[KSLotteryModel alloc] init] autorelease];
    
    [lottery setLotteryNum:@"#"];
    [lottery setGroup:@"#"];
    
    [lotterysModelDX.lotterys addObject:lottery];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_NO_SAME_BTN_TAG(i)]]];
        }
        
    }
    
    int i = 0, j = 0 ;
    
    for (KSLotteryModel * m in lotterysModelDX.lotterys) {
        if ([m.group isEqualToString:@"1"])
            i ++ ;
        if ([m.group isEqualToString:@"2"])
            j ++ ;
    }
    
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_CHECK_BTN_TAG(i)]]];
        }
        
    }
    
    if(i * j != 0){
        [[KSBettingModel share] addLotterys:lotterysModelDX];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
    }
    
    if (i * j == 0 && [lotterysModelFX.lotterys count] == 0) {
        
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self addLotterysModel];
            
        }
        return ;
    }
    
    self.isSelectedNumber = YES;
    
    if (i * j != 0) {
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * j * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"二同号单选 %d注 %d元",i * j,i * j * 2];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"二同号复选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
    }


}


-(void)getMissNumber:(NSString *)parserString{
    
    NSArray * array = [parserString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDictDX = (NSDictionary*)[jsonParser objectWithString:[array objectAtIndex:0]];
    NSDictionary* parserDictTX = (NSDictionary*)[jsonParser objectWithString:[array objectAtIndex:1]];
    [jsonParser release];
    NSArray * arraySingleSelectSameArray = [[parserDictDX objectForKey:@"result"] objectForKey:@"shuang"];
    NSArray * arraysingleSelectNoSameArray = [[parserDictDX objectForKey:@"result"] objectForKey:@"dan"];
    NSArray * arrayTX = [[parserDictTX objectForKey:@"result"] objectForKey:@"miss"];
    
    
    for (int i = 0; i < 6 ; i ++) {
        
        _lotterySameNumYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arraySingleSelectSameArray objectAtIndex:i]];
        
        _lotteryNoSameNumYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arraysingleSelectNoSameArray objectAtIndex:i]];
        
        _lotteryCheckNumYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arrayTX objectAtIndex:i]];
        
    }

}

@end
