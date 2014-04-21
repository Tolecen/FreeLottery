//
//  KS_HistoryCell.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-16.
//
//

#import "KS_HistoryCell.h"
#import "ColorUtils.h"

@interface KS_HistoryCell ()
{
    UILabel *_dateLable;
    UIImageView *_firstDiceImageView;
    UIImageView *_secondDiceImageView;
    UIImageView *_thirdDiceImageView;
    UILabel *_numLable;
    UILabel *_sumLable;
    UILabel *_waitingLable;
}
@property (nonatomic, retain) UILabel *dateLable;
@property (nonatomic, retain) UIImageView *firstDiceImageView;
@property (nonatomic, retain) UIImageView *secondDiceImageView;
@property (nonatomic, retain) UIImageView *thirdDiceImageView;
@property (nonatomic, retain) UILabel *numLable;
@property (nonatomic, retain) UILabel *sumLable;
@property (nonatomic, retain) UILabel *waitingLabel;
@end

@implementation KS_HistoryCell
@synthesize issue,winCode;
@synthesize dateLable = _dateLable;
@synthesize firstDiceImageView = _firstDiceImageView;
@synthesize secondDiceImageView = _secondDiceImageView;
@synthesize thirdDiceImageView = _thirdDiceImageView;
@synthesize numLable = _numLable;
@synthesize sumLable = _sumLable;
@synthesize waitingLabel = _waitingLable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.dateLable = [[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)]autorelease];
        self.dateLable.textAlignment = UITextAlignmentCenter;
        [self.dateLable setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [self.dateLable setBackgroundColor:[UIColor clearColor]];
        [self.dateLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
        self.dateLable.text = @"00期";
        [self addSubview:_dateLable];

        UIImageView *verticalLineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ks_vertical_line.png"]];
        verticalLineImage.frame = CGRectMake(self.dateLable.frame.origin.x+self.dateLable.frame.size.width + 10, 0, 10, 40);
        [self addSubview:verticalLineImage];
        
        self.firstDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
        self.firstDiceImageView.frame = CGRectMake(verticalLineImage.frame.origin.x + verticalLineImage.frame.size.width + 10, 7, 25, 25);
        [self addSubview:_firstDiceImageView];
        
        self.secondDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
        self.secondDiceImageView.frame = CGRectMake(self.firstDiceImageView.frame.origin.x + self.firstDiceImageView.frame.size.width + 10, 7, 25, 25);
        [self addSubview:_secondDiceImageView];
        
        self.thirdDiceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dice_zero.png"]];
        self.thirdDiceImageView.frame = CGRectMake(self.secondDiceImageView.frame.origin.x + self.secondDiceImageView.frame.size.width + 10, 7, 25, 25);
        [self addSubview:_thirdDiceImageView];
        
        self.numLable = [[UILabel alloc]initWithFrame:CGRectMake(self.thirdDiceImageView.frame.origin.x + self.thirdDiceImageView.frame.size.width + 10, 10, 50, 20)];
        [self.numLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
        self.numLable.textAlignment = UITextAlignmentCenter;
        [self.numLable setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [self.numLable setBackgroundColor:[UIColor clearColor]];
        [self.numLable setText:@"正在获取..."];
        [self addSubview:_numLable];
        
        
        self.sumLable = [[UILabel alloc]initWithFrame:CGRectMake(self.numLable.frame.origin.x + self.numLable.frame.size.width , 10, 80, 20)];
        [self.sumLable setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
        self.sumLable.textAlignment = UITextAlignmentCenter;
        [self.sumLable setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [self.sumLable setBackgroundColor:[UIColor clearColor]];
        [self.sumLable setText:[NSString stringWithFormat:@" 和值  %d", 0]];
        [self addSubview:_sumLable];
        
        
        self.waitingLabel = [[UILabel alloc]initWithFrame:CGRectMake(verticalLineImage.frame.origin.x + verticalLineImage.frame.size.width + 10, 7, 200, 25)];
        [self.waitingLabel setBackgroundColor:[UIColor clearColor]];
        [self.waitingLabel setText:@"等待开奖中..." ];
        [self.waitingLabel setTextColor:[ColorUtils parseColorFromRGB:@"#C3E8E9"]];
        [self.waitingLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self addSubview:_waitingLable];
        
        
        [self setWaitingView];
    }
    return self;
}
-(void)dealloc{
    
    [issue release];
    [winCode release];
    [_dateLable release];
    [_firstDiceImageView release];
    [_secondDiceImageView release];
    [_thirdDiceImageView release];
    [_numLable release];
    [_sumLable release];
    
    [super dealloc];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setIssue:(NSString *)n{
    if (![n isEqualToString:issue]) {
        issue = [n copy];
        NSLog(@"issue:%@",issue);
        
        NSString *conciseIssue = [issue substringFromIndex:8];
        self.dateLable.text = [NSString stringWithFormat:@"%d期",[conciseIssue integerValue]];
    }
}

-(void)setWaitingView{
    [self.firstDiceImageView setHidden:YES];
    [self.secondDiceImageView setHidden:YES];
    [self.thirdDiceImageView setHidden:YES];
    [self.numLable setHidden:YES];
    [self.sumLable setHidden:YES];
    [self.waitingLabel setHidden:NO];
}
-(void)setNoWaitingView{
    [self.firstDiceImageView setHidden:NO];
    [self.secondDiceImageView setHidden:NO];
    [self.thirdDiceImageView setHidden:NO];
    [self.numLable setHidden:NO];
    [self.sumLable setHidden:NO];
    [self.waitingLabel setHidden:YES];
}
-(void)setWinCode:(NSString *)n{
    if (![n isEqualToString:winCode]) {
        winCode = [n copy];
        NSLog(@"winCode:%@",winCode);
        

        if ([n length]>=6) {
            [self setDiceImage:[n substringWithRange:NSMakeRange(0,2)] index:1];
            [self setDiceImage:[n substringWithRange:NSMakeRange(2,2)] index:2];
            [self setDiceImage:[n substringWithRange:NSMakeRange(4,2)] index:3];
            [self setNoWaitingView];
        }else{
            [self setDiceImage:@"0" index:1];
            [self setDiceImage:@"0" index:2];
            [self setDiceImage:@"0" index:3];
            [self setWaitingView];
        }
        
        [self setDiceNumAndSum:winCode];
    }
}
-(void)setDiceNumAndSum:(NSString *)n{
    if ([n length]>=6) {
        NSString *dice1 = [n substringWithRange:NSMakeRange(0,2)];
        NSString *dice2 = [n substringWithRange:NSMakeRange(2,2)];
        NSString *dice3 = [n substringWithRange:NSMakeRange(4,2)];
        
        [self.numLable setText:[NSString stringWithFormat:@" %d  %d  %d ",[dice1 integerValue],[dice2 integerValue],[dice3 integerValue]]];
        
        [self.sumLable setText:[NSString stringWithFormat:@" 和值  %d",    [dice1 integerValue]+[dice2 integerValue]+[dice3 integerValue]]];
    }else{
        [self.numLable setText:@""];
        
        [self.sumLable setText:@""];
    }
}
-(void)setDiceImage:(NSString *)n index:(NSInteger)index{
    
    NSString *imagePath = @"";
    switch ([n integerValue]) {
        case 0:
        {
            imagePath = @"dice_zero.png";
        }
             break;
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


@end
