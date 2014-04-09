//
//  KS3SameViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-2.
//
//

#import "KS3SameViewController.h"
#import "RuYiCaiCommon.h"
#import "NSLog.h"
#import "ColorUtils.h"
#import "UIButtonEx.h"
#import "KS_PickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"


#define LOTTERY_BTN_LABEL_NUM_TAG (3455)
#define LOTTERY_BTN_LABEL_BONUS_TAG (3456)
#define LOTTERY_BTN_TAG(tag) (3457+tag)

@interface KS3SameViewController ()<UIScrollViewDelegate>
{
    UIButtonEx *_lotteryButton[7];
    UILabel *_lotteryYiLouLabel[7];
    UIScrollView *_scrollView;
    NSMutableDictionary *_selectedDic;//0 为未选中 1为选中
    KSBettingModel *_ksBetingModel;
    KSBettingModel * priviteBetingModel;
    
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) KSBettingModel *ksBetingModel;
@property (nonatomic, retain) KSLotterysModel * ksLotterys3THDXModel;
@property (nonatomic, retain) KSLotterysModel * ksLotterys3THTXModel;

@end

@implementation KS3SameViewController
@synthesize scrollView = _scrollView;
@synthesize selectedDic = _selectedDic;
@synthesize ksBetingModel = _ksBetingModel;
@synthesize ksLotterys3THDXModel = _ksLotterys3THDXModel;
@synthesize ksLotterys3THTXModel = _ksLotterys3THTXModel;

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
    self.ksLotterys3THDXModel = nil;
    self.ksLotterys3THTXModel = nil;
    self.selectedDic = nil;
    self.scrollView = nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    //初始化选号数组
    self.ksLotterys3THDXModel = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_DAN_XUAN_PALY_STYLE] autorelease];
    self.ksLotterys3THTXModel = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_TONG_XUAN_PALY_STYLE] autorelease];
    
    self.ksBetingModel = [[[KSBettingModel alloc]init] autorelease];
    [self.ksBetingModel addLotterys:_ksLotterys3THDXModel];
    [self.ksBetingModel addLotterys:_ksLotterys3THTXModel];
    
    //初始化所有按钮为未选中
    self.selectedDic = [NSMutableDictionary dictionary];
    
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
    
    
    if (self.indexPath != nil && (((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE || ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE)) {
        
        NSLog(@"%d",self.indexPath.row);
        for (KSLotteryModel * model in [[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row] lotterys]) {
            
            [self ballButtonClick:_lotteryButton[model.buttonTag - LOTTERY_BTN_TAG(0)]];
                
        }
    }
    
    
    if (((KS_PickNumberViewController *)self.chooseLotteryDelegate).navigationController.viewControllers.count != 3) {

        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
        NSString * parameter1 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_02"];//三同号单选遗漏请求参数
         
        NSString * parameter2 = [[RuYiCaiNetworkManager sharedManager] configurationMissdateDictWithLotno:kLotNoNMK3 sellWay:@"F47108MV_40"];//三同号通选遗漏请求参数
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
    
    for (int i = 0; i< 7; i++) {
        
        if (i<6) {
            _lotteryButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 + i%3 * 101, i/3 * 55, 96, 40)];
        }
        if (i==6) {
            _lotteryButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(11 , i/3 * 55, 298, 40)];
        }
        
        
        
        
//        UIImage *img=[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        img=[img stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        
        
        [_lotteryButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_normal.png"]stretchableImageWithLeftCapWidth:55 topCapHeight:30] forState:UIControlStateNormal];
        [_lotteryButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:55 topCapHeight:30] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setBackgroundImage:[[UIImage imageNamed:@"lottery_btn_highlight.png"]stretchableImageWithLeftCapWidth:55 topCapHeight:30] forState:UIControlStateSelected];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        _lotteryButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [_lotteryButton[i] setAdjustsImageWhenHighlighted:NO];
        [_lotteryButton[i] addTarget:self action:@selector(ballButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lotteryButton[i] setTargetWhenSelectedChange:self action:@selector(ballButtonSelected:)];
        [_lotteryButton[i] setTag:LOTTERY_BTN_TAG(i)];
        [self.scrollView addSubview:_lotteryButton[i]];
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        
        
        _lotteryYiLouLabel[i] = [[UILabel alloc]initWithFrame:CGRectMake(_lotteryButton[i].frame.origin.x,
                                                                         _lotteryButton[i].frame.origin.y + _lotteryButton[i] .frame.size.height + 2,
                                                                         _lotteryButton[i].frame.size.width,
                                                                         30)];
        [_lotteryYiLouLabel[i] setHidden:YES];
        [_lotteryYiLouLabel[i] setBackgroundColor:[UIColor clearColor]];
        [_lotteryYiLouLabel[i] setFont:[UIFont boldSystemFontOfSize:12.0f]];
        [_lotteryYiLouLabel[i] setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [_lotteryYiLouLabel[i] setTextAlignment:NSTextAlignmentCenter];
        [_lotteryYiLouLabel[i] setText:@"22"];
        [self.scrollView addSubview:_lotteryYiLouLabel[i]];
        
        
        
        
        UILabel *num = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _lotteryButton[i].frame.size.width, 25)];
        if (i == 6) {
            [num setText:@"三同号通选"];
        }else{
            [num setText:[NSString stringWithFormat:@"%d",111*(i+1)]];
        }
        [num setTextAlignment:NSTextAlignmentCenter];
        [num setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [num setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
        [num setBackgroundColor:[UIColor clearColor]];
        [num setTag:LOTTERY_BTN_LABEL_NUM_TAG];
        [_lotteryButton [i] addSubview:num];
        
        UILabel *bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 23, _lotteryButton[i].frame.size.width, 15)];
        [bonusLabel setText:[self setBonusLabelText:i]];
        [bonusLabel setTextAlignment:NSTextAlignmentCenter];
        [bonusLabel setFont:[UIFont boldSystemFontOfSize:11.0f]];
        [bonusLabel setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        [bonusLabel setBackgroundColor:[UIColor clearColor]];
        [bonusLabel setTag:LOTTERY_BTN_LABEL_BONUS_TAG];
        [_lotteryButton [i] addSubview:bonusLabel];
    }
}

