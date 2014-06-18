//
//  DiceViewController.m
//  Boyacai
//
//  Created by wangxr on 14-5-22.
//
//

#import "DiceViewController.h"
#import "ActivitiesViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiAppDelegate.h"
#define CAduration 3
#define StartingPoint CGPointMake(160.0, 130.0)
@interface DiceViewController ()
@property (nonatomic,retain)UIImageView * diceImgV;
@end

@implementation DiceViewController
- (void)dealloc
{
    [RuYiCaiNetworkManager sharedManager].shouldRefreshShaiZiTimer = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (self.remainingTimer != nil) {
        if( [self.remainingTimer isValid])
        {
            [self.remainingTimer invalidate];
        }
        self.remainingTimer = nil;
    }
//    if (checkLastResultTimer != nil) {
//        if( [checkLastResultTimer isValid])
//        {
//            [checkLastResultTimer invalidate];
//        }
//        checkLastResultTimer = nil;
//    }
    [_remainingTimer release];
    [_uu release];
    [_allchoumaL2 release];
    [_allchoumaL1 release];
    [_choumaImageV1 release];
    [_choumaImageV2 release];
    [_m_scrollView release];
    [_inputTF release];
    [_rightrenshuL release];
    [_rightcaidouL release];
    [_leftrenshuL release];
    [_leftcaidouL release];
    [_lastResultImageV release];
    [_lastStatusLabel release];
    [_lastNameLabel release];
    [_currentRoundNameLabel release];
    [_currentRemainingTLabel release];
    [_diceImgV release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lastResultGeted = NO;
        xiaoZhu = 0;
        daZhu = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [AdaptationUtils adaptation:self];
    self.navigationItem.title = @"猜大小,赢双倍彩豆";
    [self.navigationController.navigationBar setBackground];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(back:) andAutoPopView:NO];
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    selectedResult = 0;
    
   self.m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _m_scrollView.delegate = self;
    _m_scrollView.scrollEnabled = YES;
    [_m_scrollView setContentSize:CGSizeMake(320, 550)];
//    [self.view addSubview:m_scrollView];
    [self.view addSubview:_m_scrollView];
//    self.view = _m_scrollView;
    [_m_scrollView release];
    
    self.view.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
    UIView * topb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [topb setBackgroundColor:[UIColor whiteColor]];
    [self.m_scrollView addSubview:topb];
    [topb release];
    
    UILabel * uL = [[UILabel alloc] initWithFrame:CGRectMake(-5, 7, 120, 20)];
    [uL setBackgroundColor:[UIColor clearColor]];
    [uL setText:@"本期倒计时"];
    [uL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:uL];
    [uL release];
    
    self.currentRoundNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5, 26, 120, 20)];
    [_currentRoundNameLabel setBackgroundColor:[UIColor clearColor]];
    [_currentRoundNameLabel setText:@"20140521123期"];
    [_currentRoundNameLabel setFont:[UIFont systemFontOfSize:12]];
    [_currentRoundNameLabel setTextAlignment:NSTextAlignmentCenter];
    [_currentRoundNameLabel setTextColor:[UIColor grayColor]];
    [self.m_scrollView addSubview:_currentRoundNameLabel];
    [_currentRoundNameLabel release];
    
    UIImageView * rBGV = [[UIImageView alloc] initWithFrame:CGRectMake(120, 4.5, 94, 36.5)];
    [rBGV setImage:[UIImage imageNamed:@"topTimeBG"]];
    [self.m_scrollView addSubview:rBGV];
    [rBGV release];
    
    self.currentRemainingTLabel = [[UILabel alloc] initWithFrame:CGRectMake(121, 14, 92, 25)];
    [_currentRemainingTLabel setBackgroundColor:[UIColor clearColor]];
    [_currentRemainingTLabel setText:@"13:45"];
    [_currentRemainingTLabel setFont:[UIFont systemFontOfSize:17]];
    [_currentRemainingTLabel setTextAlignment:NSTextAlignmentCenter];
    [_currentRemainingTLabel setTextColor:[UIColor whiteColor]];
    [self.m_scrollView addSubview:_currentRemainingTLabel];
    [_currentRemainingTLabel release];
    
    self.lastNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 7, 120, 20)];
    [_lastNameLabel setBackgroundColor:[UIColor clearColor]];
    [_lastNameLabel setText:@"上一期"];
    [_lastNameLabel setFont:[UIFont systemFontOfSize:15]];
    [_lastNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_lastNameLabel];
    [_lastNameLabel release];
    
    self.lastStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 25, 120, 20)];
    [_lastStatusLabel setBackgroundColor:[UIColor clearColor]];
    [_lastStatusLabel setText:@"等待开奖"];
    [_lastStatusLabel setFont:[UIFont systemFontOfSize:13]];
    [_lastStatusLabel setTextColor:[UIColor orangeColor]];
    [_lastStatusLabel setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_lastStatusLabel];
    [_lastStatusLabel release];
    
    self.lastResultImageV = [[UIImageView alloc] initWithFrame:CGRectMake(272, 25, 18, 18)];
    [_lastResultImageV setImage:[UIImage imageNamed:@"little6"]];
    [self.m_scrollView addSubview:_lastResultImageV];
    [_lastResultImageV release];
    
    UIImageView * historyIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 225, 20, 20)];
    [historyIV setImage:[UIImage imageNamed:@"historyaward"]];
    [self.m_scrollView addSubview:historyIV];
    [historyIV release];
    
    self.historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_historyBtn setFrame:CGRectMake(25, 220, 80, 30)];
