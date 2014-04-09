//
//  JC_LeagueTableCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-6-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "JC_LeagueTableCell.h"
#import "CheckButton.h"
 
@interface JC_LeagueTableCell (internal)

@end
@implementation JC_LeagueTableCell
@synthesize leagueArray = m_leagueArray;
@synthesize selectedLeagueArrayTag = m_selectedLeagueArrayTag;
 
@synthesize parentDelete = m_parentDelete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        m_leagueArray = [[NSMutableArray alloc] initWithCapacity:10];
        m_selectedLeagueArrayTag = [[NSMutableArray alloc] initWithCapacity:10];
        UIView* writeImage = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 320 - 20, 10)];
        writeImage.backgroundColor = [UIColor whiteColor];
        [self addSubview:writeImage];
        [writeImage release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refreshTableCell
{
    int arrayCount = [m_leagueArray count];
    for (int j = 0; j < arrayCount; j++) 
    {
        if ([self viewWithTag:100 + j] != nil)
        {
            [[self viewWithTag:(100 + j)] removeFromSuperview];
        }
    }

    for (int i = 0; i < arrayCount; i++) 
    {
        BOOL isLeft = i%2 == 0 ? TRUE : FALSE; 
        CGRect Frame;
        if (isLeft) 
        {
            Frame = CGRectMake(0, i/2 * 50, 150, 50); 
        }
        else
            Frame = CGRectMake(160, i/2 * 50, 150, 50); 
        CheckButton* button = [[CheckButton alloc] initWithFrame:Frame];
        button.title = [m_leagueArray objectAtIndex:i];
        button.tag = 100 + i;
        
        button.partentView = self;
        int selectedleaguesCount = [m_selectedLeagueArrayTag count];
        for (int j = 0; j < selectedleaguesCount; j++)
        {
            int tag = [[m_selectedLeagueArrayTag objectAtIndex:j] intValue];
            if (i == tag)
            {
                button.isSelect = YES;
            }
        }
 
        [button refreshButton];
        [self addSubview:button];
        [button release];
    }
}
-(void) buttonClick:(NSInteger) tag SELECT:(BOOL)isSelect
{
    int leagueTag = tag - 100;
    if (isSelect) 
    {
        [m_selectedLeagueArrayTag addObject:[NSNumber numberWithInt:leagueTag]];
    }
    else
    {
        int count = [m_selectedLeagueArrayTag count];
        for (int i = 0; i < count; i++) 
        {
            int selectedTag = [[m_selectedLeagueArrayTag objectAtIndex:i] intValue];
            if (selectedTag == leagueTag) 
            {
                [m_selectedLeagueArrayTag removeObjectAtIndex:i];
                break;
            }
        }
    
    }
    
    [m_parentDelete.selectedLeagueArrayTag removeAllObjects];
    
    int leaguesCount = [m_selectedLeagueArrayTag count];
    for (int i = 0; i < leaguesCount; i++)
    {
        [m_parentDelete appendSelectedLeagueTag:[m_selectedLeagueArrayTag objectAtIndex:i]];
    }
    
}
- (void)dealloc
{
    [m_leagueArray release], m_leagueArray = nil;
    [super dealloc];
}
@end
