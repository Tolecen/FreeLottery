//
//  HXBX_KSBet_ViewController.m
//  Boyacai
//
//  Created by fengyuting on 13-10-28.
//
//

#import "HXBX_KSBet_ViewController.h"
#import "AdaptationUtils.h"
#import "BackBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "KSCutomerControl.h"
#import "KSLotterysModel.h"
#import "BetTabelViewCell.h"
#import "KS_PickNumberViewController.h"
#import "RuYiCaiNetworkManager.h"
#import "CustomColorButtonUtils.h"
#import "ProtocolViewController.h"

#define GOTOBACK 100            //返回
#define CLEARDATASOURCE 101     //清空
#define BETOUTTIME 102          //投注超时
#define NOTENOUGHMONEY 103      //余额不足

@interface HXBX_KSBet_ViewController ()
{
    BOOL isRegetBetcode;
}
@end

@implementation HXBX_KSBet_ViewController

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
    // Do any additional setup after loading the view from its nib.
    [AdaptationUtils adaptation:self];
    //[BackBarButtonItemUtils addBackButtonForController:self];
    
    //进入快三界面后将navigationBar的背景颜色改变
    [self.navigationController.navigationBar setNavigationBackgroundColor:[ColorUtils parseColorFromRGB:@"#5b0418"]];
    
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(goToBack) andAutoPopView:NO normalImage:@"KS_back_normal.png" highlightedImage:@"KS_back_highlighted.png"];
    UIButton * leftButton = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [leftButton setTitle:@"购彩大厅" forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 70, 26);

    [TitleViewButtonItemUtils addTitleViewForController:self title:@"快三投注" font:[UIFont boldSystemFontOfSize:20.f] textColor:[ColorUtils parseColorFromRGB:@"#fcdcdc"]];
    
    [self.view setBackgroundColor:[ColorUtils parseColorFromRGB:@"#004b47"]];
    
    //[BackBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(moreAction)];
    
    [self setHeaderView];//添加headerView
    
    [self addTableView];
    
    [self setBottomView];//添加bottomView
    
}

#pragma - mark
#pragma - mark 摇一摇

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddeKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betOutTime:) name:@"betOutTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notEnoughMoney:) name:@"notEnoughMoney" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentsChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(betCaseLotOKClick:) name:@"betCaseLotOKClick" object:nil];
    
    [self.tableView reloadData];
    
    [self becomeFirstResponder];
    
    [self changeMoneyLabel];
}


-(BOOL)canBecomeFirstResponder{
    
    return YES;
}

-(void)reloadTableViewData{
    NSLog(@"%@",self.dataSource);
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self changeMoneyLabel];
    //[self.tableView reloadData];
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (motion == UIEventSubtypeMotionShake) {
        [self addMashionSelectedNumber:nil];
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betOutTime" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notEnoughMoney" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"betCaseLotOKClick" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
}


-(void)showKeyBoard:(NSNotification *)notification{
    
    CGRect keyBoardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backgroundButton.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - keyBoardFrame.size.height - 100);
    backgroundButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3];
    [backgroundButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backgroundButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        bottomViewContainer.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100 -64-keyBoardFrame.size.height, 320, 100);
    }];
    
}


-(void)hiddeKeyBoard:(NSNotification * )notification{
    
    [backgroundButton removeFromSuperview];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        bottomViewContainer.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100 -64, 320, 100);
    }];
    
}


-(void)clickButton:(UIButton *)button{
    
    [self.periodsTextField resignFirstResponder];
    [self.multipleTextField resignFirstResponder];
}


-(void)changeMoneyLabel{
    
    NSArray * array = [KSBettingModel share].kSBettingArrayModel;
    
    int i = 0;
    
    for (KSLotterysModel *m in array) {
        i += [m getCombinationLotterysCount];
    }
    NSLog(@"count===%d",i);
    
    self.amountString = [NSString stringWithFormat:@"%d",i * 2 * [self.multipleTextField.text integerValue] * 100] ;
    
    [self.betLabel setText:[NSString stringWithFormat:@"%d注%d期%d倍",i,[self.periodsTextField.text integerValue],[self.multipleTextField.text integerValue]]];
    [self.moneyLabel setText:[NSString stringWithFormat:@"%d元",(self.amountString.integerValue/100)*(self.periodsTextField.text.integerValue)]];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.periodsTextField resignFirstResponder];
    [self.multipleTextField resignFirstResponder];
}


