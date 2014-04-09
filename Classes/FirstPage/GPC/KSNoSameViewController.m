//
//  KSNoSameViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-2.
//
//

#import "KSNoSameViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "UIButtonEx.h"
#import "Math.h"
#import "SBJsonParser.h"
#import "CommonRecordStatus.h"
#import "RuYiCaiNetworkManager.h"
#import "KS_PickNumberViewController.h"

#define LOTTERY_BTN_TAG(tag) (3457+tag)
#define LOTTERY_3_CONNECTED_BTN_TAG (3657)
//三连号标签 tag
#define LOTTERY_CHECK_IMAGE_TAG (3758)
//三连号说明 tag
#define LOTTERY_CHECK_LABEL_TAG (3759)

@interface KSNoSameViewController ()
{
    UIButtonEx *_lotteryButton[6];
    UILabel *_lotteryYiLouLabel[6];
    UIButtonEx *_lottery3ConnectedNumButton[1];
    UILabel *_lottery3ConnectedNumYiLouLabel[1];

    UIScrollView *_scrollView;
    NSMutableDictionary *_selectedDic;//0 为未选中 1为选中
    KSLotterysModel *_ksLotterys3LHModel;//3连号号码集合
    KSLotterysModel *_ksLotterys3BTHModel;//3不同号号码集合
    KSBettingModel *_ksBetingModel;

}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) KSLotterysModel *ksLotterys3LHModel;
@property (nonatomic, retain) KSLotterysModel *ksLotterys3BTHModel;
@property (nonatomic, retain) KSBettingModel *ksBetingModel;
@end

