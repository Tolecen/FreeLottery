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
#define CAduration 3
#define StartingPoint CGPointMake(160.0, 130.0)
@interface DiceViewController ()
@property (nonatomic,retain)UIImageView * diceImgV;
@end

@implementation DiceViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [renshu setText:@"人数"];
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
    
    self.leftrenshuL = [[UILabel alloc] initWithFrame:CGRectMake(49, 310, 135.3, 20)];
    [_leftrenshuL setBackgroundColor:[UIColor clearColor]];
    [_leftrenshuL setText:@"345622"];
    [_leftrenshuL setTextColor:[UIColor whiteColor]];
    [_leftrenshuL setFont:[UIFont systemFontOfSize:15]];
    [_leftrenshuL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_leftrenshuL];
    [_leftrenshuL release];
    
    self.leftcaidouL = [[UILabel alloc] initWithFrame:CGRectMake(49, 335, 135.3, 20)];
    [_leftcaidouL setBackgroundColor:[UIColor clearColor]];
    [_leftcaidouL setText:@"3322345622"];
    [_leftcaidouL setTextColor:[UIColor whiteColor]];
    [_leftcaidouL setFont:[UIFont systemFontOfSize:15]];
    [_leftcaidouL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_leftcaidouL];
    [_leftcaidouL release];
    
    self.rightrenshuL = [[UILabel alloc] initWithFrame:CGRectMake(49+135.5, 310, 135.3, 20)];
    [_rightrenshuL setBackgroundColor:[UIColor clearColor]];
    [_rightrenshuL setText:@"23622"];
    [_rightrenshuL setTextColor:[UIColor whiteColor]];
    [_rightrenshuL setFont:[UIFont systemFontOfSize:15]];
    [_rightrenshuL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_rightrenshuL];
    [_rightrenshuL release];
    
    self.rightcaidouL = [[UILabel alloc] initWithFrame:CGRectMake(49+135.5, 335, 135.3, 20)];
    [_rightcaidouL setBackgroundColor:[UIColor clearColor]];
    [_rightcaidouL setText:@"7655622"];
    [_rightcaidouL setTextColor:[UIColor whiteColor]];
    [_rightcaidouL setFont:[UIFont systemFontOfSize:15]];
    [_rightcaidouL setTextAlignment:NSTextAlignmentCenter];
    [self.m_scrollView addSubview:_rightcaidouL];
    [_rightcaidouL release];
    
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
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setFrame:CGRectMake(10, 440, 300, 34)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"tanchuangbtn_normal"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"押注" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.m_scrollView addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCurrentOK:) name:@"WXRGetIssueCurrOK" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager] queryCurrIssueMessage];
    
}
-(void)getCurrentOK:(NSNotification *)noti
{
    NSDictionary * sd = (NSDictionary *)noti.object;
    currentLotNum = [[[sd objectForKey:@"currIssue"] objectForKey:@"issueNo"] retain];
    self.currentRoundNameLabel.text = [NSString stringWithFormat:@"%@期",currentLotNum];
    NSLog(@"current No:%@",currentLotNum);
    
}
-(void)sureBtnBtnClicked:(UIButton *)sender
{
    NSLog(@"sure clicked");
    if (selectedResult==1) {
        [[RuYiCaiNetworkManager sharedManager] betWithIssueNo:currentLotNum beanNoWithBig:self.inputTF.text beanNoWithSmall:@"0"];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] betWithIssueNo:currentLotNum beanNoWithBig:@"0" beanNoWithSmall:self.inputTF.text];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([self.inputTF isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            if ([UIScreen mainScreen].bounds.size.height<500) {
                [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            }
            else
            {
                [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
            }
        } completion:^(BOOL finished) {
            
        }];
    }
    [self.inputTF resignFirstResponder];
//    self.m_scrollView.delegate = self;

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
        else
        {
            [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
//        self.m_scrollView.delegate = self;
    }];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [self.m_scrollView setFrame:CGRectMake(0, -235, 320, self.view.frame.size.height)];
        }
        else
        {
            [self.m_scrollView setFrame:CGRectMake(0, -150, 320, self.view.frame.size.height)];
        }
    } completion:^(BOOL finished) {
//        self.m_scrollView.delegate = self;
    }];

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        if ([UIScreen mainScreen].bounds.size.height<500) {
            [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
        else
        {
            [self.m_scrollView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
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
    }

    
}
-(void)addCaidouBtnClicked:(UIButton *)sender
{
    self.inputTF.text = [NSString stringWithFormat:@"%d",[self.inputTF.text intValue]+50];
}
-(void)leftSelectBtnClicked:(UIButton *)sender
{
//    if (sender.tag==1) {
    [sender setBackgroundImage:[UIImage imageNamed:@"left_selected"] forState:UIControlStateNormal];
    [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    sender.tag=2;
    NSLog(@"left selected");
    selectedResult = 1;
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
    
}
-(void)recordBtnClicked:(UIButton *)sender
{
    
}
-(void)ruleBtnClicked:(UIButton *)sender
{
    
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
     [self diceStarAnimation];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [_diceImgV stopAnimating];
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
    }
    else
    {
        [self.rightSelectBtn setBackgroundImage:[UIImage imageNamed:@"right_selected"] forState:UIControlStateNormal];
        [self.leftSelectBtn setBackgroundImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        self.rightSelectBtn.tag=2;
        NSLog(@"right selected");
        selectedResult = 2;
    }
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
        
    } completion:^(BOOL finished) {
        _diceImgV.hidden = YES;
        [self performSelector:@selector(resetShaiZi) withObject:nil afterDelay:1];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
