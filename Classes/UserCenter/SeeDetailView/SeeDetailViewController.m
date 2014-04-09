//
//  SeeDetailViewController.m
//  RuYiCai
//
//  Created by  on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SeeDetailViewController.h"
#import "RYCImageNamed.h"
#import "SeeDetailTableViewCell.h"
#import "AdaptationUtils.h"

@implementation SeeDetailViewController

@synthesize contentArray = m_contentArray;
@synthesize myTableView = m_myTableView;

- (void)dealloc
{
    [m_myTableView release], m_myTableView = nil;
    //[m_contentArray release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 12) style:UITableViewStyleGrouped];
    m_myTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    m_myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_myTableView.separatorColor = [UIColor lightGrayColor];
    [self.view addSubview:m_myTableView];
    
    [self setUpTopView];
}

- (void)setUpTopView
{
    UIImageView  *topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    topImage.image = RYCImageNamed(@"select_num_bg.png");
    [self.view addSubview:topImage];
    
    UILabel* titltLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    titltLabel.textAlignment = UITextAlignmentCenter;
    titltLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titltLabel.textColor = [UIColor brownColor];
    titltLabel.backgroundColor = [UIColor clearColor];
    if([self.contentArray count] > 0)
       titltLabel.text = [self.contentArray objectAtIndex:0];
    [topImage addSubview:titltLabel];
    [titltLabel release];
    [topImage release];
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    if (0 == section)
        return ([self.contentArray count] - 2)/2;
    else 
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section)
        return @"投注内容";
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        return 135;
    }
    else
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *myIdentifier = @"MyIdentifier";
    SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
    if (cell == nil)
        cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if([indexPath section] == 0)
    {
        NSUInteger rowIndex = [indexPath row];
        NSUInteger arrIndex = rowIndex * 2 + 1;
        cell.cellTitle = (NSString*)[self.contentArray objectAtIndex:arrIndex];
        cell.cellDetailTitle = (NSString*)[self.contentArray objectAtIndex:(arrIndex + 1)];
        cell.isTextView = NO;
    }
    else if ([indexPath section] == 1)
    {
        cell.contentStr = [self.contentArray objectAtIndex:[self.contentArray count] - 1];
        cell.isTextView = YES;
    }
    [cell refreshCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