-(void)changeFrameByIsYiLou:(BOOL)yilou{
    
    NSTrace();
    NSLog(@"%@",NSStringFromCGRect(self.scrollView.frame) );
    NSLog(@"%@",NSStringFromCGRect(self.view.frame) );
    int spacing = 55;
    
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
        if (KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  340 );
        if (!KISiPhone5) self.scrollView.contentSize = CGSizeMake(320,  272 );
        
    } while (NO);
    
    
    
    do {
        for (int i = 0; i< 7; i++) {
            if (!_lotteryButton[i] || ![_lotteryButton[i] isKindOfClass:[UIButton class]]) {
                break;
            }
            
            if (i<6) {
                [_lotteryButton[i] setFrame:CGRectMake(11 + i%3 * 101, i/3 * spacing, 96, 40)];
            }
            if (i==6) {
                [_lotteryButton[i] setFrame:CGRectMake(11 , i/3 * spacing, 298, 40)];
            }
            
            if (!_lotteryYiLouLabel[i] || ![_lotteryYiLouLabel[i] isKindOfClass:[UILabel class]] ) {
                break;
            }
            [_lotteryYiLouLabel[i] setFrame:CGRectMake(_lotteryButton[i].frame.origin.x,
                                                       _lotteryButton[i].frame.origin.y + _lotteryButton[i] .frame.size.height + 2,
                                                       _lotteryButton[i].frame.size.width,
                                                       20)];
            
            if (yilou) [_lotteryYiLouLabel[i] setHidden:NO];
            if (!yilou) [_lotteryYiLouLabel[i] setHidden:YES];
        }
        
        
    } while (NO);
    
}

