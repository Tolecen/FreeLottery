//
//  UserCenterAutoOrderDetailView.m
//  RuYiCai
//
//  Created by ruyicai on 12-11-19.
//
//

#import "UserCenterAutoOrderDetailView.h"
#import "RYCImageNamed.h"
#import "SeeDetailTableViewCell.h"
#import "HMDTDetialZhanjiCell.h"
#import "RuYiCaiCommon.h"
#import "BackBarButtonItemUtils.h"
#import "AdaptationUtils.h"
@implementation UserCenterAutoOrderDetailView
@synthesize contentArray = m_contentArray;
@synthesize myTableView = m_myTableView;
@synthesize zhanjiDic = m_zhanjiDic;
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
    [BackBarButtonItemUtils addBackButtonForController:self];
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, 320, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.contentArray count] - 2)/2 + 1;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 1) {
        static NSString *myIdentifier = @"MyIdentifier_seedetail";
        SeeDetailTableViewCell *cell = (SeeDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[SeeDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSUInteger rowIndex = [indexPath row];
        NSUInteger arrIndex = rowIndex * 2 + 1;
        cell.cellTitle = (NSString*)[self.contentArray objectAtIndex:arrIndex];
        cell.cellDetailTitle = (NSString*)[self.contentArray objectAtIndex:(arrIndex + 1)];
        cell.isTextView = NO;
        
        [cell refreshCell];
        return cell;
    }
    else
    {
        static NSString *myIdentifier = @"Cells_removeOrder";
        HMDTDetialZhanjiCell *cell = (HMDTDetialZhanjiCell*)[tableView dequeueReusableCellWithIdentifier:myIdentifier];
        if (cell == nil)
            cell = [[[HMDTDetialZhanjiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier] autorelease];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
        cell.cellTitle = @"战绩：";
 
        cell.graygoldStar = [KISDictionaryNullValue(self.zhanjiDic, @"graygoldStar") intValue];
        cell.goldStar = [KISDictionaryNullValue(self.zhanjiDic, @"goldStar") intValue];
        cell.diamond = [KISDictionaryNullValue(self.zhanjiDic, @"diamond") intValue];
        cell.graydiamond = [KISDictionaryNullValue(self.zhanjiDic, @"graydiamond") intValue];
        cell.graycup = [KISDictionaryNullValue(self.zhanjiDic, @"graycup") intValue];
        cell.cup = [KISDictionaryNullValue(self.zhanjiDic, @"cup") intValue];
        cell.graycrown = [KISDictionaryNullValue(self.zhanjiDic, @"graycrown") intValue];
        cell.crown = [KISDictionaryNullValue(self.zhanjiDic, @"crown") intValue];
        
        [cell refreshCell];
        return cell;
    
    }
 
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
