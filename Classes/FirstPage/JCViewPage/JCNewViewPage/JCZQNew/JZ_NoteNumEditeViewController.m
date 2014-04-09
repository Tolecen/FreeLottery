//
//  JZ_NoteNumEditeViewController.m
//  Boyacai
//
//  Created by qiushi on 13-8-21.
//
//

#import "JZ_NoteNumEditeViewController.h"
#import "ColorUtils.h"
#import "JZNoteNumEditCell.h"
#import "RuYiCaiLotDetail.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "SingleMutiMixButton.h"
#import "ExchangeLotteryWithIntegrationViewController.h"
#import "AdaptationUtils.h"

@interface JZ_NoteNumEditeViewController () <UITextFieldDelegate>

@end 

@implementation JZ_NoteNumEditeViewController

@synthesize editeButton = m_editeButton;

@synthesize buttonHeMai = _buttonHeMai;
@synthesize totalCost = m_totalCost;
@synthesize buttonBuy          =_buttonBuy;
@synthesize bottomScrollView = _bottomScrollView;
@synthesize jzNoteBgView     = _jzNoteBgView;
@synthesize dataBaseArray    = m_dataBaseArray;
@synthesize tableView        = m_tableView;
@synthesize playTypeTag      = m_playTypeTag;
@synthesize deleteBaseArray  = m_deleteBaseArray;
@synthesize numGameCount     = m_numGameCount;
@synthesize jzconfusionType   = m_jzconfusionType;
@synthesize fieldBeishu      =_fieldBeishu;
@synthesize allUpScrollView  = _allUpScrollView;
@synthesize zhuBeiLable      = _zhuBeiLable;
@synthesize bonusLable       = _bonusLable;
@synthesize confusion_type   = _confusion_type;
@synthesize twoCount         = _twoCount;
@synthesize isScrollerLeft   = _isScrollerLeft;
@synthesize DanCount         = _DanCount;
@synthesize betNumber        = _betNumber;
@synthesize duoChuanChooseArray = m_duoChuanChooseArray;
@synthesize bottomView       = _bottomView;
@synthesize freeGuanLable    =_freeGuanLable;
@synthesize toGetherGuanLable = _toGetherGuanLable;
@synthesize chooseBetCode     =m_chooseBetCode;
@synthesize freePassRadioIndexArray = _freePassRadioIndexArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [m_chooseBetCode release];
    [_bonusLable release];
    [_zhuBeiLable release];
    [_allUpScrollView release];
    [_toGetherGuanLable release];
    [_freeGuanLable release];
    [_freePassRadioIndexArray release];
    [_downImageView release];
    [_bottomView release];
    [m_deleteBaseArray release];
    [m_tableView release];
    [m_dataBaseArray release];
    [_jzNoteBgView release];
    [m_totalCost release];
    [_buttonHeMai release];
    [_buttonBuy release];
    [_bottomScrollView release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置各个部位的背景颜色
    [AdaptationUtils adaptation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    _bottomScrollView.backgroundColor = [ColorUtils parseColorFromRGB:@"#d9d4cb"];
  
    [_buttonBuy setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d52322"]];
    [_buttonHeMai setBackgroundColor:[ColorUtils parseColorFromRGB:@"#60513b"]];
    [_jzNoteBgView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#f7f3ec"]];
    self.deleteBaseArray = [NSMutableArray arrayWithCapacity:0];
    
    
    _freePassRadioIndexArray = [[NSMutableArray alloc] initWithCapacity:5];
    _isScrollerLeft = NO;
 //编辑按钮的创建
    m_editeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    m_editeButton.backgroundColor = [ColorUtils parseColorFromRGB:@"#e6e0d7"];
    m_editeButton.frame = CGRectMake(30, 65, 300, 40);
    [m_editeButton setTitle:@"+ 添加/编辑赛事" forState:UIControlStateNormal];
    [m_editeButton setTitleColor:[ColorUtils parseColorFromRGB:@"#544831"] forState:UIControlStateNormal];
    [self.view addSubview:m_editeButton];
    
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 120, 320, [UIScreen mainScreen].bounds.size.height - 250) style:/*UITableViewStyleGrouped*/UITableViewStylePlain];
    //    m_tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉 groupcell的圆角
    //如果不希望响应select，那么就可以用下面的代码设置属性：
    m_tableView.tableFooterView.backgroundColor = [UIColor redColor];
    m_tableView.allowsSelection=NO;
    
    [self.view addSubview:m_tableView];
    
    self.dataBaseArray = [NSMutableArray arrayWithCapacity:0];
    
    m_DanCount = 0;
    m_allCount = [[RuYiCaiLotDetail sharedObject].amount intValue];
    
    self.zhuBeiLable.text = [NSString stringWithFormat:@"%d注×%@倍＝", m_betNumber,_fieldBeishu.text];
    self.totalCost.text = [NSString stringWithFormat:@"共%.0lf元", m_allCount /100.0];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = @"1";//倍数
    
    //创建动画view下面的阴影button
    
    _shadowButton =[UIButton buttonWithType:UIButtonTypeCustom];
    _shadowButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height, 320, [UIScreen mainScreen].bounds.size.height);
    _shadowButton.backgroundColor = [UIColor grayColor];
    
    [_shadowButton addTarget:self action:@selector(clearanceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_shadowButton atIndex:100];
     //底部view创建   
    [self layoutBottomView];
    
    //底部注数和倍数刷新；
    [self changeBetNumber];
    
    if (m_playTypeTag == IJCLQPlayType_Confusion ||
        m_playTypeTag == IJCZQPlayType_Confusion) {
        m_guoguanFangshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 217 + 8 + 36, 300, 30)] autorelease];
        m_guoguanFangshLabel.text = @"过关方式";
        m_guoguanFangshLabel.backgroundColor = [UIColor clearColor];
        m_guoguanFangshLabel.textAlignment = UITextAlignmentLeft;
        m_guoguanFangshLabel.textColor = [UIColor blackColor];
        m_guoguanFangshLabel.font = [UIFont boldSystemFontOfSize:15];
        [_bottomView addSubview:m_guoguanFangshLabel];

    }
    else
    {
     if(self.numGameCount > 8)
        {
            m_guoguanFangshLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 217 + 8 + 36, 300, 30)] autorelease];
            m_guoguanFangshLabel.text = @"过关方式";
            m_guoguanFangshLabel.backgroundColor = [UIColor clearColor];
            m_guoguanFangshLabel.textAlignment = UITextAlignmentLeft;
            m_guoguanFangshLabel.textColor = [UIColor blackColor];
            m_guoguanFangshLabel.font = [UIFont boldSystemFontOfSize:15];
            [_bottomView addSubview:m_guoguanFangshLabel];
        }
        else
        {
            [self setDuoChuanPassScollView];
            
        }
    }
    [self setFreePassScollView];
    
}
//每次进入确认页面需要刷新注数数据，所以要调用该方法
- (void)changeBetNumber
{
    //胆
    for (int i = 0; i < [[m_duoChuanChooseArray combineList] count]; i++) {
        if ([(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan]) {
            m_DanCount++;
        }
    }
    
    
    if (m_playTypeTag == IJCLQPlayType_SF_DanGuan ||
        m_playTypeTag == IJCLQPlayType_LetPoint_DanGuan ||
        m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
        m_playTypeTag == IJCLQPlayType_BigAndSmall_DanGuan ||
        
        m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan ||
        m_playTypeTag == IJCZQPlayType_ZJQ_DanGuan ||
        m_playTypeTag == IJCZQPlayType_Score_DanGuan||
        m_playTypeTag == IJCZQPlayType_HalfAndAll_DanGuan ||
        m_playTypeTag == IJCZQPlayType_SPF_DanGuan
        )
    {
        m_isDanGuan = TRUE;
        //        m_betNumber = [self getFreeChuanBetNum:1];//没有过关方式
        m_betNumber = m_numGameCount + m_twoCount;
    }
    else
    {
        
        //默认显示 自由过关
        m_isFreePassButton = TRUE;
        if (m_DanCount > 1) {
            freePassRadioIndex = 500 + m_DanCount + 1;
            [_freePassRadioIndexArray addObject:[NSNumber numberWithInt:freePassRadioIndex]];
            
        }
        else
        {
            freePassRadioIndex = 502;
            [_freePassRadioIndexArray addObject:[NSNumber numberWithInt:freePassRadioIndex]];
        }
        m_betNumber = [self getFreeChuanBetNum:freePassRadioIndex - 500];//默认
        
        duoChuanPassRadioIndex = -1;
        m_duoChuanPassRadioArray = [[NSMutableArray alloc] initWithCapacity:10];
            
            //多串过关
        NSDictionary *dictionary01 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"3串3", @"526", nil];
        NSDictionary *dictionary02 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"3串4", @"527", nil];
        NSDictionary *dictionary03 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串4", @"539", nil];
        NSDictionary *dictionary04 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串5", @"540", nil];
        NSDictionary *dictionary05 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串6", @"528", nil];
        NSDictionary *dictionary06 = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"4串11", @"529", nil];
        [m_duoChuanPassRadioArray addObject:dictionary01];
        [m_duoChuanPassRadioArray addObject:dictionary02];
        [m_duoChuanPassRadioArray addObject:dictionary03];
        [m_duoChuanPassRadioArray addObject:dictionary04];
        [m_duoChuanPassRadioArray addObject:dictionary05];
        [m_duoChuanPassRadioArray addObject:dictionary06];
        
        if (m_playTypeTag != IJCLQPlayType_SFC && m_playTypeTag != IJCLQPlayType_SFC_DanGuan) {
            NSDictionary *dictionary07 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串5", @"544", nil];
            NSDictionary *dictionary08 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串6", @"545", nil];
            NSDictionary *dictionary09 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串10", @"530", nil];
            NSDictionary *dictionary10 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串16", @"541", nil];
            NSDictionary *dictionary11 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串20", @"531", nil];
            NSDictionary *dictionary12 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"5串26", @"532", nil];
            
            NSDictionary *dictionary13 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串6", @"549", nil];
            NSDictionary *dictionary14 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串7", @"550", nil];
            NSDictionary *dictionary15 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串15", @"533", nil];
            NSDictionary *dictionary16 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串20", @"542", nil];
            NSDictionary *dictionary17 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串22", @"546", nil];
            NSDictionary *dictionary18 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串35", @"534", nil];
            NSDictionary *dictionary19 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串42", @"543", nil];
            NSDictionary *dictionary20 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串50", @"535", nil];
            NSDictionary *dictionary21 = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"6串57", @"536", nil];
            
            [m_duoChuanPassRadioArray addObject:dictionary07];
            [m_duoChuanPassRadioArray addObject:dictionary08];
            [m_duoChuanPassRadioArray addObject:dictionary09];
            [m_duoChuanPassRadioArray addObject:dictionary10];
            [m_duoChuanPassRadioArray addObject:dictionary11];
            [m_duoChuanPassRadioArray addObject:dictionary12];
            [m_duoChuanPassRadioArray addObject:dictionary13];
            [m_duoChuanPassRadioArray addObject:dictionary14];
            [m_duoChuanPassRadioArray addObject:dictionary15];
            [m_duoChuanPassRadioArray addObject:dictionary16];
            [m_duoChuanPassRadioArray addObject:dictionary17];
            [m_duoChuanPassRadioArray addObject:dictionary18];
            [m_duoChuanPassRadioArray addObject:dictionary19];
            [m_duoChuanPassRadioArray addObject:dictionary20];
            [m_duoChuanPassRadioArray addObject:dictionary21];
            
            
            if (m_playTypeTag != IJCZQPlayType_ZJQ &&
                m_playTypeTag != IJCZQPlayType_ZJQ_DanGuan)
            {
                NSDictionary *dictionary22 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串7", @"553", nil];
                NSDictionary *dictionary23 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串8", @"554", nil];
                NSDictionary *dictionary24 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串21", @"551", nil];
                NSDictionary *dictionary25 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串35", @"547", nil];
                NSDictionary *dictionary26 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"7串120", @"537", nil];
                
                NSDictionary *dictionary27 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串8", @"556", nil];
                NSDictionary *dictionary28 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串9", @"557", nil];
                NSDictionary *dictionary29 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串28", @"555", nil];
                NSDictionary *dictionary30 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串56", @"552", nil];
                NSDictionary *dictionary31 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串70", @"548", nil];
                NSDictionary *dictionary32 = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"8串247", @"538", nil];
                [m_duoChuanPassRadioArray addObject:dictionary22];
                [m_duoChuanPassRadioArray addObject:dictionary23];
                [m_duoChuanPassRadioArray addObject:dictionary24];
                
                [m_duoChuanPassRadioArray addObject:dictionary25];
                [m_duoChuanPassRadioArray addObject:dictionary26];
                [m_duoChuanPassRadioArray addObject:dictionary27];
                [m_duoChuanPassRadioArray addObject:dictionary28];
                [m_duoChuanPassRadioArray addObject:dictionary29];
                [m_duoChuanPassRadioArray addObject:dictionary30];
                
                [m_duoChuanPassRadioArray addObject:dictionary31];
                [m_duoChuanPassRadioArray addObject:dictionary32];
                }
            }
            

    }
    [self refreshData];
}

