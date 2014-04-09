//
//  KS3ConnectedViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-2.
//
//

#import "KS3ConnectedViewController.h"
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

@interface KS3ConnectedViewController ()
{
    UIButtonEx *_lotteryButton[6];
    UILabel *_lotteryYiLouLabel[6];
    
    UIScrollView *_scrollView;
    NSMutableDictionary *_selectedDic;//0 为未选中 1为选中
    KSLotterysModel *_ksLotterysModel;//3不同号号码集合
    KSBettingModel *_ksBetingModel;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *selectedDic;
@property (nonatomic, strong) KSLotterysModel *ksLotterysModel;
@property (nonatomic, strong) KSBettingModel *ksBetingModel;
@end

@implementation KS3ConnectedViewController
@synthesize scrollView = _scrollView;
@synthesize selectedDic = _selectedDic;
@synthesize ksLotterysModel = _ksLotterysModel;
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
    self.scrollView = nil;
    self.ksBetingModel = nil;
    self.ksLotterysModel = nil;
    self.selectedDic = nil ;
    [super dealloc];
    
}
- (void)viewDidLoad
{
    //初始化所有按钮为未选中
    self.selectedDic = [NSMutableDictionary dictionary];
    self.ksLotterysModel = [[[KSLotterysModel alloc ] initWithPlayStyle:ER_BU_TONG_HAO_PALY_STYLE] autorelease];
    self.ksBetingModel = [[[KSBettingModel alloc]init]autorelease];
    [self.ksBetingModel addLotterys:_ksLotterysModel];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - 208)];
    if (KISiPhone5) {
        self.scrollView.contentSize = CGSizeMake(320,  self.view.frame.size.height - 208);
    }else{
        self.scrollView.contentSize = CGSizeMake(320,420);
    }
    self.scrollView.delaysContentTouches=YES;
    self.scrollView.canCancelContentTouches=NO;
    
    [self.view addSubview:_scrollView];
    [self.scrollView release];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.indexPath != nil && ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == ER_BU_TONG_HAO_PALY_STYLE) {
        
        for (KSLotteryModel * model in [[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row] lotterys]) {
            
            [self ballButtonClick:_lotteryButton[model.buttonTag - 3457]];
        }
    }

    
    if (((KS_PickNumberViewController *)self.chooseLotteryDelegate).navigationController.viewControllers.count != 3) {
        
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
        [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoNMK3 sellWay:@"F47108MV_BASE"];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -OVER LOAD
-(void)setupChooseLotterView{
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 260, 15)];
    [titleLabel setTextColor:[ColorUtils parseColorFromRGB:@"#478582"]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setText:@"猜开奖号码中2个指定的不同号码,奖金8元"];
    [self.scrollView addSubview:titleLabel];
    
    for (int i = 0; i< 6; i++) {
        _lotteryButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%6 * 50, titleLabel.frame.size.height + titleLabel.frame.origin.y + 5, 47, 40)];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_normal.png"] forState:UIControlStateNormal];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateSelected];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        _lotteryButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        [_lotteryButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotteryButton[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryButton[i] setTargetWhenSelectedChange:self action:@selector(ballButtonSelected:)];
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
}
-(void)changeFrameByIsYiLou:(BOOL)yilou{
    
    NSTrace();
    for (int i = 0; i< 6; i++) {
        if (yilou) [_lotteryYiLouLabel[i] setHidden:NO];
        if (!yilou) [_lotteryYiLouLabel[i] setHidden:YES];
    }
    
}
-(void)setupLotterMap{
    NSTrace();
    for (int i = 0; i< 6; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d",i+1]];
        [lotteryModel setGroup:@"1"];
        lotteryModel.buttonTag = LOTTERY_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
    }
    [super setupLotterMap];
}
-(void)cleanUpLotteryBasket{
    NSTrace();
    for (int i = 0; i<6; i++) {
        [_lotteryButton[i] setSelected:NO];
    }
}
#pragma mark -IBACTION
-(IBAction)ballButtonSelected:(id)sender{
    NSTrace();
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    if (btn.isSelected) {
        [self.ksLotterysModel removeLotter:lottery];
    }else{
        [self.ksLotterysModel addLottery:lottery];
    }
    //    [self notifyLotteryHasChange:_ksLotterysModel];
    
    [self.ksBetingModel updateFromOldLotterys:_ksLotterysModel];
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
    
    int randomNum[2] = {0};
    for (int i = 0; i < 2; i ++ ) {
        randomNum[i] = arc4random() % 6;
        if (randomNum[0] == randomNum[1]) {
            randomNum[1] += 1;
            if (randomNum[1] == 6) {
                randomNum[1] -= 2;
            }
        }
        [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomNum[i])]];
        UIButton *selectedBtn = (UIButton *)[self.scrollView viewWithTag:LOTTERY_BTN_TAG(randomNum[i])];
        [selectedBtn setSelected:YES];

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
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:ER_BU_TONG_HAO_PALY_STYLE] autorelease];
    
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    if([lotterysModelDX.lotterys count] >= 2){
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
        int i = [Math combinationN:[lotterysModelDX.lotterys count] M:2];
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"二不同号 %d注 %d元",i,i * 2];
    }
    
    if ([lotterysModelDX.lotterys count] < 2) {
        
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
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:ER_BU_TONG_HAO_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    KSLotterysModel * lotterysModel = [[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row];
    
    if (lotterysModelDX.lotterys.count >= 2) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
        int i = [Math combinationN:[lotterysModelDX.lotterys count] M:2];
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三不同号 %d注 %d元",i,i * 2];
        
    }else if (lotterysModelDX.lotterys.count < 2) {
        
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
}


-(void)appendDXBetingNumber:(KSLotterysModel *)DXlotterysModel{
    
    if (DXlotterysModel.lotterys.count == 2) {
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"20000101"];
    }else{
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"210001%02d",[DXlotterysModel lotterys].count];
    }
    
    DXlotterysModel.betNumberString = @"";
    
    int i = 0;
    for (KSLotteryModel * model in [DXlotterysModel lotterys]) {
        if (i != [DXlotterysModel lotterys].count - 1) {
            DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:DXlotterysModel.lotterys.count == 2 ? @"%d" : @"%02d",[model.lotteryNum integerValue]];
            
        }else{
            DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:DXlotterysModel.lotterys.count == 2 ? @"%d^" : @"%02d^",[model.lotteryNum integerValue]];
        }
        
        DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum];
        
        i ++ ;
    }
    
    NSLog(@"=====%@",DXlotterysModel.betCodeString);
}


-(void)getMissNumber:(NSString *)parserString{
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:parserString];
    [jsonParser release];
    
    NSArray * array = [[parserDict objectForKey:@"result"] objectForKey:@"miss"];
    
    
    for (int i = 0; i < [array count] ; i ++) {
        
        _lotteryYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
    }

    
}

@end
