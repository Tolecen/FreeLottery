//
//  FC3DRandomTableViewCell.m
//  RuYiCai
//
//  Created by LiTengjie on 11-8-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FC3DRandomTableViewCell.h"
#import "RYCImageNamed.h"
#import "NSLog.h"

@implementation FC3DRandomTableViewCell

@synthesize indexPath = m_indexPath;
@synthesize randomData = m_randomData;
@synthesize isLuckView;

- (void)dealloc
{
    [m_randomData release];
    [super dealloc];
}

- (void)createRandomData
{
    //    NSComparator cmptr = ^(id obj1, id obj2){
    //        if ([obj1 integerValue] > [obj2 integerValue]) {
    //            return (NSComparisonResult)NSOrderedDescending;
    //        }
    //
    //        if ([obj1 integerValue] < [obj2 integerValue]) {
    //            return (NSComparisonResult)NSOrderedAscending;
    //        }
    //        return (NSComparisonResult)NSOrderedSame;
    //    };
    [m_randomData removeAllObjects];
    int hasRandomNum = 0;
    for (int i = 0; i < m_redNum; i++)
    {
        int randomValue = 0;
        do
        {
            randomValue = arc4random() % m_redMax;
        }while (randomValue < m_redMin);
        hasRandomNum++;
        [m_randomData addObject:[NSNumber numberWithInt:randomValue]];
    }
    if(isSort)
        [m_randomData sortUsingSelector:@selector(compare:)];
}

- (void)createDataWithStartNum:(int)startNum inRedMax:(int)redMax num:(int)redNum isSort:(BOOL)_isSort
{
    isSort = _isSort;
    m_redMin = startNum;
    m_redMax = redMax;
    m_redNum = redNum;
    [self createRandomData];
}

- (void)setRedNum:(int)redNum inRedMax:(int)redMax dxds:(BOOL)dxds
{
    isSort = NO;
    m_redMin = 0;
    m_redMax = redMax;
    m_redNum = redNum;
    [self createRandomData];
    
	NSArray *array = [[NSArray alloc]initWithObjects:@"大",@"小",@"单",@"双",nil];
    CGRect buttonFrame = CGRectZero;
    for (int i = 0; i < m_redNum; i++)
    {
        if(isLuckView)
        {
            buttonFrame = CGRectMake(330/redNum + i * (kLuckBallWidth + 5),
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
        
        int num = [[m_randomData objectAtIndex:([m_randomData count] - 1 - i)] intValue];
		if(!dxds)
		{
			[button setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
		}
		else
		{
			[button setTitle:[array objectAtIndex:num] forState:UIControlStateNormal];
		}
		
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		[button setUserInteractionEnabled:NO];
        [button setBackgroundImage:RYCImageNamed(@"ball_c_red.png") forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        [button release];
    }
    [array release];
    if(!dxds)
    {
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
        m_randomData = [[NSMutableArray alloc] initWithCapacity:1];
        isLuckView = NO;
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSort:(BOOL)sort
{
    
}

@end