#pragma - mark
#pragma - mark textFieldDelegate 实现

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


//通知，textField的内容变化后就调用
-(void)textFieldContentsChange:(NSNotification *)notification{
    
    UITextField * textField = (UITextField *)notification.object;
    
    if (![textField isEqual:self.periodsTextField] && ![textField isEqual:self.multipleTextField]) {
        
        return ;
    }
    
    
    if ([self.periodsTextField isEqual:textField]) {
        if([self.periodsTextField.text intValue] <=0 || [self.periodsTextField.text intValue] > 200)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"期数范围为1~200期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
        }
        
    }else if([self.multipleTextField isEqual:textField]){
        
        if([self.multipleTextField.text intValue] <=0 || [self.multipleTextField.text intValue] > 2000)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"倍数范围为1~2000倍" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            
        }
    }
    
    [self changeMoneyLabel];
    
}


//判断textField输入的内容是否合法
-(BOOL)textFieldsContentsIsFalse{
    
    
    if (self.dataSource.count == 0) {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"所投注数不能为0" withTitle:@"提示" buttonTitle:@"确定"];
        
        return YES;
    }
    
    if (self.periodsTextField.text.length == 0 || self.multipleTextField.text.length == 0) {
        
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数和期输入不能为空" withTitle:@"提示" buttonTitle:@"确定"];
        
        return YES;
    }
    
    if ([self.periodsTextField.text characterAtIndex:0] == '0' || [self.multipleTextField.text characterAtIndex:0] == '0') {
        
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数和期不能以0开头" withTitle:@"提示" buttonTitle:@"确定"];
        
        return YES;
        
    }
    
    for (int i = 0 ; i < self.multipleTextField.text.length ; i ++ ) {
        
        UniChar chr = [self.multipleTextField.text characterAtIndex:i];
        
        if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"倍数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return YES;
        }

    }
    
    for (int i = 0 ; i < self.periodsTextField.text.length ; i ++ ) {
        
        UniChar chr = [self.periodsTextField.text characterAtIndex:i];
        
        if (chr < '0' || chr > '9')
        {
            [[RuYiCaiNetworkManager sharedManager] showMessage:@"期数必须为数字" withTitle:@"提示" buttonTitle:@"确定"];
            return YES;
        }
        
    }
    
    
    if([self.multipleTextField.text intValue] <=0 || [self.multipleTextField.text intValue] > 2000)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"输入不合法\n倍数范围为1~2000倍"
                                                 withTitle:@"提示" buttonTitle:@"确定"];
        
        return YES;
        
    }
    
    
    if([self.periodsTextField.text intValue] <=0 || [self.periodsTextField.text intValue] > 200)
    {
        [[RuYiCaiNetworkManager sharedManager] showMessage:@"输入不合法\n期数范围为1~200期"
                                                 withTitle:@"提示" buttonTitle:@"确定"];
        
        return YES;
    }
    
    return NO;
}



-(void)addTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, [UIScreen mainScreen].bounds.size.height-60-64-100) style:UITableViewStylePlain];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [ColorUtils parseColorFromRGB:@"#0b5c58"];
    [self.tableView addSubview:view];
    
    UIView * footerView = [[UIView alloc ] init];
    footerView.backgroundColor = [UIColor clearColor];
    
    footerView.frame = CGRectMake(0, 110, 320, 60);
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HXBX_protocal"]];
    
    imageView.frame = CGRectMake(20, 20, 22, 20);
    
    [footerView addSubview:imageView];
    [imageView release];
        
    UIButton * buttonf = [KSCutomerControl customButton:CGRectMake(50, 0, 260, 60) title:@"我已阅读并同意《委托投注规则》" textColor:[ColorUtils parseColorFromRGB:@"#6cb5b1"] backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15] target:self action:@selector(reviewProtocol)];
    
    [footerView addSubview:buttonf];
    
    self.tableView.tableFooterView = footerView;
}


