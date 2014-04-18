//
//  LotteryTypeEditorViewController.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-3-21.
//
//

#import "LotteryTypeEditorViewController.h"
#import "RuYiCaiCommon.h"
#import "RuYiCaiNetworkManager.h"
#import "CommonRecordStatus.h"
#import "NSLog.h"
#import "BackBarButtonItemUtils.h"
#import "RightBarButtonItemUtils.h"
#import "ColorUtils.h"
#import "AdaptationUtils.h"

#define SwitchStartTag   (212)
#define CELL_BUTTON_TAG (100010)
#define CELL_LABEL_TAG (100011)


@interface LotteryTypeEditorViewController ()<UIAlertViewDelegate>
- (void)setRecordArray;
- (void)saveLotteryTypeAction:(id)sender;
@end


@implementation LotteryTypeEditorViewController

@synthesize stateSwitchArr = _stateSwitchArr;
@synthesize showLotArray = _showLotArray;
@synthesize showArray = _showArray;
@synthesize hidenArray = _hidenArray;

- (void)dealloc
{
    [_tableView release],_tableView = nil;
    [_stateSwitchArr release],_stateSwitchArr = nil;
    [_showArray release],_showArray = nil;
    [_hidenArray release],_hidenArray = nil;
    
    if(_showLotArray != nil)
        [_showLotArray release],_showLotArray = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [AdaptationUtils adaptation:self];
    [BackBarButtonItemUtils addBackButtonForController:self addTarget:self action:@selector(goToBack) andAutoPopView:NO];
    [RightBarButtonItemUtils addRightButtonForController:self addTarget:self action:@selector(saveLotteryTypeAction:) andTitle:@"保存"];
    
    countStr = 0;
    NSMutableArray* mutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
    self.showArray = [NSMutableArray array];
    self.hidenArray = [NSMutableArray array];
    
    if(!mutableArr)//没调开机介绍图里的初始化时
    {
        [[CommonRecordStatus commonRecordStatusManager] setLotShowArray];
        NSMutableArray* newMutableArr = [[NSUserDefaults standardUserDefaults] objectForKey:kLotteryShowDicKey];
        _showLotArray = [[NSMutableArray alloc] initWithArray:newMutableArr];
    }
    else
    {
        _showLotArray = [[NSMutableArray alloc] initWithArray:mutableArr];
    }
    
    //    NSLog(@"retainCount %d", [_showLotArray retainCount]);//? 2
    _stateSwitchArr = [[NSMutableArray alloc] initWithCapacity:1];
    [self setRecordArray];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 57, 320, [UIScreen mainScreen].bounds.size.height - 114 - 57+40+10) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.editing = YES;
    [_tableView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#f5f5f5"]];
    
    //    UIView *headView = [UIView alloc]initWithFrame:<#(CGRect)#>
    UITextView *headTextView = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,57)]autorelease];
    [headTextView setText:@"您可以在这里调整大厅显示的彩种，至少保留一种彩种，点击“+”显示彩种，“x”图标隐藏彩种。"];
    [headTextView setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [headTextView setEditable:NO];
    [headTextView setScrollEnabled:NO];
    [headTextView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#f5f5f5"]];
    
    [self.view addSubview:headTextView];
    
    
    
    //    _tableView.contentInset = UIEdgeInsetsMake(0, -30, 0, 0);
    [self.view addSubview:_tableView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)setRecordArray
{
    for(int i = 0; i < [self.showLotArray count]; i ++)
    {
        if([[[[self.showLotArray objectAtIndex:i] allValues] objectAtIndex:0] isEqualToString:@"1"])
        {
            [self.stateSwitchArr addObject:@"1"];
            [self.showArray addObject:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:[[[self.showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]]];
        }
        else
        {
            [self.stateSwitchArr addObject:@"0"];
            [self.hidenArray addObject:[[CommonRecordStatus commonRecordStatusManager] lotNameWithLotTitle:[[[self.showLotArray objectAtIndex:i] allKeys] objectAtIndex:0]]];
        }
    }
    
    
}
- (IBAction)lotteryDeleteAction:(id)sender{
    NSLog(@"lottery Delete Action");
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
     {
        cell = (UITableViewCell *)[[btn superview] superview];
     }else
     {
         cell = (UITableViewCell *)[btn superview];
     }
    
    UILabel *label = (UILabel *)[cell viewWithTag:CELL_LABEL_TAG];
    NSString *lotteryName = label.text;
    
    
    NSMutableDictionary *orderLottery = [[NSUserDefaults standardUserDefaults] objectForKey:kDefultLotteryShowDicKey];
    
    NSInteger orderInteger = [[orderLottery objectForKey:lotteryName] integerValue];
    NSString* thisKey = [[[self.showLotArray objectAtIndex:orderInteger] allKeys] objectAtIndex:0];
    NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    //至少留下一种彩种的判断
    
    if ([self.hidenArray count]>=[self.stateSwitchArr count]-1)
    {
        UIAlertView *stateUIAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请至少留下一种彩种" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [stateUIAlertView show];
        [stateUIAlertView release];
        return;
    }
    
    [self.stateSwitchArr replaceObjectAtIndex:orderInteger withObject:@"0"];
    [tempDict setObject:@"0" forKey:thisKey];
    [self.showLotArray replaceObjectAtIndex:orderInteger withObject:tempDict];
    
    
    [self.hidenArray addObject:[self.showArray objectAtIndex:cell.tag]];
    [self.showArray removeObjectAtIndex:cell.tag];
    
    [_tableView reloadData];
}

- (IBAction)lotteryAddAction:(id)sender{
    NSLog(@"lottery Add Action");
    UIButton *btn = (UIButton *)sender;
    UITableViewCell *cell;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        cell = (UITableViewCell *)[[btn superview] superview];
    }else
    {
        cell = (UITableViewCell *)[btn superview];
    }
    UILabel *label = (UILabel *)[cell viewWithTag:CELL_LABEL_TAG];
    NSString *lotteryName = label.text;
    
    NSMutableDictionary *orderLottery = [[NSUserDefaults standardUserDefaults] objectForKey:kDefultLotteryShowDicKey];
    
    NSInteger orderInteger = [[orderLottery objectForKey:lotteryName] integerValue];
    NSString* thisKey = [[[self.showLotArray objectAtIndex:orderInteger] allKeys] objectAtIndex:0];
    NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [self.stateSwitchArr replaceObjectAtIndex:orderInteger withObject:@"1"];
    [tempDict setObject:@"1" forKey:thisKey];
    [self.showLotArray replaceObjectAtIndex:orderInteger withObject:tempDict];
    
    [self.showArray addObject:[self.hidenArray objectAtIndex:cell.tag]];
    [self.hidenArray removeObjectAtIndex:cell.tag];
    
    [_tableView reloadData];
}


//- (void)pressSwitch:(id)sender
//{
//	UISwitch *temp = (UISwitch *)sender;
//	int temptag = temp.tag - SwitchStartTag;
//    NSLog(@"index %d", temptag);
//
//    NSString* thisKey = [[[self.showLotArray objectAtIndex:temptag] allKeys] objectAtIndex:0];
//    NSMutableDictionary* tempDict = [NSMutableDictionary dictionaryWithCapacity:1];
//
//    if ([[self.stateSwitchArr objectAtIndex:temptag] isEqualToString:@"0"])
//    {
//        [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"1"];
//        _openLotNum += 1;
//
//        [tempDict setObject:@"1" forKey:thisKey];
//        [self.showLotArray replaceObjectAtIndex:temptag withObject:tempDict];
//    }
//    else
//    {
//        if(_openLotNum == 1)
//        {
//            temp.on = YES;
//            [[RuYiCaiNetworkManager sharedManager] showMessage:@"至少要选择一种进行显示！" withTitle:@"提示" buttonTitle:@"确定"];
//        }
//        else
//        {
//            [self.stateSwitchArr replaceObjectAtIndex:temptag withObject:@"0"];
//            _openLotNum -= 1;
//
//            [tempDict setObject:@"0" forKey:thisKey];
//            [self.showLotArray replaceObjectAtIndex:temptag withObject:tempDict];
//        }
//    }
//}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//返回标题数组中元素的个数来确定分区的个数
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger i = 0;
    switch (section) {
        case 0:
            for (NSString *switchString in self.stateSwitchArr) {
                if ([switchString isEqualToString:@"1"]) {
                    i++;
                }
            }
            return  i;//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        case 1:
            for (NSString *switchString in self.stateSwitchArr) {
                if ([switchString isEqualToString:@"0"]) {
                    i++;
                }
            }
            return i;
            break;
        default:
            return 0;
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"当前彩种";
        case 1:
            return @"更多彩种";
        default:
            return @"Unknown";
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0f;
}
- (UIView *) tableView:(UITableView *)tableView1 viewForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self tableView:_tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 22)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    //    label.backgroundColor = [UIColor redColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    label.text = sectionTitle;
    
    UIView * sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width,    35)] autorelease];
    sectionView.backgroundColor = [UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.7];
    UIImageView *sectionImgView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"table_view_head_section_bg.png"]]autorelease];
    [sectionImgView setFrame:CGRectMake(0, 0, 320, 35)];
    [sectionView addSubview:sectionImgView];
    [sectionView addSubview:label];
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        UIView *backView = [[[UIView alloc]initWithFrame:cell.frame]autorelease];
        [backView setBackgroundColor:[ColorUtils parseColorFromRGB:@"#e6e6e6"]];
        [cell addSubview:backView];
        
        
        UILabel *textLabelView = [[[UILabel alloc]initWithFrame:CGRectMake(10, 0, cell.frame.size.width, cell.frame.size.height)]autorelease];
        textLabelView.tag = CELL_LABEL_TAG;
        [textLabelView setFont:[UIFont boldSystemFontOfSize:15]];
        [textLabelView setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:textLabelView];
        
        UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cellBtn.frame = CGRectMake(280, 5, 32 , 32);
        cellBtn.tag = CELL_BUTTON_TAG;
        [cell addSubview:cellBtn];
        
        
        
        
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *tagView = [cell viewWithTag:CELL_BUTTON_TAG];
    UIButton *cellBtn;
    if (tagView && [tagView isKindOfClass:[UIButton class]]) {
        cellBtn = (UIButton *)tagView;
    }
    
    tagView = [cell viewWithTag:CELL_LABEL_TAG];
    UILabel *cellLabelView;
    if (tagView && [tagView isKindOfClass:[UILabel class]]) {
        cellLabelView = (UILabel *)tagView;
    }
    
    switch (indexPath.section) {
        case 0:
            if (YES) {
                [cellBtn removeTarget:self action:@selector(lotteryAddAction:) forControlEvents:UIControlEventTouchUpInside];
                [cellLabelView setText:[self.showArray objectAtIndex:indexPath.row]];
                cell.tag = indexPath.row;
                [cellBtn setBackgroundImage:[UIImage imageNamed:@"lottery_delete_btn.png"] forState:UIControlStateNormal];
                [cellBtn addTarget:self action:@selector(lotteryDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            break;
        case 1:
            if (YES) {
                [cellBtn removeTarget:self action:@selector(lotteryDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
                [cellLabelView setText:[self.hidenArray objectAtIndex:indexPath.row]];
                cell.tag = indexPath.row;
                [cellBtn setBackgroundImage:[UIImage imageNamed:@"lottery_add_btn.png"] forState:UIControlStateNormal];
                [cellBtn addTarget:self action:@selector(lotteryAddAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            break;
            
        default:
            break;
    }
    
    
    //    cell.textLabel.text = [self.lotArray objectAtIndex:indexPath.row];
    
    //    UISwitch*  swith = [[UISwitch alloc] initWithFrame:CGRectMake(215, 8, 79, 27)];
    //    if([[self.stateSwitchArr objectAtIndex:indexPath.row] isEqualToString:@"1"])
    //    {
    //        swith.on = YES;
    //    }
    //    else
    //    {
    //        swith.on = NO;
    //    }
    //    swith.tag = SwitchStartTag + indexPath.row;
    //    [swith addTarget:self action:@selector(pressSwitch:) forControlEvents:UIControlEventValueChanged];
    //    [cell addSubview:swith];
    //    [swith release];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //    if (sourceIndexPath != destinationIndexPath)
    //    {
    //        id object = [self.lotArray objectAtIndex:sourceIndexPath.row];
    //        [object retain];
    //        [self.lotArray removeObjectAtIndex:sourceIndexPath.row];
    //
    //        id stateObj = [self.stateSwitchArr objectAtIndex:sourceIndexPath.row];
    //        [stateObj retain];
    //        [self.stateSwitchArr removeObjectAtIndex:sourceIndexPath.row];
    //
    //        id showLot = [self.showLotArray objectAtIndex:sourceIndexPath.row];
    //        [showLot retain];
    //        [self.showLotArray removeObjectAtIndex:sourceIndexPath.row];
    //
    //        if (destinationIndexPath.row > [self.lotArray count])
    //        {
    //            [self.lotArray addObject:object];
    //            [self.stateSwitchArr addObject:stateObj];
    //            [self.showLotArray addObject:showLot];
    //        }
    //        else
    //        {
    //            [self.lotArray insertObject:object atIndex:destinationIndexPath.row];
    //            [self.stateSwitchArr insertObject:stateObj atIndex:destinationIndexPath.row];
    //            [self.showLotArray insertObject:showLot atIndex:destinationIndexPath.row];
    //        }
    //        [showLot release];
    //        [object release];
    //        [stateObj release];
    //    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//保存彩票位置信息
- (void)saveLotteryTypeAction:(id)sender{
//    [[NSUserDefaults standardUserDefaults] setObject:self.showLotArray forKey:kLotteryShowDicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];//同步
    
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"彩种设置已保存"
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
	[alert show];
	[alert release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)goToBack
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shownTabView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    if (alertView.tag==1001) {
//        NSLog(@"保存彩票位置信息");
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//   
//}
@end
