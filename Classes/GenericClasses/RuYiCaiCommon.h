/*
 *  RuYiCaiCommon.h
 *  RuYiCai
 *
 *  Created by LiTengjie on 11-8-7.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

/*主要是显示问题：如意彩或91字段*/
//#define RuYiCaiOR91     @"91"

#define RuYiCaiOR91     @"RuYiCai"

#define kRuYiCaiAesKey   @"<>hj12@#$$%^~~ff"
  
//#define kRuYiCaiServer   @"http://58.83.193.3/lotserver/RuyicaiServlet"

#define UnionBankLTInterfaceType (0) //银联生产线
//#define UnionBankLTInterfaceType (1)  //银联测试线



#define kRuYiCaiServer   @"http://220.231.48.232:4231/freelot/freelotServlet"

//#define kRuYiCaiServer   @"http://www.caifree.com/freelot/freelotServlet"


#define CaiJinDuiHuanTiShi   @"尊敬的用户，您的彩豆余额不足，赶紧免费兑换吧！"

#define TestUNum    @"00157098"
#define CheatApple  @"0"

#define BuyAndInfoSeparated   @"0"

#define CanChooseBeiShu   @"NO"


//#define kZCServer        @"http://www.ruyicai.com/jrtLot/zcAction.do;jsessionid=?method=getFlData&jsonString="
#define kRuYiCaiBetSafari   @"http://58.83.193.3/lotserver/log/betConfirm.jsp?jsonString="
//#define unionPayServer @"http://mobilepay.unionpaysecure.com/qzjy/MerOrderAction/deal.action"
//#define kRuYiCaiServer   @"http://192.168.0.190:8000/lotserver/RuyicaiServlet"



//#define kZCServer         @"http://202.43.152.170:8080/jrtLot/zcAction.do;jsessionid=?method=getFlData&jsonString="
//#define kRuYiCaiBetSafari   @"http://202.43.152.170:8080/lotserver/log/betConfirm.jsp?jsonString="

//拉卡拉  注意当发布的时候去掉此定义
#define KLAKALAShow 1

//博雅版无中奖排行榜 正常版本注释掉此行
//#define isBOYA

//即时比分 我的关注 注释掉，下个版本（3.6.3） 放开
#define KInstantScore_myGame 1

//竞彩篮球 数据分析的 联赛排名 暂时先去掉
#define KDataFenxi_JCLQ_rank 1

/*主要是判断是否跳safira界面和第三个界面是否显示手机卡充值方式和normal用户更多页面不显示评分*/
#define kRuYiCaiPlatform @"iPhone"
#define kRuYiCaiVersion  @"3.0.0"

//#define kRuYiCaiCoopid   @"28" //appStore
//#define kRuYiCaiCoopid   @"58" //APPstore官方版	58
//#define kRuYiCaiCoopid   @"59" //APPstore生活版	59
//#define kRuYiCaiCoopid   @"71" //APPstore合作版	71

//#define kRuYiCaiCoopid   @"29" //91手机助手iPhone	29
//#define kRuYiCaiCoopid   @"34" //泡椒iPhone	34
//#define kRuYiCaiCoopid   @"35" //蚕豆网iPhone	35
//#define kRuYiCaiCoopid   @"48" //百度应用	48
//#define kRuYiCaiCoopid   @"49" //十字猫	49
//#define kRuYiCaiCoopid   @"51" //历趣市场	51
//#define kRuYiCaiCoopid   @"52" //机客网	52
//#define kRuYiCaiCoopid   @"53" //软吧	53
//#define kRuYiCaiCoopid   @"72" //IOS-CPS	91助手IOS越狱	72
//#define kRuYiCaiCoopid   @"61" //91助手IOS正版	61
//#define kRuYiCaiCoopid   @"73" //IOS-特殊	win博雅ios1	73
//#define kRuYiCaiCoopid   @"74" //win博雅ios2	74
//#define kRuYiCaiCoopid   @"75" //win博雅ios3	75
//#define kRuYiCaiCoopid   @"104" //IOS积分	104




