//
//  KSSumViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-20.
//
//

#import "KSSumViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiCommon.h"
#import "RNAssert.h"
#import "NSLog.h"
#import "UIButtonEx.h"
#import "KSLotteryModel.h"
#import "KSLotterysModel.h"
#import "KS_PickNumberViewController.h"
#import "KS_PickNumberMainViewController.h"
#import "RuYiCaiNetworkManager.h"


typedef enum _ChooseLotteryStyle{
    CHOOSE_LOTTERY_NONE_NO = 0,
    CHOOSE_LOTTERY_LARGE_NO,
    CHOOSE_LOTTERY_TRUMPET_NO,
    CHOOSE_LOTTERY_ORDER_NO,
    CHOOSE_LOTTERY_DOUBLE_NO,
    
    CHOOSE_LOTTERY_LARGE_ORDER_NO,
    CHOOSE_LOTTERY_LARGE_DOUBLE_NO,
    CHOOSE_LOTTERY_TRUMPET_ORDER_NO,
    CHOOSE_LOTTERY_TRUMPET_DOUBLE_NO,
    
}ChooseLotteryStyle;

#define LOTTERY_BTN_LABEL_NUM_TAG (3455)
#define LOTTERY_BTN_LABEL_BONUS_TAG (3456)
#define LOTTERY_BTN_TAG(tag) (3457+tag)

@interface KSSumViewController ()<UIScrollViewDelegate>
{
    UIButtonEx *_lotteryButton[16];
    UILabel *_lotteryYiLouLabel[16];
    UIButton *_lotteryFastChooseButton[4];
    UILabel *_ksxhLabel;
    ChooseLotteryStyle *_chooseLotteryStyle;
    UIScrollView *_scrollView;
    
    NSMutableDictionary *_selectedDic;
    
    KSLotterysModel *_ksLotterysModel;
    KSBettingModel *_ksBetingModel;
    
    
}
@property (nonatomic, retain) NSMutableSet * selectedButtonSets;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) KSBettingModel *ksBetingModel;
@property (nonatomic, retain) KSLotterysModel *ksLotterysModel;

@end

@implementation KSSumViewController
@synthesize scrollView = _scrollView;
@synthesize ksLotterysModel = _ksLotterysModel;
@synthesize selectedDic = _selectedDic;
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
-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)dealloc{
    
    for (int i = 0; i < 16; i++)
    {
        [_lotteryButton[i] release], _lotteryButton[i] = nil;
        [_lotteryYiLouLabel[i] release] ,_lotteryYiLouLabel [i] = nil;
    }
    for (int i = 0; i<4; i++) {
        [_lotteryFastChooseButton[i] release] , _lotteryFastChooseButton[i] = nil;
    }
    [_ksxhLabel release];
    self.scrollView = nil;
    self.selectedDic = nil;
    self.ksBetingModel = nil;
    self.ksLotterysModel = nil;
    self.selectedButtonSets = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    
	[self.view setBackgroundColor:[UIColor clearColor]];
    
    //初始化选号数组
    self.ksLotterysModel = [[[KSLotterysModel alloc ] initWithPlayStyle:HE_ZHI_PALY_STYLE] autorelease];
    self.ksBetingModel = [[[KSBettingModel alloc]init] autorelease];
    [self.ksBetingModel addLotterys:_ksLotterysModel];
    
    //初始化所有按钮为未选中
    self.selectedDic = [NSMutableDictionary dictionary];
    self.selectedButtonSets = [NSMutableSet set];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 360)];
    NSLog(@"%@===",NSStringFromCGRect(self.view.frame));
    if (KISiPhone5) {
        self.scrollView.contentSize = CGSizeMake(320,  360);
    }else{
        self.scrollView.contentSize = CGSizeMake(320, 400);
    }
    self.scrollView.delaysContentTouches=YES;
    self.scrollView.canCancelContentTouches=NO;
    
    [self.view addSubview:_scrollView];
    [self.scrollView release];
    NSLog(@"%@===",[self class]);
    
    [super viewDidLoad];
    
    
    if (self.indexPath != nil && ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:self.indexPath.row]).playStyle == HE_ZHI_PALY_STYLE) {
        
        for (KSLotteryModel * model in [[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row] lotterys]) {
            
            [self ballButtonClick:_lotteryButton[model.buttonTag - 3457]];
        }
    }
    
    if (((KS_PickNumberViewController *)self.chooseLotteryDelegate).navigationController.viewControllers.count != 3) {
        //在投注界面不获取遗漏值，在选号界面获取遗漏值
        [RuYiCaiNetworkManager sharedManager].netLotType = NET_LOT_MISSDATE;
        [[RuYiCaiNetworkManager sharedManager] getLotMissdateWithLotno:kLotNoNMK3 sellWay:@"F47108MV_10"];
    }
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"viewDidLoad");
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"viewDidLoad");
}