@implementation KSNoSameViewController
@synthesize scrollView = _scrollView;
@synthesize selectedDic = _selectedDic;
@synthesize ksLotterys3BTHModel = _ksLotterys3BTHModel;
@synthesize ksLotterys3LHModel = _ksLotterys3LHModel;
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
    self.ksLotterys3BTHModel = nil;
    self.ksLotterys3LHModel = nil;
    self.selectedDic = nil;
    self.scrollView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{

    //初始化所有按钮为未选中
    self.selectedDic = [NSMutableDictionary dictionary];
    self.ksLotterys3LHModel = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE] autorelease];
    self.ksLotterys3BTHModel = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_BU_TONG_HAO_PALY_STYLE] autorelease];
    self.ksBetingModel = [[[KSBettingModel alloc]init] autorelease];
    [self.ksBetingModel addLotterys:_ksLotterys3LHModel];
    [self.ksBetingModel addLotterys:_ksLotterys3BTHModel];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 208)];
    if (KISiPhone5) {
        self.scrollView.contentSize = CGSizeMake(320,  self.view.frame.size.height - 208);
    }else{
        self.scrollView.contentSize = CGSizeMake(320,  self.view.frame.size.height - 178);
    }
    self.scrollView.delaysContentTouches=YES;
    self.scrollView.canCancelContentTouches=NO;
    
    [self.view addSubview:_scrollView];
    [self.scrollView release];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.indexPath != nil && (((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == SAN_BU_TONG_HAO_PALY_STYLE || ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE)) {
        
        NSLog(@"%d",self.indexPath.row);
        for (KSLotteryModel * model in [[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row] lotterys]) {
            if (model.buttonTag >= 3457 && model.buttonTag < 3557) {
                
                [self ballButtonClick:_lotteryButton[model.buttonTag - 3457]];
                
            }else {
                
                [self ballButtonClick:_lottery3ConnectedNumButton[0]];
            }
        }
    }

    
    if (((KS_PickNumberViewController *)self.chooseLotteryDelegate).navigationController.viewControllers.count != 3) {
    
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
        NSString * parameter1 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_BASE"];//三不同号单选遗漏请求参数
        
        NSString * parameter2 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_50"];//三连同号通选遗漏请求参数
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
    [labelImg setFrame:CGRectMake(0, 0, 78, 27)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 68, 17)];
    [label setText:@"三不同号"];
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
    [titleLabel setText:@"猜开奖的三个不同号码,奖金40元"];
    [self.scrollView addSubview:titleLabel];
    
    for (int i = 0; i< 6; i++) {
        _lotteryButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%6 * 50, titleLabel.frame.size.height + titleLabel.frame.origin.y + 15, 47, 40)];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_normal.png"] forState:UIControlStateNormal];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateSelected];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        _lotteryButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_lotteryButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotteryButton[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryButton[i] setTargetWhenSelectedChange:self action:@selector(ball3BTHButtonSelected:)];
        [_lotteryButton[i] setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [_lotteryButton[i] setTag:LOTTERY_BTN_TAG(i)];
        [self.scrollView addSubview:_lotteryButton[i]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        
        _lotteryYiLouLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(_lotteryButton[i].frame.origin.x,
                                                                         _lotteryButton[i].frame.origin.y + _lotteryButton[i] .frame.size.height,
                                                                         _lotteryButton[i].frame.size.width,
                                                                         30)];
        [_lotteryYiLouLabel[i] setHidden:YES];
        [_lotteryYiLouLabel[i] setBackgroundColor:[UIColor clearColor]];
        [_lotteryYiLouLabel[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lotteryYiLouLabel[i] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [_lotteryYiLouLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [_lotteryYiLouLabel[i] setText:@"22"];
        [self.scrollView addSubview:_lotteryYiLouLabel[i]];

    }
    
    UIImageView *checkLabelImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ks_label.png"]];
    [checkLabelImg setFrame:CGRectMake(0, _lotteryButton[0].frame.size.height + _lotteryButton[0].frame.origin.y + 15, 68, 27)];
    [checkLabelImg setTag:LOTTERY_CHECK_IMAGE_TAG];
    UILabel *checkLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 58, 17)];
    [checkLabel setText:@"三连号"];
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
    [titleCheckLabel setText:@"123/234/345/456任意开出即中40元"];
    [self.scrollView addSubview:titleCheckLabel];
    
    _lottery3ConnectedNumButton[0] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 , titleCheckLabel.frame.size.height + titleCheckLabel.frame.origin.y + 20, 298, 40)];
    
    [_lottery3ConnectedNumButton[0] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_normal.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [_lottery3ConnectedNumButton[0] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [_lottery3ConnectedNumButton[0] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateSelected];
    [_lottery3ConnectedNumButton[0] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
    [_lottery3ConnectedNumButton[0] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
    [_lottery3ConnectedNumButton[0] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
    [_lottery3ConnectedNumButton[0] setTitle:@"三连号通选" forState:UIControlStateNormal];
    _lottery3ConnectedNumButton[0].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [_lottery3ConnectedNumButton[0] setAdjustsImageWhenHighlighted:NO];
    [_lottery3ConnectedNumButton[0] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_lottery3ConnectedNumButton[0] setTargetWhenSelectedChange:self action:@selector(ball3LHButtonSelected:)];
    [_lottery3ConnectedNumButton[0] setTag:LOTTERY_3_CONNECTED_BTN_TAG];
    [self.scrollView addSubview:_lottery3ConnectedNumButton[0]];
    [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]];
    
    _lottery3ConnectedNumYiLouLabel[0] = [[UILabel alloc]initWithFrame:CGRectMake(
                                                                                  _lottery3ConnectedNumButton[0].frame.origin.x,
                                                                                  _lottery3ConnectedNumButton[0].frame.origin.y + _lottery3ConnectedNumButton[0] .frame.size.height,
                                                                                  _lottery3ConnectedNumButton[0].frame.size.width,
                                                                                  30)];
    [_lottery3ConnectedNumYiLouLabel[0] setHidden:YES];
    [_lottery3ConnectedNumYiLouLabel[0] setBackgroundColor:[UIColor clearColor]];
    [_lottery3ConnectedNumYiLouLabel[0] setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [_lottery3ConnectedNumYiLouLabel[0] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
    [_lottery3ConnectedNumYiLouLabel[0] setTextAlignment:NSTextAlignmentCenter];
    [_lottery3ConnectedNumYiLouLabel[0] setText:@"22"];
    [self.scrollView addSubview:_lottery3ConnectedNumYiLouLabel[0]];
}
-(void)changeFrameByIsYiLou:(BOOL)yilou{
    
    NSTrace();
    int spacing = 50;
    
    //非遗漏
    do {
        if (yilou) {
            break;
        }
        if (KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  self.view.frame.size.height - 208);
        if (!KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  272);
        
    } while (NO);
    
    //遗漏
    do {
        if (!yilou) {
            break;
        }
        spacing = 70;
        if (KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  340);
        if (!KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  272);
        
    } while (NO);
    
    
    
    for (int i = 0; i< 6; i++) {
        if (yilou) [_lotteryYiLouLabel[i] setHidden:NO];
        if (!yilou) [_lotteryYiLouLabel[i] setHidden:YES];

    }
    
    UIImageView *checkLabelImg = (UIImageView *)[self.scrollView viewWithTag:LOTTERY_CHECK_IMAGE_TAG];
    [checkLabelImg setFrame:CGRectMake(0, _lotteryButton[0].frame.size.height + _lotteryButton[0].frame.origin.y + spacing - 35, 68, 27)];

    UILabel *titleCheckLabel = (UILabel *)[self.scrollView viewWithTag:LOTTERY_CHECK_LABEL_TAG];     
    [titleCheckLabel setFrame:CGRectMake(checkLabelImg.frame.origin.x + checkLabelImg.frame.size.width + 10, checkLabelImg.frame.origin.y + 5, 260, checkLabelImg.frame.size.height -10)];
    
    [_lottery3ConnectedNumButton[0] setFrame:CGRectMake(11 , titleCheckLabel.frame.size.height + titleCheckLabel.frame.origin.y + 20, 298, 40)];
    
    [_lottery3ConnectedNumYiLouLabel[0] setFrame:CGRectMake(
                                                           _lottery3ConnectedNumButton[0].frame.origin.x,
                                                           _lottery3ConnectedNumButton[0].frame.origin.y + _lottery3ConnectedNumButton[0] .frame.size.height,
                                                           _lottery3ConnectedNumButton[0].frame.size.width,
                                                           30)];
        if (!yilou) [_lottery3ConnectedNumYiLouLabel[0] setHidden:YES];
        if (yilou) [_lottery3ConnectedNumYiLouLabel[0] setHidden:NO];
}
-(void)setupLotterMap{
    
    for (int i = 0; i< 6; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d",i+1]];
        [lotteryModel setGroup:@"1"];
        lotteryModel.buttonTag = LOTTERY_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
    }
    
   
    KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
    [lotteryModel setGroup:@"1"];
    lotteryModel.buttonTag = LOTTERY_3_CONNECTED_BTN_TAG;
    [lotteryModel setLotteryNum:[NSString stringWithFormat:@"三连号通选"]];
    [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]];

    [super setupLotterMap];
}
-(void)cleanUpLotteryBasket{
    NSTrace();
    for (int i = 0; i<6; i++) {
        [_lotteryButton[i] setSelected:NO];
    }
    [_lottery3ConnectedNumButton[0] setSelected:NO];
}
#pragma mark -IBACTION
-(IBAction)ball3BTHButtonSelected:(id)sender{
    NSTrace();
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
    if (btn.isSelected) {
        [self.ksLotterys3BTHModel removeLotter:lottery];
    }else{
        [self.ksLotterys3BTHModel addLottery:lottery];
    }
    //    [self notifyLotteryHasChange:_ksLotterysModel];
    
    [self.ksBetingModel updateFromOldLotterys:_ksLotterys3BTHModel];
    [self notifyLotteryBasketHasChange:_ksBetingModel];
}
-(IBAction)ball3LHButtonSelected:(id)sender{
    NSTrace();
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    if (btn.isSelected) {
        [self.ksLotterys3LHModel removeLotter:lottery];
    }else{
        [self.ksLotterys3LHModel addLottery:lottery];
    }
    //    [self notifyLotteryHasChange:_ksLotterysModel];
    
    [self.ksBetingModel updateFromOldLotterys:_ksLotterys3LHModel];
    [self notifyLotteryBasketHasChange:_ksBetingModel];
    
}

-(IBAction)ballButtonClick:(id)sender{
    
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
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        UIButton *btn = _lotteryButton[i];
        [btn setSelected:NO];
        }
    //随机选择一注
    int randomChooseNum = 0;//已选择个数

    NSMutableArray * array = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5", nil];
    
    for (int i = 0; i < 3; i ++ ) {
        int j = arc4random() % array.count;
        randomChooseNum = [[array objectAtIndex:j] integerValue];
        
        [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomChooseNum)]];
        UIButton *selectedBtn = (UIButton *)[self.scrollView viewWithTag:LOTTERY_BTN_TAG(randomChooseNum)];
        [selectedBtn setSelected:YES];

        
        [array removeObjectAtIndex:j];
    }

}



-(void)changeKsBetingModelData{
    
    if (self.indexPath == nil) {
        [self addLotterysModel];
    }else{
        [self exchangeLotterysModel];
    }
    
}


-(void)addLotterysModel{
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_BU_TONG_HAO_PALY_STYLE] autorelease];
    KSLotterysModel * lotterysModelFX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            
            NSLog(@"tag === %d,selected == %d,lotteryNum ==== %@",LOTTERY_BTN_TAG(i),[isSelected integerValue],((KSLotteryModel *)[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]).lotteryNum);
            
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    for (KSLotteryModel * model in lotterysModelDX.lotterys) {
        NSLog(@"===%@",model.lotteryNum);
    }
    
    NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]];
    if ([isSelected integerValue] == 1) {
        [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]]];
        
    }
    
    
    if([lotterysModelDX.lotterys count] >= 3){
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
        int i = [Math combinationN:[lotterysModelDX.lotterys count] M:3];
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三不同号 %d注 %d元",i,i * 2];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"三连号通选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
        
    }
    
    if ([lotterysModelDX.lotterys count] < 3 && [lotterysModelFX.lotterys count] == 0) {
        
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
}



