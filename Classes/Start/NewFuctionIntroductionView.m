//
//  NewFuctionIntroductionView.m
//  RuYiCai
//
//  Created by ruyicai on 12-4-27.
/*  
    weiliang   开机界面之后 新版本功能介绍
 */

#import "NewFuctionIntroductionView.h"
#import "RYCImageNamed.h"
@interface NewFuctionIntroductionView (internal)
-(void) startButtonClick;
@end

@implementation NewFuctionIntroductionView
@synthesize scrollView = m_scrollView;
@synthesize startButton = m_startButton;
@synthesize delegate = m_delegate;
@synthesize customPageControl = _customPageControl;
- (void)viewDidAppear:(BOOL)animated
{
    
}
- (id)initWithFrame:(CGRect)frame FirstTime:(BOOL)ifFirstIn
{
    self = [super initWithFrame:frame];
    if (self)
    {	
        //设置 scollview的 rect
        times = 0;
        self.backgroundColor = [UIColor blackColor];
    	CGRect frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
        m_scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = YES;
        if (ifFirstIn) {
            self.scrollView.contentSize = CGSizeMake(320 * 6, [UIScreen mainScreen].bounds.size.height);
        }
        else
        {
            self.scrollView.contentSize = CGSizeMake(320 * 5, [UIScreen mainScreen].bounds.size.height);
        }
        
        self.scrollView.scrollEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        //用来调整 首页面位置
        CGRect rect = CGRectMake(0, 0,   
                                 self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:YES]; 
        [self addSubview:self.scrollView];
        
        UIImageView* image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        image1.image = RYCImageNamed(@"1.jpg");
        [m_scrollView addSubview:image1];
        [image1 release];
        
        UIImageView* image2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        image2.image = RYCImageNamed(@"2.jpg");
        [m_scrollView addSubview:image2];
        [image2 release];
        
        UIImageView* image3 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 2, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        image3.image = RYCImageNamed(@"3.jpg");
        [m_scrollView addSubview:image3];
        [image3 release];
        
        UIImageView* image4 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 3, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        image4.image = RYCImageNamed(@"4.jpg");
        [m_scrollView addSubview:image4];
        [image4 release];
        
        UIImageView* image5 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 4, 0, 320, [UIScreen mainScreen].bounds.size.height)];
        image5.image = RYCImageNamed(@"5.jpg");
        [m_scrollView addSubview:image5];
        [image5 release];
        
        if(ifFirstIn){
            UIImageView* image6 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 5, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            image6.image = RYCImageNamed(@"6.png");
            [m_scrollView addSubview:image6];
            [image6 release];
            
            m_startButton = [[UIButton alloc] initWithFrame:CGRectMake(320 * 4, [UIScreen mainScreen].bounds.size.height - 100, 320, 100)];
            //        [m_startButton setBackgroundColor:[UIColor redColor]];
            
            [m_startButton addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [m_scrollView addSubview:m_startButton];
        }
        
//        UIImageView* image4 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 3, 0, 320, [UIScreen mainScreen].bounds.size.height)];
//        image4.image = RYCImageNamed(@"thenew4.png");
//        [m_scrollView addSubview:image4];
//        [image4 release];
//        
//        UIImageView* image5 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 4, 0, 320, [UIScreen mainScreen].bounds.size.height)];
//        image5.image = RYCImageNamed(@"thenew5.png");
//        [m_scrollView addSubview:image5];
//        [image5 release];
        
        //点击 按钮375 × 132
//        m_startButton = [[UIButton alloc] initWithFrame:CGRectMake(320 * 3 - 207/2, [UIScreen mainScreen].bounds.size.height - 415/2, 207/2, 415/2)];
//        [m_startButton setBackgroundImage:RYCImageNamed(@"thenew_c_startBtn.png") forState:UIControlStateNormal];
//        [m_startButton setBackgroundImage:RYCImageNamed(@"thenew_c_btnClick.png") forState:UIControlStateHighlighted];

        
        
        //-----添加-pageControl-----
        [self.customPageControl setEnabled:YES];
        self.customPageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [self.customPageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
//        [self addSubview:self.customPageControl];
        [self.customPageControl release];
        if(KISiPhone5){
            [self.customPageControl setFrame:CGRectMake(115,530, 100, 16)];
        }else{
            [self.customPageControl setFrame:CGRectMake(115,440, 100, 16)];
        }
        
        
        [self.customPageControl setPageControlStyle:PageControlStyleCustom];
        
//        [self.customPageControl setThumbImageArray:[NSMutableArray arrayWithObjects:
//                                                    [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                    [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                    [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                    nil]];
//        NSLog(@"%d",[self.customPageControl.thumbImageArray count]);
//        [self.customPageControl setSelectedThumbImageArray:[NSMutableArray arrayWithObjects:
//                                                            [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                            [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                            [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                            nil]];

        [self.customPageControl setThumbImageArray:[NSMutableArray arrayWithObjects:
                                                    [UIImage imageNamed:@"page_style_c_hove"],
                                                    [UIImage imageNamed:@"page_style_c_hove"],
                                                    [UIImage imageNamed:@"page_style_c_hove"],
                                                    nil]];
        NSLog(@"%d",[self.customPageControl.thumbImageArray count]);
        [self.customPageControl setSelectedThumbImageArray:[NSMutableArray arrayWithObjects:
                                                            [UIImage imageNamed:@"page_style_c_normal"],
                                                            [UIImage imageNamed:@"page_style_c_normal"],
                                                            [UIImage imageNamed:@"page_style_c_normal"],
                                                            nil]];
        NSLog(@"%d",[self.customPageControl.selectedThumbImageArray count]);
        [self.customPageControl setCurrentPage:0];
        [self.customPageControl setNumberOfPages:5];
    }
    return self;

}
-(void)addCloseBtn
{
    BOOL IOS7 = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        IOS7 = YES;
    }
    else IOS7 = NO;
    UIButton *buttonLogin = [[UIButton alloc] initWithFrame:CGRectMake(10, IOS7?20:10, 52, 30)];
    [buttonLogin setTitle:@"关闭" forState:UIControlStateNormal];
    buttonLogin.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonLogin setBackgroundImage:RYCImageNamed(@"item_bar_right_button_normal.png") forState:UIControlStateNormal];
    [buttonLogin setBackgroundImage:RYCImageNamed(@"item_bar_right_button_click.png") forState:UIControlStateHighlighted];
    [buttonLogin addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttonLogin];
    [buttonLogin release];
}
-(void)closeSelf
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNavBar" object:nil];
    [self removeFromSuperview];
}
- (void)dealloc
{
    [_customPageControl release];
    [m_scrollView release];
    [m_startButton release];

    [super dealloc];
}
// 点击按钮事件 
-(void) startButtonClick
{
    for (UIImageView * imageV in m_scrollView.subviews) {
        [imageV removeFromSuperview];
    }
    [m_scrollView removeFromSuperview];
//    [self release];
    /*
        ////////////////显示主页面\\\\\\\\\\\\\\\\\\\\\\\
    */
    //屏蔽掉 新版本介绍
    [m_delegate saveUserPlist];
    
    [m_delegate showLoading:nil];
//    [m_delegate.activityView disActivityView];
}

#pragma mark scrollView
/*
 scrollview  先是执行 (DidEndDragging)停止拖住的代理   然后在执行减速停止(scrollViewDidEndDecelerating)的代理
 */
//减速停止的时候开始执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  
{  
	CGPoint offsetofScrollView = scrollView.contentOffset; 
    
	NSInteger page = offsetofScrollView.x / self.scrollView.frame.size.width;

	CGRect rect = CGRectMake(page * self.scrollView.frame.size.width, 0,   
                             self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    [self.customPageControl setCurrentPage:page];
} 

//每次scollview拖动都会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offsetofScrollView = scrollView.contentOffset; 
    
    if (offsetofScrollView.x <= 0 )
    {
        [self.scrollView setContentOffset:CGPointMake(0, offsetofScrollView.y) animated:NO];
    }
    else if(offsetofScrollView.x >= 320 * 5) {
//        [self.scrollView setContentOffset:CGPointMake(320 * 2, offsetofScrollView.y) animated:NO];
        if (times==0) {
            [self startButtonClick];
            times = 1;
        }
        
    }
}

@end