-(void)viewDidUnload{
    [super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -OVER LOAD
-(void)setupChooseLotterView{
    
    for (int i = 0; i< 16; i++) {
        _lotteryButton[i] = [[UIButtonEx alloc] initWithFrame:CGRectMake(10 + i%4 * 75, 0 + i/4 * 50, 70, 40)];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_normal.png"] forState:UIControlStateNormal];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateHighlighted];
        [_lotteryButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateSelected];
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
        [num setText:[NSString stringWithFormat:@"%d",3+i]];
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
    
    _ksxhLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_lotteryButton[15].frame.origin.y + _lotteryButton[15].frame.size.height + 5, 320, 20)];
    [_ksxhLabel setTextAlignment:NSTextAlignmentCenter];
    [_ksxhLabel setText:@"快速选号"];
    [_ksxhLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
    [_ksxhLabel setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [_ksxhLabel setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:_ksxhLabel];
    
    for (int i = 0; i<4; i++) {
        if (KISiPhone5) {
            //断言
            //            RNAssert(NO, @"创建目标 Activity 失败 ! newActivity 为 nil, 或者类型不是 Activity.");
        }
        _lotteryFastChooseButton[i] = [[UIButton alloc] initWithFrame:CGRectMake(10 + i%4 * 75, _ksxhLabel.frame.size.height + _ksxhLabel.frame.origin.y + 5 + i/4 * 50, 70, 40)];
        [_lotteryFastChooseButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_normal.png"] forState:UIControlStateNormal];
        [_lotteryFastChooseButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateHighlighted];
        [_lotteryFastChooseButton[i] setBackgroundImage:[UIImage imageNamed:@"lottery_btn_highlight.png"] forState:UIControlStateSelected];
        [_lotteryFastChooseButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] forState:UIControlStateNormal];
        [_lotteryFastChooseButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateHighlighted];
        [_lotteryFastChooseButton[i] setTitleColor:[ColorUtils parseColorFromRGB:@"#f0cd55"] forState:UIControlStateSelected];
        [_lotteryFastChooseButton[i] setTitle:[self setFastChooseLabelText:i] forState:UIControlStateNormal];
        [_lotteryFastChooseButton[i] setAdjustsImageWhenHighlighted:NO];
        _lotteryFastChooseButton[i].titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        if (i<2) {
            [_lotteryFastChooseButton[i] addTarget:self action:@selector(fastChooseButtonFirstGroupClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_lotteryFastChooseButton[i] addTarget:self action:@selector(fastChooseButtonSecondGroupClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.scrollView addSubview:_lotteryFastChooseButton[i]];
    }
    
}
-(void)changeFrameByIsYiLou:(BOOL)yilou{
    
    NSTrace();
    int spacing = 50;
    NSLog(@"%@===",NSStringFromCGRect(self.view.frame));
    NSLog(@"%@===",NSStringFromCGRect(self.scrollView.frame));
    NSLog(@"%@===",NSStringFromCGSize(self.scrollView.contentSize));
    //非遗漏
    do {
        if (yilou) {
            break;
        }
        if (KISiPhone5){
            self.scrollView.contentSize = CGSizeMake(320,  360);
            NSLog(@"%@===",NSStringFromCGSize(self.scrollView.contentSize));
        }
        if (!KISiPhone5)
            //self.scrollView.contentSize = CGSizeMake(320,  self.view.frame.size.height + 30);
            self.scrollView.contentSize = CGSizeMake(320,400);
        
    } while (NO);
    
    //遗漏
    do {
        if (!yilou) {
            break;
        }
        spacing = 70;
        if (KISiPhone5)
            self.scrollView.contentSize = CGSizeMake(320,  408 );
        if (!KISiPhone5)
            self.scrollView.contentSize = CGSizeMake(320,  480);
        
    } while (NO);
    
    NSLog(@"%@===",NSStringFromCGRect(self.view.frame));
    
    do {
        for (int i = 0; i< 16; i++) {
            if (!_lotteryButton[i] || ![_lotteryButton[i] isKindOfClass:[UIButton class]]) {
                break;
            }
            [_lotteryButton[i] setFrame:CGRectMake(10 + i%4 * 75, 0 + i/4 * spacing, 70, 40)];
            
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
        if (!_ksxhLabel || ![_ksxhLabel isKindOfClass:[UILabel class]]) {
            break;
        }
        [_ksxhLabel setFrame:CGRectMake(0,_lotteryButton[15].frame.origin.y + _lotteryButton[15].frame.size.height + 5 + (spacing - 40), 320, 20)];
        
        
        for (int i = 0; i<4; i++) {
            if (!_lotteryFastChooseButton[i] || ![_lotteryFastChooseButton[i] isKindOfClass:[UIButton class]]) {
                break;
            }
            [_lotteryFastChooseButton[i] setFrame:CGRectMake(10 + i%4 * 75, _ksxhLabel.frame.size.height + _ksxhLabel.frame.origin.y + 5 + i/4 * spacing, 70, 40)];
        }
        
    } while (NO);
    
}

-(void)notifyLotteryHasChange:(KSLotterysModel *)ksLotterysModel{
    [super notifyLotteryHasChange:ksLotterysModel];
}
-(void)setupLotterMap{
    for (int i = 0; i< 16; i++) {
        KSLotteryModel *lotteryModel = [[KSLotteryModel alloc] init] ;
        [lotteryModel setLotteryNum:[NSString stringWithFormat:@"%d",i+3]];
        lotteryModel.buttonTag = LOTTERY_BTN_TAG(i);
        NSLog(@"%@",lotteryModel.lotteryNum);
        [self.lotteryModelDic setObject:lotteryModel forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
    }
    //[super setupLotterMap];
}
-(void)cleanUpLotteryBasket{
    NSTrace();
    for (int i = 0; i<16; i++) {
        [_lotteryButton[i] setSelected:NO];
        [self setLableSelected:_lotteryButton[i]];
    }
    for (int i = 0; i<4; i++) {
        [_lotteryFastChooseButton[i] setSelected:NO];
    }
}
#pragma mark -GET/SET
-(NSString *)setFastChooseLabelText:(NSInteger)i{
    if (i == 0) {
        return @"大";
    }else if (i == 1){
        return @"小";
    }else if (i == 2){
        return @"单";
    }else if (i == 3){
        return @"双";
    }else{
        return @"";
    }
}


-(void)setFastChooseButtonStatus{

    NSMutableSet * set1 = [NSMutableSet setWithObjects:@"3",@"5",@"7",@"9", nil];
    NSMutableSet * set2 = [NSMutableSet setWithObjects:@"4",@"6",@"8",@"10", nil];
    NSMutableSet * set3 = [NSMutableSet setWithObjects:@"11",@"13",@"15",@"17", nil];
    NSMutableSet * set4 = [NSMutableSet setWithObjects:@"12",@"14",@"16",@"18", nil];
//    NSMutableSet * set5 = [NSMutableSet setWithObjects:@"3",@"5",@"7",@"9", nil];
//    NSMutableSet * set6 = [NSMutableSet setWithObjects:@"3",@"5",@"7",@"9", nil];
//    NSMutableSet * set7 = [NSMutableSet setWithObjects:@"3",@"5",@"7",@"9", nil];
//    NSMutableSet * set8 = [NSMutableSet setWithObjects:@"3",@"5",@"7",@"9", nil];

    if ([self.selectedButtonSets isEqualToSet:set1]){
        //单-小
        _lotteryFastChooseButton[1].selected = YES;
        _lotteryFastChooseButton[2].selected = YES;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[3].selected = NO;

    }else if([self.selectedButtonSets isEqualToSet:set2]){
        //双-小
        _lotteryFastChooseButton[1].selected = YES;
        _lotteryFastChooseButton[3].selected = YES;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;

    }else if([self.selectedButtonSets isEqualToSet:set3]){
        //单-大
        _lotteryFastChooseButton[0].selected = YES;
        _lotteryFastChooseButton[2].selected = YES;
        _lotteryFastChooseButton[1].selected = NO;
        _lotteryFastChooseButton[3].selected = NO;

    }else if([self.selectedButtonSets isEqualToSet:set4]){
        //双-大
        _lotteryFastChooseButton[0].selected = YES;
        _lotteryFastChooseButton[3].selected = YES;
        _lotteryFastChooseButton[1].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;

    }else if([self.selectedButtonSets isEqualToSet:[set1 setByAddingObjectsFromSet:set2]]){//小
        
        _lotteryFastChooseButton[1].selected = YES;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;
        _lotteryFastChooseButton[3].selected = NO;
        
    }else if([self.selectedButtonSets isEqualToSet:[set1 setByAddingObjectsFromSet:set3]]){//单
    
        _lotteryFastChooseButton[2].selected = YES;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[1].selected = NO;
        _lotteryFastChooseButton[3].selected = NO;

        
    }else if([self.selectedButtonSets isEqualToSet:[set3 setByAddingObjectsFromSet:set4]]){//大
        
        _lotteryFastChooseButton[0].selected = YES;
        _lotteryFastChooseButton[1].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;
        _lotteryFastChooseButton[3].selected = NO;

        
    }else if([self.selectedButtonSets isEqualToSet:[set2 setByAddingObjectsFromSet:set4]]){//双
        
        _lotteryFastChooseButton[3].selected = YES;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;
        _lotteryFastChooseButton[1].selected = NO;

    
    }else{
        
        _lotteryFastChooseButton[3].selected = NO;
        _lotteryFastChooseButton[0].selected = NO;
        _lotteryFastChooseButton[2].selected = NO;
        _lotteryFastChooseButton[1].selected = NO;
        
    }

}

-(NSString *)setBonusLabelText:(NSInteger)i{
    
    
    if (i == 0) {
        return @"奖金240元";
    }else if (i == 1){
        return @"奖金80元";
    }else if (i == 2){
        return @"奖金40元";
    }else if (i == 3){
        return @"奖金25元";
    }else if (i == 4){
        return @"奖金16元";
    }else if (i == 5){
        return @"奖金12元";
    }else if (i == 6){
        return @"奖金10元";
    }else if (i == 7){
        return @"奖金9元";
    }else if (i == 8){
        return @"奖金9元";
    }else if (i == 9){
        return @"奖金10元";
    }else if (i == 10){
        return @"奖金12元";
    }else if (i == 11){
        return @"奖金16元";
    }else if (i == 12){
        return @"奖金25元";
    }else if (i == 13){
        return @"奖金40元";
    }else if (i == 14){
        return @"奖金80元";
    }else if (i == 15){
        return @"奖金240元";
    }else{
        return @"";
    }
    
}
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

//快速选号
-(void)setLotteryStyle{
    
    if (_lotteryFastChooseButton[0].isSelected &&
        !_lotteryFastChooseButton[1].isSelected &&
        !_lotteryFastChooseButton[2].isSelected &&
        !_lotteryFastChooseButton[3].isSelected)
    {
        _chooseLotteryStyle = CHOOSE_LOTTERY_LARGE_NO;
        //大
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:YES];
            [self setLableSelected:_lotteryButton[i]];
        }
        
        
        
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             _lotteryFastChooseButton[1].isSelected &&
             !_lotteryFastChooseButton[2].isSelected &&
             !_lotteryFastChooseButton[3].isSelected)
    {
        _chooseLotteryStyle = CHOOSE_LOTTERY_TRUMPET_NO;
        //小
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:YES];
            [self setLableSelected:_lotteryButton[i]];
        }
        
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             !_lotteryFastChooseButton[1].isSelected &&
             _lotteryFastChooseButton[2].isSelected &&
             !_lotteryFastChooseButton[3].isSelected)
    {
        _chooseLotteryStyle = CHOOSE_LOTTERY_ORDER_NO;
        //单
        for (int i = 1; i<16; i = i+2) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 0; i<16; i = i+2) {
            [_lotteryButton[i] setSelected:YES];
            [self setLableSelected:_lotteryButton[i]];
        }
        
        
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             !_lotteryFastChooseButton[1].isSelected &&
             !_lotteryFastChooseButton[2].isSelected &&
             _lotteryFastChooseButton[3].isSelected)
    {
        _chooseLotteryStyle = CHOOSE_LOTTERY_DOUBLE_NO;
        //双-选中
        for (int i = 0; i<16; i = i+2) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 1; i<16; i = i+2) {
            [_lotteryButton[i] setSelected:YES];
            [self setLableSelected:_lotteryButton[i]];
        }
        
    }else if(_lotteryFastChooseButton[0].isSelected &&
             !_lotteryFastChooseButton[1].isSelected &&
             _lotteryFastChooseButton[2].isSelected &&
             !_lotteryFastChooseButton[3].isSelected)
    {
        //大-单
        _chooseLotteryStyle = CHOOSE_LOTTERY_LARGE_ORDER_NO;
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:YES];
            //单
            
            for (int j = 9; j<16; j =j+2) {
                [_lotteryButton[j] setSelected:NO];
            }
            
            [self setLableSelected:_lotteryButton[i]];
        }
        
    }else if(_lotteryFastChooseButton[0].isSelected &&
             !_lotteryFastChooseButton[1].isSelected &&
             !_lotteryFastChooseButton[2].isSelected &&
             _lotteryFastChooseButton[3].isSelected)
    {
        //大-双
        _chooseLotteryStyle = CHOOSE_LOTTERY_LARGE_DOUBLE_NO;
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:YES];
            //双
            for (int j = 8; j<16; j =j+2) {
                [_lotteryButton[j] setSelected:NO];
            }
            [self setLableSelected:_lotteryButton[i]];
        }
        
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             _lotteryFastChooseButton[1].isSelected &&
             _lotteryFastChooseButton[2].isSelected &&
             !_lotteryFastChooseButton[3].isSelected)
    {
        //小-单
        _chooseLotteryStyle = CHOOSE_LOTTERY_TRUMPET_ORDER_NO;
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:YES];
            //单
            for (int j = 1; j<8; j =j+2) {
                [_lotteryButton[j] setSelected:NO];
            }
            [self setLableSelected:_lotteryButton[i]];
        }
        
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             _lotteryFastChooseButton[1].isSelected &&
             !_lotteryFastChooseButton[2].isSelected &&
             _lotteryFastChooseButton[3].isSelected)
    {
        //小-双
        _chooseLotteryStyle = CHOOSE_LOTTERY_TRUMPET_DOUBLE_NO;
        for (int i = 8; i<16; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
        for (int i = 0; i<8; i++) {
            [_lotteryButton[i] setSelected:YES];
            //双
            for (int j = 0; j<8; j =j+2) {
                [_lotteryButton[j] setSelected:NO];
            }
            
            [self setLableSelected:_lotteryButton[i]];
        }
    }else if(!_lotteryFastChooseButton[0].isSelected &&
             !_lotteryFastChooseButton[1].isSelected &&
             !_lotteryFastChooseButton[2].isSelected &&
             !_lotteryFastChooseButton[3].isSelected)
    {
        //无
        _chooseLotteryStyle = CHOOSE_LOTTERY_NONE_NO;
        for (int i = 0;  i<16; i++) {
            [_lotteryButton[i] setSelected:NO];
            [self setLableSelected:_lotteryButton[i]];
        }
    }
    
    //遍历button 将选中的按钮加入选中组
    for (int i = 0;  i<16; i++) {
        if([_lotteryButton[i] isSelected]){
            [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        }else{
            [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        }
    }
    
}
#pragma mark -IBACTION
-(IBAction)ballButtonSelected:(id)sender{
    NSTrace();
    NSLog(@"ballButtonSelected-----------");
    
    UIButtonEx *btn = (UIButtonEx *)sender;
    
    KSLotteryModel *lottery = [self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",btn.tag]];
    if (btn.isSelected) {
        [self.ksLotterysModel removeLotter:lottery];
        [self.selectedButtonSets removeObject:lottery.lotteryNum];
    }else{
        [self.ksLotterysModel addLottery:lottery];
        [self.selectedButtonSets addObject:lottery.lotteryNum];
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
    [self setLableSelected:btn];
    [self setFastChooseButtonStatus];
    
}



-(IBAction)fastChooseButtonFirstGroupClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.isSelected) {
        btn.selected = NO;
        
    }else{
        btn.selected = YES;
        
        for (int i = 0; i< 2 ; i++) {
            UIButton *oneButton = _lotteryFastChooseButton[i];
            if (btn == oneButton) {
                oneButton.selected = YES;
            }else{
                oneButton.selected = NO;
            }
        }
    }
    
    [self setLotteryStyle];
    
    
}
-(IBAction)fastChooseButtonSecondGroupClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    if (btn.isSelected) {
        btn.selected = NO;
        
    }else{
        btn.selected = YES;
        for (int i = 2; i< 4 ; i++) {
            UIButton *oneButton = _lotteryFastChooseButton[i];
            if (btn == oneButton) {
                oneButton.selected = YES;
            }else{
                oneButton.selected = NO;
            }
        }
    }
    
    [self setLotteryStyle];
    
}

#pragma mark -KSBettingLotteryDelegate 摇一摇实现
-(void)bettingLotteryViewMotionEnded{
    NSTrace();
    
    //清空原有选中的彩票
    for (int i = 0; i<4; i++) {
        UIButton *btn = _lotteryFastChooseButton[i];
        [btn setSelected:NO];
        [self setLableSelected:btn];
    }
    for (int i = 0; i<16; i++) {
        [self.selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        UIButtonEx *btn = _lotteryButton[i];
        [btn setSelected:NO];
        [self setLableSelected:btn];
        
    }
    //随机选择一注
    int randomChooseNum = 0;//已选择个数
    int randomMaxNum = 1;//最大选择个数
    int randomNum = 0;//随意数
    int randomRangeNum = 16;//随机范围
    
    while (randomChooseNum < randomMaxNum) {
        randomNum = arc4random() % randomRangeNum;
        if ([[self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomNum)]] isEqualToString: @"0"]) {
            randomChooseNum ++;
            [self.selectedDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(randomNum)]];
            UIButtonEx *selectedBtn = (UIButtonEx *)[self.scrollView viewWithTag:LOTTERY_BTN_TAG(randomNum)];
            [selectedBtn setSelected:YES];
            [self setLableSelected:selectedBtn];
        }
    }
}



