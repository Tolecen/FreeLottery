//
//  FC3DRandomGroup3TableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-9-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FC3DRandomGroup3TableViewCell.h"
#import "RYCImageNamed.h"
#import "NSLog.h"

@implementation FC3DRandomGroup3TableViewCell

@synthesize indexPath = m_indexPath;
@synthesize randomData = m_randomData;


- (void)dealloc 
{
    [m_randomData release];
    [super dealloc];
}

- (void)setSort:(BOOL)isSort
{
	m_isSort = isSort;
}

- (void)createRandomData
{
    [m_randomData removeAllObjects];
    
    m_redNum = 3;
	
    int randomValue = 0;
    randomValue = arc4random() % m_redMax;
    [m_randomData addObject:[NSNumber numberWithInt:randomValue]];
	[m_randomData addObject:[NSNumber numberWithInt:randomValue]];

    int newRandomValue = 0;
    do {
        newRandomValue = arc4random() % m_redMax;
    } while (newRandomValue == randomValue);
    [m_randomData addObject:[NSNumber numberWithInt:newRandomValue]];
	if(m_isSort)
		[m_randomData sortUsingSelector:@selector(compare:)];
}

- (void)setRedNum:(int)redNum inRedMax:(int)redMax dxds:(BOOL)dxds
{
    m_redMax = redMax;
    m_redNum = redNum;
    [self createRandomData];
    
    CGRect buttonFrame = CGRectZero;
    for (int i = 0; i < m_redNum; i++)
    {
        buttonFrame = CGRectMake(kRandomLeftOffset + i * (kRandomBallWidth + kRandomLeftOffset), 
                                 kRandomTopOffset, 
                                 kRandomBallWidth, 
                                 kRandomBallHeight);
        UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
        //([m_randomData count] - 1 - i)
        int num = [[m_randomData objectAtIndex:i] intValue];
		[button setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		[button setUserInteractionEnabled:NO];
        [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
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
		m_isSort = NO;
        m_randomData = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}

@end
