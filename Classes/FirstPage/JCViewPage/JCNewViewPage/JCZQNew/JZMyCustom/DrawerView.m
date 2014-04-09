//
//  DrawerView.m
//  DrawerDemo
//
//  Created by Zhouhaifeng on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import "DrawerView.h"
#import "RuYiCaiCommon.h"

@implementation DrawerView
@synthesize contentView,parentView,drawState;
@synthesize countEventLable;
@synthesize countUIImageView;

- (void)dealloc
{
    [jzNotVC release];
    [countUIImageView release];
    [contentView release];
    [parentView release];
    [countEventLable release];
    [super dealloc];
}
- (id)initWithView:(JZ_NoteNumEditeViewController *) jzNotViewControler parentView :(UIView *) parentview;
{
    
    self = [super initWithFrame:CGRectMake(-20+320,0,340, [UIScreen mainScreen].bounds.size.height)];
    
    if (KISiPhone5) {
        self.center = CGPointMake((-20+parentview.frame.size.width)/2+320, parentview.frame.size.height-[UIScreen mainScreen].bounds.size.height/2+48);
    }else
    {
        self.center = CGPointMake((-20+parentview.frame.size.width)/2+320, parentview.frame.size.height-[UIScreen mainScreen].bounds.size.height/2-40);
    }
    
    if (self) {
        // Initialization code
        NSLog(@"DrawerViewDrawerViewDrawerView---");
        self.backgroundColor = [UIColor yellowColor];
        jzNotVC = jzNotViewControler;
        contentView = jzNotViewControler.view;
        parentView = parentview;
        
        //一定要开启
        [parentView setUserInteractionEnabled:YES];
        
        countUIImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"left_drawer.png"]];
        countUIImageView.frame = CGRectMake(0,150,38/2+1,68/2);
        [contentView insertSubview:countUIImageView atIndex:100];
     //选中比赛个数
        countEventLable = [[UILabel alloc] initWithFrame:CGRectMake(2,150,38/2+1,68/2)];
        countEventLable.backgroundColor = [UIColor clearColor];
        countEventLable.font = [UIFont systemFontOfSize:14];
        countEventLable.textAlignment = NSTextAlignmentCenter;
        countEventLable.textColor = [UIColor whiteColor];
        [contentView insertSubview:countEventLable atIndex:101];
        //嵌入内容的UIView
        [self addSubview:contentView];
        
        //移动的手势
        UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRcognize.delegate=self;
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        
        [self addGestureRecognizer:panRcognize];
        
//        //单击的手势
//        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
//        tapRecognize.numberOfTapsRequired = 1;
//        tapRecognize.delegate = self;
//        [tapRecognize setEnabled :YES];
//        [tapRecognize delaysTouchesBegan];
//        [tapRecognize cancelsTouchesInView];
//        
//        [self addGestureRecognizer:tapRecognize];
//
        //设置两个位置的坐标
        
        if (KISiPhone5) {
            downPoint = CGPointMake((-20+parentView.frame.size.width)/2, parentView.frame.size.height-[UIScreen mainScreen].bounds.size.height/2+48);
            upPoint = CGPointMake((-20+parentView.frame.size.width)/2+320, parentView.frame.size.height-[UIScreen mainScreen].bounds.size.height/2+48);
        }else
        {
            downPoint = CGPointMake((-20+parentView.frame.size.width)/2, parentView.frame.size.height-[UIScreen mainScreen].bounds.size.height/2-40);
            upPoint = CGPointMake((-20+parentView.frame.size.width)/2+320, parentView.frame.size.height-[UIScreen mainScreen].bounds.size.height/2-40);
        }
        
        
        
        
//        self.center =  downPoint;
        
        //设置起始状态
        drawState = DrawerViewStateUp;
    }
    return self;
}


#pragma UIGestureRecognizer Handles
/*
 *  移动图片处理的函数
 *  @recognizer 移动手势
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    CGPoint translation = [recognizer translationInView:parentView];
    if (self.center.x + translation.x < downPoint.x) {
        NSLog(@"translationtranslation1111111111");
        self.center = downPoint;
        return;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftDrawerView" object:nil];
    }else if(self.center.x + translation.x > upPoint.x)
    {
        NSLog(@"translationtranslation22222222222");
        self.center = upPoint;
        return;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"rightDrawerView" object:nil];
    }else{
        NSLog(@"translationtranslation333333333");
        self.center = CGPointMake(self.center.x+translation.x,parentView.frame.size.height-[UIScreen mainScreen].bounds.size.height/2-40+44);
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:parentView];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (self.center.x < upPoint.x*3/5) {
                self.center = downPoint;
                if (jzNotVC.isScrollerLeft==NO)
                {
                     NSLog(@"translationtranslation4444444");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftDrawerView" object:nil];
                }
                
                drawState = DrawerViewStateDown;
            }else
            {
                self.center = upPoint;
                
                if (jzNotVC.isScrollerLeft==YES)
                {
                    NSLog(@"translationtranslation555555555");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"rightDrawerView" object:nil];
                }
                drawState = DrawerViewStateUp;
            }
            
        } completion:nil];
        
    }
}

/*
 *  handleTap 触摸函数
 *  @recognizer  UITapGestureRecognizer 触摸识别器
 */
//-(void) handleTap:(UITapGestureRecognizer *)recognizer
//{
//    [UIView animateWithDuration:0.75 delay:0.15 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//        if (drawState == DrawerViewStateDown) {
//            self.center = upPoint;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"rightDrawerView" object:nil];
//            drawState = DrawerViewStateUp;
////            [self transformArrow:DrawerViewStateUp];
//        }else
//        {
//            self.center = downPoint;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"leftDrawerView" object:nil];
//            drawState = DrawerViewStateDown;
////            [self transformArrow:DrawerViewStateDown];
//        }
//    } completion:nil];
//    
//}

/*
 *  transformArrow 改变箭头方向
 *  state  DrawerViewState 抽屉当前状态
 */
//-(void)transformArrow:(DrawerViewState) state
//{
//    //NSLog(@"DRAWERSTATE :%d  STATE:%d",drawState,state);
//    [UIView animateWithDuration:0.3 delay:0.35 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        if (state == DrawerViewStateUp){
//            countEventLable.transform = CGAffineTransformMakeRotation(M_PI);
//        }else
//        {
//            countEventLable.transform = CGAffineTransformMakeRotation(0);
//        }
//    } completion:^(BOOL finish){
//        drawState = state;
//    }];
//    
//    
//}


@end
