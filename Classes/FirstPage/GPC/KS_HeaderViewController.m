//
//  KS_HeaderViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-16.
//
//

#import "KS_HeaderViewController.h"
#import "ColorUtils.h"
#import "RuYiCaiNetworkManager.h"

@interface KS_HeaderViewController ()
{
    NSString *_batchCode;
    NSString *_batchEndTime;
    NSTimer *_timer;
    
    UILabel *_numLable;
    UIImageView *_firstDiceImageView;
    UIImageView *_secondDiceImageView;
    UIImageView *_thirdDiceImageView;
    UIImageView *_winningImageView;
    UILabel *_waitingLabel;
    
    BOOL _isHaveAnnouncedTheWinningData;
    
    UILabel *_endLable;
    UILabel *_timeLable;
    
    BOOL _isArtificialGetData;//手动控制页面开奖接口调用
    
}
@property (nonatomic, retain) NSString *batchCode;
@property (nonatomic, retain) NSString *batchEndTime;
@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) UILabel *numLable;
@property (nonatomic, retain) UIImageView *firstDiceImageView;
@property (nonatomic, retain) UIImageView *secondDiceImageView;
@property (nonatomic, retain) UIImageView *thirdDiceImageView;
@property (nonatomic, retain) UIImageView *winningImageView;
@property (nonatomic, retain) UILabel *waitingLabel;
@property (nonatomic, assign) BOOL isHaveAnnouncedTheWinningData;

@property (nonatomic, retain) UILabel *endLable;
@property (nonatomic, retain) UILabel *timeLable;

@property (nonatomic, assign)  BOOL isArtificialGetData;

//等待网络数据view显示
-(void)waitingInternetView;
//没有公布开奖view显示
-(void)notHaveAnnouncedTheWinningView;
//公布开奖view显示
-(void)haveAnnouncedTheWinningView;
@end

@implementation KS_HeaderViewController
@synthesize batchCode = _batchCode;
@synthesize batchEndTime = _batchEndTime;
@synthesize timer = _timer;
@synthesize delegate = _delegate;

@synthesize numLable = _numLable;
@synthesize firstDiceImageView = _firstDiceImageView;
@synthesize secondDiceImageView = _secondDiceImageView;
@synthesize thirdDiceImageView = _thirdDiceImageView;
@synthesize winningImageView = _winningImageView;
@synthesize waitingLabel = _waitingLabel;