/********新渠道号，用channel********/
#define kRuYiCaiCoopid   @"1"  //AppStore

//#define kRuYiCaiCoopid    @"110"  //葫芦商城
//#define kRuYiCaiCoopid   @"111"  //91市场
//#define kRuYiCaiCoopid   @"112"  //同步推

//#define appStoreORnormal    @"appStore"
#define appStoreORnormal    @"normal"
#define appTestPhone    @"13522407813"


//appStore跳转的充值界面地址
#define kRuYiCaiCharge   @"http://wap.ruyicai.com/w/wap/iphoneCharge.jspx"

//用户服务协议
#define kRuYiCaiUserProtocol  @"http://3g.boyacai.com/w3g/html/protocol.html"

//appStore上ruyicai的评分地址
#define kAppStorPingFen @"itms-apps://itunes.apple.com/app/id830055983"
//appStore上ruyicai的下载地址（分享）
//#define kAppStoreDownLoad @"http://itunes.apple.com/cn/app/ru-yi-cai-nin-shen-bian-cai/id492164095?mt=8"
#define kAppStoreDownLoad @"http://3g.boyacai.com/w3g/downLoad"

/*91如意彩appStore上的版本com.91caipiao.91ruyicai*/
#define AppStore91_Alipay        @"AppStore91Alipay"   //(九位数字 去 openurl的前9位)
#define AppStore91_Lakala        @"AppStore91Lakala" 
#define AppStore91_Sina          @"AppStore91Sina"

/*91如意彩手机助手上的版本com.ruyicai.91caipiao*/
#define RuYiCai91_Lakala         @"RuYiCai91Lakala" 
#define RuYiCai91_Alipay         @"RuYiCai91Alipay"  
#define RuYiCai91_Sina           @"RuYiCai91Sina"

/*如意彩票版本com.ruyicai.isoruyicai*/
#define RuYiCai_Lakala           @"RuYiCaiLakala" 
#define BoYaCai_Alipay           @"BoYaCaiAlipay"
#define BoYaCai_Sina             @"sinaweibosso.3497762629"
#define BoYaCai_Tencent          @"tencent100392744"

#define KAppScheme_Lakala  @"Lakala"
#define KAppScheme_Alipay  @"Alipay"
#define KAppScheme_Sina    @"Sina"
#define KAppScheme_Tencent    @"QQ"
#define KAppScheme_WeiXin    @"WeiXin"

//获取appdelegate
#define sharedAPP ((RuYiCaiAppDelegate *)[UIApplication sharedApplication].delegate)

//后台返回失败字段

#define KBalanceLess    @"余额不足"

//博雅彩下载地质
#define KAppWapDoload   @"http://3g.boyacai.com/w3g/"


//免费彩官方QQ
#define KQQNumber   @"2492831607"

//博雅彩客服热线
#define KCustomerServiceNum   @"400-856-1000"


/*
 用来判断 字典的值 是否为null
 如果是null  则 返回@“”，
 否则 返回 原来的值
*/
#define KISNullValue(array,i,key) ([[array objectAtIndex:i] objectForKey:key] == (NSString*)[NSNull null] ? @"" : [[array objectAtIndex:i] objectForKey:key])

#define KISDictionaryNullValue(dict,key) ([dict objectForKey:key] == (NSString*)[NSNull null] ? @"" : [dict objectForKey:key])

#define KISDictionaryHaveKey(dict,key) [[dict allKeys] containsObject:key] && ([dict objectForKey:key] != (NSString*)[NSNull null]) ? [dict objectForKey:key] : @""

#define KISiPhone5 ([[UIScreen mainScreen] bounds].size.width == 568 || [[UIScreen mainScreen] bounds].size.height == 568)

#define KISEmptyOrEnter(text) ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)

#define  KSafe_Free(variable) {[variable release]; variable = nil;}

