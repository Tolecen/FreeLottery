//
//  BuyLotteryTableViewCell.m
//  RuYiCai
//
//  Created by 纳木 那咔 on 13-1-17.
//
//

#import "BuyLotteryTableViewCell.h"
#import "RuYiCaiNetworkManager.h"
#import "ColorUtils.h"


#define kKaiJiangImgTag (412)
#define kJiaJiangImgTag (413)
#define kAddAndOpenImgTag (414)

@interface BuyLotteryTableViewCell ()
{
    @private UIImageView*  _addAwardImg;
    @private UIImageView*  _openPrizeImg;
    @private UIImageView*  _addAwardAndOpenPrizeImg;
}
@property (nonatomic, retain) UIImageView*  addAwardImg;
@property (nonatomic, retain) UIImageView*  openPrizeImg;
@property (nonatomic, retain) UIImageView*  addAwardAndOpenPrizeImg;
@end

@interface BuyLotteryTableViewCell (internal)

- (void)updateInformation:(NSNotification*)notification;

@end

@implementation BuyLotteryTableViewCell
@synthesize iconImg = _iconImg;
@synthesize lotteryName = _lotteryName;
@synthesize numStage = _numStage;
@synthesize time = _time;
@synthesize endTime = _endTime;
@synthesize kLotNoType = _kLotNoType;
@synthesize lotteryLabel = _lotteryLabel;
@synthesize numStageLabel = _numStageLabel;
@synthesize timeLabel = _timeLabel;
@synthesize kaijiang = _kaijiang;
@synthesize jiajiang = _jiajiang;
@synthesize lotteryAD = _lotteryAD;
@synthesize lotteryADContent = _lotteryADContent;
@synthesize prizeType;
@synthesize jzBackAwardLv = _jzBackAwardLv;
@synthesize jlBackAwardLv = _jlBackAwardLv;
@synthesize bdBackAwardLv = _bdBackAwardLv;

@synthesize addAwardImg = _addAwardImg;
@synthesize openPrizeImg = _openPrizeImg;
@synthesize addAwardAndOpenPrizeImg = _addAwardAndOpenPrizeImg;