#pragma - mark
#pragma - mark二同号逻辑实现

-(void)changeKsBetingModelData{
    
    if (self.indexPath == nil) {
        [self addLotterysModel];
    }else{
        [self exchangeLotterysModel];
    }
    
}


-(void)addLotterysModel{
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:HE_ZHI_PALY_STYLE] autorelease];
    
    
    for (int i = 0; i < 16; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    if([lotterysModelDX.lotterys count] >= 1){
        
        [[KSBettingModel share] addLotterys:lotterysModelDX];
        
        int i = lotterysModelDX.lotterys.count;
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"和值 %d注 %d彩豆",i,i * 2*aas];
    }
    
    if ([lotterysModelDX.lotterys count] == 0) {
        
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
    
    KSLotterysModel * lotterysModelDX = [[[KSLotterysModel alloc] initWithPlayStyle:HE_ZHI_PALY_STYLE] autorelease];
    
    for (int i = 0; i < 16; i ++) {
        NSString * isSelected = [self.selectedDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]];
        if ([isSelected integerValue] == 1) {
            [lotterysModelDX.lotterys addObject:[self.lotteryModelDic objectForKey:[NSString stringWithFormat:@"%d",LOTTERY_BTN_TAG(i)]]];
        }
        
    }
    
    
    KSLotterysModel * lotterysModel = [[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:self.indexPath.row];
    
    if (lotterysModelDX.lotterys.count >= 1) {
        
        [[KSBettingModel share] updateFromOldLotterys:lotterysModel ToNewLotterys:lotterysModelDX];
        
        int i = lotterysModelDX.lotterys.count;
        
        //拼注码
        [self appendDXBetingNumber:lotterysModelDX];
        lotterysModelDX.amountString = [NSString stringWithFormat:@"%d",i * 200];
        int aas = [[RuYiCaiNetworkManager sharedManager] oneYuanToCaidou];
        lotterysModelDX.betSumStrimng = [NSString stringWithFormat:@"三不同号 %d注 %d彩豆",i,i * 2*aas];
        
    }else if (lotterysModelDX.lotterys.count == 0) {
        
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
    
    DXlotterysModel.betCodeString = [NSString stringWithFormat:@"100001%02d",DXlotterysModel.lotterys.count];
    
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



- (void)getMissNumber:(NSString *)parserString{
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:parserString];
    [jsonParser release];
    
    NSArray * array = [[parserDict objectForKey:@"result"] objectForKey:@"miss"];
    
    
    for (int i = 0; i < [array count] ; i ++) {
        
        _lotteryYiLouLabel[i].text = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
    }
}


@end