//布局底部多串和倍数
- (void)layoutBottomView
{
    
    //底部view创建
    isBottomDown = YES;
    _bottomView  = [[UIView alloc] initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18, 320, 220)];
    
    _bottomView.backgroundColor = [ColorUtils parseColorFromRGB:@"#f7f3ec"];
    [self.view insertSubview:_bottomView aboveSubview:_shadowButton];
    //把底部bar放到最上面
    [self.view insertSubview:_bottomScrollView aboveSubview:_bottomView];
    _allUpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, 320, 160)];
    _allUpScrollView.contentSize = CGSizeMake(0, 550);    _allUpScrollView.backgroundColor = [ColorUtils parseColorFromRGB:@"#f7f3ec"];
    [_bottomView addSubview:_allUpScrollView];
    
    
    UIImageView *bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 1)];
    bottomLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#cac8c2"];
    [_bottomView addSubview:bottomLine];
    [bottomLine release];
    
    UIImageView *bottomDownLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,50, 320, 1)];
    bottomDownLine.backgroundColor = [ColorUtils parseColorFromRGB:@"#cac8c2"];
    [_bottomView addSubview:bottomDownLine];
    [bottomDownLine release];
    
    
    
    
    //布局过关方式和投注倍数的ui显示
    
    UILabel *remindLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 130, 20)];
    remindLable.text = @"您尚未选择过关方式";
    remindLable.textColor = [ColorUtils parseColorFromRGB:@"#c5c1ba"];
    remindLable.font = [UIFont systemFontOfSize:13];
    remindLable.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:remindLable];
    [remindLable release];
    
    UILabel *clearanceLable = [[UILabel alloc] initWithFrame:CGRectMake(20,20, 60, 20)];
    clearanceLable.text = @"过关方式";
    clearanceLable.backgroundColor = [UIColor clearColor];
    clearanceLable.textColor = [ColorUtils parseColorFromRGB:@"#464646"];
    clearanceLable.font = [UIFont systemFontOfSize:14];
    [_bottomView addSubview:clearanceLable];
    [clearanceLable release];
    
    _clearanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _clearanceButton.frame = CGRectMake(80, 15, 60, 30);
    [_clearanceButton setTitle:@"(必选)" forState:UIControlStateNormal];
    [_clearanceButton setTitleColor:[ColorUtils parseColorFromRGB:@"#c80000"] forState:UIControlStateNormal];
    
    _clearanceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_clearanceButton addTarget:self action:@selector(clearanceButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_clearanceButton];
    
    _downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(140,30, 18/2, 11/2)];
    _downImageView.image = [UIImage imageNamed:@"up_jc_expend.png"];
    [_bottomView addSubview:_downImageView];
    
    UILabel *multipleLable = [[UILabel alloc] initWithFrame:CGRectMake(210,12,130, 30)];
    multipleLable.backgroundColor = [UIColor clearColor];
    multipleLable.text = @"投                  倍";
    multipleLable.textColor = [ColorUtils parseColorFromRGB:@"#464646"];
    multipleLable.font = [UIFont systemFontOfSize:15];
    [_bottomView addSubview:multipleLable];
    [multipleLable release];
    
    UIImageView *multipleUIImageView = [[UIImageView alloc] initWithFrame:CGRectMake(227, 12, 70, 30)];
    multipleUIImageView.image = [UIImage imageNamed:@"select_c_jc_nomal.png"];
    [multipleUIImageView setIsAccessibilityElement:YES];
    [_bottomView addSubview:multipleUIImageView];
    [multipleUIImageView release];
    
       
    _fieldBeishu = [[UITextField alloc] initWithFrame:CGRectMake(230, 17, 65, 27)];
    
    _fieldBeishu.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	_fieldBeishu.keyboardAppearance = UIKeyboardAppearanceAlert;
    _fieldBeishu.textAlignment = NSTextAlignmentCenter;
    _fieldBeishu.font = [UIFont systemFontOfSize:14];
    _fieldBeishu.text = @"1";
    _fieldBeishu.delegate =   self;
    _fieldBeishu.returnKeyType = UIReturnKeyDone;
    [_bottomView addSubview:_fieldBeishu];
    
    
    //自由过关
    _freeGuanLable = [[UILabel alloc] initWithFrame:CGRectMake(10,5, 80, 20)];
    _freeGuanLable.text = @"自由过关";
    _freeGuanLable.font = [UIFont systemFontOfSize:14];
    _freeGuanLable.backgroundColor = [UIColor clearColor];
    [_allUpScrollView addSubview:_freeGuanLable];
    
    //组合过关
    _toGetherGuanLable = [[UILabel alloc] initWithFrame:CGRectMake(10,65, 80, 20)];
    _toGetherGuanLable.text = @"多串过关";
    _toGetherGuanLable.font = [UIFont systemFontOfSize:14];
    _toGetherGuanLable.backgroundColor =  [UIColor clearColor];
    [_allUpScrollView addSubview:_toGetherGuanLable];
    
}

#pragma mark textFielddelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
        isBottomDown=NO;
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        _bottomView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18-160, 320, 220);
    
        [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL  isOk = YES;
    for (int i = 0; i < textField.text.length; i++)
    {
        UniChar chr = [textField.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"数字不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"填写的必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
    }
    if (isOk) {
        if([textField.text intValue] <= 0 || [textField.text intValue] > 100000)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"投注倍数的范围为 1~100000倍" withTitle:@"提示" buttonTitle:@"确定"];
            isOk = NO;
        }
    }
    
    if (!isOk) {
        self.fieldBeishu.text = @"1";
    }
    [self refreshData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.fieldBeishu.text.length >= 6 && range.length == 0)
    {
        return  NO;
    }
    else//只允许输入数字
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self hideKeybord];
    return YES;
}

- (void)hideKeybord
{
    isBottomDown=YES;
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationRepeatAutoreverses:NO];
        _bottomView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18, 320, 220);
        
        [UIView commitAnimations];
        [UIView commitAnimations];
    
}



#pragma mark tableViewdelegate
//改变行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 80;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataBaseArray count];
}
//绘制cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *groupCell = @"groupCell";
    
	JZNoteNumEditCell *cell = (JZNoteNumEditCell*)[tableView dequeueReusableCellWithIdentifier:groupCell];
	if(cell == nil)
	{
		cell = [[[JZNoteNumEditCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:groupCell]autorelease];
        cell.isLeftSelect = NO;
        cell.isCenterSelect = NO;
        cell.isRightSelect = NO;
        
        //胆按钮默认设置为隐藏
        [cell.danButton setHidden:YES];
        [cell.deleteNoteBtn addTarget:self action:@selector(deleteBaseObject:) forControlEvents:UIControlEventTouchUpInside];
	}
    
    
    cell.jZ_NoteNumEditeViewController = self;
    cell.playTypeTag = m_playTypeTag;
    cell.indexpath = indexPath;
    
    JZNoteNumEditCell_DataBase* base;
    
    base = [self.dataBaseArray objectAtIndex:indexPath.row];
    
    //获取是否被选，然后进行选中操作
            cell.isLeftSelect = [base ZQ_S_ButtonIsSelect];


            cell.isCenterSelect = [base ZQ_P_ButtonIsSelect];
         

            cell.isRightSelect = [base ZQ_F_ButtonIsSelect];

    
    cell.homeTeam = [base homeTeam];
    cell.VisitTeam = [base VisitTeam];
    cell.vf = [base vf];
    cell.vp = [base vp];
    cell.vs = [base vs];
    
    
    
    //胆是否隐藏的控制判断
    if ([self.dataBaseArray count] >= 3)
    {
        [cell.danButton setHidden:NO];
        //取消一注彩票会把该注的胆隐藏掉
        if (cell.isCenterSelect ==NO && cell.isLeftSelect == NO && cell.isRightSelect ==NO)
        {
            [cell.danButton setHidden:YES];
        }
        else
        {
            if (m_numGameCount>=3)
            {
                [cell.danButton setHidden:NO];
            }
            else
            {
                [cell.danButton setHidden:YES];
            }
        }
    }else
    {
      [cell.danButton setHidden:YES];
    }
    
    
    
    
    if ([self gameIsSelect:indexPath]) {
        if ([base JC_DanIsSelect]) {
            NSLog(@"\n[tableCell JC_DanIsSelect]:%d",indexPath.row);
        }
        [cell setIsJC_Button_Dan_Select:[base JC_DanIsSelect]];
    }
    else
    {
        [cell setIsJC_Button_Dan_Select:FALSE];
    }
    
    
    [cell RefreshCellView];
    return cell;
}


-(BOOL) gameIsSelect:(NSIndexPath*) indexPath
{
    NSInteger section;
    NSInteger row;
        
        section = indexPath.section;
        row = indexPath.row;
   
    
    JZNoteNumEditCell_DataBase* tableCell = (JZNoteNumEditCell_DataBase*) [self.dataBaseArray objectAtIndex:indexPath.row];
    
    int goalArrayCount = [[tableCell sfc_selectTag] count];
    if ([tableCell ZQ_S_ButtonIsSelect] || [tableCell ZQ_P_ButtonIsSelect] || [tableCell ZQ_F_ButtonIsSelect] || goalArrayCount > 0  )
    {
        return TRUE;
    }
    
    return FALSE;
}
//删除选中的赛事
- (void)deleteBaseObject:(id)sender

{
    JZNoteNumEditCell *cell = (JZNoteNumEditCell *)[(UIButton *)sender superview];
    
    NSIndexPath *indexpath = [m_tableView indexPathForCell:cell];
    
    [self.deleteBaseArray addObject:[self.dataBaseArray objectAtIndex:indexpath.row]];
    [self.dataBaseArray removeObjectAtIndex:indexpath.row];
    [self.tableView reloadData];
    [self refreshData];
}