#define LotCount  (6)//彩种种类
#define LotteryCount  (5)//彩种种类
#define NUMBERS @"0123456789\n"//只允许输入数字
//内联函数
static inline void drawArc(CGContextRef ctx, CGPoint point, UIColor* color, NSInteger radius) {//画圆
    //    CGContextSetRGBFillColor(ctx, color.redColor, color.g));//红色
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextFillEllipseInRect(ctx, CGRectMake(point.x - radius, point.y - radius, radius * 2, radius * 2));
}

static inline void drawRec(CGContextRef ctx, CGRect rec, UIColor* color) {//画矩形
    CGContextSetFillColor(ctx, CGColorGetComponents( [color CGColor]));
    CGContextAddRect(ctx, rec);
}

static inline void drawLine(CGContextRef ctx, CGPoint startPoint, CGPoint endPoint) {//画线
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    CGContextStrokePath(ctx);
}

#define kColorWithRGB(r, g, b, a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]


//彩种编号
#define kLotNoSSQ        @"F47104"  //双色球
#define kLotNoQLC        @"F47102"  //七乐彩
#define kLotNoFC3D       @"F47103"  //福彩3D
#define kLotNo115        @"T01010"  //11选5
#define kLotNoSSC        @"T01007"  //时时彩
#define kLotNoDLT        @"T01001"  //大乐透
#define kLotNoPLS        @"T01002"  //排列三
#define kLotNoQXC        @"T01009"  //七星彩
#define kLotNoPL5        @"T01011"  //排列五
#define kLotNoJQC        @"T01005"  //进球彩
#define kLotNoLCB        @"T01006"  //足彩六场半
#define kLotNoSFC        @"T01003"  //足彩胜负彩
#define kLotNoRX9        @"T01004"  //足彩任九
#define kLotNo11YDJ      @"T01012"  //十一运夺金
#define kLotNo22_5       @"T01013"  //22选5
#define kLotNoGD115      @"T01014"  //广东11选5
#define kLotNoKLSF       @"T01015"  //广东快乐十分
#define kLotNoNMK3       @"F47108"  //内蒙快三
#define kLotNoCQ115       @"T01016"  //重庆115
#define kLotNoCQSF       @"F47109"  //重庆快乐十分

#define kLotNoJCLQ      @"JC_L" //竞彩篮球
#define kLotNoJCZQ      @"JC_Z" //竞彩足球

#define kLotNoZC      @"ZC" //足彩

#define kLotNoJCLQ_SF       @"J00005"  //竞彩篮球胜负
#define kLotNoJCLQ_RF       @"J00006"  //竞彩篮球让分胜负
#define kLotNoJCLQ_SFC      @"J00007"  //竞彩篮球胜分差
#define kLotNoJCLQ_DXF      @"J00008"  //竞彩篮球大小分

#define kLotNoJCZQ_SPF       @"J00001"  //竞彩足球胜平负
#define kLotNoJCZQ_ZJQ      @"J00003"  //竞彩足球总进球数
#define kLotNoJCZQ_SCORE    @"J00002"  //竞彩足球比分
#define kLotNoJCZQ_HALF     @"J00004"  //竞彩足球半全场
#define kLotNoJCZQ_RQ_SPF       @"J00013"  //竞彩足球胜平负
#define kLotNoJCLQ_CONFUSION    @"J00012"  //竞彩混合篮球
#define kLotNoJCZQ_CONFUSION    @"J00011"  //竞彩混合ZU球

#define kLotNoBJDC             @"BD"//北京单场
#define kLotNoBJDC_RQSPF          @"B00001"
#define kLotNoBJDC_JQS            @"B00002"
#define kLotNoBJDC_HalfAndAll     @"B00003"
#define kLotNoBJDC_SXDS           @"B00004"
#define kLotNoBJDC_Score          @"B00005"


#define kLotTitleHM      @"hm"  //合买大厅
#define kLotTitleZJJH    @"zjjh"  //专家荐号
#define kLotTitleXYXH    @"xyxh"  //幸运选号