//    [_historyBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_historyBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateNormal];
//    [historyBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateSelected];
    [_historyBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_historyBtn setTitle:@"历史开奖" forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_historyBtn];
    [_historyBtn addTarget:self action:@selector(historyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * recordIV = [[UIImageView alloc] initWithFrame:CGRectMake(115, 225, 20, 20)];
    [recordIV setImage:[UIImage imageNamed:@"lotrecord"]];
    [self.m_scrollView addSubview:recordIV];
    [recordIV release];
    
    self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordBtn setFrame:CGRectMake(130, 220, 80, 30)];
    //    [_historyBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_recordBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateNormal];
    //    [historyBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateSelected];
    [_recordBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_recordBtn setTitle:@"投注记录" forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_recordBtn];
    [_recordBtn addTarget:self action:@selector(recordBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView * ruleIV = [[UIImageView alloc] initWithFrame:CGRectMake(220, 225, 20, 20)];
    [ruleIV setImage:[UIImage imageNamed:@"rule"]];
    [self.m_scrollView addSubview:ruleIV];
    [ruleIV release];
    
    self.ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ruleBtn setFrame:CGRectMake(235, 220, 80, 30)];
    //    [_historyBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_ruleBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateNormal];
    //    [historyBtn setTitleColor:[UIColor colorWithRed:0.027 green:0.58 blue:0.757 alpha:1] forState:UIControlStateSelected];
    [_ruleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_ruleBtn setTitle:@"活动规则" forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_ruleBtn];
    [_ruleBtn addTarget:self action:@selector(ruleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * centerBGV = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, 103)];
    [centerBGV setBackgroundColor:[UIColor whiteColor]];
    [self.m_scrollView addSubview:centerBGV];
    [centerBGV release];
    
    self.leftSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftSelectBtn setFrame:CGRectMake(49, 260, 135.5, 103)];
    [_leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_leftSelectBtn];
    [_leftSelectBtn addTarget:self action:@selector(leftSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.leftSelectBtn.tag = 1;
    
    self.rightSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightSelectBtn setFrame:CGRectMake(320-135.5, 260, 135.5, 103)];
    [_rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_rightSelectBtn];
    [_rightSelectBtn addTarget:self action:@selector(rightSelectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.rightSelectBtn.tag = 1;
    
    UIImageView * shaiziIV1 = [[UIImageView alloc] initWithFrame:CGRectMake(69, 270, 25, 25)];
    [shaiziIV1 setImage:[UIImage imageNamed:@"little1"]];
    [self.m_scrollView addSubview:shaiziIV1];
    UIImageView * shaiziIV2 = [[UIImageView alloc] initWithFrame:CGRectMake(104, 270, 25, 25)];
    [shaiziIV2 setImage:[UIImage imageNamed:@"little2"]];
    [self.m_scrollView addSubview:shaiziIV2];
    UIImageView * shaiziIV3 = [[UIImageView alloc] initWithFrame:CGRectMake(139, 270, 25, 25)];
    [shaiziIV3 setImage:[UIImage imageNamed:@"little3"]];
    [self.m_scrollView addSubview:shaiziIV3];
    
    UIImageView * shaiziIV4 = [[UIImageView alloc] initWithFrame:CGRectMake(205, 270, 25, 25)];
    [shaiziIV4 setImage:[UIImage imageNamed:@"little4"]];
    [self.m_scrollView addSubview:shaiziIV4];
    UIImageView * shaiziIV5 = [[UIImageView alloc] initWithFrame:CGRectMake(240, 270, 25, 25)];
    [shaiziIV5 setImage:[UIImage imageNamed:@"little5"]];
    [self.m_scrollView addSubview:shaiziIV5];
    UIImageView * shaiziIV6 = [[UIImageView alloc] initWithFrame:CGRectMake(275, 270, 25, 25)];
    [shaiziIV6 setImage:[UIImage imageNamed:@"little6"]];
    [self.m_scrollView addSubview:shaiziIV6];
    [shaiziIV1 release];
    [shaiziIV2 release];
    [shaiziIV3 release];
    [shaiziIV4 release];
    [shaiziIV5 release];
    [shaiziIV6 release];
    
    UILabel * renshu = [[UILabel alloc] initWithFrame:CGRectMake(0, 310, 49, 20)];
    [renshu setBackgroundColor:[UIColor clearColor]];
    [renshu setText:@"人次"];
    [renshu setTextColor:[UIColor grayColor]];
    [renshu setFont:[UIFont systemFontOfSize:15]];
    [renshu setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:renshu];
    [renshu release];
    
    UILabel * caidou = [[UILabel alloc] initWithFrame:CGRectMake(0, 335, 49, 20)];
    [caidou setBackgroundColor:[UIColor clearColor]];
    [caidou setText:@"彩豆"];
    [caidou setTextColor:[UIColor grayColor]];
    [caidou setFont:[UIFont systemFontOfSize:15]];
    [caidou setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:caidou];
    [caidou release];
    
    self.leftrenshuL = [[UILabel alloc] initWithFrame:CGRectMake(59, 310, 115.3, 20)];
    [_leftrenshuL setBackgroundColor:[UIColor clearColor]];
    [_leftrenshuL setText:@"345622"];
    [_leftrenshuL setTextColor:[UIColor whiteColor]];
    [_leftrenshuL setFont:[UIFont systemFontOfSize:15]];
    [_leftrenshuL setTextAlignment:NSTextAlignmentLeft];
    [self.m_scrollView addSubview:_leftrenshuL];
    [_leftrenshuL release];
    
    self.leftcaidouL = [[UILabel alloc] initWithFrame:CGRectMake(59, 335, 115.3, 20)];
    [_leftcaidouL setBackgroundColor:[UIColor clearColor]];
    [_leftcaidouL setText:@"3322345622"];
    [_leftcaidouL setTextColor:[UIColor whiteColor]];
    [_leftcaidouL setFont:[UIFont systemFontOfSize:15]];
    [_leftcaidouL setTextAlignment:NSTextAlignmentLeft];
    [self.m_scrollView addSubview:_leftcaidouL];
    [_leftcaidouL release];
    

    
    
    UIImageView * yazhuBG = [[UIImageView alloc] initWithFrame:CGRectMake(49+135.5-84, 363-29, 84, 29)];
    [yazhuBG setImage:[UIImage imageNamed:@"yazhubg"]];
    [self.m_scrollView addSubview:yazhuBG];
    [yazhuBG release];
    
    UIImageView * yazhuicon = [[UIImageView alloc] initWithFrame:CGRectMake(23, 5, 22.5, 16.5)];
    [yazhuicon setImage:[UIImage imageNamed:@"yazhuICO"]];
    [yazhuBG addSubview:yazhuicon];
    [yazhuicon release];
    
    self.allchoumaL1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 39, 29)];
    self.allchoumaL1.backgroundColor = [UIColor clearColor];
    self.allchoumaL1.textAlignment = NSTextAlignmentCenter;
    [self.allchoumaL1 setText:@"0"];
    [self.allchoumaL1 setFont:[UIFont systemFontOfSize:12]];
    [yazhuBG addSubview:self.allchoumaL1];
    [self.allchoumaL1 release];
    
    self.choumaImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(95, 290, 45.5, 44.5)];
    [_choumaImageV1 setImage:[UIImage imageNamed:@"chouma_1"]];
    [self.m_scrollView addSubview:_choumaImageV1];
    [_choumaImageV1 release];
    self.choumaImageV1.hidden = YES;
    self.choumaL1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45.5, 44.5)];
    self.choumaL1.backgroundColor = [UIColor clearColor];
    self.choumaL1.textAlignment = NSTextAlignmentCenter;
    self.choumaL1.adjustsFontSizeToFitWidth = YES;
    [self.choumaImageV1 addSubview:self.choumaL1];
    //    [self.choumaL1 setTextColor:[UIColor whiteColor]];
    [self.choumaL1 release];
    
    self.rightrenshuL = [[UILabel alloc] initWithFrame:CGRectMake(59+135.5, 310, 115.3, 20)];
    [_rightrenshuL setBackgroundColor:[UIColor clearColor]];
    [_rightrenshuL setText:@"23622"];
    [_rightrenshuL setTextColor:[UIColor whiteColor]];
    [_rightrenshuL setFont:[UIFont systemFontOfSize:15]];
    [_rightrenshuL setTextAlignment:NSTextAlignmentLeft];
    [self.m_scrollView addSubview:_rightrenshuL];
    [_rightrenshuL release];
    
    self.rightcaidouL = [[UILabel alloc] initWithFrame:CGRectMake(59+135.5, 335, 115.3, 20)];
    [_rightcaidouL setBackgroundColor:[UIColor clearColor]];
    [_rightcaidouL setText:@"7655622"];
    [_rightcaidouL setTextColor:[UIColor whiteColor]];
    [_rightcaidouL setFont:[UIFont systemFontOfSize:15]];
    [_rightcaidouL setTextAlignment:NSTextAlignmentLeft];
    [self.m_scrollView addSubview:_rightcaidouL];
    [_rightcaidouL release];
    

    
    UIImageView * yazhuBG2 = [[UIImageView alloc] initWithFrame:CGRectMake(49+135.5-84+135.5, 363-29, 84, 29)];
    [yazhuBG2 setImage:[UIImage imageNamed:@"yazhubg"]];
    [self.m_scrollView addSubview:yazhuBG2];
    [yazhuBG2 release];
    
    UIImageView * yazhuicon2 = [[UIImageView alloc] initWithFrame:CGRectMake(23, 5, 22.5, 16.5)];
    [yazhuicon2 setImage:[UIImage imageNamed:@"yazhuICO"]];
    [yazhuBG2 addSubview:yazhuicon2];
    [yazhuicon2 release];
    
    self.allchoumaL2 = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 39, 29)];
    self.allchoumaL2.backgroundColor = [UIColor clearColor];
    self.allchoumaL2.textAlignment = NSTextAlignmentCenter;
    [self.allchoumaL2 setText:@"0"];
    [self.allchoumaL2 setFont:[UIFont systemFontOfSize:12]];
    [yazhuBG2 addSubview:self.allchoumaL2];
    [self.allchoumaL2 release];
    
    self.choumaImageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(44+135.5+51, 290, 45.5, 44.5)];
    [_choumaImageV2 setImage:[UIImage imageNamed:@"chouma_2"]];
    [self.m_scrollView addSubview:_choumaImageV2];
    [_choumaImageV2 release];
    self.choumaImageV2.hidden = YES;
    self.choumaL2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45.5, 44.5)];
    self.choumaL2.backgroundColor = [UIColor clearColor];
    self.choumaL2.textAlignment = NSTextAlignmentCenter;
    self.choumaL2.adjustsFontSizeToFitWidth = YES;
    [self.choumaImageV2 addSubview:self.choumaL2];
    //    [self.choumaL2 setTextColor:[UIColor whiteColor]];
    [self.choumaL2 release];
    
    UILabel * tL = [[UILabel alloc] initWithFrame:CGRectMake(0, 390, 80, 20)];
    [tL setBackgroundColor:[UIColor clearColor]];
    [tL setText:@"押彩豆:"];
    [tL setTextColor:[UIColor grayColor]];
    [tL setFont:[UIFont systemFontOfSize:17]];
    [tL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:tL];
    [tL release];
    
    UIButton * minusCaidouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusCaidouBtn setFrame:CGRectMake(75, 380, 41, 41)];
    [minusCaidouBtn setBackgroundImage:[UIImage imageNamed:@"minuscaidou"] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:minusCaidouBtn];
    [minusCaidouBtn addTarget:self action:@selector(minusCaidouBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * inputBGV = [[UIView alloc] initWithFrame:CGRectMake(120, 380, 139, 41)];
    [inputBGV setBackgroundColor:[UIColor whiteColor]];
    [self.m_scrollView addSubview:inputBGV];
    [inputBGV release];
    
    self.inputTF = [[UITextField alloc] initWithFrame:CGRectMake(125, 385, 110, 30)];
    self.inputTF.delegate = self;
    [_inputTF setBorderStyle:UITextBorderStyleNone];
    [_inputTF setTextAlignment:NSTextAlignmentCenter];
    [_inputTF setText:@"50"];
    _inputTF.keyboardType = UIKeyboardTypeNumberPad;
    _inputTF.returnKeyType = UIReturnKeyDone;
    [self.m_scrollView addSubview:_inputTF];
    [_inputTF release];
    
    UIButton * addCaidouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addCaidouBtn setFrame:CGRectMake(265, 380, 41, 41)];
    [addCaidouBtn setBackgroundImage:[UIImage imageNamed:@"addcaidou"] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:addCaidouBtn];
    [addCaidouBtn addTarget:self action:@selector(addCaidouBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setFrame:CGRectMake(10, 440, 300, 34)];
    [_sureBtn setBackgroundImage:[UIImage imageNamed:@"tanchuangbtn_normal"] forState:UIControlStateNormal];
    [_sureBtn setTitle:@"押注" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(sureBtnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * shakeIV = [[UIImageView alloc] initWithFrame:CGRectMake(220, 60, 18, 18)];
    [shakeIV setImage:[UIImage imageNamed:@"shakeshake"]];
    [self.m_scrollView addSubview:shakeIV];
    [shakeIV release];
    
    UILabel * hgj = [[UILabel alloc] initWithFrame:CGRectMake(240, 59, 80, 20)];
    [hgj setBackgroundColor:[UIColor clearColor]];
    [hgj setText:@"摇一摇机选"];
    [hgj setTextColor:[UIColor blackColor]];
    [hgj setFont:[UIFont systemFontOfSize:12]];
    [hgj setTextAlignment:NSTextAlignmentLeft];
    [self.m_scrollView addSubview:hgj];
    [hgj release];
    
    
    self.diceImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 105)];
    _diceImgV.center = StartingPoint;
    _diceImgV.image = [UIImage imageNamed:@"ting1"];
    _diceImgV.animationImages = @[[UIImage imageNamed:@"ting1"],[UIImage imageNamed:@"ting2"],[UIImage imageNamed:@"ting3"],[UIImage imageNamed:@"ting4"],[UIImage imageNamed:@"ting6"],[UIImage imageNamed:@"ting6"]];
    _diceImgV.animationDuration = 0.3;
    [self.m_scrollView addSubview:_diceImgV];
    [_diceImgV release];
    
    self.xiuxiView = [[UIView alloc] initWithFrame:CGRectMake(0, 260, 320, self.view.frame.size.height-260)];
    [_xiuxiView setBackgroundColor:[UIColor whiteColor]];
    [self.m_scrollView addSubview:_xiuxiView];
    [_xiuxiView release];
    self.xiuxiView.hidden = YES;
    
    self.uu = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 60)];
    [_uu setBackgroundColor:[UIColor clearColor]];
    [_uu setTextColor:[UIColor orangeColor]];
    [_uu setTextAlignment:NSTextAlignmentCenter];
    [_uu setNumberOfLines:0];
    [_uu setLineBreakMode:NSLineBreakByCharWrapping];
    [_xiuxiView addSubview:_uu];
    [_uu setText:@"客官，现在是休息时间，请您过段时间再来吧"];
    [_uu release];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentOK:) name:@"WXRGetIssueCurrOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getcurlotDetailOK:) name:@"WXRGetcurlotDetailOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betPeaOK:) name:@"WXRBetPeaOK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betFailed:) name:@"WXRBetPeaFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freshTimer:) name:@"freshShaiZiTimer" object:nil];

    
