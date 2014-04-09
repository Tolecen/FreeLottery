//
//  HMDTAutoOrderAmountSetcell.m
//  RuYiCai
//
//  Created by ruyicai on 12-11-14.
//
//

#import "HMDTAutoOrderAmountSetcell.h"
#import "RYCImageNamed.h"
#import "HMDTAutoOrderViewController.h"
#import "RuYiCaiNetworkManager.h"
@interface HMDTAutoOrderAmountSetcell (inter)
-(void) changeViewButtonClick:(id)sender;
-(void) hasMaxAmountButtonClick:(id)sender;
-(void) forceJoinButtonClick:(id)sender;
-(void) creatByAllAmountView;
-(void) creatByPercentView;
-(void) textFieldResponseOK:(NSNotification*)notification;
-(void) hideKeybord;
@end

@implementation HMDTAutoOrderAmountSetcell
@synthesize superViewController = m_superViewController;
- (void)dealloc
{
    [m_buttonByallAmount release];
    [m_buttonByPercent release];
    
    [m_viewByAllAmount release];
    [m_orderAmountByAllAmount release];
    [m_orderCountByAllAmount release];
    [m_freezeAmountLable release];
    
 
    [m_viewByByPercent release];
    [m_buttonHaveMaxByPercent release];
    [m_buttonNoMaxByByPercent release];
    [m_orderAmountByPercent release];
    [m_orderCountByPercent release];
 
    [m_lableHaveMaxByPercent release];
    [m_textHaveMaxByPercent release];
    [m_lableYuanHaveMaxByPercent release];
    
    [m_forceJoinButtonByAllAmount release];
    [m_forceJoinLableByAllAmount release];
    
    [m_forceJoinButtonByPercent release];
    [m_forceJoinLableByPercent release];
 
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
 
        m_isByAllAmount = YES;
        m_forceJoinByAllAmount = YES;
        m_forceJoinByPercent = YES;
        m_buttonByallAmount  = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 20, 20)];
        [m_buttonByallAmount setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        m_buttonByallAmount.tag = 100;
        [m_buttonByallAmount addTarget:self action:@selector(changeViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_buttonByallAmount setBackgroundColor:[UIColor clearColor]];
        [self addSubview:m_buttonByallAmount];
        
        UILabel* amountLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, 130, 20)];
        amountLable.textAlignment = UITextAlignmentLeft;
        amountLable.font = [UIFont systemFontOfSize:13.0f];
        amountLable.textColor = [UIColor blackColor];
        amountLable.text = @"按固定金额定制跟单";
        amountLable.backgroundColor = [UIColor clearColor];
        [self addSubview:amountLable];
        [amountLable release];
   
        
        m_buttonByPercent  = [[UIButton alloc] initWithFrame:CGRectMake(160, 15, 20, 20)];
        [m_buttonByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        m_buttonByPercent.tag = 101;
        [m_buttonByPercent addTarget:self action:@selector(changeViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_buttonByPercent setBackgroundColor:[UIColor clearColor]];
        [self addSubview:m_buttonByPercent];
        UILabel* percentLable = [[UILabel alloc] initWithFrame:CGRectMake(185, 15, 120, 20)];
        percentLable.textAlignment = UITextAlignmentLeft;
        percentLable.font = [UIFont systemFontOfSize:13.0f];
        percentLable.textColor = [UIColor blackColor];
        percentLable.text = @"按百分比定制跟单";
        percentLable.backgroundColor = [UIColor clearColor];
        [self addSubview:percentLable];
        [percentLable release];
        
        
        m_viewByAllAmount = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
        m_viewByAllAmount.backgroundColor = [UIColor clearColor];
        [self addSubview:m_viewByAllAmount];
        [self creatByAllAmountView];
 
        m_viewByByPercent = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
        m_viewByByPercent.backgroundColor = [UIColor clearColor];
        [self addSubview:m_viewByByPercent];
        [self creatByPercentView];
        m_viewByByPercent.hidden = YES;
    }
    return self;
}
-(void) creatByAllAmountView
{
    UILabel* amtLableByAllAmount = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 100, 20)];
    amtLableByAllAmount.text = @"每次认购金额：";
    amtLableByAllAmount.textColor = [UIColor blackColor];
    amtLableByAllAmount.backgroundColor = [UIColor clearColor];
    amtLableByAllAmount.font = [UIFont systemFontOfSize:14.0f];
    amtLableByAllAmount.textAlignment = UITextAlignmentLeft;
    [m_viewByAllAmount addSubview:amtLableByAllAmount];
    [amtLableByAllAmount release];
    
    m_orderAmountByAllAmount = [[UITextField alloc] initWithFrame:CGRectMake(130, 20, 110, 31)];
    m_orderAmountByAllAmount.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_orderAmountByAllAmount.borderStyle = UITextBorderStyleRoundedRect;
    m_orderAmountByAllAmount.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_orderAmountByAllAmount.textColor = [UIColor blackColor];
    m_orderAmountByAllAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_orderAmountByAllAmount.text = @"1";
    m_orderAmountByAllAmount.tag = 10000;
    m_orderAmountByAllAmount.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_orderAmountByAllAmount.returnKeyType = UIReturnKeyDone;
    [m_viewByAllAmount addSubview:m_orderAmountByAllAmount];
    
    UILabel* buyAmtRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 50, 21)];
    buyAmtRatioLabel.text = @"元";
    buyAmtRatioLabel.font = [UIFont systemFontOfSize:14];
    buyAmtRatioLabel.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:buyAmtRatioLabel];
    [buyAmtRatioLabel release];
    UILabel* minBuyAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 100, 21)];
    minBuyAmtLabel.text = @"至少认购1元";
    minBuyAmtLabel.font = [UIFont systemFontOfSize:14];
    minBuyAmtLabel.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:minBuyAmtLabel];
    [minBuyAmtLabel release];
    
    
    UILabel* buyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 100, 21)];
    buyCountLabel.textAlignment = UITextAlignmentLeft;
    buyCountLabel.text = @"定制次数：";
    buyCountLabel.font = [UIFont systemFontOfSize:14];
    buyCountLabel.textColor = [UIColor blackColor];
    buyCountLabel.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:buyCountLabel];
    [buyCountLabel release];
    

    m_orderCountByAllAmount = [[UITextField alloc] initWithFrame:CGRectMake(130, 80, 110, 31)];
    m_orderCountByAllAmount.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_orderCountByAllAmount.borderStyle = UITextBorderStyleRoundedRect;
    m_orderCountByAllAmount.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_orderCountByAllAmount.textColor = [UIColor blackColor];
    m_orderCountByAllAmount.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_orderCountByAllAmount.text = @"10";
    m_orderCountByAllAmount.tag = 10001;

    m_orderCountByAllAmount.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_orderCountByAllAmount.returnKeyType = UIReturnKeyDone;
    [m_viewByAllAmount addSubview:m_orderCountByAllAmount];
    UILabel* buyCountRadioLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 85, 50, 21)];
    buyCountRadioLabel.textAlignment = UITextAlignmentLeft;
    buyCountRadioLabel.text = @"次";
    buyCountRadioLabel.font = [UIFont systemFontOfSize:14];
    buyCountRadioLabel.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:buyCountRadioLabel];
    [buyCountRadioLabel release];
    
    UILabel* maXBuyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 120, 100, 21)];
    maXBuyCountLabel.text = @"最多99次";
    maXBuyCountLabel.font = [UIFont systemFontOfSize:14];
    maXBuyCountLabel.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:maXBuyCountLabel];
    [maXBuyCountLabel release];
    
    m_freezeMonney = 0;
    m_freezeAmountLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 200, 21)];
    m_freezeAmountLable.textAlignment = UITextAlignmentLeft;
    m_freezeAmountLable.text = @"需要冻结金额 0 元";
    m_freezeAmountLable.textColor = [UIColor blackColor];
    m_freezeAmountLable.font = [UIFont systemFontOfSize:14];
    m_freezeAmountLable.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:m_freezeAmountLable];
 
    
    m_forceJoinButtonByAllAmount  = [[UIButton alloc] initWithFrame:CGRectMake(20, 190, 20, 20)];
    [m_forceJoinButtonByAllAmount setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
    m_forceJoinButtonByAllAmount.tag = 300;
    [m_forceJoinButtonByAllAmount addTarget:self action:@selector(forceJoinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_forceJoinButtonByAllAmount setBackgroundColor:[UIColor clearColor]];
    [m_viewByAllAmount addSubview:m_forceJoinButtonByAllAmount];
    
    m_forceJoinLableByAllAmount = [[UILabel alloc] initWithFrame:CGRectMake(50, 175, 230, 50)];
    m_forceJoinLableByAllAmount.textAlignment = UITextAlignmentLeft;
    m_forceJoinLableByAllAmount.text = @"强制参与（选择了该项，如果设置的跟单金额大于可以跟单的金额，也会参与该合买）";
 
    m_forceJoinLableByAllAmount.lineBreakMode =UILineBreakModeCharacterWrap;
    m_forceJoinLableByAllAmount.numberOfLines = 2;
    m_forceJoinLableByAllAmount.textColor = [UIColor blackColor];
    m_forceJoinLableByAllAmount.font = [UIFont systemFontOfSize:12];
    m_forceJoinLableByAllAmount.backgroundColor = [UIColor clearColor];
    [m_viewByAllAmount addSubview:m_forceJoinLableByAllAmount];
    
}
-(void) creatByPercentView
{
    UILabel* amtLableByPercent = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 100, 20)];
    amtLableByPercent.text = @"每次认购金额：";
    amtLableByPercent.textColor = [UIColor blackColor];
    amtLableByPercent.backgroundColor = [UIColor clearColor];
    amtLableByPercent.font = [UIFont systemFontOfSize:14.0f];
    amtLableByPercent.textAlignment = UITextAlignmentLeft;
    [m_viewByByPercent addSubview:amtLableByPercent];
    [amtLableByPercent release];
  
    m_orderAmountByPercent = [[UITextField alloc] initWithFrame:CGRectMake(130, 20, 110, 31)];
    m_orderAmountByPercent.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_orderAmountByPercent.borderStyle = UITextBorderStyleRoundedRect;
    m_orderAmountByPercent.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_orderAmountByPercent.textColor = [UIColor blackColor];
    m_orderAmountByPercent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_orderAmountByPercent.text = @"1";
    m_orderAmountByPercent.tag = 10002;

    m_orderAmountByPercent.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_orderAmountByPercent.returnKeyType = UIReturnKeyDone;
    [m_viewByByPercent addSubview:m_orderAmountByPercent];
    
    UILabel* buyAmtRatioLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 25, 50, 21)];
    buyAmtRatioLabel.text = @"%";
    buyAmtRatioLabel.font = [UIFont systemFontOfSize:14];
    buyAmtRatioLabel.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:buyAmtRatioLabel];
    [buyAmtRatioLabel release];
    UILabel* minBuyAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, 100, 21)];
    minBuyAmtLabel.text = @"至少认购1%";
    minBuyAmtLabel.font = [UIFont systemFontOfSize:14];
    minBuyAmtLabel.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:minBuyAmtLabel];
    [minBuyAmtLabel release];
 
    m_hasMaxAmountByPercent = YES;
    m_buttonNoMaxByByPercent  = [[UIButton alloc] initWithFrame:CGRectMake(15, 80, 20, 20)];
    [m_buttonNoMaxByByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    m_buttonNoMaxByByPercent.tag = 200;
    [m_buttonNoMaxByByPercent addTarget:self action:@selector(hasMaxAmountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonNoMaxByByPercent setBackgroundColor:[UIColor clearColor]];
    [m_viewByByPercent addSubview:m_buttonNoMaxByByPercent];
    UILabel* amountLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 80, 130, 20)];
    amountLable.textAlignment = UITextAlignmentLeft;
    amountLable.font = [UIFont systemFontOfSize:13.0f];
    amountLable.textColor = [UIColor blackColor];
    amountLable.text = @"无金额上限";
    amountLable.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:amountLable];
    [amountLable release];
    
    m_buttonHaveMaxByPercent  = [[UIButton alloc] initWithFrame:CGRectMake(160, 80, 20, 20)];
    [m_buttonHaveMaxByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
    m_buttonHaveMaxByPercent.tag = 201;
    [m_buttonHaveMaxByPercent addTarget:self action:@selector(hasMaxAmountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_buttonHaveMaxByPercent setBackgroundColor:[UIColor clearColor]];
    [m_viewByByPercent addSubview:m_buttonHaveMaxByPercent];

    
    UILabel* percentLable = [[UILabel alloc] initWithFrame:CGRectMake(185, 80, 120, 20)];
    percentLable.textAlignment = UITextAlignmentLeft;
    percentLable.font = [UIFont systemFontOfSize:14.0f];
    percentLable.textColor = [UIColor blackColor];
    percentLable.text = @"超过金额上限";
    percentLable.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:percentLable];
    [percentLable release];
 
    //认购金额上限
    m_lableHaveMaxByPercent = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 120, 20)];
    m_lableHaveMaxByPercent.textAlignment = UITextAlignmentLeft;
    m_lableHaveMaxByPercent.font = [UIFont systemFontOfSize:14.0f];
    m_lableHaveMaxByPercent.textColor = [UIColor blackColor];
    m_lableHaveMaxByPercent.text = @"认购金额上限：";
    m_lableHaveMaxByPercent.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:m_lableHaveMaxByPercent];
 
    m_textHaveMaxByPercent = [[UITextField alloc] initWithFrame:CGRectMake(130, 105, 110, 31)];
    m_textHaveMaxByPercent.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_textHaveMaxByPercent.borderStyle = UITextBorderStyleRoundedRect;
    m_textHaveMaxByPercent.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_textHaveMaxByPercent.textColor = [UIColor blackColor];
    m_textHaveMaxByPercent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_textHaveMaxByPercent.text = @"50";
    m_textHaveMaxByPercent.tag = 10003;

    m_textHaveMaxByPercent.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_textHaveMaxByPercent.returnKeyType = UIReturnKeyDone;
    [m_viewByByPercent addSubview:m_textHaveMaxByPercent];
    
    m_lableYuanHaveMaxByPercent = [[UILabel alloc] initWithFrame:CGRectMake(250, 105, 50, 21)];
    m_lableYuanHaveMaxByPercent.text = @"元";
    m_lableYuanHaveMaxByPercent.font = [UIFont systemFontOfSize:14];
    m_lableYuanHaveMaxByPercent.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:m_lableYuanHaveMaxByPercent];
 
    UILabel* countLableBypercent = [[UILabel alloc] initWithFrame:CGRectMake(20, 145, 100, 20)];
    countLableBypercent.text = @"定制次数：";
    countLableBypercent.backgroundColor = [UIColor clearColor];
    countLableBypercent.textColor = [UIColor blackColor];
    countLableBypercent.font = [UIFont systemFontOfSize:15.0f];
    countLableBypercent.textAlignment = UITextAlignmentLeft;
    [m_viewByByPercent addSubview:countLableBypercent];
    [countLableBypercent release];
    
    m_orderCountByPercent = [[UITextField alloc] initWithFrame:CGRectMake(130, 145, 110, 31)];
    m_orderCountByPercent.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    m_orderCountByPercent.borderStyle = UITextBorderStyleRoundedRect;
    m_orderCountByPercent.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_orderCountByPercent.textColor = [UIColor blackColor];
    m_orderCountByPercent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_orderCountByPercent.text = @"10";
    m_orderCountByPercent.tag = 10004;
    m_orderCountByPercent.keyboardAppearance = UIKeyboardAppearanceAlert;
    m_orderCountByPercent.returnKeyType = UIReturnKeyDone;
    [m_viewByByPercent addSubview:m_orderCountByPercent];
 
    UILabel* maXBuyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 180, 100, 21)];
    maXBuyCountLabel.text = @"最多99次";
    maXBuyCountLabel.font = [UIFont systemFontOfSize:14];
    maXBuyCountLabel.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:maXBuyCountLabel];
    [maXBuyCountLabel release];
  
    m_forceJoinLableByPercent = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 230, 50)];
    m_forceJoinLableByPercent.textAlignment = UITextAlignmentLeft;
    m_forceJoinLableByPercent.text = @"强制参与（选择了该项，如果设置的跟单金额大于可以跟单的金额，也会参与该合买）";
    m_forceJoinLableByPercent.lineBreakMode =UILineBreakModeCharacterWrap;
    m_forceJoinLableByPercent.numberOfLines = 2;
    m_forceJoinLableByPercent.textColor = [UIColor blackColor];
    m_forceJoinLableByPercent.font = [UIFont systemFontOfSize:12];
    m_forceJoinLableByPercent.backgroundColor = [UIColor clearColor];
    [m_viewByByPercent addSubview:m_forceJoinLableByPercent];
    
    m_forceJoinButtonByPercent = [[UIButton alloc] initWithFrame:CGRectMake(20, 215, 20, 20)];
    [m_forceJoinButtonByPercent setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
    m_forceJoinButtonByPercent.tag = 301;
    [m_forceJoinButtonByPercent addTarget:self action:@selector(forceJoinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_forceJoinButtonByPercent setBackgroundColor:[UIColor clearColor]];
    [m_viewByByPercent addSubview:m_forceJoinButtonByPercent];
}
-(void) hasMaxAmountButtonClick:(id)sender
{
    if ([sender tag] == 200 && m_hasMaxAmountByPercent) {
        m_lableHaveMaxByPercent.hidden = YES;
        m_textHaveMaxByPercent.hidden = YES;
        m_lableYuanHaveMaxByPercent.hidden = YES;
        
        [m_buttonNoMaxByByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [m_buttonHaveMaxByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        m_hasMaxAmountByPercent = NO;
        self.superViewController.hasMaxAmountByPercent = m_hasMaxAmountByPercent;
        return;
    }
    if ([sender tag] == 201 && !m_hasMaxAmountByPercent) {
        m_lableHaveMaxByPercent.hidden = NO;
        m_textHaveMaxByPercent.hidden = NO;
        m_lableYuanHaveMaxByPercent.hidden = NO;
        
        [m_buttonHaveMaxByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [m_buttonNoMaxByByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        m_hasMaxAmountByPercent = YES;
        self.superViewController.hasMaxAmountByPercent = m_hasMaxAmountByPercent;
        return;
    }
}

-(void) changeViewButtonClick:(id)sender
{
    int tag = [sender tag];
    if (tag == 100) {
        m_isByAllAmount = YES;
        m_viewByAllAmount.hidden = NO;
        m_viewByByPercent.hidden = YES;
        self.superViewController.isByAllAmount = YES;
        [m_buttonByallAmount setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [m_buttonByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    }
    else if(tag == 101)
    {
        m_isByAllAmount = NO;
        m_viewByAllAmount.hidden = YES;
        m_viewByByPercent.hidden = NO;
        self.superViewController.isByAllAmount = NO;
        [m_buttonByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [m_buttonByallAmount setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
    }
}
-(void) forceJoinButtonClick:(id)sender
{
    int tag = [sender tag];
    if (tag == 300) {
        if (m_forceJoinByAllAmount) {
            m_forceJoinByAllAmount = NO;
            self.superViewController.forceJoin = NO;
            [m_forceJoinButtonByAllAmount setImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
        }
        else{
            m_forceJoinByAllAmount = YES;
            self.superViewController.forceJoin = YES;
            [m_forceJoinButtonByAllAmount setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
        }
    }
    if (tag == 301) {
        if (m_forceJoinByPercent) {
            m_forceJoinByPercent = NO;
            self.superViewController.forceJoin = NO;
            [m_forceJoinButtonByPercent setImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
        }
        else{
            m_forceJoinByPercent = YES;
            self.superViewController.forceJoin = YES;
            [m_forceJoinButtonByPercent setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
        }
    }
 
}
 
-(void) refresh
{
    m_orderAmountByAllAmount.delegate = self.superViewController;
    m_orderCountByAllAmount.delegate = self.superViewController;

    m_orderAmountByPercent.delegate = self.superViewController;
    m_textHaveMaxByPercent.delegate = self.superViewController;
    m_orderCountByPercent.delegate = self.superViewController;
    
    m_freezeMonney = [m_orderAmountByAllAmount.text doubleValue] * [m_orderCountByAllAmount.text doubleValue];
    m_freezeAmountLable.text = [NSString stringWithFormat:@"需要冻结金额 %0.0lf 元",m_freezeMonney];
    
    //修改定制页面--定制次数不能修改
    if (self.superViewController.ViewType == MODIFY_AUTO_ORDER_VIEW)
    {
        [m_orderCountByAllAmount setEnabled:NO];
        m_orderCountByAllAmount.textColor = [UIColor grayColor];
        [m_orderCountByPercent setEnabled:NO];
        m_orderCountByPercent.textColor = [UIColor grayColor];
        
    }
    else
    {
        [m_orderCountByAllAmount setEnabled:YES];
        m_orderCountByAllAmount.textColor = [UIColor blackColor];
        [m_orderCountByPercent setEnabled:YES];
        m_orderCountByPercent.textColor = [UIColor blackColor];
    }
    
    if (self.superViewController.isByAllAmount)
    {
        m_isByAllAmount = YES;
        m_viewByAllAmount.hidden = NO;
        m_viewByByPercent.hidden = YES;
        [m_buttonByallAmount setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
        [m_buttonByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];

        m_orderCountByAllAmount.text = self.superViewController.orderCountByAllAmount;
        m_orderAmountByAllAmount.text = self.superViewController.orderAmountByAllAmount;
 
        m_freezeMonney = [m_orderAmountByAllAmount.text doubleValue] * [m_orderCountByAllAmount.text doubleValue];
        m_freezeAmountLable.text = [NSString stringWithFormat:@"需要冻结金额 %0.0lf 元",m_freezeMonney];

        //强制参与
        if (!self.superViewController.forceJoin) {
            m_forceJoinByAllAmount = NO;
            [m_forceJoinButtonByAllAmount setImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
        }
        else{
            m_forceJoinByAllAmount = YES;
            [m_forceJoinButtonByAllAmount  setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
        }

    }
    else//百分比
    {
        m_isByAllAmount = NO;
        m_viewByAllAmount.hidden = YES;
        m_viewByByPercent.hidden = NO;
        [m_buttonByallAmount setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
        [m_buttonByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];

        m_orderAmountByPercent.text = self.superViewController.orderAmountByPercent;
        m_orderCountByPercent.text = self.superViewController.orderCountByPercent;
        m_textHaveMaxByPercent.text = self.superViewController.orderMaxAmountByPercent;
 
        if (self.superViewController.hasMaxAmountByPercent) {
            m_lableHaveMaxByPercent.hidden = NO;
            m_textHaveMaxByPercent.hidden = NO;
            m_lableYuanHaveMaxByPercent.hidden = NO;
            
            [m_buttonHaveMaxByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
            [m_buttonNoMaxByByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
            m_hasMaxAmountByPercent = YES;
        }
        else
        {
            m_lableHaveMaxByPercent.hidden = YES;
            m_textHaveMaxByPercent.hidden = YES;
            m_lableYuanHaveMaxByPercent.hidden = YES;
            
            [m_buttonNoMaxByByPercent setImage:RYCImageNamed(@"radio_click.png") forState:UIControlStateNormal];
            [m_buttonHaveMaxByPercent setImage:RYCImageNamed(@"radio_normal.png") forState:UIControlStateNormal];
            m_hasMaxAmountByPercent = NO;
        }
        //强制参与
        if (!self.superViewController.forceJoin) {
            m_forceJoinByPercent = NO;
            [m_forceJoinButtonByPercent setImage:RYCImageNamed(@"select_2.png") forState:UIControlStateNormal];
        }
        else{
            m_forceJoinByPercent = YES;
            [m_forceJoinButtonByPercent setImage:RYCImageNamed(@"select2_select.png") forState:UIControlStateNormal];
        }
    }
    
}
@end