#define kLotTitleSSQ     @"ssq"  //双色球
#define kLotTitleQLC     @"qlc"  //七乐彩
#define kLotTitleFC3D    @"ddd"  //福彩3D
#define kLotTitleDLT     @"dlt"  //大乐透
#define kLotTitlePLS     @"pl3"  //排列三
#define kLotTitle11X5    @"11-5" //11选5
#define kLotTitleCQ11X5   @"cq-11-5"  //重庆11选5
#define kLotTitleSSC     @"ssc"  //时时彩

#define kLotTitleZC      @"zc"   //足彩
#define kLotTitleSFC     @"sfc"  //胜负彩
#define kLotTitle6CB     @"6cb"  //6场半
#define kLotTitleRX9     @"rx9"  //任选九
#define kLotTitleJQC     @"jqc"  //进球彩

#define kLotTitlePL5     @"pl5"  //排列五
#define kLotTitleQXC     @"qxc"  //七星彩
#define kLotTitle11YDJ   @"11-ydj"  //十一运夺金
#define kLotTitle22_5    @"22-5"  //22选5
#define kLotTitleGD115   @"gd-11-5" //广东11选5
#define kLotTitleNMK3          @"jlks"  //快三
#define kLotTitleBJDC          @"bjdc"//北京单场

#define kLotTitleJCLQ    @"jclq"  //竞彩篮球
#define kLotTitleJCZQ    @"jczq"  //竞彩足球


#define kLotTitleJCLQ_SF       @"jclq_sf"  //竞彩篮球胜负
#define kLotTitleJCLQ_RF       @"J00006_rf"  //竞彩篮球让分胜负
#define kLotTitleJCLQ_SFC      @"J00007_sfc"  //竞彩篮球胜分差
#define kLotTitleJCLQ_DXF      @"J00008_dxf"  //竞彩篮球大小分

#define kLotTitleKLSF          @"gd-happy-10" //广东快乐十分
#define kLotTitleCQSF          @"cq-happy-10"//重庆快乐十分
#define kLotTitlePK10          @"C00001"//PK拾
#define kLotTitleJXSSC         @"C00002"//江西时时彩


#define kLoginStatusFormat @"彩金: %@"

#define kMaxBeishu       (50)    //最大倍数
#define kMaxQishu        (99)    //最大期数
#define kMaxBetCost      (20000)//最大单注投注金额，10万

#define kPayStationShowKey      @"payStationShowKey"
#define kLotShowDicKey      @"lotShowDicKey"
#define kLotteryShowDicKey      @"lotteryShowDicKey"
#define kDefultLotteryShowDicKey @"lotteryDefultShowKey"

#define kLotteryBetWarnKey        @"lotteryBetWarnKey"
#define kLotteryBetWarnSongKey    @"lotteryBetSongWarnKey"
#define kLotteryBetWarnTimeKey    @"lotteryBetWarnTimeKey"

//充值中心 充值方式
#define kPayStationKeyOfZFBAQ @"aqzfb"
#define kPayStationKeyOfLDYS @"ldys"
#define kPayStationKeyOfYL @"ylcz"

#define kPayStationKeyOfYLYY @"ylyy"
#define kPayStationKeyOfCFT @"cftcz"

#define kPayStationKeyOfSJCZK @"sjczk"


//#define kPayStationKeyOfZFBWAP @"zfbwap"
#define kPayStationKeyOfYHZZ @"yhzz"



