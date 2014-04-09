//
//  SSQRandomTableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSQRandomTableViewCell.h"
#import "RYCImageNamed.h"
#import "NSLog.h"

@implementation SSQRandomTableViewCell

@synthesize indexPath = m_indexPath;
@synthesize randomData = m_randomData;
@synthesize isSort;
@synthesize isLuckView;

- (void)dealloc 
{
    [m_randomData release];
    [super dealloc];
}

- (void)createRandomData
{
    [m_randomData removeAllObjects];
    int hasRandomNum = 0;
    for (int i = 0; i < m_redNum; i++)
    {
        BOOL repeat = NO;
        int randomValue = 0;
        do 
        {
            repeat = NO;
            randomValue = arc4random() % m_redMax;
            for (int j = 0; j < hasRandomNum; j++)
            {
                int value = [[m_randomData objectAtIndex:j] intValue];
                if (value == randomValue)
                {
                    repeat = YES;
                    break;
                }
            }
        } while (repeat);
        hasRandomNum++;
        [m_randomData addObject:[NSNumber numberWithInt:randomValue]];
    }
    if(isSort)
        [m_randomData sortUsingSelector:@selector(compare:)];
    
    hasRandomNum = 0;
    NSMutableArray* blueData = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < m_blueNum; i++)
    {
        BOOL repeat = NO;
        int randomValue = 0;
        do 
        {
            repeat = NO;
            randomValue = arc4random() % m_blueMax;
            for (int j = 0; j < hasRandomNum; j++)
            {
                int value = [[blueData objectAtIndex:j] intValue];
                if (value == randomValue)
                {
                    repeat = YES;
                    break;
                }
            }
        } while (repeat);
        
        hasRandomNum++;
        [blueData addObject:[NSNumber numberWithInt:randomValue]];
    }
    [blueData sortUsingSelector:@selector(compare:)];
    [m_randomData addObjectsFromArray:blueData];
}

- (void)setRedNum:(int)redNum inRedMax:(int)redMax andBlueNum:(int)blueNum inBlueMax:(int)blueMax
{
    m_redMax = redMax;
    m_blueMax = blueMax;
    m_redNum = redNum;
    m_blueNum = blueNum;
    [self createRandomData];
    
    CGRect buttonFrame = CGRectZero;
    for (int i = 0; (i < m_redNum + m_blueNum); i++)
    {
        if(isLuckView)
        {
            buttonFrame = CGRectMake(380/(m_redNum + m_blueNum) + i * (kLuckBallWidth + 5), 
                                     0, 
                                     kLuckBallWidth, 
                                     kLuckBallHeight);
        }
        else
        {
             buttonFrame = CGRectMake(kRandomLeftOffset + i * (kRandomBallWidth + kRandomLeftOffset), 
                                 kRandomTopOffset, 
                                 kRandomBallWidth, 
                                 kRandomBallHeight);
        }
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        int num = [[m_randomData objectAtIndex:i] intValue];
		[button setTitle:[NSString stringWithFormat:@"%02d", (num + 1)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		[button setUserInteractionEnabled:NO];
        
        if (i < m_redNum)
        {
            [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundImage:RYCImageNamed(@"ball_c_blue.png") forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button release];
    }
    
    UIButton* deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonFrame.origin.x + kRandomBallWidth + kRandomRightOffset, 
                                                                        buttonFrame.origin.y, 
                                                                        kRandomBallWidth, 
                                                                        kRandomBallHeight)];
    [deleteButton setUserInteractionEnabled:YES];
    deleteButton.backgroundColor = [UIColor clearColor];
    [deleteButton setBackgroundImage:RYCImageNamed(@"delete.png") forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];    
    [self.contentView addSubview:deleteButton];
    [deleteButton release];
}

- (void)deleteAction
{
    NSMutableDictionary* myDictionary = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDictionary setObject:self.indexPath forKey:@"indexPath"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteRandomBallCell" object:myDictionary];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
		isSort = YES;
        isLuckView = NO;
        m_randomData = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}

@end