-(void)exchangeLotterysModel{
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_BU_TONG_HAO_PALY_STYLE] autorelease];
    KSLotterysModel * lotterysModelFX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    
    NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]];
    if ([isSelected integerValue] == 1) {
        [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_3_CONNECTED_BTN_TAG]]];
        
    }
    
    KSLotterysModel * lotterysModel = [[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row];
    
    if (lotterysModel.playStyle == SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
    }else if (lotterysModel.playStyle == SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle == SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];

        
    }else if(lotterysModel.playStyle == SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        
        return ;
    }
    
    
    if (lotterysModel.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
    }else if (lotterysModel.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
        
    }else if(lotterysModel.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        
        return ;
    }

    
    
    
    if (lotterysModel.playStyle != SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
    }else if (lotterysModel.playStyle != SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count >= 3 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle != SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
        
    }else if(lotterysModel.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE && lotterysModel.playStyle == SAN_BU_TONG_HAO_PALY_STYLE && lotterysModelDX.lotterys.count < 3 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
            
        }
        return ;
    }
    
    self.isSelectedNumber = YES;
    
    if (lotterysModelDX.lotterys.count >= 3) {
        
        int i = [Math combinationN:[lotterysModelDX.lotterys count] M:3];
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三不同号 %d注 %d元",i,i * 2];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"三连号通选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
    }
}


