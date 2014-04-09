//
//  SingleMutiMixButton.m
//  Boyacai
//
//  Created by qiushi on 13-9-6.
//
//

#import "SingleMutiMixButton.h"

@implementation SingleMutiMixButton

@synthesize moreCount = _moreCount;
@synthesize jz_NoteNumEditeViewController = _jz_NoteNumEditeViewController;

- (void)dealloc
{
    [_jz_NoteNumEditeViewController release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title Tag:(NSInteger)radioTag minWinAmount:(double)minWinAmount maxWinAmount:(double)maxWinAmount numGameCount:(int)numGameCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.text = title;
        [self setBackgroundImage:[UIImage imageNamed:@"select_c_jc_click.png"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"select_c_jc_nomal.png"] forState:UIControlStateNormal];
        
        [self setTag:radioTag];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitle:title forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        m_maxWinAmount = maxWinAmount;
        m_minWinAmount = minWinAmount;
        m_numGameCount = numGameCount;
        
        
        
    }
    return self;
}

//传进来一个X串Y的字符串，返回这种串法的个数
-(NSInteger) getNoteNumberByDuoChuanRadioTag:(NSString*)DuoChuanRadioTag
{
    int count = 0;
    
    if ([DuoChuanRadioTag isEqualToString:@"3串3"]) {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:3];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(3 - 2, (m_numGameCount - 2));
        
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:3 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"3串4"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:3] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:3];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(3 - 2, (m_numGameCount - 2));
        
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:3 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:3 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"4串4"] )
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:4];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(4 - 3, (m_numGameCount - 3));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"4串5"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:4] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:4];
        ;
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(4 - 3, (m_numGameCount - 3));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"4串6"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:4];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(4 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"4串11"])
    {
                
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:4] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:4] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:4];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(4 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:4 Y:4];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    
    else if([DuoChuanRadioTag isEqualToString:@"5串5"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(5 - 4, (m_numGameCount - 4));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"5串6"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(5 - 4, (m_numGameCount - 4));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"5串10"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"5串16"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(5 - 3, (m_numGameCount - 3));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"5串20"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"5串26"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:5] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:5];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(5 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:5 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    
    else if([DuoChuanRadioTag isEqualToString:@"6串6"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(6 - 5, (m_numGameCount - 5));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串7"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(6 - 5, (m_numGameCount - 5));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串15"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串20"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(6 - 3, (m_numGameCount - 3));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串22"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(6 - 4, (m_numGameCount - 4));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串35"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串42"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:3];
        m_minWinAmount *= RYCChoose(6 - 3, (m_numGameCount - 3));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串50"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"6串57"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:6] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:6];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(6 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:6 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"7串7"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:7];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(7 - 6, (m_numGameCount - 6));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"7串8"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:7 ChangShu:7];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(7 - 6, (m_numGameCount - 6));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:7];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"7串21"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:7];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(7 - 5, (m_numGameCount - 5));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"7串35"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:7];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(7 - 4, (m_numGameCount - 4));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"7串120"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:7] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:7 ChangShu:7];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(7 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:6];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:7 Y:7];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    
    else if([DuoChuanRadioTag isEqualToString:@"8串8"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:7 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:7];
        m_minWinAmount *= RYCChoose(8 - 7, (m_numGameCount - 7));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"8串9"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:7 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:8 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:7];
        m_minWinAmount *= RYCChoose(8 - 7, (m_numGameCount - 7));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:8];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
        
    }
    else if([DuoChuanRadioTag isEqualToString:@"8串28"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:6];
        m_minWinAmount *= RYCChoose(8 - 6, (m_numGameCount - 6));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:6];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"8串56"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:5];
        m_minWinAmount *= RYCChoose(8 - 5, (m_numGameCount - 5));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:5];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"8串70"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:4];
        m_minWinAmount *= RYCChoose(8 - 4, (m_numGameCount - 4));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:4];
        amount += m_maxWinAmount;
        
        m_maxWinAmount = amount;
    }
    else if([DuoChuanRadioTag isEqualToString:@"8串247"])
    {
        count = [_jz_NoteNumEditeViewController getDuoChuanBetNum:2 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:3 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:4 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:5 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:6 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:7 ChangShu:8] +
        [_jz_NoteNumEditeViewController getDuoChuanBetNum:8 ChangShu:8];
        
        m_minWinAmount = [_jz_NoteNumEditeViewController getMinWinAmountByX:2];
        m_minWinAmount *= RYCChoose(8 - 2, (m_numGameCount - 2));
        
        //最大
        float amount = 0.0;
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:2];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:3];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:4];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:5];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:6];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:7];
        amount += m_maxWinAmount;
        
        [_jz_NoteNumEditeViewController calculationAmountBy_X_Y:8 Y:8];
        amount += m_maxWinAmount;
        m_maxWinAmount = amount;
    }
    return count;
}




@end