//获取投注的信息，选胜负的详细信息
- (NSArray *)getSfArray:(NSInteger)index
{
    NSMutableString* betcodeList = [NSMutableString stringWithString:[[RuYiCaiLotDetail sharedObject] disBetCode]];
    
    if ([betcodeList length] == 0) {
        return nil;
    }
    
    NSArray* gameArray = [betcodeList componentsSeparatedByString:@";"];
    
    NSMutableArray  *sfpStrArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    if (gameArray > 0){
        
            NSString* str = [gameArray objectAtIndex:index];
            
            NSArray* array_2 = [str componentsSeparatedByString:@"@"];
            
            
            if ([array_2 count] == 2)
            {
                NSString* play_str = [array_2 objectAtIndex:1];
                NSArray* array_3 = [play_str componentsSeparatedByString:@","];
               
                for (int j = 0 ; j < [array_3 count];j++) {
                    NSString* str_3 = [array_3 objectAtIndex:j];
                    
                    if ([str_3 length] > 0) {
                        NSArray* array_4 = [str_3 componentsSeparatedByString:@"~"];
                        NSString* play_content = ([array_4 count] > 1 ? [array_4 objectAtIndex:1] : @"");
                        if ([play_content length]>=2)
                        {
                            sfpStrArray = (NSMutableArray *)[play_content componentsSeparatedByString:@" "];
                            
                            
                        }
                        
                        
                    }
                }
            }

    }
    
    return sfpStrArray;
}

-(BOOL) changeClickState:(NSIndexPath*)indexPath clickState:(BOOL)clickState  ButtonIndex:(NSInteger)buttonIndex

{
    
    NSInteger row;
        row = indexPath.row;
       
    JZNoteNumEditCell_DataBase*  base =(JZNoteNumEditCell_DataBase*) [self.dataBaseArray objectAtIndex:row];
    
    if (buttonIndex == 1)
    {
        if (clickState)
        {
            [base setZQ_S_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_S_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 2)
    {
        if (clickState)
        {
            [base setZQ_P_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_P_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 3)
    {
        if (clickState)
        {
            [base setZQ_F_ButtonIsSelect:YES];
        }
        else
        {
            [base setZQ_F_ButtonIsSelect:NO];
        }
    }
    else if(buttonIndex == 4)
    {
        if (clickState)
        {
            if ([self judegmentDan_clickEvent]) {
                [base setJC_DanIsSelect:YES];
            }
            else
            {
                return FALSE;
            }
        }
        else
        {
            [base setJC_DanIsSelect:NO];
        }
        
    }
    /*
     去除所选 胆
     */
    if (![base ZQ_S_ButtonIsSelect] && ![base ZQ_P_ButtonIsSelect] && ![base ZQ_F_ButtonIsSelect] && [[base sfc_selectTag] count] <= 0) {
        [base setJC_DanIsSelect:NO];
    }
    if (m_playTypeTag == IJCZQPlayType_RQ_SPF || m_playTypeTag == IJCZQPlayType_RQ_SPF_DanGuan || m_playTypeTag == IJCZQPlayType_SPF || m_playTypeTag == IJCZQPlayType_SPF_DanGuan) {
        //刷新 所选比赛场次，金额
        NSInteger gameCount = 0;
        m_twoCount = 0;
        m_threeCount = 0;
        
         for (int i = 0; i < [self.dataBaseArray count]; i++) {
        
                BOOL ZQ_S_ButtonIsSelect = [(JZNoteNumEditCell_DataBase*) [self.dataBaseArray objectAtIndex:i] ZQ_S_ButtonIsSelect];
                
                BOOL ZQ_P_ButtonIsSelect = [(JZNoteNumEditCell_DataBase*) [self.dataBaseArray objectAtIndex:i] ZQ_P_ButtonIsSelect];
                
                BOOL ZQ_F_ButtonIsSelect = [(JZNoteNumEditCell_DataBase*) [self.dataBaseArray objectAtIndex:i] ZQ_F_ButtonIsSelect];
                
                if (ZQ_S_ButtonIsSelect || ZQ_P_ButtonIsSelect || ZQ_F_ButtonIsSelect)
                {
                    gameCount++;
                    if (ZQ_S_ButtonIsSelect && ZQ_P_ButtonIsSelect && !ZQ_F_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    if (ZQ_S_ButtonIsSelect && ZQ_F_ButtonIsSelect && !ZQ_P_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && !ZQ_S_ButtonIsSelect)
                    {
                        m_twoCount++;
                    }
                    
                    if (ZQ_F_ButtonIsSelect&& ZQ_P_ButtonIsSelect && ZQ_S_ButtonIsSelect)
                    {
                        m_threeCount++;
                    }
                }
         }
        m_numGameCount = gameCount;
    }
    [self refreshData];
    [m_tableView reloadData];//用于胜平负都取消选项时 胆 按钮自动未选中
    
    return TRUE;
}

//用于设胆之前的判断
-(BOOL) judegmentDan_clickEvent
{
    /*
     所选比赛 至少有一场不sedan
     */
    int danCount = 0;
        for (int spindex = 0; spindex < [m_dataBaseArray count]; spindex++)
        {
            JZNoteNumEditCell_DataBase* base = [self.dataBaseArray objectAtIndex:spindex];
            if ([base JC_DanIsSelect]) {
                danCount++;
            }
    }
    if (danCount + 2 >= m_numGameCount) {
        
        NSString* message = @"";
        if (danCount <= 0 || m_numGameCount - 2 <= 0) {
            message = [message stringByAppendingString:@"不符合设胆条件"];
        }
        else
            message = [message stringByAppendingFormat:@"胆码不能超过%d个",m_numGameCount - 2];
        [[RuYiCaiNetworkManager sharedManager] showMessage:message withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    if (danCount >= 7) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最多可以选择七场比赛进行设胆" withTitle:@"错误" buttonTitle:@"确定"];
        return FALSE;
    }
    return TRUE;
}


- (void)setDuoChuanPassScollView
{
    if (m_numGameCount >= 3)
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10, _toGetherGuanLable.frame.origin.y+25, 70, 20) Title:@"3串3" isSelect:NO Tag:1 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_numGameCount == 3)) ? FALSE : TRUE)];
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25, 70, 20) Title:@"3串4" isSelect:NO Tag:2 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_numGameCount == 3)) ? FALSE : TRUE)];
        //改变allUpScrollView
        _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70);
    }
    if(m_numGameCount >= 4 )
    {
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2,_toGetherGuanLable.frame.origin.y+25, 70, 20) Title:@"4串4" isSelect:NO Tag:3
                             ISCLICK:((m_DanCount >= 4 || (m_DanCount > 0 && m_numGameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 +76 * 3, _toGetherGuanLable.frame.origin.y+25, 70, 20) Title:@"4串5" isSelect:NO Tag:4
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_numGameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 , _toGetherGuanLable.frame.origin.y+25 + 35, 70, 20) Title:@"4串6" isSelect:NO Tag:5
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_numGameCount == 4)) ? FALSE : TRUE)];
        
        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35, 70, 20) Title:@"4串11" isSelect:NO Tag:6
                             ISCLICK:((m_DanCount >= 4  || (m_DanCount > 0 && m_numGameCount == 4)) ? FALSE : TRUE)];
        _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70+ 35);
    }
    //竞彩篮球  胜分差 只有 4串 以内的
    //竞彩足球    比分    只有 4串 以内的
    //竞彩足球    半全场  只有 4串 以内的
    
    if (m_playTypeTag != IJCLQPlayType_SFC &&
        
        m_playTypeTag != IJCZQPlayType_Score &&
        
        m_playTypeTag != IJCZQPlayType_HalfAndAll
        )
    {
        if (self.jzconfusionType == JzZQ_SCORE ||
            self.jzconfusionType == JzZQ_HALF||
            self.jzconfusionType == JzLQ_SFC)
        {
            
        }
        else
        {
            if(m_numGameCount >= 5)
            {
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2 , _toGetherGuanLable.frame.origin.y+25 + 35, 70, 20) Title:@"5串5" isSelect:NO Tag:7
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76* 3,_toGetherGuanLable.frame.origin.y+25 + 35, 70, 20) Title:@"5串6" isSelect:NO Tag:8
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                
                
                [self CreatDuoChuanPassRadio:CGRectMake(10, _toGetherGuanLable.frame.origin.y+25 + 35 * 2, 70, 20) Title:@"5串10" isSelect:NO Tag:9
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35 * 2, 70, 20) Title:@"5串16" isSelect:NO Tag:10
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2, _toGetherGuanLable.frame.origin.y+25+ 35 * 2, 70, 20) Title:@"5串20" isSelect:NO Tag:11
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 3 , _toGetherGuanLable.frame.origin.y+25+ 35 * 2, 70, 20) Title:@"5串26" isSelect:NO Tag:12
                                     ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
                _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70+ 35 * 2);
                
            }
            if(m_numGameCount >= 6)
            {
                [self CreatDuoChuanPassRadio:CGRectMake(10, _toGetherGuanLable.frame.origin.y+25 + 35 * 3, 70, 20) Title:@"6串6" isSelect:NO Tag:13
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35 * 3, 70, 20) Title:@"6串7" isSelect:NO Tag:14
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2, _toGetherGuanLable.frame.origin.y+25+ 35 * 3, 70, 20) Title:@"6串15" isSelect:NO Tag:15
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 3, _toGetherGuanLable.frame.origin.y+25 + 35 * 3, 70, 20) Title:@"6串20" isSelect:NO Tag:16
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                
                [self CreatDuoChuanPassRadio:CGRectMake(10, _toGetherGuanLable.frame.origin.y+25 + 35 * 4, 70, 20) Title:@"6串22" isSelect:NO Tag:17
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35 * 4, 70, 20) Title:@"6串35" isSelect:NO Tag:18
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 +76 * 2, _toGetherGuanLable.frame.origin.y+25 + 35 * 4, 70, 20) Title:@"6串42" isSelect:NO Tag:19
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                [self CreatDuoChuanPassRadio:CGRectMake(10 +76 * 3 , _toGetherGuanLable.frame.origin.y+25 + 35 * 4, 70, 20) Title:@"6串50" isSelect:NO Tag:20
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                
                
                [self CreatDuoChuanPassRadio:CGRectMake(10 , _toGetherGuanLable.frame.origin.y+25 + 35 * 5, 70, 20) Title:@"6串57" isSelect:NO Tag:21
                                     ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
                _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70+ 35 * 5);
            }
            //竞彩足球  总进球 只有 6串 以内的
            if (m_playTypeTag != IJCZQPlayType_ZJQ )
            {
                if (self.jzconfusionType == JzZQ_ZJQ) {
                    
                }
                else
                {
                    if(m_numGameCount >= 7 )
                    {
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35 * 5, 70, 20) Title:@"7串7" isSelect:NO Tag:22
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10  + 76 * 2, _toGetherGuanLable.frame.origin.y+25 + 35 * 5, 70, 20) Title:@"7串8" isSelect:NO Tag:23
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 3 , _toGetherGuanLable.frame.origin.y+25 + 35 * 5, 70, 20) Title:@"7串21" isSelect:NO Tag:24
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10 , _toGetherGuanLable.frame.origin.y+25 + 35 * 6, 70, 20) Title:@"7串35" isSelect:NO Tag:25
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 +76, _toGetherGuanLable.frame.origin.y+25 + 35 * 6, 70, 20) Title:@"7串120" isSelect:NO Tag:26
                                             ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                        _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70+ 35 * 6);
                        
                    }
                    if(m_numGameCount >= 8 && m_DanCount <= 8)
                    {
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2, _toGetherGuanLable.frame.origin.y+25 + 35 * 6, 70, 20) Title:@"8串8" isSelect:NO Tag:27
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10  + 76 * 3, _toGetherGuanLable.frame.origin.y+25 + 35 * 6, 70, 20) Title:@"8串9" isSelect:NO Tag:28
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10, _toGetherGuanLable.frame.origin.y+25 + 35 * 7, 70, 20) Title:@"8串28" isSelect:NO Tag:29
                                             ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76, _toGetherGuanLable.frame.origin.y+25 + 35 * 7, 70, 20) Title:@"8串56" isSelect:NO Tag:30 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 2, _toGetherGuanLable.frame.origin.y+25 + 35 * 7, 70, 20) Title:@"8串70" isSelect:NO Tag:31 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        [self CreatDuoChuanPassRadio:CGRectMake(10 + 76 * 3, _toGetherGuanLable.frame.origin.y+25 + 35 * 7, 70, 20) Title:@"8串247" isSelect:NO Tag:32 ISCLICK:((m_DanCount >= 8  || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                        
                        _allUpScrollView.contentSize = CGSizeMake(0, _toGetherGuanLable.frame.origin.y+70+ 35 * 7);
                    }
                }
            }
        }
    }
}

