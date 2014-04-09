//
//  SFCViewController.m
//  RuYiCai
//
//  Created by ruyicai on 12-5-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SFCViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"
#import "MyButton.h"
#import "JC_TableView_ContentCell.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@interface SFCViewController (internal)
- (void)setupNavigationBar;
- (void)selectButtonClick;
- (void)buttonClick:(id)sender;
@end

@implementation SFCViewController

@synthesize playTypeTag = m_playTypeTag;
@synthesize isJCLQView = m_isJCLQView;
@synthesize scollView = m_scollView;
@synthesize selectScore = m_selectScore;
@synthesize JCLQ_parentController = m_JCLQ_parentController;
@synthesize JCZQ_parentController = m_JCZQ_parentController;
@synthesize BJDC_parentController = m_BJDC_parentController;
@synthesize indexPath = m_indexPath;
@synthesize team = m_team;
@synthesize buttonText = m_buttonText;

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}
- (void)dealloc
{
    NSTrace(); 
    [m_rightTitleBarItem release], m_rightTitleBarItem = nil;
    [m_selectScore release], m_selectScore = nil;
    [m_team release];
    [m_indexPath release];
    [m_buttonText release], m_buttonText = nil;
    [m_scollView release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [AdaptationUtils adaptation:self];
    self.view.backgroundColor = [UIColor colorWithPatternImage:RYCImageNamed(@"table_beijing.png")];
    m_scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, 300, 330)];
    self.scollView.scrollEnabled = YES;
    self.scollView.delegate = self;
    self.scollView.backgroundColor = [UIColor whiteColor];
    self.scollView.contentSize = CGSizeMake(300, 330);
    [self.view addSubview:self.scollView];
    
    if (m_selectScore == Nil) {
        m_selectScore = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if (m_buttonText == Nil) {
        m_buttonText = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    UIImageView* imageTop = [[UIImageView alloc] initWithFrame:CGRectMake(9, 10, 302, 10)];
    imageTop.image = RYCImageNamed(@"croner_top.png");
    [self.view addSubview:imageTop];
    [imageTop release];
    
    UILabel * teamLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    teamLable.textAlignment = UITextAlignmentCenter;
    teamLable.backgroundColor = [UIColor clearColor];
    teamLable.font = [UIFont systemFontOfSize:15];
    teamLable.text = m_team;
    [self.scollView addSubview:teamLable];
    [teamLable release];
    
    UIImageView *image_line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50,300,2)];
    image_line.image = RYCImageNamed(@"croner_line.png");
    [self.scollView addSubview:image_line];    
    [image_line release];
    
    int buttonCount = [m_buttonText count];
    if (1 == m_isJCLQView) {
        //胜分差 页面
        for (int i = 0 ; i < buttonCount; i++) {
            int posX = i % 3;
            int posY = i / 3;
            
            MyButton *button = [[MyButton alloc] initWithFrame:CGRectMake(15 + 95 * posX,70 + 60 * posY, 80, 50)];

            NSString *string01 = @"";
            NSString *string02 = @"";
            NSArray* teamArray =  [[m_buttonText objectAtIndex:i] componentsSeparatedByString:@"|"];
            if ([teamArray count] == 2) {
                string01 = [teamArray objectAtIndex:0];
                string02 = [teamArray objectAtIndex:1];
            }
            if (m_playTypeTag == IJCLQPlayType_SFC ||
                m_playTypeTag == IJCLQPlayType_SFC_DanGuan)
            {
                if (i < 6) {
                    button.tag = i + 1; 
                }
                else
                {
                    button.tag = i + 5;
                } 
            }
            else
            {
                button.tag = i;
            }
 
            int count = [m_selectScore count];
            BOOL ishave = NO;
            if (count > 0)
            {
                for (int j = 0; j < count; j++) 
                {
                    int selectScoreTag = [[m_selectScore objectAtIndex:j] intValue];
                    if (button.tag == selectScoreTag)
                    {
                        ishave = YES;
                        break;
                    }
                }
            }
            if (ishave)
            {
                [button setMyButton:[UIImage imageNamed:@"sfc_select_click.png"] UPLABEL:string01 DOWNLABEL:string02];
                [button setIsSelect:YES];
            }
            else
            {
                if (m_playTypeTag == IJCLQPlayType_SFC ||
                    m_playTypeTag == IJCLQPlayType_SFC_DanGuan) 
                {
                    if (i < 6)
                    {
                        [button setMyButton:[UIImage imageNamed:@"sfc_s_select_normal.png"] UPLABEL:string01 DOWNLABEL:string02];  
                    }
                    else
                    {
                        [button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:string01 DOWNLABEL:string02];
                    }
                }
                else
                {
                    [button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:string01 DOWNLABEL:string02]; 
                }
            }
            [button setImage:[UIImage imageNamed:@"sfc_select_click"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.upLabel.font = [UIFont boldSystemFontOfSize:12];
            [self.scollView addSubview:button];
            [button release];
        }
    }
    else
    {
        if (m_playTypeTag == IJCZQPlayType_Score ||
            m_playTypeTag == IJCZQPlayType_Score_DanGuan)
        {
            self.scollView.contentSize = CGSizeMake(300, 330 * 2 + 100);
        }
        if (m_playTypeTag == IBJDCPlayType_Score) {
            self.scollView.contentSize = CGSizeMake(300, 600);
        }
        for (int i = 0 ; i < buttonCount; i++) {
            int posX = i % 3;
            int posY = i / 3;
            
            MyButton *button = [[MyButton alloc] initWithFrame:CGRectMake(15 + 95 * posX,70 + 60 * posY, 80, 50)];
            
            NSString *string01 = @"";
            NSString *string02 = @"";
            NSArray* teamArray =  [[m_buttonText objectAtIndex:i] componentsSeparatedByString:@"|"];
            if ([teamArray count] == 2) {
                string01 = [teamArray objectAtIndex:0];
                string02 = [teamArray objectAtIndex:1];
            }
            button.tag = i; 

            int count = [m_selectScore count];
            BOOL ishave = NO;
            if (count > 0)
            {
                for (int j = 0; j < count; j++) 
                {
                    int selectScoreTag = [[m_selectScore objectAtIndex:j] intValue];
                    if (button.tag == selectScoreTag)
                    {
                        ishave = YES;
                        break;
                    }
                }
            }
            if (ishave) 
            {
                [button setMyButton:[UIImage imageNamed:@"sfc_select_click.png"] UPLABEL:string01 DOWNLABEL:string02];  
                [button setIsSelect:YES];
            }
            else
            {
                [button setMyButton:[UIImage imageNamed:@"sfc_f_select_normal.png"] UPLABEL:string01 DOWNLABEL:string02];        
            }
 
            [button setImage:[UIImage imageNamed:@"sfc_select_click.png"] forState:UIControlStateHighlighted];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.scollView addSubview:button];
            [button release];
        }
    }
    
       
    UIImageView* imageBottom = [[UIImageView alloc] initWithFrame:CGRectMake(9, 350, 302, 10)];
    imageBottom.image = RYCImageNamed(@"croner_bottom.png");
    [self.view addSubview:imageBottom];
    [imageBottom release];
    
}
- (void)setupNavigationBar
{
    
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(selectButtonClick) andTitle:@"确定"];
    
