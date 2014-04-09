//
//  ConfusionViewController.m
//  RuYiCai
//
//  Created by ruyicai on 13-3-4.
//
//

#import "ConfusionViewController.h"

#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiLotDetail.h"
#import "NSLog.h"

#import "JC_TableView_ContentCell.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "MyButton.h"
#import "AdaptationUtils.h"
@interface ConfusionViewController (internal)
- (void)setupNavigationBar;
- (void)selectButtonClick;
- (void)buttonClick:(id)sender;
@end

@implementation ConfusionViewController

@synthesize playTypeTag = m_playTypeTag;
@synthesize isJCLQView = m_isJCLQView;
@synthesize scollView = m_scollView;
@synthesize selectScore = m_selectScore;
@synthesize JCLQ_parentController = m_JCLQ_parentController;
@synthesize JCZQ_parentController = m_JCZQ_parentController;
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
    NSInteger scollHeight = 280;
    m_scollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 60, 300, scollHeight)];
    self.scollView.scrollEnabled = YES;
    self.scollView.delegate = self;
    self.scollView.backgroundColor = [UIColor whiteColor];
    self.scollView.contentSize = CGSizeMake(300, 380);
    [self.view addSubview:self.scollView];
    
    if (m_selectScore == nil) {
        m_selectScore = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if (m_buttonText == nil) {
        m_buttonText = [[NSMutableArray alloc] initWithCapacity:10];
    }
    
    UIImageView* imageTop = [[UIImageView alloc] initWithFrame:CGRectMake(9, 50, 302, 10)];
    imageTop.image = RYCImageNamed(@"croner_top.png");
    [self.view addSubview:imageTop];
    [imageTop release];
    
    UILabel * teamLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 320, 40)];
    teamLable.textAlignment = UITextAlignmentCenter;
    teamLable.backgroundColor = [UIColor clearColor];
    teamLable.font = [UIFont systemFontOfSize:15];
    teamLable.text = m_team;
    [self.view addSubview:teamLable];
    [teamLable release];
    
    int startY = 0;//每一个区域的起始位置
    int jianjuValue = 4;//每个区域的间距
    
    if (m_isJCLQView) {
        //胜负
        NSArray* sf_array = (m_buttonText.count >= 1 ? [m_buttonText objectAtIndex:0] : [NSArray array]);
        for (int i = 0; i < [sf_array count]; i++) {
            
            [self creatButton:1 I:i RECT:CGRectMake(10 + i * 140,0,140, 36) IMAGE:[UIImage imageNamed:@"jclq_confusion_long_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_long_click.png"] UPTEXT:[sf_array objectAtIndex:i] DOWNTEXT:@""];
        }
        //让分胜负
        NSArray* letpoint_array = (m_buttonText.count >= 2 ? (NSArray*)[m_buttonText objectAtIndex:1] : [NSArray array]);
        for (int i = 0; i < [letpoint_array count]; i++) {
            MyButton* letpoint_button = [self creatButton:2 I:(i == 2 ? i - 1 : i) RECT:CGRectMake(10 + i * 93,40, 93, 36) IMAGE:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_center_click.png"] UPTEXT:[letpoint_array objectAtIndex:i] DOWNTEXT:@""];
            if (i == 1) {
                letpoint_button.tag = i;
                [letpoint_button setEnabled:YES];
                [letpoint_button setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateNormal];
                [letpoint_button setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateHighlighted];
                [letpoint_button.upLabel setTextColor:[UIColor lightGrayColor]];
                [letpoint_button removeTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        //大小分
        NSArray* big_point_array = (m_buttonText.count >= 3 ? (NSArray*)[m_buttonText objectAtIndex:2] : [NSArray array]);
        for (int i = 0; i < [big_point_array count]; i++) {
            
            MyButton* big_point_button = [self creatButton:3 I:(i == 2 ? i - 1 : i) RECT:CGRectMake(10 + i * 93,40 * 2, 93, 36) IMAGE:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_center_click.png"] UPTEXT:[big_point_array objectAtIndex:i] DOWNTEXT:@""];
            
            if (i == 1) {
                big_point_button.tag = i;
                [big_point_button setEnabled:YES];
                [big_point_button setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateNormal];
                [big_point_button setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateHighlighted];
                [big_point_button.upLabel setTextColor:[UIColor lightGrayColor]];
                [big_point_button removeTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        //胜分差
        NSArray* sfc_point_array = (m_buttonText.count >= 4 ? (NSArray*)[m_buttonText objectAtIndex:3] : [NSArray array]);
        for (int i = 0; i < [sfc_point_array count]; i++) {
            int heng = i % 3;
            int shu = i/3;
            
            NSString *string01 = @"";
            NSString *string02 = @"";
            NSArray* teamArray =  [[sfc_point_array objectAtIndex:i] componentsSeparatedByString:@"|"];
            if ([teamArray count] == 2) {
                string01 = [teamArray objectAtIndex:0];
                string02 = [teamArray objectAtIndex:1];
            }
            [self creatButton:4 I:i RECT:CGRectMake(heng * 93 + 10,40 * 3 + 38 * shu, 93, 38) IMAGE:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_center_click.png"] UPTEXT:string01 DOWNTEXT:string02];
        }
    }
    else
    {
        scollHeight = (KISiPhone5 ? 400 : 340);
        self.scollView.frame = CGRectMake(10, 60, 300,scollHeight );
        self.scollView.contentSize = CGSizeMake(300, 440);
        
        //胜平负
        NSArray* spf_array = (m_buttonText.count >= 1 ? [m_buttonText objectAtIndex:0] : [NSArray array]);
        if ([spf_array count] > 0) {
            
            for (int i = 0; i < [spf_array count]; i++) {
                
                [self creatButton:1 I:i RECT:CGRectMake(10 + i * 93,startY, 93, 36) IMAGE:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_center_click.png"] UPTEXT:[spf_array objectAtIndex:i] DOWNTEXT:@""];
            }
            
            startY = 36 + jianjuValue;
        }
        
        //让球胜平负
        NSArray* letpoint_array = (m_buttonText.count >= 2 ? (NSArray*)[m_buttonText objectAtIndex:1] : [NSArray array]);
        if ([letpoint_array count] > 0) {
            
            for (int i = 0; i < [letpoint_array count] - 1; i++) {
                [self creatButton:2 I:i RECT:CGRectMake(10 + (i+1) * 70,startY, 70, 36) IMAGE:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jclq_confusion_center_click.png"] UPTEXT:[letpoint_array objectAtIndex:i] DOWNTEXT:@""];
            }
            UIButton *rangButton = [[UIButton alloc] initWithFrame:CGRectMake(10, startY, 70, 36)];
            [rangButton setTitle:[letpoint_array objectAtIndex:[letpoint_array count] - 1] forState:UIControlStateNormal];
            [rangButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [rangButton setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateNormal];
            [rangButton setBackgroundImage:[UIImage imageNamed:@"jclq_confusion_center_normal.png"] forState:UIControlStateHighlighted];
            rangButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [self.scollView addSubview:rangButton];
            [rangButton release];
            
            startY = startY + 36 + jianjuValue;
        }
        
        //半全场
        NSArray* bqc_array = (m_buttonText.count >= 3 ? (NSArray*)[m_buttonText objectAtIndex:2] : [NSArray array]);
        if ([bqc_array count] > 0) {
            
            for (int i = 0; i < [bqc_array count]; i++) {
                int heng = i % 5;
                int shu = i/5;
                
                NSString *string01 = @"";
                NSString *string02 = @"";
                NSArray* teamArray =  [[bqc_array objectAtIndex:i] componentsSeparatedByString:@"|"];
                if ([teamArray count] == 2) {
                    string01 = [teamArray objectAtIndex:0];
                    string02 = [teamArray objectAtIndex:1];
                }
                [self creatButton:3 I:i RECT:CGRectMake(10 + heng * 56,startY + 37 * shu, 56, 37) IMAGE:[UIImage imageNamed:@"jczq_confusion_line2_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jczq_confusion_line2_click.png"] UPTEXT:string01 DOWNTEXT:string02];
                
                if (i == [bqc_array count] - 1) {
                    //填补空白
                    MyButton *big_empty_button = [[[MyButton alloc] initWithFrame:CGRectMake(10 + (heng + 1) * 56,startY + 37 * shu, 56, 37)] autorelease];
                    [big_empty_button setMyButton:nil UPLABEL:@"" DOWNLABEL:@""];
                    
                    [big_empty_button setBackgroundImage:[UIImage imageNamed:@"jczq_confusion_line2_normal.png"] forState:UIControlStateNormal];
                    [big_empty_button setBackgroundImage:[UIImage imageNamed:@"jczq_confusion_line2_normal.png"] forState:UIControlStateHighlighted];
                    big_empty_button.tag = 10000 + i;
                    [self.scollView addSubview:big_empty_button];
                }
            }
            startY = startY + (36 + 1) * 2 + jianjuValue;
        }
        
        //总进球
        NSArray* zjq_array = (m_buttonText.count >= 4 ? (NSArray*)[m_buttonText objectAtIndex:3] : [NSArray array]);
        if ([zjq_array count] > 0) {
            
            for (int i = 0; i < [zjq_array count]; i++) {
                int heng = i % 4;
                int shu = i/4;
                
                NSString *string01 = @"";
                NSString *string02 = @"";
                NSArray* teamArray =  [[zjq_array objectAtIndex:i] componentsSeparatedByString:@"|"];
                if ([teamArray count] == 2) {
                    string01 = [teamArray objectAtIndex:0];
                    string02 = [teamArray objectAtIndex:1];
                }
                [self creatButton:4 I:i RECT:CGRectMake(heng * 70 + 10,startY + 37 * shu, 70, 37) IMAGE:[UIImage imageNamed:@"jczq_confusion_line3_normal.png"] IMAGE_CLICK:[UIImage imageNamed:@"jczq_confusion_line3_click.png"] UPTEXT:string01 DOWNTEXT:string02];
            }
            startY = startY + (36 + 1) * 2 + jianjuValue;
        }
        
        NSArray* score_array = (m_buttonText.count >= 5 ? (NSArray*)[m_buttonText objectAtIndex:4] : [NSArray array]);
        
        if ([score_array count] > 0) {
            
            for (int i = 0; i < [score_array count]; i++) {
                int heng = 0, shu = 0 ,width = 40,height = 37 , x_index = 0;
                if (i <= 5) {//第一行
                    heng = i;
                    shu = 0;
                    if (heng > 0) {
                        x_index = 80;
                    }
                }
                else if(i > 5 && i <= 12)//第二行
                {
                    heng = i - 6;
                    shu = 1;
                }
                else if (i > 12 && i <= 17)
                {
                    heng = i - 13;
                    shu = 2;
                    if (heng > 0) {
                        x_index = 120;
                    }
                }
                else if (i > 17 && i <= 23)
                {
                    heng = i - 18;
                    shu = 3;
                    if (heng > 0) {
                        x_index = 80;
                    }
                }
                else if (i > 23 && i <= 30)//第五行
                {
                    heng = i - 24;
                    shu = 4;
                }
                
                UIImage* image_normal = [UIImage imageNamed:@"jczq_confusion_line4_small_normal.png"];
                UIImage* image_click = [UIImage imageNamed:@"jczq_confusion_line4_small_click.png"];
                if (i == 0 || i == 18) {
                    width = 80;
                    image_normal = [UIImage imageNamed:@"jczq_confusion_line4_center_normal.png"];
                    image_click = [UIImage imageNamed:@"jczq_confusion_line4_center_click.png"];
                }
                if (i == 13)
                {
                    width = 120;
                    image_normal = [UIImage imageNamed:@"jczq_confusion_line4_long_normal.png"];
                    image_click = [UIImage imageNamed:@"jczq_confusion_line4_long_click.png"];
                }
                NSString *string01 = @"";
                NSString *string02 = @"";
                NSArray* teamArray =  [[score_array objectAtIndex:i] componentsSeparatedByString:@"|"];
                if ([teamArray count] == 2) {
                    string01 = [teamArray objectAtIndex:0];
                    string02 = [teamArray objectAtIndex:1];
                }
                [self creatButton:5 I:i RECT:CGRectMake(x_index + (x_index > 0 ? heng - 1 : heng) * 40 + 10,startY + 37 * shu, width, height) IMAGE:image_normal IMAGE_CLICK:image_click UPTEXT:string01 DOWNTEXT:string02];
                
            }
        }
    }
    UIImageView* imageBottom = [[UIImageView alloc] initWithFrame:CGRectMake(9, scollHeight + 60, 302, 10)];
    imageBottom.image = RYCImageNamed(@"croner_bottom.png");
    [self.view addSubview:imageBottom];
    [imageBottom release];
    
}

- (MyButton*)creatButton:(int)line_index I:(int)i RECT:(CGRect)rect IMAGE:(UIImage*)image_normal IMAGE_CLICK:(UIImage*)image_click UPTEXT:(NSString*)uptext DOWNTEXT:(NSString*)downtext
{
    MyButton *button = [[[MyButton alloc] initWithFrame:rect] autorelease];
    [button setMyButton:nil UPLABEL:uptext DOWNLABEL:downtext];
    button.upLabel.frame = CGRectMake(0, 0, button.frame.size.width, ([downtext length] > 0 ? button.frame.size.height/2 + 5 : button.frame.size.height));
    button.upLabel.font = [UIFont boldSystemFontOfSize:15];
    button.downLabel.font = [UIFont boldSystemFontOfSize:10];
    button.downLabel.textColor = [UIColor lightGrayColor];
    button.upLabel.textColor = [UIColor darkGrayColor];
    
    //判断 是否是选中
    BOOL ishave = NO;
    int tagValue = line_index*100 + i;
    for (int have_index = 0; have_index < [[self.selectScore objectAtIndex:line_index-1] count]; have_index++) {
        NSLog(@"\n%@",[self.selectScore objectAtIndex:line_index - 1]);
        if (i == [[[self.selectScore objectAtIndex:line_index - 1] objectAtIndex:have_index] intValue]) {
            ishave = YES;
            break;
        }
    }
    if (ishave) {
        [button.upLabel setTextColor:[UIColor whiteColor]];
        [button.downLabel setTextColor:[UIColor whiteColor]];
        [button setBackgroundImage:image_click forState:UIControlStateNormal];
    }
    else
        [button setBackgroundImage:image_normal forState:UIControlStateNormal];
    [button setIsSelect:ishave];
    
    [button setBackgroundImage:image_click forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tagValue;
    [self.scollView addSubview:button];
    
    return button;
}

//判断是否支持此玩法
- (BOOL) isSupportPlayType
{
    BOOL isSupport;
    
    return isSupport;
}

- (void)setupNavigationBar
{
    [BackBarButtonItemUtils addBackButtonForController:self];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(selectButtonClick) andTitle:@"确定"];

    if (m_isJCLQView) {
        self.navigationItem.title = @"竞彩篮球";
    }
    else
    {
        self.navigationItem.title = @"竞彩足球";
    }
}

- (void)buttonClick:(id)sender
{
    int tag = [sender tag];
    NSString *strTag = [NSString stringWithFormat:@"%d",tag%100];
    BOOL select = [(MyButton*)sender isSelect];
    select = !select;
    [(MyButton*)sender setIsSelect:select];
    
    int array_index = 0;
    UIImage* buttonImage_normal = nil;
    UIImage* buttonImage_click = nil;
    switch (tag/100) {
        case 1:
        {
            array_index = 0;
            break;
        }
        case 2:
        {
            array_index = 1;
            break;
        }
        case 3:
        {
            array_index = 2;
            break;
        }
        case 4:
        {
            array_index = 3;
            break;
        }
        case 5:
        {
            array_index = 4;
            break;
        }
        default:
            break;
    }
    
    if (self.isJCLQView) {
        if (array_index == 0) {
            buttonImage_normal = [UIImage imageNamed:@"jclq_confusion_long_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jclq_confusion_long_click.png"];
        }
        else
        {
            buttonImage_normal = [UIImage imageNamed:@"jclq_confusion_center_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jclq_confusion_center_click.png"];
        }
    }
    else
    {
        if (array_index == 0) {
            buttonImage_normal = [UIImage imageNamed:@"jclq_confusion_center_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jclq_confusion_center_click.png"];
        }
        
        else if(array_index == 1)
        {
            buttonImage_normal = [UIImage imageNamed:@"jclq_confusion_center_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jclq_confusion_center_click.png"];
        }
        
        else if(array_index == 2)
        {
            buttonImage_normal = [UIImage imageNamed:@"jczq_confusion_line2_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jczq_confusion_line2_click.png"];
        }
        else if (array_index == 3)
        {
            buttonImage_normal = [UIImage imageNamed:@"jczq_confusion_line3_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jczq_confusion_line3_click.png"];
        }
        else if (array_index == 4)
        {
            buttonImage_normal= [UIImage imageNamed:@"jczq_confusion_line4_small_normal.png"];
            buttonImage_click = [UIImage imageNamed:@"jczq_confusion_line4_small_click.png"];
            if (tag%100 == 0 || tag%100 == 18) {
                buttonImage_normal = [UIImage imageNamed:@"jczq_confusion_line4_center_normal.png"];
                buttonImage_click = [UIImage imageNamed:@"jczq_confusion_line4_center_click.png"];
            }
            if (tag%100 == 13)
            {
                buttonImage_normal = [UIImage imageNamed:@"jczq_confusion_line4_long_normal.png"];
                buttonImage_click = [UIImage imageNamed:@"jczq_confusion_line4_long_click.png"];
            }
        }
    }
    if (select) {
        [(MyButton*)sender setImage:buttonImage_click forState:UIControlStateNormal];
        ((MyButton*)sender).upLabel.textColor = [UIColor whiteColor];
        ((MyButton*)sender).downLabel.textColor = [UIColor whiteColor];
        [[self.selectScore objectAtIndex:array_index] addObject:strTag];
    }
    else
    {
        ((MyButton*)sender).upLabel.textColor = [UIColor darkGrayColor];
        ((MyButton*)sender).downLabel.textColor = [UIColor lightGrayColor];
        
        [(MyButton*)sender setImage:buttonImage_normal forState:UIControlStateNormal];
        NSLog(@"%@",[self.selectScore objectAtIndex:array_index]);
        for (int i = 0; i < [[self.selectScore objectAtIndex:array_index] count]; i++) {
            if ([strTag isEqual:(NSString*)[[self.selectScore objectAtIndex:array_index] objectAtIndex:i]]) {
                [[self.selectScore objectAtIndex:array_index] removeObjectAtIndex:i];
                break;
            }
        }
    }
}

- (void)selectButtonClick
{
    //把  选择的胜分差 的 tag 传到 竞彩篮球页面
    int count = [self.selectScore count];
    
    NSLog(@"%@",self.selectScore);
    
    NSString* buttontext = @"";
    if (m_isJCLQView) {
        JCLQ_tableViewCell_DataBase* base =  (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCLQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]];
        [[base confusion_selectTag] removeAllObjects];
        for (int i = 0; i < count; i++)
        {
            NSMutableArray* array = [NSMutableArray arrayWithArray:[self.selectScore objectAtIndex:i]];
            NSLog(@"\n%@",array);
            //            //排序
            //            for (int i = 0; i<[array count]; i++)
            //            {
            //                for (int j=i+1; j<[array count]; j++)
            //                {
            //                    int a = [[array objectAtIndex:i] intValue];
            //                    int b = [[array objectAtIndex:j] intValue];
            //                    if (a > b)
            //                    {
            //                        int temp = b;
            //                        [array replaceObjectAtIndex:j withObject:[NSString stringWithFormat:@"%d",b]];
            //                        [array replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",temp]];
            //                    }
            //                }
            //            }
            //            NSLog(@"\n%@",array);
            [base.confusion_selectTag addObject:array];
        }
        //存储 按钮上要显示的文字
        for (int i = 1; i <= 4; i++) {
            int tag = i * 100;
            for (int j = 0; j < [[base.confusion_selectTag objectAtIndex:i-1] count]; j++) {
                tag += [[(NSMutableArray*)[base.confusion_selectTag objectAtIndex:i-1] objectAtIndex:j] intValue];
                for (int k = 0;  k < [[self.scollView subviews] count]; k++) {
                    if (tag == [(MyButton*)[[self.scollView subviews] objectAtIndex:k] tag]) {
                        buttontext = [buttontext stringByAppendingFormat:@"  %@|%@   ",[(MyButton*)[[self.scollView subviews] objectAtIndex:k] upLabel].text,[(MyButton*)[[self.scollView subviews] objectAtIndex:k] downLabel].text];
                        break;
                    }
                }
                tag = i * 100;
            }
        }
        base.confusionButtonText = buttontext;
        
        [m_JCLQ_parentController reloadDataTwo];
    }
    else
    {
        JCLQ_tableViewCell_DataBase* base =  (JCLQ_tableViewCell_DataBase*)[[(JCLQ_tableViewCell_DataArray*)[[m_JCZQ_parentController tableCell_DataArray] objectAtIndex:[m_indexPath section]] tableHeaderArray] objectAtIndex:[m_indexPath row]];
        [[base confusion_selectTag] removeAllObjects];
        for (int i = 0; i < count; i++)
        {
            NSMutableArray* array = [NSMutableArray arrayWithArray:[self.selectScore objectAtIndex:i]];
            [base.confusion_selectTag addObject:array];
        }
        
        //存储 按钮上要显示的文字
        for (int i = 1; i <= 5; i++) {
            int tag = i * 100;
            for (int j = 0; j < [[base.confusion_selectTag objectAtIndex:i-1] count]; j++) {
                tag += [[(NSMutableArray*)[base.confusion_selectTag objectAtIndex:i-1] objectAtIndex:j] intValue];
                for (int k = 0;  k < [[self.scollView subviews] count]; k++) {
                    if (tag == [(MyButton*)[[self.scollView subviews] objectAtIndex:k] tag])
                    {
                        if (i == 2) {
                            
                            buttontext = [buttontext stringByAppendingFormat:@"让球%@|%@  ",[(MyButton*)[[self.scollView subviews] objectAtIndex:k] upLabel].text,[(MyButton*)[[self.scollView subviews] objectAtIndex:k] downLabel].text];
                        }
                        else
                        {
                            buttontext = [buttontext stringByAppendingFormat:@"%@|%@  ",[(MyButton*)[[self.scollView subviews] objectAtIndex:k] upLabel].text,[(MyButton*)[[self.scollView subviews] objectAtIndex:k] downLabel].text];
                        }
                        break;
                    }
                }
                tag = i * 100;
            }
        }
        base.confusionButtonText = buttontext;
        
        
        [m_JCZQ_parentController reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) appendButtonText:(NSArray*)buttonText
{
    if (m_buttonText == nil) {
        m_buttonText = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [m_buttonText addObject:buttonText];
}
-(void) appendSelectScoreText:(NSMutableArray *)selectText
{
    if (m_selectScore == nil) {
        m_selectScore = [[NSMutableArray alloc] initWithCapacity:10];
    }
    [m_selectScore addObject:selectText];
}

@end


