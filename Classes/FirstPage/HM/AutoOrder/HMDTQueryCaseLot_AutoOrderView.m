//
//  HMDTQueryCaseLot_AutoOrderView.m
//  RuYiCai
//
//  Created by ruyicai on 12-11-19.
//
//

#import "HMDTQueryCaseLot_AutoOrderView.h"
#import "RYCImageNamed.h"
#import "HMDTDetialZhanjiCell.h"
#import "UserCenterAutoOrderDetailView.h"
#import "HMDTQueryCaseLotViewController.h"
#import "HMDTAutoOrderViewController.h"
@interface HMDTQueryCaseLot_AutoOrderView(inter)
-(void) buttonClick:(id)sender;
@end

@implementation HMDTQueryCaseLot_AutoOrderView
 
@synthesize lotName = m_lotName;
@synthesize caseId = m_caseId;
@synthesize starter = m_starter;
@synthesize starterUserNo = m_starterUserNo;
@synthesize lotNo = m_lotNo;
@synthesize times = m_times;
@synthesize joinAmt = m_joinAmt;
@synthesize safeAmt = m_safeAmt;
@synthesize maxAmt = m_maxAmt;
@synthesize percent = m_percent;
@synthesize forceJoin = m_forceJoin;
@synthesize joinType = m_joinType;
@synthesize createTime = m_createTime;
@synthesize state = m_state;
@synthesize zhanjiDic = m_zhanjiDic;
@synthesize supViewController = m_supViewController;
- (void)dealloc
{
    [m_lotName release];
    [m_buyTimeLabel release];
    [m_stateLabel release];
    [m_starterLabel release];
    [m_joinAmtLabel release];
    [joinAmountTip release];
    [m_modifyButton release];
    [m_checkDetailButton release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 310, 78)];
        bgImageView.image = RYCImageNamed(@"kj_box_bg.png");
        [self addSubview:bgImageView];
        [bgImageView release];
        
        m_lotNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        m_lotNameLabel.textAlignment = UITextAlignmentLeft;
        m_lotNameLabel.backgroundColor = [UIColor clearColor];
        m_lotNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:m_lotNameLabel];
        
        m_stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 80, 20)];
        m_stateLabel.textAlignment = UITextAlignmentLeft;
        m_stateLabel.textColor = [UIColor redColor];
        m_stateLabel.backgroundColor = [UIColor clearColor];
        m_stateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_stateLabel];
 
        m_buyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 120, 15)];
        m_buyTimeLabel.textAlignment = UITextAlignmentLeft;
        m_buyTimeLabel.textColor = [UIColor brownColor];
        m_buyTimeLabel.backgroundColor = [UIColor clearColor];
        m_buyTimeLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_buyTimeLabel];
        
        m_starterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 200, 15)];
        m_starterLabel.textAlignment = UITextAlignmentLeft;
        m_starterLabel.textColor = [UIColor blackColor];
        m_starterLabel.backgroundColor = [UIColor clearColor];
        m_starterLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_starterLabel];
        
        joinAmountTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 62, 80, 15)];
        joinAmountTip.textAlignment = UITextAlignmentLeft;
        joinAmountTip.textColor = [UIColor blackColor];
        [joinAmountTip setText:@"认购金额："];
        joinAmountTip.backgroundColor = [UIColor clearColor];
        joinAmountTip.font = [UIFont systemFontOfSize:12];
        [self addSubview:joinAmountTip];
        
        m_joinAmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 62, 200, 15)];
        m_joinAmtLabel.textAlignment = UITextAlignmentLeft;
        m_joinAmtLabel.textColor = [UIColor blackColor];
        m_joinAmtLabel.textColor = [UIColor redColor];
        m_joinAmtLabel.backgroundColor = [UIColor clearColor];
        m_joinAmtLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:m_joinAmtLabel];
 
        m_checkDetailButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 5, 80, 30)];
        [m_checkDetailButton setBackgroundImage:RYCImageNamed(@"check_auto_order_button_normal.png") forState:UIControlStateNormal];
        [m_checkDetailButton setBackgroundImage:RYCImageNamed(@"check_auto_order_button_click.png") forState:UIControlStateHighlighted];
        [m_checkDetailButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        m_checkDetailButton.backgroundColor = [UIColor clearColor];
        [m_checkDetailButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [m_checkDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        m_checkDetailButton.titleLabel.font = [UIFont systemFontOfSize:15];
        m_checkDetailButton.tag = 0;
        [self addSubview:m_checkDetailButton];
 
        m_modifyButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 45, 80, 30)];
        [m_modifyButton setBackgroundImage:RYCImageNamed(@"check_auto_order_button_normal.png") forState:UIControlStateNormal];
        [m_modifyButton setBackgroundImage:RYCImageNamed(@"check_auto_order_button_click.png") forState:UIControlStateHighlighted];
        m_modifyButton.backgroundColor = [UIColor clearColor];
        [m_modifyButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_modifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_modifyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [m_modifyButton setTitle:@"修改定制" forState:UIControlStateNormal];
        m_modifyButton.tag = 1;
        [self addSubview:m_modifyButton];

    }
    return self;
}
-(void) buttonClick:(id)sender
{
    if ([sender tag] == 0) {
        NSMutableArray*  contentArr = [[NSMutableArray alloc] initWithCapacity:1];

        [contentArr addObject:[NSString stringWithFormat:@"彩种：%@",self.lotName]];

        [contentArr addObject:@"跟单名人:"];
        [contentArr addObject:self.starter];
        [contentArr addObject:@"名人战绩:"];
        [contentArr addObject:self.zhanjiDic];
 
        [contentArr addObject:@"定制时间:" ];
        [contentArr addObject:self.createTime];
        [contentArr addObject:@"状态:" ];
        [contentArr addObject:([@"0" isEqualToString:self.state] ? @"无效":@"有效")];
        [contentArr addObject:@"跟单类型:"];//0:金额跟单;1:百分比跟单
        [contentArr addObject:([@"0" isEqualToString:self.joinType] ? @"按固定金额跟单" : @"按百分比跟单")];
        if ([self.joinType isEqualToString:@"0"]) {
            [contentArr addObject:@"定制金额:"];
            [contentArr addObject:[NSString stringWithFormat:@"%0.2lf元", [self.joinAmt doubleValue]/100]];
        }
        else
        {
            [contentArr addObject:@"定制百分比:"];
            NSString* str = [NSString stringWithFormat:@"%d",[self.percent intValue]];
            str = [str stringByAppendingString:@"%"];
            [contentArr addObject:str];
        }
 
        [contentArr addObject:@"定制次数:"];
        [contentArr addObject:self.times];
        [contentArr addObject:@"强制参与:"];
        [contentArr addObject:([@"0" isEqualToString:self.forceJoin] == YES ? @"否":@"是")];//0:不强制跟单;1:强制跟单
 
        [self.supViewController setHidesBottomBarWhenPushed:YES];
        
        UserCenterAutoOrderDetailView* viewController = [[UserCenterAutoOrderDetailView alloc] init];
        viewController.contentArray = contentArr;
        viewController.zhanjiDic = self.zhanjiDic;
        viewController.navigationItem.title = @"定制跟单查询详情";
        [self.supViewController.navigationController pushViewController:viewController animated:YES];
        [contentArr release];
        [viewController release];
    }
    else
    {
        [self.supViewController setHidesBottomBarWhenPushed:YES];
        HMDTAutoOrderViewController* view = [[HMDTAutoOrderViewController alloc] init];
        view.lotNo = self.lotNo;
        view.starterUserNo = self.starterUserNo;

        if ([self.state isEqualToString:@"1"]) {
            view.ViewType = MODIFY_AUTO_ORDER_VIEW;//修改定制跟单
            view.caseId = self.caseId;
            view.states = ([self.state isEqualToString:@"1"] ? @"进行中" : @"已取消");
            view.creatTimes = self.createTime;
            view.isByAllAmount = ([self.joinType isEqualToString:@"0"] ? YES : NO);
            if ([self.joinType isEqualToString:@"0"]) {
                view.orderAmountByAllAmount = [NSString stringWithFormat:@"%0.0lf",[self.joinAmt doubleValue]/100];
                view.orderCountByAllAmount = self.times;
                
                //默认值
                view.orderMaxAmountByPercent = @"50";
                view.orderCountByPercent = @"10";
                view.orderAmountByPercent = @"1";
                view.hasMaxAmountByPercent = YES;
            }
            else
            {
                view.orderMaxAmountByPercent = [NSString stringWithFormat:@"%0.0lf",[self.maxAmt doubleValue]/100];
                view.orderCountByPercent = self.times;
                view.orderAmountByPercent = self.percent;
                view.hasMaxAmountByPercent = YES;
                
                //默认值
                view.orderAmountByAllAmount = @"1";
                view.orderCountByAllAmount = @"10";
            }
            view.forceJoin = ([self.forceJoin isEqualToString:@"0"] ? NO : YES);
        }
        else
        {
            view.isByAllAmount = YES;
            view.forceJoin = YES;
            view.hasMaxAmountByPercent = YES;
            //默认值
            view.orderMaxAmountByPercent = @"50";
            view.orderCountByPercent = @"10";
            view.orderAmountByPercent = @"1";
            //默认值
            view.orderAmountByAllAmount = @"1";
            view.orderCountByAllAmount = @"10";
        }
        [self.supViewController.navigationController pushViewController:view animated:YES];
        [view release];
    }
}

- (void)refreshView
{
    m_lotNameLabel.text = m_lotName;
    if ([@"0" isEqualToString:m_state]) {
        m_stateLabel.text = [NSString stringWithFormat:@"(%@)", @"无效"];
        m_stateLabel.textColor = [UIColor grayColor];
        
        m_stateLabel.hidden = NO;
        [m_modifyButton setTitle:@"再次定制" forState:UIControlStateNormal];
    }
    else
    {
        m_stateLabel.hidden = YES;
        [m_modifyButton setTitle:@"修改定制" forState:UIControlStateNormal];
    }
    m_buyTimeLabel.text = self.createTime;
    m_starterLabel.text = [NSString stringWithFormat:@"发起人：%@" ,self.starter];
    if ([@"0" isEqualToString:self.joinType]) {
        joinAmountTip.text = @"认购金额：";
        m_joinAmtLabel.text = [NSString stringWithFormat:@"￥%0.2lf元",[self.joinAmt doubleValue]/100];
    }
    else
    {
        joinAmountTip.text = @"认购百分比：";
        NSString* str = [NSString stringWithFormat:@"%d",[self.percent intValue]];
        str = [str stringByAppendingString:@"%"];
        m_joinAmtLabel.text = str;
    }

}
@end
