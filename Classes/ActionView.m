//
//  ActionView.m
//  Boyacai
//
//  Created by wangxr on 14-4-15.
//
//

#import "ActionView.h"
@interface ActionView ()
@property (nonatomic,retain)NSMutableArray *labelArray;
@end
@implementation ActionView
- (void)dealloc
{
    [_labelArray release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed: @"title_bg.png"];
        self.backgroundColor = [UIColor colorWithPatternImage:image];
        self.labelArray = [NSMutableArray array];
        switch ([[self class] actionType]) {
            case 0:{
                self.actionType = 0;
            }break;
            case 1:{
                self.actionType = 1;
            }break;
                
            default:
                break;
        }
        [self loadSubView];
        
    }
    return  self;
}
- (void)loadSubView
{
    if (_actionType) {
        for (int i = 0; i<4; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [self randomString];
            [_labelArray addObject:label];
            [self addSubview:label];
            [label release];
        }
        [self reloadSubView];
        UILabel * label = _labelArray[3];
        label.frame =CGRectMake(0, 80, 320, 20);
        label.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(animateWithActionType1) userInfo:nil repeats:YES];
    }else
    {
        UILabel * label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.frame = CGRectMake(0, 10, 320, 20);
        [_labelArray addObject:label];
        label.text = [self randomString];
        [self addSubview:label];
        [label release];
        [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(animateWithActionType0) userInfo:nil repeats:YES];
    }
}
- (NSString*)randomString
{
    NSInteger b ;
    if (arc4random()%10<8) {
        b = 3;
    }else
    {
        b = 5;
    }
    NSInteger a = arc4random()%b;
    switch (a) {
        case 0:{
            return [NSString stringWithFormat:@"恭喜用户%@完成任务获得%d彩豆。",[self randomPhoneNo],(arc4random()%500+100)];
        }break;
        case 1:{
            return [NSString stringWithFormat:@"恭喜用户%@成功购买%d注彩票。",[self randomPhoneNo],(arc4random()%5+1)];
        }break;
        case 2:{
            return [NSString stringWithFormat:@"恭喜用户%@成功兑换%d彩豆。",[self randomPhoneNo],(arc4random()%9900+100)];
        }break;
        case 3:{
            return [NSString stringWithFormat:@"恭喜用户%@成功提现%d元。",[self randomPhoneNo],(arc4random()%5000+1)*10];
        }break;
        case 4:{
            return [NSString stringWithFormat:@"恭喜用户%@中奖获得%d元。",[self randomPhoneNo],[self randommoney]];
        }break;
            
        default:{
            return @"";
        }
            break;
    }
    
}
- (NSInteger)randommoney
{
    NSArray * array = @[@"4",@"5",@"6",@"9",@"10",@"11",@"13",@"19",@"20",@"26",@"30",@"58",@"65",@"78",@"90",@"116",@"117",@"130",@"160",@"190",@"195",@"540"];
    return (arc4random()%5+1)*[array[arc4random()%array.count] integerValue];
}
- (NSString*)randomPhoneNo
{
    NSInteger a  = 3;
    switch (arc4random()%3) {
        case 0:
            a = 3;
            break;
        case 1:
            a = 5;
            break;
        case 3:
            a = 8;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"1%d*****%d%d%d%d",a,arc4random()%10,arc4random()%10,arc4random()%10,arc4random()%10];
}

- (void)reloadSubView
{
    for (int i = 0; i<4; i++) {
        UILabel * label = _labelArray[i];
        if (i ==3) {
            label.frame = CGRectMake(0, -10, 320, 20);
            label.hidden = YES;
        }else{
            label.frame = CGRectMake(0, 10+i*20, 320, 20);
            label.hidden = NO;
        }
        if (i==1) {
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:14];
        }else
        {
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont boldSystemFontOfSize:12];
        }
    }
}
- (void)hiddenSelf
{
    self.hidden = YES;
}
- (void)animateWithActionType0
{
    self.hidden = NO;
    UILabel * label = _labelArray[0];
    label.text = [self randomString];
    [self performSelector:@selector(hiddenSelf) withObject:nil afterDelay:10];
}
- (void)animateWithActionType1
{
    UILabel * label = _labelArray[0];
    [_labelArray removeObjectAtIndex:0];
    [_labelArray addObject:label];
    [UIView animateWithDuration:0.3 animations:^{
        [self reloadSubView];
    }completion:^(BOOL finished) {
        label.frame =CGRectMake(0, 80, 320, 20);
        label.hidden = NO;
        label.text = [self randomString];
    }];
}
- (void)setFrame:(CGRect)frame
{
    frame.size = [self ViewSize];
    [super setFrame:frame];
}
- (CGSize)ViewSize
{
    if (_actionType) {
        return CGSizeMake(320, 80);
    }else
    {
        return CGSizeMake(320, 40);
    }
}
+(NSInteger)actionType
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString* date = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    if ([date intValue]>=23||[date intValue]<7) {
        return 0;
    }else
    {
        return 1;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end