//        if( [checkLastResultTimer isValid])
//        {
//            [checkLastResultTimer invalidate];
//        }
 

//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showRemainTime) userInfo:nil repeats:YES];
//        if( [self.remainingTimer isValid])
//        {
//            [self.remainingTimer invalidate];
//        }

//    self.remainingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showRemainTime) userInfo:nil repeats:YES];
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
    
    
    [RuYiCaiNetworkManager sharedManager].shouldRefreshShaiZiTimer = YES;
    
    
}

-(void)freshTimer:(NSNotification *)noti
{
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
}
-(void)choumaDonghua
{


}
-(void)betPeaOK:(NSNotification *)noti
{
    xiaoZhu = [self.choumaL1.text intValue]+xiaoZhu;
    daZhu = [self.choumaL2.text intValue]+daZhu;
    
    [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    selectedResult = 0;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",xiaoZhu] forKey:@"shaizicurrentxiao"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",daZhu] forKey:@"shaizicurrentda"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    bdkHUD = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Checkmark.png"] text:@"投注成功!"];
//    
//    bdkHUD.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIApplication sharedApplication].keyWindow.center.y - 20);
//    [[UIApplication sharedApplication].keyWindow addSubview:bdkHUD];
    self.view.userInteractionEnabled = NO;
    __block UIViewController * sV = self;
//    [bdkHUD presentWithDuration:0.8f speed:0.3f inView:nil completion:^{
//        [bdkHUD removeFromSuperview];
////        [bdkHUD release];
//        
//    }];
    [self.view.window showHUDWithText:@"投注成功" Type:ShowPhotoYes Enabled:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [_choumaImageV1 setFrame:CGRectMake(95+30, 290+30, 0, 0)];
        [_choumaImageV2 setFrame:CGRectMake(44+135.5+51+30, 290+30, 0, 0)];
        //            [self.choumaL1 setFrame:CGRectMake(95+30, 290+30, 0, 0)];
        //            [self.choumaL2 setFrame:CGRectMake(44+135.5+51+30, 290+30, 0, 0)];
    } completion:^(BOOL finished) {
        [_choumaImageV1 setFrame:CGRectMake(95, 290, 45.5, 44.5)];
        [_choumaImageV2 setFrame:CGRectMake(44+135.5+51, 290, 45.5, 44.5)];
        [_choumaL2 setFrame:CGRectMake(0, 0, 45.5, 44.5)];
        [_choumaL1 setFrame:CGRectMake(0, 0, 45.5, 44.5)];
        _choumaImageV1.hidden = YES;
        _choumaImageV2.hidden = YES;
        _allchoumaL1.text = [NSString stringWithFormat:@"%d",xiaoZhu];
        _allchoumaL2.text = [NSString stringWithFormat:@"%d",daZhu];
        [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
        sV.view.userInteractionEnabled = YES;
        _sureBtn.enabled = YES;
    }];


}

