//
//  XinShouZhiNanViewController.m
//  RuYiCai
//
//  Created by  on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XinShouZhiNanViewController.h"
#import "RYCImageNamed.h"
//#import "BackBarButtonItemUtils.h"
#import "RuYiCaiCommon.h"
#import "AdaptationUtils.h"
#import "RuYiCaiAppDelegate.h"


@interface XinShouZhiNanViewController ()
{
}
@property (nonatomic,retain) NSMutableArray *pageGroups;

@end

@implementation XinShouZhiNanViewController

@synthesize scrollView = m_scrollView;
@synthesize customPageControl;


- (void)dealloc
{
    [m_scrollView release];
    [customPageControl release];
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [self.navigationController.navigationBar setHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        statView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:statView];
        [statView release];
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height)];
    }else
    {
        m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    }
    
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.contentSize = CGSizeMake(320 *3+1, [UIScreen mainScreen].bounds.size.height);
    self.scrollView.scrollEnabled = YES;
    self.scrollView.bounces = NO;//不超过边界
    
    
    //用来调整 首页面位置
    CGRect rect = CGRectMake(0, 0,
                             self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
    [self.view addSubview:self.scrollView];
    
    UIImageView* image1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, ([UIScreen mainScreen].bounds.size.height) - 20)];
    image1.image = RYCImageNamed(@"thenew1.png");
    [m_scrollView addSubview:image1];
    [image1 release];
    
    UIImageView* image2 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, ([UIScreen mainScreen].bounds.size.height)-20)];
    image2.image = RYCImageNamed(@"thenew2.png");
    [m_scrollView addSubview:image2];
    [image2 release];
    
    UIImageView* image3 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 2, 0, 320, ([UIScreen mainScreen].bounds.size.height)-20)];
    image3.image = RYCImageNamed(@"thenew3a.png");
    [m_scrollView addSubview:image3];
    [image3 release];
    
//    UIImageView* image4 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 3, 0, 320, [UIScreen mainScreen].bounds.size.height )];
//    image4.image = RYCImageNamed(@"thenew4.png");
//    [m_scrollView addSubview:image4];
//    [image4 release];
//    
//    UIImageView* image5 = [[UIImageView alloc] initWithFrame:CGRectMake(320 * 4, 0, 320, [UIScreen mainScreen].bounds.size.height)];
//    image5.image = RYCImageNamed(@"thenew5.png");
//    [m_scrollView addSubview:image5];
//    [image5 release];
    
    
//    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 50, 30)];
//    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_normal.png") forState:UIControlStateNormal];
//    [backButton setBackgroundImage:RYCImageNamed(@"back_triangle_c_click.png") forState:UIControlStateHighlighted];
//	[backButton addTarget:self action:@selector(goToBack) forControlEvents:UIControlEventTouchUpInside];
//	[backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
//    backButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    //    [self.navigationController.navigationBar addSubview:m_backButton];
//    //    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
//    [self.view insertSubview:backButton atIndex:100];
//    [backButton release];
    
    //-----添加-pageControl-----
    [self.customPageControl setEnabled:NO];
    self.customPageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
    [self.customPageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:self.customPageControl];
    [self.customPageControl release];
    if(KISiPhone5){
        [self.customPageControl setFrame:CGRectMake(115,530, 100, 16)];
    }else{
        [self.customPageControl setFrame:CGRectMake(115,440, 100, 16)];
    }
    

    [self.customPageControl setPageControlStyle:PageControlStyleCustom];
//    [self.customPageControl setThumbImageArray:[NSMutableArray arrayWithObjects:
//                                                [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                [UIImage imageNamed:@"page_style_c_normal.png"],
//                                                nil]];
//    NSLog(@"%d",[self.customPageControl.thumbImageArray count]);
//    [self.customPageControl setSelectedThumbImageArray:[NSMutableArray arrayWithObjects:
//                                                        [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                        [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                        [UIImage imageNamed:@"page_style_c_hove.png"],
//                                                        nil]];
    
    [self.customPageControl setThumbImageArray:[NSMutableArray arrayWithObjects:
                                                [UIImage imageNamed:@""],
                                                [UIImage imageNamed:@""],
                                                [UIImage imageNamed:@""],
                                                nil]];
    NSLog(@"%d",[self.customPageControl.thumbImageArray count]);
    [self.customPageControl setSelectedThumbImageArray:[NSMutableArray arrayWithObjects:
                                                        [UIImage imageNamed:@""],
                                                        [UIImage imageNamed:@""],
                                                        [UIImage imageNamed:@""],
                                                        nil]];
    
    NSLog(@"%d",[self.customPageControl.selectedThumbImageArray count]);
    [self.customPageControl setCurrentPage:0];
    [self.customPageControl setNumberOfPages:3];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleBlackTranslucent;
}

- (void)goToBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}




- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x>320*2)
    {
       [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
	CGPoint offsetofScrollView = scrollView.contentOffset;
    
	NSInteger page = offsetofScrollView.x / self.scrollView.frame.size.width;
    
	CGRect rect = CGRectMake(page * self.scrollView.frame.size.width, 0,
                             self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];

    [self.customPageControl setCurrentPage:page];
    

    NSLog(@"page:%d",page);
    
}


@end