-(void)appendFXBetingNumber:(KSLotterysModel *)FXlotterysModel{
    
    FXlotterysModel.betCodeString = [NSString stringWithFormat:@"500001^"];
    FXlotterysModel.betNumberString = @"三连号通选";
    
}


-(void)appendDXBetingNumber:(KSLotterysModel *)DXlotterysModel{
    
    if (DXlotterysModel.lotterys.count == 3) {
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"000001"];
    }else{
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"630001%02d",[DXlotterysModel lotterys].count];
    }
    
    DXlotterysModel.betNumberString = @"";

    int i = 0;
    for (KSLotteryModel * model in [DXlotterysModel lotterys]) {
        if (i != [DXlotterysModel lotterys].count - 1) {
            DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]];
            
        }else{
            DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d^",[model.lotteryNum integerValue]];
        }
        
        DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
        
        i ++ ;
    }
    
    NSLog(@"=====%@",DXlotterysModel.betCodeString);
}



-(void)getMissNumber:(NSString *)parserString{
    
    NSArray * array = [parserString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"|"]];
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDictDX = (NSDictionary*)[jsonParser objectWithString:[array objectAtIndex:0]];
    NSDictionary* parserDictTX = (NSDictionary*)[jsonParser objectWithString:[array objectAtIndex:1]];
    [jsonParser release];
    NSArray * arrayDX = [[parserDictDX objectForKey:@"result"] objectForKey:@"miss"];
    NSArray * arrayTX = [[parserDictTX objectForKey:@"result"] objectForKey:@"miss"];
    
    
    for (int i = 0; i < [arrayDX count] + [arrayTX count] ; i ++) {
        
        if (i == 6) {
            _lottery3ConnectedNumYiLouLabel[0].text = [NSString stringWithFormat:@"%@",[arrayTX objectAtIndex:0]];
        }else{
            _lotteryYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arrayDX objectAtIndex:i]];
            
        }
    }
    
}

@end