- (void)drawRect:(CGRect)rect
{
//    UIImage *image = [UIImage imageNamed: @"gou_cai_da_ting_cell_separator.png"];   //TODO
//    [image drawInRect:CGRectMake(0, 0, 320, 1)];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79, 320, 1)];
        [lineImgView setImage:[UIImage imageNamed:@"gou_cai_da_ting_cell_separator.png"]];
        [self addSubview:lineImgView];
        [lineImgView release];
        
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(305, 40, 6, 8)];
        [bgImgView setImage:[UIImage imageNamed:@"cell_accessory_style.png"]];
        [self addSubview:bgImgView];
        [bgImgView release];
        
        
        self.backgroundColor = [ColorUtils parseColorFromRGB:@"#efede9"];
        
        self.iconImg = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 60, 60)] autorelease];
        [self addSubview:self.iconImg];
        
        self.lotteryLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 20, 140, 20)] autorelease];
        self.lotteryLabel.textColor = [UIColor blackColor];
        self.lotteryLabel.textAlignment = UITextAlignmentLeft;
        self.lotteryLabel.backgroundColor = [UIColor clearColor];
        self.lotteryLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:_lotteryLabel];
        
        //距离XX期截止
        self.numStageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(90, 43, 200, 30)] autorelease];
        self.numStageLabel.textAlignment = UITextAlignmentLeft;
        self.numStageLabel.backgroundColor = [UIColor clearColor];
        self.numStageLabel.font = [UIFont boldSystemFontOfSize:9];
        self.numStageLabel.textColor = [ColorUtils parseColorFromRGB:@"#464646"];
        [self addSubview:_numStageLabel];
        
        //彩种宣传语
        self.lotteryAD = [[[UILabel alloc] initWithFrame:CGRectMake(165, 15, 135, 30)] autorelease];
        self.lotteryAD.textAlignment = UITextAlignmentRight;
        self.lotteryAD.textColor = [UIColor redColor];
        self.lotteryAD.backgroundColor = [UIColor clearColor];
        self.lotteryAD.font = [UIFont boldSystemFontOfSize:10];
        [self addSubview:_lotteryAD];
        
        //倒计时时间（不再使用）
        self.timeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(195, 40, 135, 30)] autorelease];
        self.timeLabel.textAlignment = UITextAlignmentCenter;
        self.timeLabel.textColor = [ColorUtils parseColorFromRGB:@"3c3c3c"];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:9];
        [self addSubview:_timeLabel];
        
        self.addAwardImg = [[[UIImageView alloc] initWithFrame:CGRectMake(277, 4, 43, 14)]autorelease];
        self.addAwardImg.image = RYCImageNamed(@"jiajiang_tb.png");
        self.addAwardImg.backgroundColor = [UIColor clearColor];
        self.addAwardImg.tag = kJiaJiangImgTag;
        [self addSubview:_addAwardImg];

        self.openPrizeImg = [[[UIImageView alloc] initWithFrame:CGRectMake(277, 4, 43, 14)]autorelease];
        self.openPrizeImg.image = RYCImageNamed(@"kaijiang_tb.png");
        self.openPrizeImg.backgroundColor = [UIColor clearColor];
        self.openPrizeImg.tag = kKaiJiangImgTag;
        [self addSubview:_openPrizeImg];
        
        self.addAwardAndOpenPrizeImg = [[[UIImageView alloc] initWithFrame:CGRectMake(263, 4, 57, 14)]autorelease];
        self.addAwardAndOpenPrizeImg.image = RYCImageNamed(@"kaijiang_jiajiang_tb.png");
        self.addAwardAndOpenPrizeImg.backgroundColor = [UIColor clearColor];
        self.addAwardAndOpenPrizeImg.tag = kAddAndOpenImgTag;
        [self addSubview:_addAwardAndOpenPrizeImg];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)refreshDate{
    
    switch (self.prizeType) {
        case TodayNothing:
            [self.addAwardImg setHidden:YES];
            [self.openPrizeImg setHidden:YES];
            [self.addAwardAndOpenPrizeImg setHidden:YES];
            break;
        case TodayAddAward:
            [self.addAwardImg setHidden:NO];
            [self.openPrizeImg setHidden:YES];
            [self.addAwardAndOpenPrizeImg setHidden:YES];
            break;
        case TodayOpenPrize:
            [self.addAwardImg setHidden:YES];
            [self.openPrizeImg setHidden:NO];
            [self.addAwardAndOpenPrizeImg setHidden:YES];
            break;
        case TodayAddAwardAndOpenPrize:
            [self.addAwardImg setHidden:YES];
            [self.openPrizeImg setHidden:YES];
            [self.addAwardAndOpenPrizeImg setHidden:NO];
            break;
        default:
            [self.addAwardImg setHidden:YES];
            [self.openPrizeImg setHidden:YES];
            [self.addAwardAndOpenPrizeImg setHidden:YES];
            break;
    }

    
    self.lotteryAD.text = self.lotteryADContent;
    
    if([self.kLotNoType isEqualToString:kLotNoJCZQ]){
        self.lotteryLabel.text = [NSString stringWithFormat:@"%@",self.lotteryName];
        if(![self.jzBackAwardLv isEqualToString:@""])
        {
            self.numStageLabel.text = [NSString stringWithFormat:@"最近比赛：%@VS%@",[[self.jzBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:0],[[self.jzBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:1]];
        }else
        {
            self.numStageLabel.text = @"当前暂无比赛";

        }
        
//        self.timeLabel.text = @"69%";
    }
    else if([self.kLotNoType isEqualToString:kLotNoJCLQ])
    {
        self.lotteryLabel.text = [NSString stringWithFormat:@"%@",self.lotteryName];
        
        if(![self.jlBackAwardLv isEqualToString:@""])
        {
            self.numStageLabel.text = [NSString stringWithFormat:@"最近比赛：%@VS%@",[[self.jlBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:0],[[self.jlBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:1]];
        }else
        {
            self.numStageLabel.text = @"当前暂无比赛";
            
        }
//        self.timeLabel.text = @"69%";
    }
    else if([self.kLotNoType isEqualToString:kLotNoBJDC])
    {
        self.lotteryLabel.text = [NSString stringWithFormat:@"%@",self.lotteryName];
        
        if(![self.bdBackAwardLv isEqualToString:@""])
        {
            self.numStageLabel.text =[NSString stringWithFormat:@"最近比赛：%@VS%@",[[self.bdBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:0],[[self.bdBackAwardLv componentsSeparatedByString:@":"] objectAtIndex:1]];
        }else
        {
            self.numStageLabel.text = @"当前暂无比赛";
            
        }
        //        self.timeLabel.text = @"69%";
    }
    else
    {
        self.lotteryLabel.text = [NSString stringWithFormat:@"%@",self.lotteryName];
        self.numStageLabel.text = [NSString stringWithFormat:@"离%0.0lf期截止:",[self.numStage doubleValue]];
        NSString *lotteryTime = [NSString stringWithFormat:@"%@%@",
                                 [NSString stringWithFormat:@"离%0.0lf期截止 : ",[self.numStage doubleValue]],
                                 self.endTime];
        
        self.numStageLabel.text = lotteryTime;
//        self.timeLabel.text = self.endTime;
        
    }
}




//- (void)queryTodayOpenOrAddOK:(NSNotification*)notification//今日开奖、加奖
//{
//    
//    
//    NSObject *obj = [notification object];
//    NSString *str = (NSString*)obj;
//    NSLog(@"%@",str);
//    SBJsonParser *jsonParser = [SBJsonParser new];
//    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:str];
//    [jsonParser release];
//    
//    [CommonRecordStatus commonRecordStatusManager].inProgressActivityCount = [NSString stringWithFormat:@"%@", [parserDict objectForKey:@"inProgressActivityCount"]];
//    
//    
//    if([[[parserDict objectForKey:self.kLotNoType] objectForKey:@"isAddAward"] isEqualToString:@"true"])
//    {
//        [[self viewWithTag:kJiaJiangImgTag] removeFromSuperview];
//        
//        UIImageView*  jiaImg = [[UIImageView alloc] initWithFrame:CGRectMake(294, 4, 15, 70)];
//        jiaImg.image = RYCImageNamed(@"jiajiang_tb.png");
//        jiaImg.backgroundColor = [UIColor clearColor];
//        jiaImg.tag = kJiaJiangImgTag;
//        [self addSubview:jiaImg];
//        [jiaImg release];
//    }
//    else
//    {
//        [[self viewWithTag:kJiaJiangImgTag] removeFromSuperview];
//    }
//    if([[[parserDict objectForKey:self.kLotNoType] objectForKey:@"isTodayOpenPrize"] isEqualToString:@"true"])
//    {
//        [[self viewWithTag:kKaiJiangImgTag] removeFromSuperview];
//        
//        UIImageView*  openImg = [[UIImageView alloc] initWithFrame:CGRectMake(294, 4, 15, 70)];
//        openImg.image = RYCImageNamed(@"kaijiang_tb.png");
//        openImg.backgroundColor = [UIColor clearColor];
//        openImg.tag = kKaiJiangImgTag;
//        [self addSubview:openImg];
//        [openImg release];
//    }
//    else
//    {
//        [[self viewWithTag:kKaiJiangImgTag] removeFromSuperview];
//    }
//      
//}


-(void)dealloc{
    [_bdBackAwardLv release];
    [_jlBackAwardLv release];
    [_jzBackAwardLv release];
    [_iconImg release];
    [_lotteryName release];
    [_numStage release];
    [_time release];
    [_endTime release];
    [_lotteryLabel release];
    [_numStageLabel release];
    [_timeLabel release];
    [_kLotNoType release];
    [_lotteryAD release];
    prizeType = nil;
    [_addAwardImg release];
    [_openPrizeImg release];
    [_addAwardAndOpenPrizeImg release];
    [super dealloc];
}

@end