-(void)reviewProtocol{
    
    NSLog(@"执行了");
    ProtocolViewController * controller = [[ProtocolViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
    
}


-(void)setHeaderView{
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.backgroundColor = [ColorUtils parseColorFromRGB:@"#095854"] ;
    
    leftButton.frame = CGRectMake(20, 10, 130, 40);
    
    [leftButton addTarget:self action:@selector(addSelfSelectedNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton addTarget:self action:@selector(ButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    
    UILabel * selfAddLabel = [KSCutomerControl customLabel:CGRectMake(10, 3, 15, 30) title:@"+" textColor:[ColorUtils parseColorFromRGB:@"#bcc4b4"] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:22]];
    
    [leftButton addSubview:selfAddLabel];
    
    UILabel * selfLabel = [KSCutomerControl customLabel:CGRectMake(20, 0, 110, 40) title:@"添加自选号码" textColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15]];
    
    [leftButton addSubview:selfLabel];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.backgroundColor = [ColorUtils parseColorFromRGB:@"#095854"] ;
    
    rightButton.frame = CGRectMake(170, 10, 130, 40);
    [rightButton addTarget:self action:@selector(addMashionSelectedNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton addTarget:self action:@selector(ButtonHighlighted:) forControlEvents:UIControlEventTouchDown];
    
    UILabel * mashionAddLabel = [KSCutomerControl customLabel:CGRectMake(10, 3, 15, 30) title:@"+" textColor:[ColorUtils parseColorFromRGB:@"#bcc4b4"] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont boldSystemFontOfSize:22]];
    
    [rightButton addSubview:mashionAddLabel];
    
    UILabel * mashionLabel = [KSCutomerControl customLabel:CGRectMake(20, 0, 110, 40) title:@"添加机选号码" textColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15]];
    
    [rightButton addSubview:mashionLabel];
    
    [self.view addSubview:leftButton];
    [self.view addSubview:rightButton];
    
    [KSCutomerControl superView:leftButton subViewColor:[ColorUtils parseColorFromRGB:@"#6e8c82"] lineWith:2];
    
    [KSCutomerControl superView:rightButton subViewColor:[ColorUtils parseColorFromRGB:@"#6e8c82"] lineWith:2];
    
}


-(void)addSelfSelectedNumber:(UIButton *)button{
    NSLog(@"调用了");
    
    button.backgroundColor = [ColorUtils parseColorFromRGB:@"#095854"] ;
    
    KS_PickNumberViewController * controller = [[KS_PickNumberViewController alloc ] init];
    
    controller.controllerBePushFirstOrOtherType = selfSelectedNumber;
    
    
    if ([self.dataSource count] == 0) {
        controller.pickType = PickNumHZ;
    }else{
        KSLotterysModel * lotterys = (KSLotterysModel *)[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:0];
        
        
        if (lotterys.playStyle == HE_ZHI_PALY_STYLE) {
            
            controller.pickType = PickNumHZ;
            
        }else if(lotterys.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE || lotterys.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE){
            controller.pickType = PickNumST;
        }else if(lotterys.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE || lotterys.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE){
            controller.pickType = PickNumET;
        }else if (lotterys.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE || lotterys.playStyle == SAN_BU_TONG_HAO_PALY_STYLE){
            controller.pickType = PickNumSBT;
        }else if(lotterys.playStyle == ER_BU_TONG_HAO_PALY_STYLE){
            controller.pickType = PickNumEBT;
        }
        
    }
    
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}


-(void)addMashionSelectedNumber:(UIButton *)button{
    
    NSLog(@"调用了");

    button.backgroundColor = [ColorUtils parseColorFromRGB:@"#095854"] ;

    KS_PickNumberViewController * controller = (KS_PickNumberViewController *)[self.navigationController.viewControllers objectAtIndex:1];
    
    if (self.dataSource.count == 0) {
        controller.pickType = PickNumHZ;
    }else{
        KSLotterysModel * lotterys = (KSLotterysModel *)[[[KSBettingModel share] kSBettingArrayModel] objectAtIndex:0];
        
        if (lotterys.playStyle == HE_ZHI_PALY_STYLE) {
            
            controller.pickType = PickNumHZ;
            
        }else if(lotterys.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE || lotterys.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE){
            controller.pickType = PickNumST;
        }else if (lotterys.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE || lotterys.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE){
            
            controller.pickType = PickNumET;
        }else if (lotterys.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE || lotterys.playStyle == SAN_BU_TONG_HAO_PALY_STYLE){
            controller.pickType = PickNumSBT;
        }else if (lotterys.playStyle == ER_BU_TONG_HAO_PALY_STYLE){
            
            controller.pickType = PickNumEBT;
        }
        
    }
    [controller changePlayGUI];
    
    [self.delegate yaoYiYaoEvent:button ];
}


-(void)ButtonHighlighted:(UIButton *)btn{
    
    btn.backgroundColor = [ColorUtils parseColorFromRGB:@"#063c3a"] ;

}


-(void)setBottomView{
    
    bottomViewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100 -64, 320, 100)];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, 320, 50)];
    
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
    
    self.betLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 22, 180, 25)];
    [self.betLabel setTextColor:[ColorUtils parseColorFromRGB:@"#ffe5c9"]];
    [self.betLabel setBackgroundColor:[UIColor clearColor]];
    [self.betLabel setTextAlignment:NSTextAlignmentCenter];
    [self.betLabel setFont:[UIFont systemFontOfSize:15]];
    [self.betLabel setText:@"8注1期1倍"];
    [bottomView addSubview:_betLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 3, 180, 25)];
    [self.moneyLabel setTextColor:[ColorUtils parseColorFromRGB:@"#ffa234"]];
    [self.moneyLabel setBackgroundColor:[UIColor clearColor]];
    [self.moneyLabel setTextAlignment:NSTextAlignmentCenter];
    [self.moneyLabel setText:@"共16元"];
    
    [bottomView addSubview:_moneyLabel];
    
    [bottomView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#011814"]];
    
    //[bottomViewContainer setBackgroundColor:[UIColor ]];
    
    [bottomViewContainer addSubview:bottomView];
    
    
    UIView * bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    bottomView2.backgroundColor  = [ColorUtils parseColorFromRGB:@"#003432"];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 50)];
    
    [label1 setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont boldSystemFontOfSize:18]];
    [label1 setTextAlignment:NSTextAlignmentLeft];
    [label1 setText:@"连续买              期"];
    [bottomView2 addSubview:label1];
    
    UIView * textFieldBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(75, 10, 60, 30)];
    
    [textFieldBackgroundView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#96ada5"]];
    
    [bottomView2 addSubview:textFieldBackgroundView];
    [textFieldBackgroundView release];
    
    self.periodsTextField = [[UITextField alloc] initWithFrame:CGRectMake(75, 10, 60, 30)];
    self.periodsTextField.delegate = self;
    [self.periodsTextField setBackgroundColor:[UIColor clearColor]];
    
    [self.periodsTextField setTextColor:[ColorUtils parseColorFromRGB:@"#003432"]];
    self.periodsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.periodsTextField setTextAlignment:NSTextAlignmentCenter];
    self.periodsTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.periodsTextField setText:@"1"];
    
    self.periodsTextField.font = [UIFont systemFontOfSize:18];
    [bottomView2 addSubview:self.periodsTextField];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 110, 50)];
    
    [label2 setTextColor:[ColorUtils parseColorFromRGB:@"#f0f6ea"]];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont boldSystemFontOfSize:18]];
    [label2 setTextAlignment:NSTextAlignmentLeft];
    [label2 setText:@"投              倍"];
    [bottomView2 addSubview:label2];
    
    UIView * textFieldBackgroundView2 = [[UIView alloc] initWithFrame:CGRectMake(223, 10, 60, 30)];
    
    [textFieldBackgroundView2 setBackgroundColor:[ColorUtils parseColorFromRGB:@"#96ada5"]];
    
    [bottomView2 addSubview:textFieldBackgroundView2];
    [textFieldBackgroundView2 release];
    
    self.multipleTextField = [[UITextField alloc] initWithFrame:CGRectMake(223, 10, 60, 30)];
    self.multipleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.multipleTextField.delegate = self;
    self.multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.multipleTextField setBackgroundColor:[UIColor clearColor]];
    
    [self.multipleTextField setTextColor:[ColorUtils parseColorFromRGB:@"#003432"]];
    
    [self.multipleTextField setTextAlignment:NSTextAlignmentCenter];
    
    [self.multipleTextField setText:@"1"];
    
    self.multipleTextField.font = [UIFont systemFontOfSize:18];
    [bottomView2 addSubview:self.multipleTextField];
    
    [bottomViewContainer addSubview:bottomView2];
    [bottomView2 release];
    
    [self.view addSubview:bottomViewContainer];
    
    [bottomViewContainer release];
    [bottomView release];
    
    
}