//	m_rightTitleBarItem = [[UIBarButtonItem alloc]
//                           initWithTitle:@"确定"
//                           style:UIBarButtonItemStylePlain
//                           target:self
//                           action:@selector(selectButtonClick)];
//    self.navigationItem.rightBarButtonItem = m_rightTitleBarItem;
    
    if (1 == m_isJCLQView) {
         self.navigationItem.title = @"竞彩篮球";
    }
    else if(0 == m_isJCLQView)
    {
        self.navigationItem.title = @"竞彩足球";
    }
    else  
    {
        self.navigationItem.title = @"北京单场";
    }
}

- (void)buttonClick:(id)sender
{
    int tag = [sender tag];
    BOOL select = [(MyButton*)sender isSelect];
    select = !select;
    [(MyButton*)sender setIsSelect:select];
    
    NSString *strTag = @"";
    strTag = [strTag stringByAppendingFormat:@"%d",tag];
    if (select) {
        [m_selectScore addObject:strTag];
        [(MyButton*)sender setImage:[UIImage imageNamed:@"sfc_select_click"] forState:UIControlStateNormal];
    }
    else
    {
        int count = [m_selectScore count];
        for (int i = 0; i < count; i++) {
            if ([strTag isEqual:(NSString*)[m_selectScore objectAtIndex:i]])
            {
                [m_selectScore removeObjectAtIndex:i];
                break;
            }
        }
        if (1 == m_isJCLQView) {
            if (tag > 6) {
                [(MyButton*)sender setImage:[UIImage imageNamed:@"sfc_f_select_normal"] forState:UIControlStateNormal];
            }
            else
            {
                [(MyButton*)sender setImage:[UIImage imageNamed:@"sfc_s_select_normal"] forState:UIControlStateNormal];    
            }  
        }
        else 
        {
            [(MyButton*)sender setImage:[UIImage imageNamed:@"sfc_f_select_normal"] forState:UIControlStateNormal];
        }
    }
}

- (void)selectButtonClick
{
//    [m_parentController clearAllChoose];
    //把  选择的胜分差 的 tag 传到 竞彩篮球页面
    int count = [m_selectScore count];
    if (1 == m_isJCLQView) {
        [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCLQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] removeAllObjects];
        for (int i = 0; i < count; i++) 
        {
            [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCLQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] addObject:[m_selectScore objectAtIndex:i]];
        }
        [m_JCLQ_parentController reloadDataTwo];   
    }
    else
    {
        [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCZQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] removeAllObjects];
        [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[self.BJDC_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] removeAllObjects];

        for (int i = 0; i < count; i++)
        {
            if (2 == self.isJCLQView) {
                [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[self.BJDC_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] addObject:[m_selectScore objectAtIndex:i]];
            }
            else
                [[(JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCZQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]] sfc_selectTag] addObject:[m_selectScore objectAtIndex:i]];
        }
        if (0 == self.isJCLQView) {
            [m_JCZQ_parentController reloadData];
        }
        else
        {
             [self.BJDC_parentController reloadData];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}
 
-(void) appendButtonText:(NSString*)buttonText
{
    if (m_buttonText == Nil) {
        m_buttonText = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [m_buttonText addObject:buttonText];
}
-(void) appendSelectScoreText:(NSString *)scoreText
{
    if (m_selectScore == Nil) {
        m_selectScore = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [m_selectScore addObject:scoreText];
}
 
@end

