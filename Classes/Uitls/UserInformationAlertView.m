//
//  UserInformationAlertView.m
//  Boyacai
//
//  Created by qiushi on 13-5-13.
//
//

#import "UserInformationAlertView.h"
#import "RuYiCaiNetworkManager.h"

@implementation UserInformationAlertView
@synthesize userAlertDelegate;
@synthesize contentImage;
@synthesize nameLable  = _nameLable;
@synthesize ceridLable = _ceridLable;
@synthesize nameStr = _nameStr;
@synthesize ceridStr = _ceridStr;


- (void)dealloc
{
    [_ceridStr release];
    [_ceridStr release];
    [_nameStr release];
    [_nameLable release];
    [_ceridLable release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.bounds = CGRectMake(0, 0, 305, 341);
    }
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
    //屏蔽系统的ImageView 和 UIButton
    for (UIView *v in [self subviews]) {
//        if ([v class] == [UIImageView class]){
//            [v setHidden:YES];
//        }
        if ([v isKindOfClass:[UIButton class]] ||
            [v isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        }
    }
    
    UILabel *label1 = [[UILabel alloc]  initWithFrame:CGRectMake(20, 45, 85, 21)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"您的姓名:";
    label1.textColor = [UIColor whiteColor];
    [self addSubview:label1];
    
    self.nameLable = [[[UILabel alloc] initWithFrame:CGRectMake(110, 45, 60, 21)] autorelease];
    self.nameLable.backgroundColor = [UIColor clearColor];
    self.nameLable.textColor = [UIColor whiteColor];
    _nameLable.text = self.nameStr;
    [self addSubview: self.nameLable];
    UILabel *label2 = [[UILabel alloc]  initWithFrame:CGRectMake(20, 80, 85, 21)];
    label2.textColor = [UIColor whiteColor];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"证件号码:";
    [self addSubview:label2];
    
    self.ceridLable = [[[UILabel alloc] initWithFrame:CGRectMake(110,80, 160, 21)] autorelease];
    self.ceridLable.backgroundColor = [UIColor clearColor];
    self.ceridLable.textColor = [UIColor whiteColor];
    self.ceridLable.text = self.ceridStr;
    [self addSubview: self.ceridLable];
    
    UILabel *infoLable = [[UILabel alloc]  initWithFrame:CGRectMake(20, 115, 240, 36)];
    infoLable.backgroundColor = [UIColor clearColor];
    infoLable.lineBreakMode = UILineBreakModeWordWrap;
    infoLable.numberOfLines = 0;
        infoLable.text = @"您的账户已经绑定，如有疑问请联系客服咨询。";
    infoLable.font = [UIFont systemFontOfSize:16];
    infoLable.textColor = [UIColor whiteColor];
    [self addSubview:infoLable];
    [infoLable release];
    
    
    
    UILabel *kefuLable = [[UILabel alloc]  initWithFrame:CGRectMake(20, 155, 85, 36)];
    kefuLable.backgroundColor = [UIColor clearColor];
    kefuLable.text = @"客服电话:";
    kefuLable.textColor = [UIColor whiteColor];
    [self addSubview:kefuLable];
    [kefuLable release];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(110, 155, 150, 36)];
    button2.tag = 2;
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setTitle:@"400-856-1000" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    button2.backgroundColor = [UIColor clearColor];
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button2];
    
}

-(void) buttonClicked:(id)sender
{
    UIDevice* device = [UIDevice currentDevice];
    NSString* deviceName = [device model];
    if([deviceName isEqualToString:@"iPad"] || [deviceName isEqualToString:@"iPod touch"])
    {
        [[RuYiCaiNetworkManager sharedManager]showMessage:@"当前设备没有打电话功能！" withTitle:@"提示" buttonTitle:@"确定"];
        return;
    }
    NSURL *phoneNumberURL = [NSURL URLWithString:@"telprompt://4008561000"];
    
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
    
    [self dismissWithClickedButtonIndex:0 animated:YES];
    
}

//- (void) show {
//    [super show];
//    //    CGSize imageSize = self.backgroundImage.size;
//    //    self.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    self.frame = CGRectMake(350, 300, 320, 191);
//}
@end