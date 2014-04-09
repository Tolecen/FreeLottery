//
//  SwitchTableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SwitchTableCell.h"

#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiAppDelegate.h"
@interface SwitchTableCell (internal)

-(void)switchChanged:(id)sender;

@end

@implementation SwitchTableCell
@synthesize isYes = m_isYes;
@synthesize lableString = m_lableString;
@synthesize accessoryImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 320, 42)];
        accessoryImageView.image = [UIImage imageNamed:@"cell_c_gengduo.png"];
        [self addSubview:accessoryImageView];
        
        m_delegate = (RuYiCaiAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        m_titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 40)];
        m_titleLable.textAlignment = UITextAlignmentLeft;
        m_titleLable.backgroundColor = [UIColor clearColor];
        m_titleLable.font = [UIFont systemFontOfSize:16];
        [self addSubview:m_titleLable];
        
        m_switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(220, 7, 79, 27)];
        if (m_delegate.autoRememberMystatus) {
            m_isYes = YES;
            [m_switchButton setOn:YES];   
        }
        else
        {
            m_isYes = NO;
            [m_switchButton setOn:NO];
        }

        [self addSubview:m_switchButton];
        [m_switchButton addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) refreshData
{
    m_titleLable.text = m_lableString;
}

-(void)switchChanged:(id)sender
{
    if(m_switchButton.on)
    {
//        m_isYes = YES;
//        [m_delegate saveAutoLoginPlist];
        m_switchButton.on = NO;
        UIAlertView *loginTixingAlery = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请到登陆页面设置自动登陆" delegate:Nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [loginTixingAlery show];
        [loginTixingAlery release];
    }
    else
    {
        m_isYes = NO;
        [m_delegate resetAutoLoginPlist];
        
    }
}
- (void)dealloc
{
    [accessoryImageView release];
    [m_lableString release];
    [m_titleLable release];
    [m_switchButton release];
    [super dealloc];
}

@end