typedef enum 
{

	ELotTitleSSQ = 1,//双色球
    ELotTitleQLC,    //七乐彩
    ELotTitleFC3D,//福彩3D
    ELotTitle11X5,//江西11选5
    ELotTitleGZ_11X5,//广东11选5

    ELotTitleSSC,//时时彩
    ELotTitleDLT,//大乐透
    ELotTitlePLS,//排列三
    
    ELotTitleQXC,//七星彩
    ELotTitlePL5,//排列五
    
    ELotTitleJQC,//进球彩
    ELotTitle6CB,//足彩六场半
    ELotTitleSFC,//足彩胜负彩
    ELotTitleRX9,//足彩任选九
    ELotTitle11YDJ,//十一运夺金
    ELotTitle22_5, //22选5
 
    ELotTitleJCLQ_SF,//竞彩篮球胜负
    ELotTitleJCLQ_RF,//竞彩篮球让分胜负
    ELotTitleJCLQ_SFC,//竞彩篮球胜分差
    ELotTitleJCLQ_DXF,//竞彩篮球大小分
    
    ELotTitleJCZQ_RQ,//竞彩足球胜平负
    ELotTitleJCZQ_ZJQ,//竞彩足球总进球数
    ELotTitleJCZQ_SCORE,//竞彩足球比分
    ELotTitleJCZQ_HALF, //竞彩足球半全场
    
} LotType;

typedef enum 
{
    ILotTitleSSQ = 1,//
    ILotTitleQLC,    //
    ILotTitleFC3D,//
    ILotTitleDLT,//
    ILotTitlePLS,//
    ILotTitleQXC,//
    ILotTitlePL5,//
} KaiJiangImageTag;

typedef enum 
{
    IJCLQPlayType_SF = 1,//胜负
    IJCLQPlayType_LetPoint,    //让分胜负
    IJCLQPlayType_SFC,//胜分差
    IJCLQPlayType_BigAndSmall,//大小分差
    
    IJCLQPlayType_SF_DanGuan,//胜负_单关
    IJCLQPlayType_LetPoint_DanGuan,    //让分胜负_单关
    IJCLQPlayType_SFC_DanGuan,//胜分差_单关
    IJCLQPlayType_BigAndSmall_DanGuan,//大小分差_单关
    
    IJCLQPlayType_Confusion,//竞彩篮球 混合过关
    
    IJCZQPlayType_RQANDNO_SPF,//让球和非让球胜平负的结合体
    IJCZQPlayType_RQ_SPF,//让球胜平负
    IJCZQPlayType_SPF,//胜平负
    IJCZQPlayType_ZJQ,  //总进球数
    IJCZQPlayType_Score,//比分
    IJCZQPlayType_HalfAndAll,//半全场
    
    IJCZQPlayType_RQ_SPF_DanGuan,//让球胜平负_单管
    IJCZQPlayType_SPF_DanGuan,//胜平负_单关
    IJCZQPlayType_ZJQ_DanGuan,    //总进球数_单关
    IJCZQPlayType_Score_DanGuan,//比分_单关
    IJCZQPlayType_HalfAndAll_DanGuan,//半全场_单关
    
    
    IJCZQPlayType_Confusion,//竞彩足球 混合过关
    
    //北京单场
    IBJDCPlayType_RQ_SPF,//胜平负
    IBJDCPlayType_ZJQ,//总进球数
    IBJDCPlayType_Score,//比分
    IBJDCPlayType_HalfAndAll,//半全场
    IBJDCPlayType_SXDS,//上下单双
    
} JCPlayTypeTag;

//高频彩玩法
#define kPlayType2        (0)
#define kPlayType3        (1)
#define kPlayType4        (2)
#define kPlayType5        (3)
#define kPlayType6        (4)
#define kPlayType7        (5)
#define kPlayType8        (6)
#define kPlayType1        (7)
#define kPlayTypezu2      (8)
#define kPlayTypezhi2     (9)
#define kPlayTypezu3      (10)
#define kPlayTypezhi3     (11)