-(void)clearEvent:(UIButton *)button{
    
    [button setBackgroundColor:[ColorUtils parseColorFromRGB:@"#11312c"]];
    
    if ([KSBettingModel share].kSBettingArrayModel.count == 0) {
        UIAlertView * alertView = [[UIAlertView alloc ] initWithTitle:@"温馨提示" message:@"投注列表已经为空！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }else{
        UIAlertView * alertView = [[UIAlertView alloc ] initWithTitle:@"温馨提示" message:@"你确定要清空投注列表么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
        [alertView release];
    }
    
}


-(void)clearButtonHighlighted:(UIButton *)btn{
    
    [btn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#0c221e"]];
    
}


-(void)buyEvent:(UIButton *)button{
    
    [button setBackgroundColor:[ColorUtils parseColorFromRGB:@"#d38806"]];
    
    if (![RuYiCaiNetworkManager sharedManager].hasLogin)
    {
        [[RuYiCaiNetworkManager sharedManager] showLoginAlertView];
        return;
    }
    
    if ([self textFieldsContentsIsFalse]) {
        return ;//textField输入不合法，就返回
    }
    
    [RuYiCaiLotDetail sharedObject].oneAmount = @"200";
    [RuYiCaiLotDetail sharedObject].betType = @"bet";
    
    //    if(![self.normalBetViewController normalBetCheck])
    //    {
    //        return;
    //    }
    //        [MobClick event:@"GPC_bet"];
    
    //    [self.normalBetViewController buildBetCode];
    [RuYiCaiLotDetail sharedObject].subscribeInfo = @"";
    
    
    //        [MobClick event:@"GPC_bet"];
    [self buildBetCode];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setObject:@"1" forKey:@"isSellWays"];//注码格式改变0001051315182125~02^_1_200_200!0001051315182125~02^_1_200_200 注码_倍数_单注的金额_单倍总金额（多注投)
    NSLog(@"%@",[NSString stringWithString: [RuYiCaiLotDetail sharedObject].amount]);
    
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [NSString stringWithString: [RuYiCaiLotDetail sharedObject].amount];
    
    [[RuYiCaiNetworkManager sharedManager] betLotery:dict];
    
}



-(void)buyButtonHighlighted:(UIButton *)btn{
    
    [btn setBackgroundColor:[ColorUtils parseColorFromRGB:@"#a15d04"]];
}



-(void)buildBetCode{
    
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
    
    [RuYiCaiLotDetail sharedObject].batchCode = sharedAPP.betchString;
    NSLog(@"betchString======%@",sharedAPP.betchString);
    NSLog(@"betchCode======%@",[RuYiCaiLotDetail sharedObject].batchCode);
    
    [RuYiCaiLotDetail sharedObject].lotNo = kLotNoNMK3;
    [RuYiCaiLotDetail sharedObject].batchNum = [NSString stringWithFormat:@"%d", self.periodsTextField.text.integerValue];
    [RuYiCaiLotDetail sharedObject].lotMulti = [NSString stringWithFormat:@"%d", self.multipleTextField.text.integerValue];
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].lotMulti);
    [RuYiCaiLotDetail sharedObject].amount = self.amountString;
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].amount);
    [RuYiCaiLotDetail sharedObject].moreZuAmount = [RuYiCaiLotDetail sharedObject].amount;
    [RuYiCaiLotDetail sharedObject].prizeend = @"";
    NSLog(@"%@",[RuYiCaiLotDetail sharedObject].betCode);
    
    [RuYiCaiLotDetail sharedObject].moreZuBetCode = @"";
    NSLog(@"%@", [RuYiCaiLotDetail sharedObject].moreBetCodeInfor);
    
    for(int i = 0; i < [[KSBettingModel share].kSBettingArrayModel count]; i++)
    {
        if(i != [[KSBettingModel share].kSBettingArrayModel count] - 1)
            [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_200_%@!",((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:i]).betCodeString, [RuYiCaiLotDetail sharedObject].lotMulti, ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:i]).amountString];
        else
            [RuYiCaiLotDetail sharedObject].moreZuBetCode = [[RuYiCaiLotDetail sharedObject].moreZuBetCode stringByAppendingFormat:@"%@_%@_200_%@",((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:i]).betCodeString, [RuYiCaiLotDetail sharedObject].lotMulti, ((KSLotterysModel *)[[KSBettingModel share].kSBettingArrayModel objectAtIndex:i]).amountString];
        
        //NSLog(@"aaaa %@", [RuYiCaiLotDetail sharedObject].moreZuBetCode);
        
        NSLog(@"%@",[RuYiCaiLotDetail sharedObject].moreZuBetCode);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goToBack{
    
    if ([self.dataSource count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return ;
    }
    UIAlertView * alertView = [[UIAlertView alloc ] initWithTitle:@"退出提示" message:@"是否清除本次选号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除号码",@"保存号码", nil];
    alertView.tag = 100;
    [alertView show];
    [alertView release];
    
    
}


#pragma - mark
#pragma - alertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([self.periodsTextField isFirstResponder]) {
        if (self.periodsTextField.text.integerValue > 200) {
            self.periodsTextField.text = @"200";
        }else if(self.periodsTextField.text.integerValue <= 0){
            self.periodsTextField.text = @"1";
        }
        [self changeMoneyLabel];
    }else if([self.multipleTextField isFirstResponder]){
        
        if (self.multipleTextField.text.integerValue > 2000) {
            self.multipleTextField.text = @"2000";
        }else if(self.multipleTextField.text.integerValue <= 0){
                self.multipleTextField.text = @"1";
        }
        
        [self changeMoneyLabel];
    }
    
    if (buttonIndex != alertView.cancelButtonIndex) {

        if (alertView.tag == GOTOBACK || alertView.tag == CLEARDATASOURCE) {
            
            if (buttonIndex == 1) {
            
                [[KSBettingModel share] removeAll];
                
                [self.tableView reloadData];
            }
            
            if (alertView.tag == GOTOBACK) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            
        }else if(alertView.tag == BETOUTTIME){
            
            isRegetBetcode = YES;
            //重新获取注码，投注
            [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiry:kLotNoNMK3];
            
        }else if(alertView.tag == NOTENOUGHMONEY){
            
                RechargeViewController* viewController = [[RechargeViewController alloc] init];
                viewController.isHidePush = YES;
                viewController.lotNo = kLotNoNMK3;
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
        }
    }
}


#pragma - mark
#pragma - mark tableDataSource and tableDelegate

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.editing && indexPath.row == 0) {
        return UITableViewCellEditingStyleInsert;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KS_PickNumberViewController * controller = [[KS_PickNumberViewController alloc] init];
    
    controller.controllerBePushFirstOrOtherType = changeSelectedNumber;
    
    KSLotterysModel * lotterys = [[KSBettingModel share].kSBettingArrayModel objectAtIndex:indexPath.row ];
    
    [controller setIndexPath:indexPath withKSLotterysModel: lotterys];
    
    if (lotterys.playStyle == HE_ZHI_PALY_STYLE) {
        controller.pickType = PickNumHZ;
        
    }else if(lotterys.playStyle == SAN_TONG_HAO_DAN_XUAN_PALY_STYLE || lotterys.playStyle == SAN_TONG_HAO_TONG_XUAN_PALY_STYLE){
        controller.pickType = PickNumST;
    }else if (lotterys.playStyle == ER_TONG_HAO_FU_XUAN_PALY_STYLE || lotterys.playStyle == ER_TONG_HAO_DAN_XUAN_PALY_STYLE){
        controller.pickType = PickNumET;
    }else if (lotterys.playStyle == SAN_LIAN_HAO_TONG_XUAN_PALY_STYLE || lotterys.playStyle == SAN_BU_TONG_HAO_PALY_STYLE){
        controller.pickType = PickNumSBT;
    }else if (lotterys.playStyle == ER_BU_TONG_HAO_PALY_STYLE){
        controller.pickType = PickNumEBT;
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [[KSBettingModel share] removeLottersAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [self changeMoneyLabel];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%@",self.dataSource);
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentify = @"identify";
    
    BetTabelViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BetTabelViewCell" owner:self options:nil] lastObject];
    }
    
    UIView * selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    selectedView.backgroundColor = [ColorUtils parseColorFromRGB:@"#003432"];
    
    [cell setSelectedBackgroundView:selectedView];
    
    KSLotterysModel * lotterys = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.betNumberLabel.text = lotterys.betNumberString;
    [cell.betNumberLabel setAdjustsFontSizeToFitWidth:YES];
    cell.betNumberLabel.textColor = [ColorUtils parseColorFromRGB:@"#f0f6ea"];
    
    cell.betSumLabel.text = lotterys.betSumStrimng ;
    cell.betSumLabel.textColor = [ColorUtils parseColorFromRGB:@"#94f4ef"];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)];
    view.backgroundColor = [ColorUtils parseColorFromRGB:@"#0b5c58"];
    [cell addSubview:view];
    
    
    return cell;
    
}