//设置单多串
- (void)setFreePassScollView
{
    if (m_numGameCount >= 2) {
        BOOL isSelect = [self isHaveSelected:502];
        [self CreatFreePassRadio:CGRectMake(10, 30, 70, 20) Title:@"2串1" isSelect:isSelect Tag:502 ISCLICK:((m_DanCount >= 2) ? FALSE : TRUE)];
    }
    if(m_numGameCount >= 3)
    {
        BOOL isSelect = [self isHaveSelected:503];
        [self CreatFreePassRadio:CGRectMake(10 + 76, 30, 70, 20) Title:@"3串1" isSelect:isSelect Tag:503 ISCLICK:((m_DanCount >= 3 || (m_DanCount > 0 && m_numGameCount == 3)) ? FALSE : TRUE)];
    }
    if(m_numGameCount >= 4)
    {
        BOOL isSelect = [self isHaveSelected:504];
        [self CreatFreePassRadio:CGRectMake(10 + 76 * 2, 30, 70, 20) Title:@"4串1" isSelect:isSelect Tag:504 ISCLICK:((m_DanCount >= 4 || (m_DanCount > 0 && m_numGameCount == 4)) ? FALSE : TRUE)];
    }
    //竞彩篮球  胜分差 只有 4串 以内的
    //竞彩足球    比分    只有 4串 以内的
    //竞彩足球    半全场  只有 4串 以内的
    if (m_playTypeTag != IJCLQPlayType_SFC   &&
        m_playTypeTag != IJCZQPlayType_Score   &&
        m_playTypeTag != IJCZQPlayType_HalfAndAll
        )
    {
        if (self.jzconfusionType == JzZQ_SCORE ||
            self.jzconfusionType == JzZQ_HALF||
            self.jzconfusionType == JzLQ_SFC)
        {
            
        }
        else
        {
            if(m_numGameCount >= 5)
            {
                BOOL isSelect = [self isHaveSelected:505];
                [self CreatFreePassRadio:CGRectMake(10 + 76 * 3, 30, 70, 20) Title:@"5串1" isSelect:isSelect Tag:505 ISCLICK:((m_DanCount >= 5  || (m_DanCount > 0 && m_numGameCount == 5)) ? FALSE : TRUE)];
            }
            if(m_numGameCount >= 6)
            {
                _toGetherGuanLable.frame = CGRectMake(10, 100, 80, 20);
                BOOL isSelect = [self isHaveSelected:506];
                [self CreatFreePassRadio:CGRectMake(10, 30 + 35, 70, 20) Title:@"6串1" isSelect:isSelect Tag:506 ISCLICK:((m_DanCount >= 6  || (m_DanCount > 0 && m_numGameCount == 6)) ? FALSE : TRUE)];
            }
            //竞彩足球  总进球 只有 6串 以内的
            if (m_playTypeTag != IJCZQPlayType_ZJQ  )
            {
                if (self.jzconfusionType == JzZQ_ZJQ)
                {
                    
                }
                else
                {
                    if(m_numGameCount >= 7)
                    {
                        BOOL isSelect = [self isHaveSelected:507];
                        [self CreatFreePassRadio:CGRectMake(10 + 76 * 1, 30 + 35, 70, 20) Title:@"7串1" isSelect:isSelect Tag:507 ISCLICK:((m_DanCount >= 7  || (m_DanCount > 0 && m_numGameCount == 7)) ? FALSE : TRUE)];
                    }
                    if(m_numGameCount >= 8)
                    {
                        BOOL isSelect = [self isHaveSelected:508];
                        [self CreatFreePassRadio:CGRectMake(10 + 76 * 2, 30 + 35, 70, 20) Title:@"8串1" isSelect:isSelect Tag:508 ISCLICK:((m_DanCount >= 8 || (m_DanCount > 0 && m_numGameCount == 8)) ? FALSE : TRUE)];
                    }
                }
            }
        }
        
    }
    
}

/*
 注：竞彩  玩法 过关方式 限制（暂时）
 
 竞彩篮球：
 [
 胜分差 只有 4串 以内的
 
 ]
 竞彩足球：
 [
 胜平负  全部
 
 总进球  只有 6串 以内的
 比分    只有 4串 以内的
 半全场  只有 4串 以内的
 ]
 */