//江西11选5、广东11选5、山东十一运夺金 
//与玩法对应
#define kwinDescribtionArray_direct [NSArray arrayWithObjects:@"至少选择2个号码投注，命中任意2位即中奖！",@"至少选择3个号码投注，命中任意3位即中奖！",@"至少选择4个号码投注，命中任意4位即中奖！",@"至少选择5个号码投注，全部命中即中奖！",@"至少选择6个号码投注，选号中任意5位与开奖号码一致即中奖！",@"至少选择7个号码投注，选号中任意5位与开奖号码一致即中奖！",@"至少选择8个号码投注，选号中任意5位与开奖号码一致即中奖！",@"至少选择1个号码投注，命中开奖在号码第1位即中奖！",@"至少选择2个号码投注，投注号码与开奖号码前两位一致，位置不限即中奖！",@"每位各选1 个或多个号码投注，按位置全部命中即中奖！",@"至少选择3个号码投注，投注号码与开奖号码前三位一致，位置不限即中奖！",@"每位各选1 个或多个号码投注，按位置全部命中即中奖！",nil]

#define kwinMonneyArray_direct [NSArray arrayWithObjects:@"奖金：6元",@"奖金：19元",@"奖金：78元",@"奖金：540元",@"奖金：90元",@"奖金：26元",@"奖金：9元",@"奖金：13元",@"奖金：65元",@"奖金：130元",@"奖金：195元",@"奖金：1170元",nil]

//胆拖
#define kwinDescribtionArray_dantuo [NSArray arrayWithObjects:@"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，投注号码与开奖号码前两位一致，位置不限即中奖！",@"胆码可选1-2个，拖码至少选择2个，胆码加拖码≥4个，命中开奖号码的任意3位即中奖！",@"胆码可选1-3个，拖码至少选择2个，胆码加拖码≥5个，命中开奖号码的任意5位即中奖！",@"胆码可选1-4个，拖码至少选择2个，胆码加拖码≥6个，全部命中开奖号码即中奖！",@"胆码可选1-5个，拖码至少选择2个，胆码加拖码≥7个，选号中任意5位与开奖号码一致即中奖！",@"胆码可选1-6个，拖码至少选择2个，胆码加拖码≥8个，选号中任意5位与开奖号码一致即中奖！" ,@"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，投注号码与开奖号码前两位一致，位置不限即中奖！",@"胆码可选1-2个，拖码至少选择2个，胆码加拖码≥4个，投注号码与开奖号码前三位一致，位置不限即中奖！",nil]

#define kwinMonneyArray_dantuo [NSArray arrayWithObjects:@"奖金：6元",@"奖金：19元",@"奖金：78元",@"奖金：540元",@"奖金：90元",@"奖金：26元", @"奖金：65元",@"奖金：195元",nil]
 
//江西11选5 胆拖 （任选八）
#define kwinDescribtionArray_JXdantuo [NSArray arrayWithObjects:@"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，投注号码与开奖号码前两位一致，位置不限即中奖！",@"胆码可选1-2个，拖码至少选择2个，胆码加拖码≥4个，命中开奖号码的任意3位即中奖！",@"胆码可选1-3个，拖码至少选择2个，胆码加拖码≥5个，命中开奖号码的任意5位即中奖！",@"胆码可选1-4个，拖码至少选择2个，胆码加拖码≥6个，全部命中开奖号码即中奖！",@"胆码可选1-5个，拖码至少选择2个，胆码加拖码≥7个，选号中任意5位与开奖号码一致即中奖！",@"胆码可选1-6个，拖码至少选择2个，胆码加拖码≥8个，选号中任意5位与开奖号码一致即中奖！" ,@"胆码可选1-7个，拖码至少选择2个，胆码加拖码≥9个，选号中任意5位与开奖号码一致即中奖！"    ,@"至少选择1个胆码和2个拖码投注，胆码加拖码≥3个，投注号码与开奖号码前两位一致，位置不限即中奖！",@"胆码可选1-2个，拖码至少选择2个，胆码加拖码≥4个，投注号码与开奖号码前三位一致，位置不限即中奖！",nil]
 
#define kwinMonneyArray_JXdantuo [NSArray arrayWithObjects:@"奖金：6元",@"奖金：19元",@"奖金：78元",@"奖金：540元",@"奖金：90元",@"奖金：26元",@"奖金：9元",@"奖金：65元",@"奖金：195元",nil]

#define checkoutCaptcha  1