#pragma mark
#pragma mark 投注期号过期处理
- (void)betOutTime:(NSNotification*)notification
{
    
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSString class]])
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"尊敬的用户"
            message:[NSString stringWithFormat:@"当前投注已转入下一期%@期，是否投注该新期？" ,(NSString*)obj]
            delegate:self
            cancelButtonTitle:@"返回"
            otherButtonTitles:@"继续投注",nil];
        [alertView show];
        [alertView setTag:102];
        [alertView release];
    }
}


//继续投注
- (void)updateInformation:(NSNotification*)notification
{
	NSLog(@"updatefor******");
    
    if (isRegetBetcode == YES) {
        sharedAPP.betchString = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];
        
        [self buyEvent:nil];
    }
    
    isRegetBetcode = NO;

}


- (void)notEnoughMoney:(NSNotification*)notification
{
    UIAlertView* alterView = [[UIAlertView alloc] initWithTitle:@"提示"
        message:CaiJinDuiHuanTiShi
        delegate:self
        cancelButtonTitle:@"取消"
        otherButtonTitles:@"免费兑换",nil];
    alterView.tag = 103;
    [alterView show];
    [alterView release];
    
}


-(void)betCaseLotOKClick:(NSNotification *)notification{
    
    //如果是在键盘弹出的时候进行的投注，则收起键盘再跳转
    if (bottomViewContainer.frame.origin.y == [UIScreen mainScreen].bounds.size.height - 100 -64-216) {
        [self.periodsTextField resignFirstResponder];
        [self.multipleTextField resignFirstResponder];
        [self hiddeKeyBoard:nil];
    }
    
    
    //清空数据源，并跳到选号界面
    [[KSBettingModel share] removeAll];
    
    [self addSelfSelectedNumber:nil];
}

@end