-(void)betFailed:(NSNotification *)noti
{
    [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    selectedResult = 0;
    self.choumaImageV1.hidden = YES;
    self.choumaImageV2.hidden = YES;
//    [self.view.window showHUDWithText:@"投注失败" Type:ShowPhotoNo Enabled:YES];
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
    self.sureBtn.enabled = YES;
}

-(void)getcurlotDetailOK:(NSNotification *)noti
{
    NSDictionary * sd = (NSDictionary *)noti.object;
    self.leftrenshuL.text = [[[sd objectForKey:@"result"] objectAtIndex:0] objectForKey:@"cnt"];
    self.leftcaidouL.text = [[[sd objectForKey:@"result"] objectAtIndex:0] objectForKey:@"amt"];
    self.rightrenshuL.text = [[[sd objectForKey:@"result"] objectAtIndex:1] objectForKey:@"cnt"];
    self.rightcaidouL.text = [[[sd objectForKey:@"result"] objectAtIndex:1] objectForKey:@"amt"];
}
-(void)showRemainTime:(NSTimer *)theTimer
{
    if (![theTimer isEqual:self.remainingTimer]) {
        [theTimer invalidate];
        theTimer = nil;
        return;
    }
    int leftTime = [self.currentRemainingTime intValue]-1;
    self.currentRemainingTime = [NSString stringWithFormat:@"%d",leftTime];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / 60);
		leftTime -= numMinute * 60;
		int numSecond = (int)(leftTime);
        NSString * timeStr = [NSString stringWithFormat:@"%d:%d",
                              numMinute, numSecond];
        NSLog(@"left :%@",timeStr);
        self.currentRemainingTLabel.text = timeStr;
    }
    else
    {
        self.currentRemainingTLabel.text = @"请稍等";
        self.lastResultImageV.hidden = YES;
        self.lastStatusLabel.hidden = NO;
        [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
    }

}
-(void)getCurrentOK:(NSNotification *)noti
{
    NSDictionary * sd = (NSDictionary *)noti.object;
    id currD = [sd objectForKey:@"currIssue"];
    NSDictionary * preD = [sd objectForKey:@"prevIssue"];
    if (![currD isKindOfClass:[NSDictionary class]]) {
        if (!currD||!preD||[[sd objectForKey:@"currIssue"] isEqualToString:@""]) {
//            if (checkLastResultTimer != nil) {
//                if( [checkLastResultTimer isValid])
//                {
//                    [checkLastResultTimer invalidate];
//                }
//                checkLastResultTimer = nil;
//            }
//            if (self.remainingTimer != nil) {
//                if( [self.remainingTimer isValid])
//                {
//                    [self.remainingTimer invalidate];
//                }
//                self.remainingTimer = nil;
//            }
            self.currentRoundNameLabel.text = @"没有当前期";
            self.currentRemainingTLabel.text = @"休息中";
            self.lastStatusLabel.text = @"休息中";
            self.lastResultImageV.hidden = YES;
            self.xiuxiView.hidden = NO;
            
            NSString * bTime = [[sd objectForKey:@"game"] objectForKey:@"beginTime"];
//            NSDate * bD = [NSDate dateWithTimeIntervalSinceNow:[bTime doubleValue]/1000];
            NSString * eTime = [[sd objectForKey:@"game"] objectForKey:@"endTime"];
//            NSDate * eD = [NSDate dateWithTimeIntervalSinceNow:[eTime doubleValue]/1000];
//            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
//            [formatter setDateFormat:@"HH:mm"];
//            NSString* dateS1 = [formatter stringFromDate:bD];
//            NSString* dateS2 = [formatter stringFromDate:eD];
//            [formatter release];
            
            [self.uu setText:[NSString stringWithFormat:@"客官，现在是休息时间，今天的投注时间是%@到%@",bTime,eTime]];
            return;
        }

    }
    
    self.xiuxiView.hidden = YES;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"shaizicurrentda"]) {
        daZhu = 0;
    }
    else
        daZhu = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shaizicurrentda"] intValue];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"shaizicurrentxiao"]) {
        xiaoZhu = 0;
    }
    else
        xiaoZhu = [[[NSUserDefaults standardUserDefaults] objectForKey:@"shaizicurrentxiao"] intValue];
    
    NSString * tempCurrent = [[NSUserDefaults standardUserDefaults] objectForKey:@"shaizicurrentlotnum"];
    if (!tempCurrent) {
        tempCurrent = @"11";
    }
    if (![tempCurrent isEqualToString:[[sd objectForKey:@"currIssue"] objectForKey:@"issueNo"]]) {
        xiaoZhu = 0;
        daZhu = 0;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",xiaoZhu] forKey:@"shaizicurrentxiao"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",daZhu] forKey:@"shaizicurrentda"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    self.allchoumaL1.text = [NSString stringWithFormat:@"%d",xiaoZhu];
    self.allchoumaL2.text = [NSString stringWithFormat:@"%d",daZhu];
    
    currentLotNum = [[[sd objectForKey:@"currIssue"] objectForKey:@"issueNo"] retain];
    [[NSUserDefaults standardUserDefaults] setObject:currentLotNum forKey:@"shaizicurrentlotnum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[RuYiCaiNetworkManager sharedManager] queryCurrentLotDetailWithgameNo:nil AndissueNo:currentLotNum];
    self.currentRoundNameLabel.text = [NSString stringWithFormat:@"%@期",currentLotNum];
    double a = [[[sd objectForKey:@"currIssue"] objectForKey:@"endBetTime"] doubleValue]/1000-[[sd objectForKey:@"systemTime"] doubleValue]/1000;
    self.currentRemainingTime = [NSString stringWithFormat:@"%.0f",a];
    double nowT = [[sd objectForKey:@"systemTime"] doubleValue]/1000;
//    currentRemainingTime = 
//    timeStr = @"0分0秒";
	int leftTime = [self.currentRemainingTime intValue];
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / 60);
		leftTime -= numMinute * 60;
		int numSecond = (int)(leftTime);
        NSString * timeStr = [NSString stringWithFormat:@"%d:%d",
                   numMinute, numSecond];
        NSLog(@"left :%@",timeStr);
        self.currentRemainingTLabel.text = timeStr;
    }
    
    id preDs = [sd objectForKey:@"prevIssue"];
    if ([preDs isKindOfClass:[NSDictionary class]]) {
        double kj = [[[sd objectForKey:@"prevIssue"] objectForKey:@"endAwardTime"] doubleValue]/1000-nowT;
        if (kj>0) {
            lastResultGeted = NO;
        }
        if ([[[sd objectForKey:@"prevIssue"] objectForKey:@"awardState"] intValue] == 3&&kj<=0&&!lastResultGeted) {
            
            self.lastStatusLabel.hidden = YES;
            NSString * sdf = [NSString stringWithFormat:@"%@",[[sd objectForKey:@"prevIssue"] objectForKey:@"winCodeDetail"]];
            //        [self.lastResultImageV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"little%@",sdf]]];
            [self littleShaiziArray:[sdf intValue]];
            self.lastResultImageV.hidden = NO;
            lastResultGeted = YES;
            
        }
        else if(!lastResultGeted){
            self.lastStatusLabel.hidden = NO;
            self.lastStatusLabel.text = @"等待开奖";
            self.lastResultImageV.hidden = YES;
        }
        

        if (kj>0) {
            NSLog(@"time remianing to kaijiang:%f",kj);
            
            self.checkLastResultTimer = [NSTimer scheduledTimerWithTimeInterval:kj target:self selector:@selector(checkLastResult) userInfo:nil repeats:NO];
        }

    }
    else
    {
        self.lastStatusLabel.hidden = NO;
        self.lastStatusLabel.text = @"暂无上期";
        self.lastResultImageV.hidden = YES;
    }
    if (self.remainingTimer != nil) {
        if( [self.remainingTimer isValid])
        {
            [self.remainingTimer invalidate];
        }
        self.remainingTimer = nil;
    }
        self.remainingTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showRemainTime:) userInfo:nil repeats:YES];
    [self showRemainTime:self.remainingTimer];
    
    
    NSLog(@"current No:%@",currentLotNum);
    
}
-(void)checkLastResult
{
//    [checkLastResultTimer invalidate];
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
}
-(void)sureBtnBtnClicked:(UIButton *)sender
{
    if (selectedResult==0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，还没选择押大还是押小呢，快去选一个吧，可以手动点大还是小，也可以摇一摇机选哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if ([self.inputTF.text intValue]>1000) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，理性投注，最大只能押1000彩豆哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if ([self.inputTF.text intValue]<50) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，别太吝啬呀，最少要投50个彩豆呢" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [self.inputTF resignFirstResponder];
    self.sureBtn.enabled = NO;
    __block UIViewController * sv = self;
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
        else
        {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
        
    }];
    NSLog(@"sure clicked");
    NSString * stringUrl3 = [[NSBundle mainBundle] pathForResource:@"chouma" ofType:@"wav"];
    NSURL * url3 = [NSURL fileURLWithPath:stringUrl3];
    AVAudioPlayer* getcoinAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
    [getcoinAudio prepareToPlay];
    [getcoinAudio play];
    
    
    if (selectedResult==2) {
        self.choumaImageV2.center = sender.center;
        self.choumaImageV2.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [_choumaImageV2 setFrame:CGRectMake(44+135.5+51, 290, 45.5, 44.5)];
        } completion:^(BOOL finished) {
            [[RuYiCaiNetworkManager sharedManager] betWithIssueNo:currentLotNum beanNoWithBig:_inputTF.text beanNoWithSmall:@"0"];
            [m_delegate.activityView activityViewShow];
            [m_delegate.activityView.titleLabel setText:@"投注中..."];
        }];
    }
    else
    {
        self.choumaImageV1.center = sender.center;
        self.choumaImageV1.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [_choumaImageV1 setFrame:CGRectMake(95, 290, 45.5, 44.5)];
        } completion:^(BOOL finished) {
            [[RuYiCaiNetworkManager sharedManager] betWithIssueNo:currentLotNum beanNoWithBig:@"0" beanNoWithSmall:_inputTF.text];
            [m_delegate.activityView activityViewShow];
            [m_delegate.activityView.titleLabel setText:@"投注中..."];
        }];
    }
    

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
 
