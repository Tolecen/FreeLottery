//
//  CustomeUserAlertView.m
//  Boyacai
//
//  Created by qiushi on 13-9-24.
//
//

#import "CustomeUserAlertView.h"


@implementation CustomeUserAlertView
@synthesize myView;
@synthesize activityIndicator;
@synthesize animation;
@synthesize delegate;
-(id)init{
    if (self=[super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        //UIWindow的层级 总共有三种
        self.windowLevel = UIWindowLevelAlert;
        myView = [[UIView alloc]initWithFrame:CGRectMake(30, 140, 260, 200)];
        UIButton *okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [okButton setBackgroundImage:[UIImage imageNamed:@"thenew1.png"] forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(pressoKButton:) forControlEvents:UIControlEventTouchUpInside];
        okButton.frame = CGRectMake(90, 130, 80, 40);
        [myView addSubview:okButton];
        // [okButton release];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(105, 75, 50, 50)];
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
        [myView addSubview:activityIndicator];
        // [activityIndicator release];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:myView.bounds];
        [imageView setImage:[[UIImage imageNamed:@"thenew1.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
        [myView insertSubview:imageView atIndex:0];
        [imageView release];
        
        animation = [[CustomizedAlertAnimation alloc]customizedAlertAnimationWithUIview:myView];
        animation.delegate = self;
        [self addSubview:myView];
        [myView release];
    }
    
    return self;
}


-(void)show{
    [self makeKeyAndVisible];
    [animation showAlertAnimation];
}

-(void)dismiss{
    
    [self resignKeyWindow];
    [animation dismissAlertAnimation];
    
}

-(void) pressoKButton:(id)sender{
    [self dismiss];
}


#pragma mark -- CustomizedAlertAnimationDelegate


//自定义的alert view出现动画结束后调用
-(void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v{
    NSLog(@"showCustomizedAlertAnimationIsOverWithUIView");
    [activityIndicator startAnimating];
}

//自定义的alert view消失动画结束后调用
-(void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v{
    NSLog(@"dismissCustomizedAlertAnimationIsOverWithUIView");
    [activityIndicator stopAnimating];
    
    [self.delegate CustomeAlertViewDismiss:self];
    
}


@end