-(void)notifyLotteryHasChange:(KSLotterysModel *)ksLotterysModel{
    [super notifyLotteryHasChange:ksLotterysModel];
}
-(void)setupLotterMap{
    for (int i = 0; i< 7; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc]init];
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d",i + 1]];
        lotteryModel.buttonTag = LOTTERY_BTN_TAG(i);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
    }
    [super setupLotterMap];
    
}
-(void)cleanUpLotteryBasket{
    NSTrace();
    for (int i = 0; i<7; i++) {
        [_lotteryButton[i] setSelected:NO];
        [self setLableSelected:_lotteryButton[i]];
    }
}
#pragma mark -GET/SET
-(void)setLableSelected:(UIButton *)button{
    if (button.isSelected) {
        UILabel *num = (UILabel *)[button viewWithTag:LOTTERY_BTN_LABEL_NUM_TAG];
        [num setTextColor:[ColorUtils parseColorFromRGB:@"#f0cd55"]];
        UILabel *bonus = (UILabel *)[button viewWithTag:LOTTERY_BTN_LABEL_BONUS_TAG];
        [bonus setTextColor:[ColorUtils parseColorFromRGB:@"#f0cd55"]];
    }else{
        UILabel *num = (UILabel *)[button viewWithTag:LOTTERY_BTN_LABEL_NUM_TAG];
        [num setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
        UILabel *bonus = (UILabel *)[button viewWithTag:LOTTERY_BTN_LABEL_BONUS_TAG];
        [bonus setTextColor:[ColorUtils parseColorFromRGB:@"#c0ccbc"]];
        
    }
}
-(NSString *)setBonusLabelText:(NSInteger)i{
    
    
    if (i >= 0 && i < 6) {
        return @"奖金240元";
    }else if (i == 6){
        return @"任意一个豹子开出，即中40元";
    }else{
        return @"";
    }
    
}

#pragma mark -IBACTION

-(IBAction)ballButtonClick:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.isSelected) {
        btn.selected = NO;
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
        
        
    }else{
        
        btn.selected = YES;
        [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",btn.tag]];
    }
    [self setLableSelected:btn];
    
}



-(IBAction)ballButtonSelected:(id)sender{
    NSTrace();
    
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    
    if (btn.tag >= LOTTERY_BTN_TAG(0) && btn.tag <= LOTTERY_BTN_TAG(5)) {
        if (btn.isSelected) {
            [self.ksLotterys3THDXModel removeLotter:lottery];
        }else{
            [self.ksLotterys3THDXModel addLottery:lottery];
        }
        //    [self notifyLotteryHasChange:_ksLotterysModel];
        
        [self.ksBetingModel updateFromOldLotterys:_ksLotterys3THDXModel];
        [self notifyLotteryBasketHasChange:_ksBetingModel];
        
    }else if(btn.tag == LOTTERY_BTN_TAG(6)){
        
        if (btn.isSelected) {
            [self.ksLotterys3THTXModel removeLotter:lottery];
        }else{
            [self.ksLotterys3THTXModel addLottery:lottery];
        }
        //    [self notifyLotteryHasChange:_ksLotterysModel];
        
        [self.ksBetingModel updateFromOldLotterys:_ksLotterys3THTXModel];
        [self notifyLotteryBasketHasChange:_ksBetingModel];
        
    }
    
    
}