@synthesize endLable = _endLable;
@synthesize timeLable = _timeLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    
    NSLog(@"headerViewController is dead!");
    [_batchCode release];
    [_batchEndTime release];
    [_endLable release];
    [_timeLable release];
    [super dealloc];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.numLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
    [self.numLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
    self.numLable.textAlignment = UITextAlignmentCenter;
    [self.numLable setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.numLable setBackgroundColor:[UIColor clearColor]];
    //    [self.numLable setText:[NSString stringWithFormat:@"%d期开奖:%d %d %d",20,1,2,3]];
    [self.numLable setText:[NSString stringWithFormat:@"数据获取中..."]];
    [self.view addSubview:_numLable];
    
    
    self.endLable = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 100, 20)];
    [self.endLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
    self.endLable.textAlignment = UITextAlignmentCenter;
    [self.endLable setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [self.endLable setBackgroundColor:[UIColor clearColor]];
    [self.endLable setText:[NSString stringWithFormat:@"距%d期截止",0]];
    [self.view addSubview:_endLable];
    
    
    self.firstDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
    self.firstDiceImageView.frame = CGRectMake(22, 25, 28, 28);
    [self.view addSubview:_firstDiceImageView];
    
    self.secondDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
    self.secondDiceImageView.frame = CGRectMake(self.firstDiceImageView.frame.origin.x + self.firstDiceImageView.frame.size.width + 5, 25, 28, 28);
    [self.view addSubview:_secondDiceImageView];
    
    self.thirdDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
    self.thirdDiceImageView.frame = CGRectMake(self.secondDiceImageView.frame.origin.x + self.secondDiceImageView.frame.size.width + 5, 25, 28, 28);
    [self.view addSubview:_thirdDiceImageView];
    
    
    
    self.winningImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"waiting.png"]];
    [self.winningImageView setFrame:CGRectMake(18, 29, 22, 22)];
    [self.view addSubview:_winningImageView];
    
    self.waitingLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.winningImageView.frame.origin.x + self.winningImageView.frame.size.width + 5, 27, 100, 26)];
    [self.waitingLabel setText:@"等待开奖"];
    [self.waitingLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [self.waitingLabel setBackgroundColor:[UIColor clearColor]];
    [self.waitingLabel setTextAlignment:NSTextAlignmentLeft];
    [self.waitingLabel setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
    [self.view addSubview:_waitingLabel];
    
    
    
    self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(199, 23, 100, 30)];
    [self.timeLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
    self.timeLable.textAlignment = UITextAlignmentCenter;
    [self.timeLable setFont:[UIFont systemFontOfSize:25.0f]];
    [self.timeLable setBackgroundColor:[UIColor clearColor]];
    [self.timeLable setText:[NSString stringWithFormat:@"%@:%@",@"00",@"00"]];
    [self.view addSubview:_timeLable];
    
	// Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取当前期号和时间-收听开启
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInformation:) name:@"updateInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatehighFrequencyInquiryTheWinningInformation:) name:@"updatehighFrequencyInquiryTheWinningInformation" object:nil];
    
    [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiry:kLotNoNMK3];
    [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiryTheWinningInformation:kLotNoNMK3 Maxresult:5];
    [self notHaveAnnouncedTheWinningView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    //获取当前期号和时间-收听销毁
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateInformation" object:nil];
    //最近期开奖查询-收听销毁
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updatehighFrequencyInquiryTheWinningInformation" object:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)waitingInternetView{
    
}
-(void)notHaveAnnouncedTheWinningView{
    
    [self.firstDiceImageView setHidden:YES];
    [self.secondDiceImageView setHidden:YES];
    [self.thirdDiceImageView setHidden:YES];
    
    [self.winningImageView setHidden:NO];
    [self.waitingLabel setHidden:NO];
    self.isHaveAnnouncedTheWinningData = NO;
    self.isArtificialGetData = NO;
}
-(void)haveAnnouncedTheWinningView{
    [self.firstDiceImageView setHidden:NO];
    [self.secondDiceImageView setHidden:NO];
    [self.thirdDiceImageView setHidden:NO];
    
    [self.winningImageView setHidden:YES];
    [self.waitingLabel setHidden:YES];
    self.isHaveAnnouncedTheWinningData = YES;
    self.isArtificialGetData = NO;
}
-(void)setDiceImage:(NSString *)n index:(NSInteger)index{
    
    NSString *imagePath = @"";
    switch ([n integerValue]) {
        case 0:
        {
            imagePath = @"dice_zero.png";
        }
        case 1:
        {
            imagePath = @"dice_one.png";
        }
            break;
        case 2:
        {
            imagePath = @"dice_two.png";
        }
            break;
        case 3:
        {
            imagePath = @"dice_three.png";
        }
            break;
        case 4:
        {
            imagePath = @"dice_four.png";
        }
            break;
        case 5:
        {
            imagePath = @"dice_five.png";
        }
            break;
        case 6:
        {
            imagePath = @"dice_six.png";
        }
            break;
            
        default:
            break;
    }
    
    switch (index) {
        case 1:
        {
            [self.firstDiceImageView setImage:[UIImage imageNamed:imagePath]];
        }
            break;
        case 2:
        {
            [self.secondDiceImageView setImage:[UIImage imageNamed:imagePath]];
        }
            break;
        case 3:
        {
            [self.thirdDiceImageView setImage:[UIImage imageNamed:imagePath]];
        }
            break;
            
        default:
            break;
    }
}
-(void)refreshHistoryData:(id)data{
    NSTrace();
    if(!self.isHaveAnnouncedTheWinningData && self.isArtificialGetData ){
        [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiryTheWinningInformation:kLotNoNMK3 Maxresult:1];
    }
}
#pragma mark notification NSTimer method
- (void)updatehighFrequencyInquiryTheWinningInformation:(NSNotification*)notification
{
    NSTrace();
    NSArray *contents = (NSArray*)notification.userInfo;
    NSDictionary *contentDic = [NSDictionary dictionary];
    if ([contents count] > 0) {
        contentDic= (NSDictionary *)[contents objectAtIndex:0];
    }
    
    
    //    if (!contentDic) {
    //        return;
    //    }
    //    if ([KISDictionaryHaveKey(contentDic, @"batchCode") isEqualToString:@""]) {
    //        return;
    //    }
    //    if ([KISDictionaryHaveKey(contentDic, @"winCode") isEqualToString:@""]) {
    //        return;
    //    }
    
    NSString *historyBatchCode = [contentDic objectForKey:@"batchCode"];
    NSString *numDate = @"0";
    if ([historyBatchCode length]>8) {
        //从第8位截取数值
        numDate= [historyBatchCode substringFromIndex:8];
    }

    //未开奖
    do {
        if (![[contentDic objectForKey:@"winCode"] isEqualToString:@""]) {
            break;
        }
        
        self.numLable.text = [NSString stringWithFormat:@"%d期等待开奖",[numDate integerValue]];
        [self notHaveAnnouncedTheWinningView];
    } while (NO);
    //已开奖
    do {
        if ([[contentDic objectForKey:@"winCode"] isEqualToString:@""]) {
            break;
        }
        NSString *winCode = [contentDic objectForKey:@"winCode"];
        [self.numLable setText:[NSString stringWithFormat:@"%d期开奖:%d %d %d",
                                [numDate integerValue],
                                [[winCode substringWithRange:NSMakeRange(0,2)] integerValue],
                                [[winCode substringWithRange:NSMakeRange(2,2)] integerValue],
                                [[winCode substringWithRange:NSMakeRange(4,2)] integerValue]]];
        [self setDiceImage:[winCode substringWithRange:NSMakeRange(0,2)] index:1];
        [self setDiceImage:[winCode substringWithRange:NSMakeRange(2,2)] index:2];
        [self setDiceImage:[winCode substringWithRange:NSMakeRange(4,2)] index:3];
        [self haveAnnouncedTheWinningView];
        
    } while (NO);
    
    NSLog(@"------contents---------%@",contents);
    
    if(_delegate && [_delegate respondsToSelector:@selector(refreshHistoryData:)])
    {
        [self.delegate  refreshWinningHistoryData:contents];
    }
    
}
- (void)updateInformation:(NSNotification*)notification
{
	NSLog(@"updatefor******");
	self.batchCode = [[RuYiCaiNetworkManager sharedManager] highFrequencyCurrentCode];

    sharedAPP.betchString = self.batchCode;
    
    NSLog(@"betchString======%@",sharedAPP.betchString);
    
    NSLog(@"%@",self.batchCode);
    self.batchEndTime = [[RuYiCaiNetworkManager sharedManager] highFrequencyLeftTime];
    
    NSLog(@"updateInformation- batchEndTime %@",self.batchEndTime);
    NSString *numDate = @"0";
    if ([self.batchCode length]>8) {
        //从第8位截取数值
        numDate= [self.batchCode substringFromIndex:8];
    }

	_endLable.text = [NSString stringWithFormat:@"距%d期截止",[numDate integerValue]];

    if ( [_timer isValid]) {
        NSLog(@"重新启动");
        [_timer setFireDate:[NSDate distantPast]];
    }else{
        NSLog(@"timer开始");
		_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(refreshEndTime) userInfo:nil repeats:YES];
    }

}
- (void)refreshEndTime
{
    if (0 == self.batchEndTime.length)
    {
		return;
    }
	self.timeLable.text = @"00:00";
	int leftTime = [self.batchEndTime intValue];
    
	if (leftTime > 0)
	{
	    int numMinute = (int)(leftTime / 60.0);
		leftTime -= numMinute * 60.0;
		int numSecond = (int)(leftTime);
        NSString *numMS = @"00";
        if (9>=numMinute && numMinute>=0) {
            numMS = [NSString stringWithFormat:@"0%d",numMinute];
        }else{
            numMS = [NSString stringWithFormat:@"%d",numMinute];
        }
        NSString *numSS = @"00";
        if (9>=numSecond && numSecond>=0) {
            numSS = [NSString stringWithFormat:@"0%d",numSecond];
        }else{
            numSS = [NSString stringWithFormat:@"%d",numSecond];
        }
	    self.timeLable.text = [NSString stringWithFormat:@"%@:%@",
                               numMS, numSS];
		self.batchEndTime = [NSString stringWithFormat:@"%d",[self.batchEndTime intValue]-1];
        
        if (numMinute >= 6 && leftTime%60 == 0 && !self.isHaveAnnouncedTheWinningData) {
            NSLog(@"-----每过一分钟调用一次----");
            [[RuYiCaiNetworkManager sharedManager]highFrequencyInquiryTheWinningInformation:kLotNoNMK3 Maxresult:5];
            self.isArtificialGetData = NO;
        }
        if (numMinute <= 6 ) {
            self.isArtificialGetData = YES;
        }

	}
	else if(leftTime == 0)//防止过期彩种
	{
		if([_timer isValid])
		{
            NSLog(@"防止过期彩种");
            [_timer setFireDate:[NSDate distantFuture]];
		}
        
 	    [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiry:kLotNoNMK3];
        [[RuYiCaiNetworkManager sharedManager] highFrequencyInquiryTheWinningInformation:kLotNoNMK3 Maxresult:5];
        //		[[RuYiCaiNetworkManager sharedManager] showMessage:[NSString stringWithFormat:@"快三%@期时间已到，进入下一期" , self.batchCode] withTitle:@"提示" buttonTitle:@"确定"];
        
	}
	else //时间为负时，停止调用
	{
		if([_timer isValid])
		{
            NSLog(@"_timer 销毁停用");
			[_timer invalidate];
			_timer = nil;
		}
	}
}
@end
