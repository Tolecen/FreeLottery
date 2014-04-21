//
//  GiftWordTableViewController.m
//  RuYiCai
//
//  Created by  on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GiftWordTableViewController.h"
#import "RYCImageNamed.h"
#import "RuYiCaiNetworkManager.h"
#import "RuYiCaiLotDetail.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"

@implementation GiftWordTableViewController

@synthesize tableView = m_tableView;
@synthesize giftMessage = m_giftMessage;

- (void)dealloc
{	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getGiftMessageOK" object:nil];	

    [m_tableView release], m_tableView = nil;
    [m_giftMessage release], m_giftMessage = nil;

	[super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGiftMessageOK:) name:@"getGiftMessageOK" object:nil];
    
    m_giftMessage = [[NSMutableArray alloc] initWithCapacity:1];
    
    [[RuYiCaiNetworkManager sharedManager] getGiftMessage];
}

- (void)getGiftMessageOK:(NSNotification*)notification
{
    SBJsonParser *jsonParser = [SBJsonParser new];
    NSDictionary* parserDict = (NSDictionary*)[jsonParser objectWithString:[RuYiCaiNetworkManager sharedManager].giftMessageText];
    [jsonParser release];
    NSArray* contentArray = (NSArray*)[parserDict objectForKey:@"result"];

    for(int i = 0; i < [contentArray count]; i++)
    {
        [self.giftMessage addObject:[[contentArray objectAtIndex:i] objectForKey:@"content"]];
    }
//	self.giftMessage = [[RuYiCaiNetworkManager sharedManager].giftMessageText componentsSeparatedByString:@"|"];
	//NSLog(@"%@",self.giftMessage);
	
	CGRect tableFrame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64);
    m_tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.rowHeight = 60;
	[self.view addSubview:self.tableView];
}

#pragma mark UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{ 
    return [self.giftMessage count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 5;
	cell.textLabel.text = [m_giftMessage objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:12];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [RuYiCaiLotDetail sharedObject].giftContentStr = [m_giftMessage objectAtIndex:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