#pragma mark -KSBettingLotteryDelegate 摇一摇实现
-(void)bettingLotteryViewMotionEnded{
    NSTrace();
    
    //清空原有选中的彩票
    KS_PickNumberViewController * controller = (KS_PickNumberViewController * )self.chooseLotteryDelegate;
    if ([controller.navigationController.viewControllers count] != 3){
        
        for (int i = 0; i<7; i++) {
            [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
            UIButton *btn = _lotteryButton[i];
            [btn setSelected:NO];
            [self setLableSelected:btn];
            
        }
        
    }
    //随机选择一注
    int randomChooseNum = 0;//已选择个数
    int randomMaxNum = 1;//最大选择个数
    int randomNum = 0;//随意数
    int randomRangeNum = 7;//随机范围
    
    while (randomChooseNum < randomMaxNum) {
        randomNum = arc4random() % randomRangeNum;
        NSLog(@"randomRangeNum:%d",randomNum);
        if ([[self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomNum)]] isEqualToString: @"0"]) {
            
            randomChooseNum ++;
            [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomNum)]];
            UIButton *selectedBtn = (UIButton *)[self.scrollView viewWithTag:LOTTERY_BTN_TAG(randomNum)];
            [selectedBtn setSelected:YES];
            [self setLableSelected:selectedBtn];
        }
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
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_DAN_XUAN_PALY_STYLE] autorelease];
    KSLotterysModel * lotterysModelFX = [[[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_TONG_XUAN_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(6)]];
    if ([isSelected integerValue] == 1) {
        [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(6)]]];
        
    }
    
    
    if([lotterysModelDX.lotterys count] >= 1){
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
        int i = lotterysModelDX.lotterys.count;
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三同号单选 %d注 %d元",i,i * 2];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"三同号通选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
        
    }
    
    if ([lotterysModelDX.lotterys count] == 0 && [lotterysModelFX.lotterys count] == 0) {
        
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
    
    KSLotterysModel * lotterysModelDX = [[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_DAN_XUAN_PALY_STYLE];
    KSLotterysModel * lotterysModelFX = [[KSLotterysModel alloc] initWithPlayStyle:SAN_TONG_HAO_TONG_XUAN_PALY_STYLE];
    
    for (int i = 0; i < 6; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    
    NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(6)]];
    if ([isSelected integerValue] == 1) {
        [lotterysModelFX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(6)]]];
        
    }
    
    KSLotterysModel * lotterysModel = [[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row];
    
    if (lotterysModel.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        [[KSBettingModel share] addLotterys:lotterysModelFX];
        
    }else if (lotterysModel.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
        
    }else if(lotterysModel.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
        }
        
        return ;
    }
    
    
    if (lotterysModel.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
    }else if (lotterysModel.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
        
    }else if(lotterysModel.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] == 0){
        //随机
        [self bettingLotteryViewMotionEnded];
        
        self.isSelectedNumber = NO;
        
        KS_PickNumberViewController * controller = (KS_PickNumberViewController *)self.chooseLotteryDelegate;
        
        if (controller.navigationController.viewControllers.count == 3) {
            
            [self exchangeLotterysModel];
        }
        
        return ;
    }
    
    
    
    
    if (lotterysModel.playStyle != SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] != 0) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
    }else if (lotterysModel.playStyle != SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count >= 1 && [lotterysModelFX.lotterys count] == 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
    }else if(lotterysModel.playStyle != SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModel.playStyle != SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] != 0){
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelFX];
        
        
    }else if(lotterysModel.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE && lotterysModel.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE && lotterysModelDX.lotterys.count == 0 && [lotterysModelFX.lotterys count] == 0){
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
    
    if (lotterysModelDX.lotterys.count >= 1) {
        
        int i = lotterysModelDX.lotterys.count;
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三同号单选 %d注 %d元",i,i * 2];
    }
    
    if ([lotterysModelFX.lotterys count] != 0) {
        //拼注码
        [self appendFXBetingNumber:lotterysModelFX];
        lotterysModelFX.amountString = [NSString stringWithFormat:@"%d",[lotterysModelFX.lotterys count] * 200];
        lotterysModelFX.betSumStrimng = [NSString stringWithFormat:@"三同号通选 %d注 %d元",[lotterysModelFX.lotterys count],[lotterysModelFX.lotterys count] * 2];
    }
}


-(void)appendFXBetingNumber:(KSLotterysModel *)FXlotterysModel{
    
    FXlotterysModel.betCodeString = [NSString stringWithFormat:@"400001^"];
    FXlotterysModel.betNumberString = @"三同号通选";
    
}


-(void)appendDXBetingNumber:(KSLotterysModel *)DXlotterysModel{
    
    DXlotterysModel.betNumberString = @"";
    
    if (DXlotterysModel.lotterys.count == 1) {
        
        KSLotteryModel * model = DXlotterysModel.lotterys.lastObject;
        
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"020001"];
        
        DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d%02d%02d^",[model.lotteryNum integerValue],[model.lotteryNum integerValue],[model.lotteryNum integerValue]];
        
        DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum,model.lotteryNum,model.lotteryNum];
        
    }else{
        
        DXlotterysModel.betCodeString = [NSString stringWithFormat:@"810001%02d",DXlotterysModel.lotterys.count];
        
        int i = 0;
        for (KSLotteryModel * model in [DXlotterysModel lotterys]) {
            
            if (i != [DXlotterysModel lotterys].count - 1) {
                DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d",[model.lotteryNum integerValue]];
                
            }else{
                DXlotterysModel.betCodeString = [DXlotterysModel.betCodeString stringByAppendingFormat:@"%02d^",[model.lotteryNum integerValue]];
            }
            
            DXlotterysModel.betNumberString = [NSString stringWithFormat:@"%@%@%@%@ ",DXlotterysModel.betNumberString,model.lotteryNum,model.lotteryNum,model.lotteryNum];
            
            i ++ ;
        }
        
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
            _lotteryYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arrayTX objectAtIndex:0]];
        }else{
            _lotteryYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[arrayDX objectAtIndex:i]];

        }
    }

}


@end