//    self.m_scrollView.delegate = self;

}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    __block UIViewController * sv = self;
    if ([self.inputTF isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            if ([UIScreen mainScreen].bounds.size.height<500) {
                [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
            }
            else
            {
                [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    [self.inputTF resignFirstResponder];
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
    [self.inputTF resignFirstResponder];
    __block UIViewController * sv = self;
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
        else
        {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
//        self.m_scrollView.delegate = self;
    }];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    __block UIViewController * sv = self;
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [_m_scrollView setFrame:CGRectMake(0, -235, 320, sv.view.frame.size.height)];
        }
        else
        {
            [_m_scrollView setFrame:CGRectMake(0, -150, 320, sv.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
//        self.m_scrollView.delegate = self;
    }];

    return YES;
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if ([[self.inputTF.text stringByAppendingString:string] intValue]>=1001) {
//        return NO;
////        self.inputTF.text = [self.inputTF.text substringToIndex:3];
//        
//    }
//    return YES;
//}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    selectedResult == 1?(self.choumaL1.text = self.inputTF.text):(self.choumaL2.text = self.inputTF.text);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTF resignFirstResponder];
    selectedResult == 1?(self.choumaL1.text = self.inputTF.text):(self.choumaL2.text = self.inputTF.text);
    __block UIViewController * sv = self;
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
        else
        {
            [_m_scrollView setFrame:CGRectMake(0, 0, 320, sv.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
//        self.m_scrollView.delegate = self;
    }];
    return YES;
}
-(void)minusCaidouBtnClicked:(UIButton *)sender
{
    if ([self.inputTF.text intValue]>=50) {
        self.inputTF.text = [NSString stringWithFormat:@"%d",[self.inputTF.text intValue]-50];
        selectedResult == 1?(self.choumaL1.text = self.inputTF.text):(self.choumaL2.text = self.inputTF.text);
    }

    
}
-(void)addCaidouBtnClicked:(UIButton *)sender
{
    if ([self.inputTF.text intValue]<1000) {
        self.inputTF.text = [NSString stringWithFormat:@"%d",[self.inputTF.text intValue]+50];
        selectedResult == 1?(self.choumaL1.text = self.inputTF.text):(self.choumaL2.text = self.inputTF.text);

    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，理性投注，最大只能压1000彩豆哦" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    
}
-(void)leftSelectBtnClicked:(UIButton *)sender
{
//    if (sender.tag==1) {
    [sender setBackgroundImage:[UIImage imageNamed:@"left_selected"] forState:UIControlStateNormal];
    [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    sender.tag=2;
    NSLog(@"left selected");
    selectedResult = 1;
//    self.choumaImageV1.hidden = NO;
//    self.choumaImageV2.hidden = YES;
    self.choumaL1.text = self.inputTF.text;
    self.choumaL2.text = @"0";
//    NSString * stringUrl3 = [[NSBundle mainBundle] pathForResource:@"chouma" ofType:@"wav"];
//    NSURL * url3 = [NSURL fileURLWithPath:stringUrl3];
//    AVAudioPlayer* getcoinAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
//    [getcoinAudio prepareToPlay];
//    [getcoinAudio play];
//    }
//    else
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
//        [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right_selected"] forState:UIControlStateNormal];
//        sender.tag=2;
//    }
    
}
-(void)rightSelectBtnClicked:(UIButton *)sender
{
//    if (sender.tag==1) {
    [sender setBackgroundImage:[UIImage imageNamed:@"right_selected"] forState:UIControlStateNormal];
    [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
    sender.tag=2;
    NSLog(@"right selected");
    selectedResult = 2;
//    self.choumaImageV1.hidden = YES;
//    self.choumaImageV2.hidden = NO;
    self.choumaL2.text = self.inputTF.text;
    self.choumaL1.text = @"0";

//    }
//    else
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
//        [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left_selected"] forState:UIControlStateNormal];
//        sender.tag=2;
//    }
}
-(void)historyBtnClicked:(UIButton *)sender
{
    IssueHistoryViewController * isV = [[IssueHistoryViewController alloc] init];
    [self.navigationController pushViewController:isV animated:YES];
    [isV release];
    
}
-(void)recordBtnClicked:(UIButton *)sender
{
    IssueHistoryViewController * isV = [[IssueHistoryViewController alloc] init];
    isV.type = QueryTypeGameOrder;
    [self.navigationController pushViewController:isV animated:YES];
    [isV release];
}
-(void)ruleBtnClicked:(UIButton *)sender
{
    ADIntroduceViewController * inv = [[ADIntroduceViewController alloc] init];
    inv.theTextType = TextTypeShaiZiRule;
    [self.navigationController pushViewController:inv animated:YES];
    [inv release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenTabView" object:nil];
}
- (void)diceStarAnimation
{
    [_diceImgV startAnimating];
    
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 16.0]];
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    spin.duration = CAduration + 1;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setValues:[self randomKeyPointArray]];
    animation.duration = CAduration;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects: animation, spin,nil];
    animGroup.duration = CAduration+1;
    animGroup.delegate = self;
    [[_diceImgV layer] addAnimation:animGroup forKey:nil];
    
}
-(void)littleShaiziArray:(int)result
{
    NSMutableArray * gg = [NSMutableArray array];
    NSLog(@"hhhhhhhh1:%d",result);
    [self.lastResultImageV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"little%d",result]]];
//    NSString *imgPath=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"little%d",result] ofType:@"png"];
//    UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
//    [gg addObject:img];
    for (int i = 0; i<12; i++) {
        int k = arc4random()%6+1;
        NSString *imgPath=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"little%d",k] ofType:@"png"];
        UIImage *img=[UIImage imageWithContentsOfFile:imgPath];
        [gg addObject:img];
        NSLog(@"hhhhhhhh:%d",k);
    }

    self.lastResultImageV.animationImages=gg;
    self.lastResultImageV.animationDuration=2;
    self.lastResultImageV.animationRepeatCount=1;
    [self.lastResultImageV startAnimating];
}
- (NSArray*)randomKeyPointArray
{
    float high = self.view.frame.size.height-52.5;
    switch (arc4random()%5) {
        case 0:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(50.0, 370);
            CGPoint p3 = CGPointMake(160.0, high);
            CGPoint p4 = CGPointMake(270.0, 370);
            CGPoint p5 = CGPointMake(140.0, 52.5);
            CGPoint p6 = CGPointMake(50.0, 140.0);
            CGPoint p7 = CGPointMake(200.0, high);
            CGPoint p8 = CGPointMake(270.0, high-100);
            CGPoint p9 = CGPointMake(50.0, 200.0);
            CGPoint p10 = CGPointMake(160.0, 52.5);
            CGPoint p11 = CGPointMake(270.0, 100.0);
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p10],[NSValue valueWithCGPoint:p11],[NSValue valueWithCGPoint:p1]];
        }break;
        case 1:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(270.0, 52.5);
            CGPoint p3 = CGPointMake(50.0, high/2);
            CGPoint p4 = CGPointMake(270.0, high);
            CGPoint p5 = CGPointMake(50.0, high-100);
            CGPoint p6 =  CGPointMake(270.0, 350);
            CGPoint p7 = CGPointMake(200.0, 52.5);
            CGPoint p8 = CGPointMake(50.0, high);
            CGPoint p9 = CGPointMake(270.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        case 2:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(270.0, 200);
            CGPoint p3 = CGPointMake(200.0, high);
            CGPoint p4 = CGPointMake(50.0, high-100);
            CGPoint p5 = CGPointMake(270.0, high/2);
            CGPoint p6 =  CGPointMake(50.0, 200);
            CGPoint p7 = CGPointMake(270.0, high-200);
            CGPoint p8 = CGPointMake(200.0, high);
            CGPoint p9 = CGPointMake(50.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        case 3:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(100.0, 52.5);
            CGPoint p3 = CGPointMake(270.0, high);
            CGPoint p4 = CGPointMake(50.0, high-100);
            CGPoint p5 = CGPointMake(270.0, high/2);
            CGPoint p6 =  CGPointMake(50.0, 200);
            CGPoint p7 = CGPointMake(270.0, high-200);
            CGPoint p8 = CGPointMake(200.0, high);
            CGPoint p9 = CGPointMake(50.0, high/2);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
        default:{
            CGPoint p1 = StartingPoint;
            CGPoint p2 = CGPointMake(100.0, high);
            CGPoint p3 = CGPointMake(270.0, 370);
            CGPoint p4 = CGPointMake(50.0, high/2);
            CGPoint p5 = CGPointMake(200.0, 52.5);
            CGPoint p6 =  CGPointMake(270.0, high-100);
            CGPoint p7 = CGPointMake(50.0, high);
            CGPoint p8 = CGPointMake(270.0, 370);
            CGPoint p9 = CGPointMake(50.0, 200);
            
            return  @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2],[NSValue valueWithCGPoint:p3],[NSValue valueWithCGPoint:p4], [NSValue valueWithCGPoint:p5],[NSValue valueWithCGPoint:p6],[NSValue valueWithCGPoint:p7],[NSValue valueWithCGPoint:p8],[NSValue valueWithCGPoint:p9],[NSValue valueWithCGPoint:p1]];
        }break;
    }
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ([_diceImgV isAnimating]) {
        return;
    }
    if (self.xiuxiView.hidden == NO) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"现在还是休息时间哦，稍后再来吧" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
     [self diceStarAnimation];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_diceImgV stopAnimating];
    [self.choumaImageV1 stopAnimating];
    [self.choumaImageV2 stopAnimating];
    int d = arc4random()%6+1;
    NSLog(@"%d",d);
    _diceImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"ting%d",d]];
    
    [self performSelector:@selector(shaiZiMakeLittle:) withObject:[NSNumber numberWithInt:d] afterDelay:0.7];
    
}
-(void)shaiZiMakeLittle:(NSNumber *)num
{
    int s = [num intValue];
    if (s==1||s==2||s==3) {
        [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left_selected"] forState:UIControlStateNormal];
        [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        self.leftSelectBtn.tag=2;
        NSLog(@"left selected");
        selectedResult = 1;
//        self.choumaImageV1.hidden = NO;
//        self.choumaImageV2.hidden = YES;
        self.choumaL1.text = self.inputTF.text;
        self.choumaL2.text = @"0";
    }
    else
    {
        [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right_selected"] forState:UIControlStateNormal];
        [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        self.rightSelectBtn.tag=2;
        NSLog(@"right selected");
        selectedResult = 2;
//        self.choumaImageV1.hidden = YES;
//        self.choumaImageV2.hidden = NO;
        self.choumaL2.text = self.inputTF.text;
        self.choumaL1.text = @"0";
    }
//    NSString * stringUrl3 = [[NSBundle mainBundle] pathForResource:@"chouma" ofType:@"wav"];
//    NSURL * url3 = [NSURL fileURLWithPath:stringUrl3];
//    AVAudioPlayer* getcoinAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:url3 error:nil];
//    [getcoinAudio prepareToPlay];
//    [getcoinAudio play];

    __block UIViewController *sv = self;

    [UIView animateWithDuration:0.4 animations:^{
        switch (s) {
            case 1:
            {
                [_diceImgV setFrame:CGRectMake(69, 270, 25, 25)];
            }
                break;
            case 2:
            {
                [_diceImgV setFrame:CGRectMake(104, 270, 25, 25)];
            }
                break;
            case 3:
            {
                [_diceImgV setFrame:CGRectMake(139, 270, 25, 25)];
            }
                break;
            case 4:
            {
                [_diceImgV setFrame:CGRectMake(205, 270, 25, 25)];
            }
                break;
            case 5:
            {
                [_diceImgV setFrame:CGRectMake(240, 270, 25, 25)];
            }
                break;
            case 6:
            {
                [_diceImgV setFrame:CGRectMake(275, 270, 25, 25)];
            }
                break;
            default:
                break;
    
            
        }
        
//        [self.choumaImageV1.layer addAnimation:animation forKey:nil];
  
        
    } completion:^(BOOL finished) {
//        [self choumaDonghua];
        _diceImgV.hidden = YES;
        [sv performSelector:@selector(resetShaiZi) withObject:nil afterDelay:1];
    }];
}
-(void)resetShaiZi
{
    _diceImgV.hidden = NO;
    [_diceImgV setFrame:CGRectMake(139, 270, 100, 105)];
    _diceImgV.center = StartingPoint;
}
- (void)back:(id)sender
{
    if (self.remainingTimer != nil) {
        if( [self.remainingTimer isValid])
        {
            [self.remainingTimer invalidate];
        }
        self.remainingTimer = nil;
    }
//    if (checkLastResultTimer != nil) {
//        if( [checkLastResultTimer isValid])
//        {
//            [checkLastResultTimer invalidate];
//        }
//        checkLastResultTimer = nil;
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