- (BOOL)isHaveSelected:(NSInteger)index
{
    BOOL ishave = FALSE;
    for (int a = 0; a < [_freePassRadioIndexArray count]; a++) {
        if ([[_freePassRadioIndexArray objectAtIndex:a] intValue] == index) {
            ishave = TRUE;
            break;
        }
    }
    return ishave;
}
//创建多串过关的
- (void)CreatDuoChuanPassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger)radioTag ISCLICK:(BOOL) isClick
{
    //X串X
    SingleMutiMixButton* string2_1 = [[SingleMutiMixButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 70, 64/2) title:title Tag:radioTag minWinAmount:m_minWinAmount maxWinAmount:m_maxWinAmount numGameCount:m_numGameCount];
    string2_1.jz_NoteNumEditeViewController = self;
    /*initWithFrame:
     添加 过关限制
     */
    if (isClick) {
        [string2_1 addTarget:self action:@selector(duoChuanPassRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [_allUpScrollView addSubview:string2_1];
    [string2_1 release];
}

//创建自由过关的
- (void)CreatFreePassRadio:(CGRect)rect Title:(NSString*)title isSelect:(BOOL)select Tag:(NSInteger) radioTag ISCLICK:(BOOL) isClick
{
    //X串1
    //X串1
    UIButton* string2_1 = [[UIButton alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 70, 64/2)];
    [string2_1 setBackgroundImage:[UIImage imageNamed:@"select_c_jc_click.png"] forState:UIControlStateSelected];
    [string2_1 setBackgroundImage:[UIImage imageNamed:@"select_c_jc_nomal.png"] forState:UIControlStateNormal];
   
    if (select) {
        string2_1.selected = YES;
        int count = [_freePassRadioIndexArray count];
        BOOL isHave = FALSE;
        for (int a = 0; a < count; a++) {
            if ([[_freePassRadioIndexArray objectAtIndex:a] intValue] == radioTag) {
                isHave = TRUE;
            }
        }
        if (!isHave) {
            [_freePassRadioIndexArray addObject:[NSNumber numberWithInt:radioTag]];
        }
    }
   
    
    /*
     添加 过关限制
     */
    if (isClick) {
       [string2_1 addTarget:self action:@selector(freePassRadioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [string2_1 setTitle:title forState:UIControlStateNormal];
    [string2_1 setTitle:title forState:UIControlStateSelected];
    [string2_1 setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [string2_1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    string2_1.titleLabel.font = [UIFont systemFontOfSize:15];
    [string2_1 setTag:radioTag];
    [_allUpScrollView addSubview:string2_1];
    [string2_1 release];
    
}


//过关按钮点击
- (void)clearanceButtonClick
{
    if (isBottomDown)
    {
        _downImageView.image = [UIImage imageNamed:@"down_jc_expend.png"];
        _shadowButton.frame = CGRectMake(20, 0, 320, [UIScreen mainScreen].bounds.size.height);
        _shadowButton.alpha = 0.3;
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:.3];
        _bottomView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18-160, 320, 220);
        [UIView commitAnimations];
        isBottomDown =NO;
    }else
    {
        [_fieldBeishu resignFirstResponder];
        _downImageView.image = [UIImage imageNamed:@"up_jc_expend.png"];

        _shadowButton.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18, 320, [UIScreen mainScreen].bounds.size.height);
        _shadowButton.alpha = 0.5;
        [UIView beginAnimations:nil context:nil];
        
        [UIView setAnimationDuration:.3];
        _bottomView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - 130+18, 320, 220);
        [UIView commitAnimations];
        isBottomDown =YES;
    }
    
    
    
}
- (void)freePassRadioButtonClick:(id)sender
{
    m_isFreePassButton = YES;
    [self refrshDuoTypeButton];
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    
    int beforBetNum = m_betNumber;
    NSLog(@"%d", btn.tag);
    if (btn.selected) {
        m_betNumber += [self getFreeChuanBetNum:btn.tag - 500];
        if (m_betNumber > 10000) {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高注数不能超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
            m_betNumber = beforBetNum;
            btn.selected = !btn.selected;
        }
        else
            [_freePassRadioIndexArray addObject:[NSNumber numberWithInt:btn.tag]];
    }
    else
    {
        if ([_freePassRadioIndexArray count] == 1) {
            btn.selected = YES;
        }
        else
        {
            m_betNumber -= [self getFreeChuanBetNum:btn.tag - 500];
            
            [_freePassRadioIndexArray removeObject:[NSNumber numberWithInt:btn.tag]];//未勾选的就移除
        }
    }
    NSLog(@"%d", m_betNumber);
    [self refreshData];
}


- (void)duoChuanPassRadioButtonClick:(id)sender
{
    m_isFreePassButton = NO;
    [self refrshPlayTypeButton];
    SingleMutiMixButton* btn = (SingleMutiMixButton*)sender;
    if (btn.selected) {
        return;
    }
    btn.selected = !btn.selected;
    duoChuanPassRadioIndex = btn.tag;
    for (UIView*  viewbtn in _allUpScrollView.subviews)
    {
        if ([viewbtn isKindOfClass:[UIButton class]] && viewbtn != btn) {
            UIButton* tempBtn = (UIButton*)viewbtn;
            tempBtn.selected = NO;
        }
    }
    
//    NSArray* keyArray = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex-1] allKeys];
//    
//    NSString *key = [keyArray objectAtIndex:0];
//    NSString *value = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex-1] objectForKey:key];
//    [self getNoteNumberByDuoChuanRadioTag:value]
    
    m_betNumber = [btn getNoteNumberByDuoChuanRadioTag:btn.titleLabel.text];
    if (m_betNumber > 10000) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"最高注数不能超过10000注！" withTitle:@"提示" buttonTitle:@"确定"];
        m_betNumber = 0;
        btn.selected = NO;
    }
    
    
    [self refreshData];
}


//计算单式过关的注数
- (NSInteger)getFreeChuanBetNum:(NSInteger)X
{
    int count = 0;
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    int Dan_count = 0;
    
    JZ_CombineList* noDanArray = [[JZ_CombineList alloc] init];
    JZ_CombineList* danArray = [[JZ_CombineList alloc] init];
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
        if ([(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
            [danArray appendList:[[m_duoChuanChooseArray combineList] objectAtIndex:i]];
        }
        else
            [noDanArray appendList:[[m_duoChuanChooseArray combineList] objectAtIndex:i]];
    }
    
    int danBetNum = 1;//胆组合的总数
    for (int d = 0; d < [danArray.combineList count]; d++) {
        JZ_CombineBase* base = [danArray.combineList objectAtIndex:d];
        danBetNum *= [base gameCount];
    }
    
    //选X－Dan_count场
    int b[X-Dan_count];
    JZ_CombineListArray *listArrayTemp = [[JZ_CombineListArray alloc] init];
    jzcombine(a, duoChuanChooseArraycount - Dan_count, X-Dan_count, b, X-Dan_count,listArrayTemp,noDanArray);//在没有胆的比赛中选（X－胆）场
    
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        JZ_CombineList* List = (JZ_CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int tempCount = danBetNum;
        for (int i = 0; i < [List.combineList count]; i ++) {
            JZ_CombineBase* base = [List.combineList objectAtIndex:i];
            tempCount *= [base gameCount];
        }
        count += tempCount;
    }
    return count;
}
-(void) initAppendArrangePS{
    if (m_Com_SParray != nil)
    {
        [m_Com_SParray release];
    }
    m_Com_SParray = [[JZ_CombineList alloc] init];
}
-(void) appendArrangePS:(JZ_CombineBase*) PS
{
    if (m_Com_SParray == nil)
    {
        m_Com_SParray = [[JZ_CombineList alloc] init];
    }
    JZ_CombineBase* base = [[JZ_CombineBase alloc] init];
    for (int i = 0; i < [[PS combineBase_SP] count]; i++)
    {
        [[base combineBase_SP] addObject:(NSString*)[[PS combineBase_SP] objectAtIndex:i]];
    }
    base.isDan = [PS isDan];
    [m_Com_SParray appendList:base];
    [base release];
}



-(void)refrshDuoTypeButton//清空多串过关的勾选
{
    if (duoChuanPassRadioIndex>-1)
    {
        m_betNumber = 0;
        m_minWinAmount = 0.00;
        m_maxWinAmount = 0.00;
        UIButton *numBtn = (UIButton*)[_allUpScrollView viewWithTag:duoChuanPassRadioIndex];
        numBtn.selected = NO;
        duoChuanPassRadioIndex = -1;
     }
                
           
    
}



-(void)refrshPlayTypeButton//清空所有自由过关
{
    if ([_freePassRadioIndexArray count]>0)
    {
        m_betNumber = 0;
        m_minWinAmount = 0.00;
        m_maxWinAmount = 0.00;
        for (UIView*  viewbtn in _allUpScrollView.subviews)
        {
                for (NSNumber *numKey in _freePassRadioIndexArray)
                {
                    int num = [numKey intValue];
                    UIButton *numBtn = (UIButton*)[_allUpScrollView viewWithTag:num];
                            numBtn.selected = NO;
                }
                
                
            
        }
        [_freePassRadioIndexArray removeAllObjects];
    }

}


//刷新注数，金额和预计奖金
- (void) refreshData
{
    int fieldText = [self.fieldBeishu.text intValue];
    
    if (m_isDanGuan)
    {
        //         2011年10月11日，足球比分游戏和篮球胜分差游戏的单关销售由原来的“浮动奖金”升级为“固定奖金”。也就是说，您购彩竞彩足球比分和篮球胜分差的单关时，会按照投注出票时的奖金进行计奖返奖。
        //
        //         例如：用户购买1场比赛，出票时的奖金是5.5，倍投为10
        //
        //         那么用户这个单关固定奖金投注所获得的奖金是=2元×5.5×10，奖金是110元
        m_minWinAmount = 0.00;
        m_maxWinAmount = 0.00;
        if (m_playTypeTag == IJCLQPlayType_SFC_DanGuan ||
            m_playTypeTag == IJCZQPlayType_Score_DanGuan)
        {
            m_minWinAmount = [[[(JZ_CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue] * 2.0;
            
            float maxAmount = 0.0;
            for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
            {
                maxAmount += [[[(JZ_CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0]floatValue] * 2.0;
            }
            m_maxWinAmount = maxAmount ;
        }
        
        else
        {
            m_minWinAmount = [[[(JZ_CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:0] combineBase_SP] objectAtIndex:0] floatValue];
            //            m_minWinAmount = [[m_arrangeSP_Min objectAtIndex:0] floatValue];
            
            float maxAmount = 0.0;
            for (int a = 0; a < [[m_Com_arrangeSP_Max combineList] count]; a++)
            {
                maxAmount += [[[(JZ_CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:a] combineBase_SP] objectAtIndex:0] floatValue];
            }
            m_maxWinAmount = maxAmount ;
        }
    }
    else
    {
        if (m_isFreePassButton && m_numGameCount >= 2)
        {
            m_minWinAmount = 0.00;
            m_maxWinAmount = 0.00;
            
            m_maxAmount_Confusion = 0.0;
            m_minAmount_Confusion = 0.0;
            
            float minMonney = 0;
            float maxMonney = 0;
            
            for (int a = 0; a < [_freePassRadioIndexArray count]; a++) {
                
                if (self.playTypeTag == IJCLQPlayType_Confusion ||
                    self.playTypeTag == IJCZQPlayType_Confusion) {
                    
                    [self calculationWinAmountForConfusion:[[_freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                    
                    if (a == 0) {
                        minMonney = m_minAmount_Confusion;
                    }
                    minMonney > m_minAmount_Confusion ? (minMonney = m_minAmount_Confusion) : (minMonney);
                    
                    maxMonney += m_maxAmount_Confusion;
                }
                else
                {
                    //计算最小的奖金
                    [self getMinWinAmountByX:[[_freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                    if (a == 0) {
                        minMonney = m_minWinAmount;
                    }
                    minMonney > m_minWinAmount ? (minMonney = m_minWinAmount) : (minMonney);
                    
                    //计算最大的奖金
                    NSLog(@"%@",_freePassRadioIndexArray);
                    [self calculationAmountBy_X_Y:[[_freePassRadioIndexArray objectAtIndex:a] intValue] - 500 Y:1];
                    maxMonney += m_maxWinAmount;
                }
                
            }
            m_maxWinAmount = maxMonney;
            m_minWinAmount = minMonney;
        }
    }
    //    m_betNumber = count;
    
    m_allCount = m_betNumber * 2.0 * fieldText * 100;
    self.zhuBeiLable.text = [NSString stringWithFormat:@"%d注×%@倍 ", m_betNumber,_fieldBeishu.text];
    self.totalCost.text = [NSString stringWithFormat:@"共%.0lf元", m_allCount /100.0];
    self.bonusLable.text = [NSString stringWithFormat:@"%0.2lf元 -- %0.2lf元", m_minWinAmount * fieldText,m_maxWinAmount * fieldText];
    
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", fieldText];
}

#pragma mark betCode method
- (void)buildBetCode
{
    //by huangxin
    int numBeishu = [self.fieldBeishu.text intValue];


    NSString* betCode = @"";
    if (m_isDanGuan)
    {
        
        betCode = [betCode stringByAppendingFormat:@"%d@",500];

        
        betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,m_betNumber * 200];
    }
    else
    {
        if (m_isFreePassButton)
        {
            int RadioIndexArrayCount = [_freePassRadioIndexArray count];
            for (int a = 0; a < RadioIndexArrayCount; a++) {
                if (m_DanCount > 0)
                {
                    betCode = [betCode stringByAppendingFormat:@"%d@",[[_freePassRadioIndexArray objectAtIndex:a] intValue] + 100];
                }
                else
                    betCode = [betCode stringByAppendingFormat:@"%d@",[[_freePassRadioIndexArray objectAtIndex:a] intValue]];
                
                betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
                
                int betNum = [self getFreeChuanBetNum:[[_freePassRadioIndexArray objectAtIndex:a] intValue] - 500];
                betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,betNum * 200];
                if (a < RadioIndexArrayCount - 1) {
                    betCode = [betCode stringByAppendingString:@"!"];
                }
            }
        }
        else
        {
            NSArray* keyArray = [(NSDictionary*)[m_duoChuanPassRadioArray objectAtIndex:duoChuanPassRadioIndex-1] allKeys];
            NSString *key = [keyArray objectAtIndex:0];
            
            int keyNumber = [key intValue];
            
            if (m_DanCount > 0) {
                keyNumber += 100;
            }
            
            betCode = [betCode stringByAppendingFormat:@"%@@",[NSString stringWithFormat:@"%d",keyNumber]];
            betCode = [betCode stringByAppendingFormat:@"%@",m_chooseBetCode];
            betCode = [betCode stringByAppendingFormat:@"_%d_200_%d",numBeishu,m_betNumber * 200];
        }
    }
    
    [RuYiCaiLotDetail sharedObject].betCode = betCode;
    
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = [RuYiCaiLotDetail sharedObject].betCode;
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithFormat:@"%.0lf",m_allCount];
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", numBeishu];
    [RuYiCaiLotDetail sharedObject].batchNum = @"1";
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    [RuYiCaiLotDetail sharedObject].batchCode = @"";
    
    [RuYiCaiLotDetail sharedObject].amount = [NSString stringWithFormat:@"%.0lf",m_allCount];
}

//组合数算法
void jzcombine( int a[], int n, int m, int b[], const int M ,JZ_CombineListArray *ListArraybase, JZ_CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            jzcombine(a,i-1,m-1,b,M,ListArraybase,data);
        else      // m == 1, 输出一个组合
        {
            JZ_CombineList *array = [[JZ_CombineList alloc] init];
            for(int j=M-1; j>=0; j--)
            {
                JZ_CombineBase* base = (JZ_CombineBase*)[[data combineList] objectAtIndex:b[j]];
                JZ_CombineBase* baseBase = [[JZ_CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                baseBase.gameCount = [base gameCount];
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    //                    [base.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                
                [array appendList:baseBase];
                [baseBase release];
            }
            [ListArraybase appendListArray:array];
            [array release];
        }
    }
}

void jzcombine_List( int a[], int n, int m,  int b[], const int M,JZ_CombineList *listbase,JZ_CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            jzcombine_List(a,i-1,m-1,b,M,listbase,data);
        else      // m == 1, 输出一个组合
        {
            for(int j=M-1; j>=0; j--)
            {
                JZ_CombineBase* base = (JZ_CombineBase*)[[data combineList] objectAtIndex:b[j]];
                JZ_CombineBase* baseBase = [[JZ_CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                baseBase.gameCount = [base gameCount];
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [listbase appendList:baseBase];
                [baseBase release];
            }
        }
    }
}

void jzcombine_SP(float a[], int n, int m, int b[], const int M ,JZ_CombineListArray *ListArraybase,JZ_CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            jzcombine_SP(a,i-1,m-1,b,M,ListArraybase,data);
        else      // m == 1, 输出一个组合
        {
            JZ_CombineList *array = [[JZ_CombineList alloc] init];
            for(int j=M-1; j>=0; j--)
            {
                JZ_CombineBase* base = (JZ_CombineBase*)[[data combineList] objectAtIndex:b[j]];
                JZ_CombineBase* baseBase = [[JZ_CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                for (int sp = 0; sp < [[base combineBase_SP] count]; sp++) {
                    [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:sp]];
                }
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [array appendList:baseBase];
                [baseBase release];
            }
            [ListArraybase appendListArray:array];
            [array release];
        }
    }
}
void jzcombine_SP_List(float a[], int n, int m, int b[], const int M ,JZ_CombineList *listbase,JZ_CombineList* data)
{
    for(int i=n; i>=m; i--)  // 注意这里的循环范围
    {
        b[m-1] = i - 1;
        if (m > 1)
            jzcombine_SP_List(a,i-1,m-1,b,M,listbase,data);
        else      // m == 1, 输出一个组合
        {
            for(int j=M-1; j>=0; j--)
            {
                JZ_CombineBase* base = (JZ_CombineBase*)[[data combineList] objectAtIndex:b[j]];
                JZ_CombineBase* baseBase = [[JZ_CombineBase alloc ]init];
                baseBase.isDan = [base isDan];
                for (int sp = 0; sp < [[base combineBase_SP] count]; sp++) {
                    [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:sp]];
                }
                for (int  k= 0; k < [[base combineBase_SP_confusion] count]; k++) {
                    [baseBase.combineBase_SP_confusion replaceObjectAtIndex:k withObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                    
                    //                    [baseBase.combineBase_SP_confusion addObject:[[base combineBase_SP_confusion] objectAtIndex:k]];
                }
                [listbase appendList:baseBase];
                [baseBase release];
            }
        }
    }
}



void jzcombine_SP_confusion(NSMutableArray* result,NSArray* data,int curr,int count,NSMutableArray* temp_baseArray)
{
    if (curr == count)
    {
        NSLog(@" @@@@@@@@@@@@@@@ \n%@ ",temp_baseArray);
        [result addObject:temp_baseArray];
        [temp_baseArray removeAllObjects];
    }
    else
    {
        int i;
        NSArray* array = [data objectAtIndex:curr];
        for (i = 0; i < [array count]; ++i)
        {
            [temp_baseArray addObject:[array objectAtIndex:i]];
            jzcombine_SP_confusion(result,data, curr+1,count,temp_baseArray);
        }
    }
}

//计算复式过关的注数
- (NSInteger)getDuoChuanBetNum:(NSInteger)X  ChangShu:(NSInteger)Y
{
    int count = 0;
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    int Dan_count = 0;
    
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
        if ([(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
        }
    }
    
    //选X场
    int b[X];
    JZ_CombineListArray *listArrayTemp = [[JZ_CombineListArray alloc] init];
    jzcombine(a, duoChuanChooseArraycount, X, b, X,listArrayTemp,m_duoChuanChooseArray);//在n个数中选取m
    
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        JZ_CombineList* List = (JZ_CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int tempCount = 1;
        BOOL isHaveDan = NO;//是否剔除不含胆的场数
        NSInteger danCount = 0;
        for (int i = 0; i < [List.combineList count]; i ++) {
            JZ_CombineBase* base = [List.combineList objectAtIndex:i];
            
            isHaveDan += Dan_count <= Y - X ? YES : base.isDan;
            danCount += base.isDan;//胆个数
            tempCount *= base.gameCount;//每种组合选择个数之积
            if (i == [List.combineList count] - 1) {//考虑胆数量
                if (X == Y) {
                    tempCount = danCount == m_DanCount ? tempCount : 0;
                }
                else
                    tempCount = isHaveDan >= (X - (Y - Dan_count)) ? tempCount : 0;//6场 3个胆 4串4
            }
        }
        if (Dan_count == 0 || Dan_count == danCount) {//重复数 跟胆相关
            tempCount *= RYCChoose(Y - X, self.numGameCount-X);
        }
        else if (Dan_count != 0 && danCount < Dan_count)
        {
            if (RYCChoose(Y - X - (Dan_count - danCount), self.numGameCount - Dan_count - (X - danCount)) != 0) {
                tempCount *= RYCChoose(Y - X - (Dan_count - danCount), self.numGameCount - Dan_count - (X - danCount));
            }
        }
        else if(!isHaveDan)//不考虑要包含胆的组合 的重复数
            tempCount *= RYCChoose(Y - X - Dan_count, self.numGameCount - X - Dan_count);
        count += tempCount;
    }
    NSLog(@"count1 %d" ,count);
    
    return count;
}

#pragma mark 计算除混合过关的预计奖金
- (void) appendDuoChuanChoose:(NSString*)chooseCount IS_DAN:(BOOL)is_Dan CONFUSION:(NSArray*)confusion_array
{
    if (m_duoChuanChooseArray == nil) {
        m_duoChuanChooseArray = [[JZ_CombineList alloc] init];
    }

    JZ_CombineBase* base = [[[JZ_CombineBase alloc]init] autorelease];
    [base setGameCount:[chooseCount intValue]];
    [base setIsDan:is_Dan];
    if (confusion_array != nil) {
        for(int i = 0; i < [confusion_array count]; i++) {
            
            [[base combineBase_SP_confusion] replaceObjectAtIndex:i withObject:[confusion_array objectAtIndex:i]];
            //            [base.combineBase_SP_confusion addObject:[confusion_array objectAtIndex:i]];
        }
    }
    
    [m_duoChuanChooseArray appendList:base];
}

-(void) sortSPArray
{
    //排序     //对几场比赛排序 从小到大
    if (m_Com_arrangeSP_Min != nil)
    {
        [m_Com_arrangeSP_Min release];
    }
    m_Com_arrangeSP_Min = [[JZ_CombineList alloc] init];

    int spCount = [[m_Com_SParray combineList] count];
    for (int spindex = 0; spindex < spCount; spindex++)
    {
        JZ_CombineBase *baseTemp = (JZ_CombineBase*)[[m_Com_SParray combineList] objectAtIndex:spindex];
        JZ_CombineBase* base = [[[JZ_CombineBase alloc] init] autorelease];
        int SPCount = [[baseTemp combineBase_SP] count];
        float minValue = 0;
        for (int i = 0; i < SPCount; i++)
        {
            float value = [[[baseTemp combineBase_SP] objectAtIndex:i] floatValue];
            if (i == 0)
            {
                minValue = value;
            }
            else
            {
                if (minValue > value)
                {
                    minValue = value;
                }
            }
        }
        base.isDan = [baseTemp isDan];
        [[base combineBase_SP] addObject:[NSString stringWithFormat:@"%f",minValue]];
        
        [m_Com_arrangeSP_Min appendList:base];
    }
    
    int arraySPcount = [[m_Com_arrangeSP_Min combineList] count];
    float a[arraySPcount];
    //存放临时 的m_Com_arrangeSP_Min
    JZ_CombineList* Com_arrangeSP_Min_Temp = [[[JZ_CombineList alloc] init] autorelease];
    for (int arrange_i = 0; arrange_i < arraySPcount; arrange_i++)
    {
        JZ_CombineBase* base = (JZ_CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:arrange_i];
        float value = [[[base combineBase_SP] objectAtIndex:0] floatValue];
        a[arrange_i] = value;
        
        JZ_CombineBase* baseBase = [[[JZ_CombineBase alloc] init] autorelease];
        baseBase.isDan = [base isDan];
        [[baseBase combineBase_SP] addObject:[NSString stringWithFormat:@"%f",value]];
        [Com_arrangeSP_Min_Temp appendList:baseBase];
    }
    
    [[m_Com_arrangeSP_Min combineList] removeAllObjects];
    
    int sort_IndexArray[arraySPcount];//排序之后的 索引
    int index = 0;
    while(index < arraySPcount)
    {
        sort_IndexArray[index]=index;
        index++;
    }
    
    int m_i,m_j;
    float m_temp;
    
    for(m_j = 0;m_j < arraySPcount;m_j++)
    {
        for (m_i = m_j + 1; m_i < arraySPcount; ++m_i)
        {
            if (a[m_j] > a[m_i])
            {
                m_temp = a[m_j];
                a[m_j] = a[m_i];
                a[m_i] = m_temp;
                
                m_temp = sort_IndexArray[m_j];
                sort_IndexArray[m_j] = sort_IndexArray[m_i];
                sort_IndexArray[m_i] = m_temp;
            }
        }
        
    }
    
    for (int arrange_i = 0  ; arrange_i <arraySPcount; arrange_i++)
    {
        JZ_CombineBase* base = (JZ_CombineBase*)[[Com_arrangeSP_Min_Temp combineList] objectAtIndex:sort_IndexArray[arrange_i]];
        JZ_CombineBase* baseBase = [[[JZ_CombineBase alloc] init] autorelease];
        baseBase.isDan = [base  isDan];
        
        //        NSLog(@"%@",[base combineBase_SP]);
        
        [[baseBase combineBase_SP] addObject:[[base combineBase_SP] objectAtIndex:0]];
        [m_Com_arrangeSP_Min  appendList:base];
        
    }
    
    //////////////////////////////////////////排序     //对几场比赛排序 从大到小
    if (m_Com_arrangeSP_Max != nil)
    {
        [m_Com_arrangeSP_Max release];
    }
    m_Com_arrangeSP_Max = [[JZ_CombineList alloc] init ];
    int sp_max_Count = [[m_Com_SParray combineList] count];
    for (int spindex = 0; spindex < sp_max_Count; spindex++)
    {
        JZ_CombineBase *baseTemp = (JZ_CombineBase*)[[m_Com_SParray combineList] objectAtIndex:spindex];
        JZ_CombineBase* base = [[[JZ_CombineBase alloc] init] autorelease];
        int SPCount = [[baseTemp combineBase_SP] count];
        float maxValue = 0.0;
        for (int i = 0; i < SPCount; i++)
        {
            float value = [[[baseTemp combineBase_SP] objectAtIndex:i] floatValue];
            if (i == 0)
            {
                maxValue = value;
            }
            else
            {
                if (maxValue < value)
                {
                    maxValue = value;
                }
            }
        }
        base.isDan = [baseTemp isDan];
        [[base combineBase_SP] addObject:[NSString stringWithFormat:@"%f",maxValue]];
        [m_Com_arrangeSP_Max appendList:base];
    }
    
    int arraySP_maxcount = [[m_Com_arrangeSP_Max combineList] count];
    float max_a[arraySP_maxcount];
    
    //存放临时 的m_Com_arrangeSP_Max
    JZ_CombineList* Com_arrangeSP_Max_Temp = [[[JZ_CombineList alloc] init] autorelease];
    for (int arrange_i = 0; arrange_i < arraySP_maxcount; arrange_i++)
    {
        JZ_CombineBase* base =(JZ_CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:arrange_i];
        float value = [[[base combineBase_SP] objectAtIndex:0] floatValue];
        max_a[arrange_i] = value;
        
        JZ_CombineBase* baseBase = [[[JZ_CombineBase alloc] init] autorelease];
        baseBase.isDan = [base isDan];
        [[baseBase combineBase_SP] addObject:[NSString stringWithFormat:@"%f",value]];
        [Com_arrangeSP_Max_Temp appendList:baseBase];
    }
    [[m_Com_arrangeSP_Max combineList] removeAllObjects];
    
    int sort_Max_IndexArray[arraySP_maxcount];//排序之后的 索引
    index = 0;
    while(index < arraySP_maxcount)
    {
        sort_Max_IndexArray[index]=index;
        index++;
    }
    
    //排序
    {
        int m_i,m_j;
        float m_temp;
        for(m_j = 0;m_j < arraySP_maxcount;m_j++)
        {
            for (m_i = m_j + 1; m_i < arraySP_maxcount; ++m_i)
            {
                if (max_a[m_j] < max_a[m_i])
                {
                    m_temp = max_a[m_j];
                    max_a[m_j] = max_a[m_i];
                    max_a[m_i] = m_temp;
                    
                    m_temp = sort_Max_IndexArray[m_j];
                    sort_Max_IndexArray[m_j] = sort_Max_IndexArray[m_i];
                    sort_Max_IndexArray[m_i] = m_temp;
                }
            }
            
        }
    }
    
    for (int arrange_i = 0; arrange_i < arraySPcount; arrange_i++)
    {
        JZ_CombineBase* base = (JZ_CombineBase*)[[Com_arrangeSP_Max_Temp combineList] objectAtIndex:(sort_Max_IndexArray[arrange_i])];
        JZ_CombineBase* baseBase = [[[JZ_CombineBase alloc] init] autorelease];
        baseBase.isDan = [base  isDan];
        [[baseBase combineBase_SP] addObject:(NSString*)[[base combineBase_SP] objectAtIndex:0]];
        [m_Com_arrangeSP_Max  appendList:base];
    }

}

//获得最小的奖金
-(float) getMinWinAmountByX:(NSInteger)X
{
    m_minWinAmount = 0.0;
    int Xindex = 0;
    /*
     先取出 含胆的 比赛
     */
    for (int j = 0;j < [[m_Com_arrangeSP_Min combineList] count]; j++)
    {
        if (j == 0) {
            m_minWinAmount = 1.0;
        }
        JZ_CombineBase* base = (JZ_CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:j];
        if ([base isDan]) {
            m_minWinAmount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    /*
     补全 X 串 y
     */
    for (int i = 0;i < [[m_Com_arrangeSP_Min combineList] count]; i++)
    {
        if (Xindex >= X) {
            break;
        }
        JZ_CombineBase* base = (JZ_CombineBase*)[[m_Com_arrangeSP_Min combineList] objectAtIndex:i];
        if (![base isDan]) {
            m_minWinAmount *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
            Xindex++;
        }
    }
    m_minWinAmount *= 2.0;
    return m_minWinAmount;
}



//***************************************************
//by huangxin add
//计算除了混合玩法之外的各种玩法的预计最大奖金
//含胆和不含胆，Y为1的情况都能够计算
//***************************************************
- (void) calculationAmountBy_X_Y:(NSInteger)x Y:(NSInteger)y
{
    m_maxWinAmount = 0.0;
    int MaxSP_Count = [[m_Com_arrangeSP_Max combineList] count];
    float SP_a[MaxSP_Count];
    
    int Dan_count = 0;
    for (int i = 0; i < MaxSP_Count; i++)
    {
        float value = [[[(JZ_CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0]floatValue];
        SP_a[i] = value;
        if ([(JZ_CombineBase*)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i] isDan])
        {
            Dan_count++;
        }
    }
    
    //如果不含胆
    if (Dan_count == 0) {
        
        JZ_CombineListArray *SP_listArrayTemp = [[JZ_CombineListArray alloc] init];
        float peilv = 0.0;
        
        if (y == 1) {
            
            int SP_c[x];
            jzcombine_SP(SP_a, MaxSP_Count, x, SP_c, x,SP_listArrayTemp,m_Com_arrangeSP_Max);//在n场比赛中选取m场
            for (int i = 0; i < [[SP_listArrayTemp combineListArray] count]; i++) {
                
                JZ_CombineList* list = (JZ_CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i];
                
                int listCount  = [[list combineList] count];
                
                for (int m = 0; m < listCount; m++) {
                    
                    JZ_CombineBase* base = (JZ_CombineBase*)[[(JZ_CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i] combineList] objectAtIndex:m];
                    
                    if (m == 0) {
                        peilv = 1.0;
                    }
                    peilv *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
                }
                
                m_maxWinAmount += peilv;
            }
        }
        else
        {
            
            int SP_b[y];
            jzcombine_SP(SP_a, MaxSP_Count, y, SP_b, y,SP_listArrayTemp,m_Com_arrangeSP_Max);//在n场比赛中选取m场
            
            int num = RYCChoose(x - y, MaxSP_Count - y);
            for (int j = 0;j < [[SP_listArrayTemp combineListArray] count]; j++)
            {
                JZ_CombineList* list = (JZ_CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:j];
                
                int listCount  = [[list combineList] count];
                
                for (int m = 0; m < listCount; m++) {
                    
                    JZ_CombineBase* base = (JZ_CombineBase*)[[(JZ_CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:j] combineList] objectAtIndex:m];
                    if (m == 0) {
                        peilv = 1.0;
                    }
                    peilv *= [[[base combineBase_SP] objectAtIndex:0] floatValue];
                }
                
                m_maxWinAmount += peilv * (double)num;
            }
        }
        m_maxWinAmount *= 2.0;
        [SP_listArrayTemp release];
    }
    else //含胆
    {
        //第一步：把选择的比赛分成含胆和不含胆的两部分
        JZ_CombineList *dan_ListArray = [[JZ_CombineList alloc] init];//含胆的比赛
        JZ_CombineList *no_dan_ListArray = [[JZ_CombineList alloc] init];//不含胆的比赛
        
        for (int i = 0; i < MaxSP_Count; i++)
        {
            JZ_CombineBase *base = (JZ_CombineBase *)[[m_Com_arrangeSP_Max combineList] objectAtIndex:i];
            if ([base isDan]) {
                
                [dan_ListArray appendList:base];
            }
            else
            {
                [no_dan_ListArray appendList:base];
            }
        }
        //第二步：根据胆的个数分情况,计算不含胆部分的最大赔率
        if (x <= Dan_count) {
            
            NSLog(@"胆大!");
        }
        else
        {
            JZ_CombineListArray *SP_listArrayTemp = [[JZ_CombineListArray alloc] init];
            
            int no_dan_array_count = [[no_dan_ListArray combineList] count];
            float SP_no_a[no_dan_array_count];
            
            
            
            for (int i = 0; i < no_dan_array_count; i++)
            {
                float value = [[[(JZ_CombineBase*)[[no_dan_ListArray combineList] objectAtIndex:i] combineBase_SP] objectAtIndex:0] floatValue];
                SP_no_a[i] = value;
            }
            
            float dan_peilv = 0.0;
            for (int dan_i = 0; dan_i < [[dan_ListArray combineList] count]; dan_i++) {
                
                float value = [[[(JZ_CombineBase*)[[dan_ListArray combineList] objectAtIndex:dan_i] combineBase_SP] objectAtIndex:0] floatValue];
                if (dan_i == 0) {
                    dan_peilv = 1.0;
                }
                dan_peilv *= value;
            }
            int SP_c[x - Dan_count];
            jzcombine_SP(SP_no_a, no_dan_array_count, x - Dan_count, SP_c, x - Dan_count,SP_listArrayTemp,no_dan_ListArray);//在n场比赛中选取m场
            
            for (int i = 0; i < [[SP_listArrayTemp combineListArray] count]; i++)
            {
                JZ_CombineList* list = (JZ_CombineList*)[[SP_listArrayTemp combineListArray] objectAtIndex:i];
                
                JZ_CombineList *addDan_List = [[JZ_CombineList alloc] init];
                
                
                for (int list_i = 0; list_i < [[list combineList] count]; list_i++) {
                    
                    JZ_CombineBase* base = (JZ_CombineBase *)[[list combineList] objectAtIndex:list_i];
                    [addDan_List appendList:base];
                }
                //用得到的不含胆的比赛补全
                for (int k = 0; k < [[dan_ListArray combineList] count]; k++) {
                    
                    JZ_CombineBase* base = (JZ_CombineBase *)[[dan_ListArray combineList] objectAtIndex:k];
                    [addDan_List appendList:base];
                }
                //
                int listCount  = [[addDan_List combineList] count];
                float SP_bu_a[listCount];
                for (int h = 0; h < listCount; h++)
                {
                    float value = [[[(JZ_CombineBase*)[[addDan_List combineList] objectAtIndex:h] combineBase_SP] objectAtIndex:0]floatValue];
                    SP_bu_a[h] = value;
                }
                
                JZ_CombineListArray *SP_bu_listArrayTemp = [[JZ_CombineListArray alloc] init];
                float peilv = 0.0;
                
                if (y == 1)
                {
                    int numCount = [[list combineList] count];
                    for (int j = 0; j < numCount; j++) {
                        
                        JZ_CombineBase *listBase = (JZ_CombineBase*)[[list combineList] objectAtIndex:j];
                        
                        if (j == 0) {
                            peilv = 1.0;
                        }
                        peilv *= [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
                    }
                    peilv = peilv * dan_peilv;
                    m_maxWinAmount += peilv;
                }
                else
                {
                    int SP_b[y];
                    jzcombine_SP(SP_bu_a, listCount, y, SP_b, y,SP_bu_listArrayTemp,addDan_List);//在n场比赛中选取m场
                    
                    int num = RYCChoose(x - y, listCount - y);
                    for (int j = 0;j < [[SP_bu_listArrayTemp combineListArray] count]; j++)
                    {
                        JZ_CombineList* bu_list = (JZ_CombineList*)[[SP_bu_listArrayTemp combineListArray] objectAtIndex:j];
                        
                        for (int m = 0; m < [[bu_list combineList] count]; m++) {
                            
                            JZ_CombineBase* listBase = (JZ_CombineBase*)[[(JZ_CombineList*)[[SP_bu_listArrayTemp combineListArray] objectAtIndex:j] combineList] objectAtIndex:m];
                            if (m == 0) {
                                peilv = 1.0;
                            }
                            peilv *= [[[listBase combineBase_SP] objectAtIndex:0] floatValue];
                        }
                        
                        m_maxWinAmount += peilv * (double)num;
                    }
                }
                [SP_bu_listArrayTemp release];
                [addDan_List release];
            }
        }
        
        [dan_ListArray release];
        [no_dan_ListArray release];
        m_maxWinAmount *= 2.0;
    }
}



- (BOOL) BetJudement
{
    for (int i = 0; i < self.fieldBeishu.text.length; i++)
    {
        UniChar chr = [self.fieldBeishu.text characterAtIndex:i];
        if ('0' == chr && 0 == i)
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
        else if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return NO;
        }
    }
    
    if([self.fieldBeishu.text intValue] <= 0 || [self.fieldBeishu.text intValue] > 100000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数的范围为1～100000" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    if(m_betNumber == 0)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择至少一注投注" withTitle:@"提示" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}


#pragma mark 计算混合过关的预计奖金

//给一个数组排序  ,选择排序
- (void) sortForArray:(NSMutableArray *) array
{
    int count = [array count];
    if (count <= 1) {
        return;
    }
    
    for (int i = 0; i< count-1; i++) {
        int m =i;
        for (int j =i+1; j<[array count]; j++) {
            if ([[array objectAtIndex:j] floatValue] < [[array objectAtIndex:m] floatValue]) {
                m = j;
            }
        }
        if (m != i) {
            [self swapWithData:array index1:m index2:i];
        }
    }
}


//交换数组里的两个元素的位置

- (void) swapWithData:(NSMutableArray *)adata index1:(NSInteger) index1 index2:(NSInteger) index2{
    
    NSNumber *tmp = [adata objectAtIndex:index1];
    [adata replaceObjectAtIndex:index1 withObject:[adata objectAtIndex:index2]];
    [adata replaceObjectAtIndex:index2 withObject:tmp];
    
}

//从一个数组里面找到x个最小的数，相乘

- (float) calculationMinItemsArray_X:(NSMutableArray*)array X:(int)x
{
    float allCount = 0.0;
    int count = [array count];
    if (count < x) {
        
    }
    else
    {
        for (int i = 0; i < x; i++) {
            if (i == 0) {
                allCount = 1.0;
            }
            allCount *= [[array objectAtIndex:i] floatValue];
        }
    }
    return allCount;
}


//计算混合过关的预计奖金
- (void) calculationWinAmountForConfusion:(int) y
{
    m_minAmount_Confusion = 0.0;
    //    m_maxAmount_Confusion = 0.0;
    
    int count = [[m_duoChuanChooseArray combineList] count];
    NSMutableArray *minSp_Array = [[NSMutableArray alloc] initWithCapacity:1];
    
    //计算最小奖金
    for (int i = 0; i < count; i++)
    {
        JZ_CombineBase *base = (JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i];
        
        NSMutableArray *confusionSPArray = [base combineBase_SP_confusion];
        
        NSMutableArray *oneGame_SPArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        //选出每种玩法中赔率最小的保存下来
        for (int j = 0; j < [confusionSPArray count]; j++) {
            
            NSMutableArray *array = [confusionSPArray objectAtIndex:j];
            if ([array count] > 0) {
                if ([array count] > 1) {
                    [self sortForArray:array];
                    
                }
                [oneGame_SPArray addObject:[array objectAtIndex:0]];
            }
            
        }
        
        if ([oneGame_SPArray count] > 1) {
            
            [self sortForArray:oneGame_SPArray];
        }
        [minSp_Array addObject:[oneGame_SPArray objectAtIndex:0]];
        [oneGame_SPArray release];
    }
    
    if ([minSp_Array count] > 1) {
        [self sortForArray:minSp_Array];
    }
    
    m_minAmount_Confusion = [self calculationMinItemsArray_X:minSp_Array X:y];
    
    [minSp_Array release];
    m_minAmount_Confusion *= 2.0;
    
    //计算最大预计奖金
    [self confusionMaxAmountBy_X:m_numGameCount By_Y:y];
    
    m_maxAmount_Confusion *= 2.0;
}
- (void) confusionMaxAmountBy_X:(int)X By_Y:(int)y
{
    
    m_maxAmount_Confusion = 0.0;//最大的奖金
    int duoChuanChooseArraycount = [[m_duoChuanChooseArray combineList] count];
    int a[duoChuanChooseArraycount];
    for (int i = 0; i < duoChuanChooseArraycount; i++)
    {
        a[i] = [(JZ_CombineBase*)[[m_duoChuanChooseArray combineList] objectAtIndex:i] gameCount];
    }
    
    /*
     第一步 ：
     从 gamecount 里 选出 三场 (X)
     */
    int b[X];
    JZ_CombineListArray *listArrayTemp = [[JZ_CombineListArray alloc] init];
    jzcombine(a, duoChuanChooseArraycount, X, b, X,listArrayTemp,m_duoChuanChooseArray);//在n个数中选取m
    
    
    /*
     第二步 ：
     从 listBase里 选出 2场(Y) ，计算组合数
     */
    int ListArrayCount = [[listArrayTemp combineListArray] count];
    for (int j = 0; j < ListArrayCount; j++)
    {
        JZ_CombineList* List = (JZ_CombineList*)[[listArrayTemp combineListArray] objectAtIndex:j];
        int a_1[[[List combineList] count]];
        int b_1[y];
        for (int m = 0; m < [[List combineList] count]; m++) {
            a_1[m] = [[[List combineList] objectAtIndex:m] gameCount];
        }
        //此处 也是个CombineListArray  例如 3串3 此处 是从选出的三场比赛里 选出2场存储
        JZ_CombineListArray* listArray2Temp = [[JZ_CombineListArray alloc] init];
        jzcombine(a_1, [[List combineList] count], y, b_1, y,listArray2Temp,List);//在n个数中选取m
        
        int listArray2Count = [[listArray2Temp combineListArray] count];
        for (int p = 0; p < listArray2Count; p++)
        {
            JZ_CombineList* List = (JZ_CombineList*)[[listArray2Temp combineListArray] objectAtIndex:p];
            
            [self calculationConfusionAmountOfCombineList:List];
            
        }
    }
    
}


- (void) calculationConfusionAmountOfCombineList:(JZ_CombineList*) listBase
{
    /*
     获得 最后的 最小组合数组 既X串1 得出可能性
     */
    int baseCount = [[listBase combineList] count];
    
    NSMutableArray* array_base_confusion = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    for (int k = 0; k < baseCount; k++)
    {
        JZ_CombineBase* base_base = (JZ_CombineBase*)[[listBase combineList] objectAtIndex:k];
        NSMutableArray* array = [NSMutableArray array];
        BOOL ishave = NO;
        for (int base_confusion_index = 0; base_confusion_index < [[base_base combineBase_SP_confusion] count];base_confusion_index++)
        {
            NSArray* confusion_array = [[base_base combineBase_SP_confusion] objectAtIndex:base_confusion_index];
            if ([confusion_array count] > 0) {
                float confusion_sp = 0;
                ishave = YES;
                for (int i = 0; i < [confusion_array count]; i++) {
                    float currValue = [[confusion_array objectAtIndex:i] floatValue];
                    if (i == 0) {
                        confusion_sp = currValue;
                    }
                    else
                    {
                        confusion_sp < currValue ? confusion_sp = currValue : confusion_sp;
                    }
                }
                [array addObject:[NSNumber numberWithFloat:confusion_sp]];
            }
        }
        if(ishave)
            [array_base_confusion addObject:array];
    }
    /*
     不明白为什么要这么做
     如果 不把array_base_confusion 存放到成员变量，执行完show（）后
     数据会丢失
     */
    m_tempConfusionArray = [[[NSMutableArray alloc] initWithCapacity:4] autorelease];
    for (int i = 0; i < [array_base_confusion count]; i++) {
        NSMutableArray* array = [NSMutableArray arrayWithArray:[array_base_confusion objectAtIndex:i]];
        [m_tempConfusionArray addObject:array];
    }
    if ([array_base_confusion count] > 0)
    {
        const char* data[10];
        char result[10];
        m_tempBase_stringArray = [NSMutableArray array];
        for (int i = 0; i < [array_base_confusion count]; i++) {
            NSArray* array = [NSArray arrayWithArray:[array_base_confusion objectAtIndex:i]];
            NSString* index_array = @"";
            for (int j = 0; j < [array count]; j++) {
                index_array = [index_array stringByAppendingFormat:@"%d",j];
            }
            data[i] = [index_array UTF8String];
        }
        int count = [array_base_confusion count];
        show(result, data, 0, count);
        /*
         例如 取出来的是 A{a(赔率),b,c} B{e,f}
         下标值的 组合为 00，01，10，11，20，21
         */
        //根据下标值 计算奖金
        for (int m = 0; m < [m_tempBase_stringArray count]; m++) {
            float tempnum = 0.0;
            NSString* index_string = [m_tempBase_stringArray objectAtIndex:m];
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < [index_string length]; i++) {
                NSRange range;
                range.length = 1;
                range.location = i;
                [array addObject:[index_string substringWithRange:range]];
            }
            for (int k = 0; k < [array count]; k++)
            {
                if (k == 0) {
                    tempnum = 1;
                }
                int x = [[array objectAtIndex:k] intValue];
                float sp = [[[array_base_confusion objectAtIndex:k] objectAtIndex:x] floatValue];
                tempnum *= sp;
            }
            m_maxAmount_Confusion += tempnum;
        }
    }
    
    
}

- (IBAction)buyClick:(id)sender
{
    //    //保存选择的比赛到关注里面
    //    if ([m_eventChooseGameArray count] > 0) {
    //
    //        [[NSUserDefaults standardUserDefaults] setValue:m_eventChooseGameArray forKey:self.userChooseGameEvent];
    //    }
    //    else
    //    {
    //        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.userChooseGameEvent];
    //    }
    
    
    if (m_betNumber > 10000) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"单笔投注不能超过10000注，请您重新选择玩法" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    
    [RuYiCaiNetworkManager sharedManager].netAppType = NET_APP_BASE;
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    
    if (m_betNumber <= 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"请选择玩法" withTitle:@"投注提示" buttonTitle:@"确定"];
        return;
    }
    
    if([appStoreORnormal isEqualToString:@"appStore"]&&
       [appTestPhone isEqualToString:[RuYiCaiNetworkManager sharedManager].phonenum])
    {
        if([self BetJudement])
        {
            [self buildBetCode];
            [self wapPageBuild];
        }
    }
    else
    {
                if([self BetJudement])
                {
                    [MobClick event:@"JC_bet"];
                    
                    [self buildBetCode];
                    
                    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
                    [dict setObject:@"1" forKey:@"isSellWays"];
                    if (m_minWinAmount != 0.0 || m_maxWinAmount != 0.0) {//预计奖金
                        [dict setObject:[NSString stringWithFormat:@"%0.2lf元-%.2lf元", m_minWinAmount, m_maxWinAmount] forKey:@"expectPrizeAmt"];
                    }
                    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
                }
//            }break;
//            case kSegIndexHM:
//            {
//                [self buildBetCode];
//                [RuYiCaiLotDetail sharedObject].sellWay = @"0";
//                //                [self.LaunchHMView buildBetCode];
//                [self.LaunchHMView LotComplete:nil];
//            }break;
//                
//            default:
//                break;
//        }
    }
}

- (void)wapPageBuild
{
    if([[RuYiCaiNetworkManager sharedManager] testConnection])
    {
        NSMutableDictionary* mDict = [[RuYiCaiNetworkManager sharedManager] getCommonCookieDictionary];
        [mDict setObject:@"betLot" forKey:@"command"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].phonenum forKey:@"phonenum"];
        [mDict setObject:[RuYiCaiNetworkManager sharedManager].userno forKey:@"userno"];
        if([RuYiCaiLotDetail sharedObject].batchCode)
            [mDict setObject:[RuYiCaiLotDetail sharedObject].batchCode forKey:@"batchcode"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].batchNum forKey:@"batchnum"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuBetCode forKey:@"bet_code"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotNo forKey:@"lotno"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].lotMulti forKey:@"lotmulti"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].moreZuAmount forKey:@"amount"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].betType forKey:@"bettype"];
        [mDict setObject:[RuYiCaiLotDetail sharedObject].sellWay forKey:@"sellway"];
        [mDict setObject:@"1" forKey:@"isSellWays"];
        
        SBJsonWriter *jsonWriter = [SBJsonWriter new];
        NSString* cookieStr = [jsonWriter stringWithObject:mDict];
        [jsonWriter release];
        
        NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
        NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
        NSString *AESstring = [[[NSString alloc] initWithData:sendData encoding:NSUTF8StringEncoding] autorelease];
        
        NSMutableString *sendStr = [NSMutableString stringWithFormat:
                                    @"%@",kRuYiCaiBetSafari];
        NSString *allStr = [sendStr stringByAppendingString:AESstring];
        //        NSLog(@"safari:%@ ", allStr);
        
        NSString *strUrl = [allStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"检测不到网络" withTitle:@"提示" buttonTitle:@"确定"];
    }
}

#pragma mark 投注余额不足处理
- (void)notEnoughMoney:(NSNotification*)notification
{
    
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:CaiJinDuiHuanTiShi
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
    //            [alterView addButtonWithTitle:@"直接支付"];
    [alterView addButtonWithTitle:@"免费兑换"];
    alterView.tag = 112;
    [alterView show];
    [alterView release];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(1 == buttonIndex)//去充值
        {
            [self setHidesBottomBarWhenPushed:YES];
            
            ExchangeLotteryWithIntegrationViewController* viewController = [[ExchangeLotteryWithIntegrationViewController alloc] init];
            viewController.isShowBackButton = YES;

            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
    
