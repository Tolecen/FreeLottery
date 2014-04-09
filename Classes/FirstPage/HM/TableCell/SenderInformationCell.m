//
//  SenderInformationCell.m
//  RuYiCai
//
//  Created by qiushi on 13-1-24.
//
//

#import "SenderInformationCell.h"
#import "HMDTAutoOrderViewController.h"

@implementation SenderInformationCell
@synthesize sendNameLable = m_sendNameLable;
@synthesize recordLable   = m_recordLable;
@synthesize commissionBtn = m_commissionBtn;
@synthesize superViewController = m_superViewController;

@synthesize graygoldStar = m_graygoldStar;
@synthesize graydiamond = m_graydiamond;
@synthesize graycup = m_graycup;
@synthesize graycrown = m_graycrown;

@synthesize goldStar = m_goldStar;
@synthesize diamond = m_diamond;
@synthesize cup = m_cup;
@synthesize crown = m_crown;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //               if (![@"senderInfoCell" isEqual:reuseIdentifier]) {
        //
        //            [m_commissionBtn addTarget:self action:@selector(orderButtonPress) forControlEvents:UIControlEventTouchUpInside];
        //
        //        }
        
        
	}
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void) orderButtonPress
{
//    [self.superViewController hidesBottomBarWhenPushed];
    HMDTAutoOrderViewController* view = [[HMDTAutoOrderViewController alloc] init];
    //    view.navigationController.title = @"定制跟单设置";
    //    [view setDataDic:self.superViewController.dataDic];
    
    view.lotNo = self.superViewController.lotNo;
    view.starterUserNo = self.superViewController.starterUserNo;
    view.isByAllAmount = YES;
    view.forceJoin = YES;
    
    //默认值
    view.hasMaxAmountByPercent = YES;
    view.orderMaxAmountByPercent = @"50";
    view.orderCountByPercent = @"10";
    view.orderAmountByPercent = @"1";
    //默认值
    view.orderAmountByAllAmount = @"1";
    view.orderCountByAllAmount = @"10";
    
    [self.superViewController.navigationController pushViewController:view animated:YES];
    [view release];
    
}

- (void)refreshCell
{
    int widthIndex = 100;
    
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:m_graygoldStar];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:m_goldStar];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:m_graydiamond];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:m_diamond];
    //
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:m_graycup];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:m_cup];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:m_graycrown];
    //
    //    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:m_crown];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"crown.png" ICONUM:m_crown];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycrown.png" ICONUM:m_graycrown];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"cup.png" ICONUM:m_cup];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graycup.png" ICONUM:m_graycup];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"diamond.png" ICONUM:m_diamond];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graydiamond.png" ICONUM:m_graydiamond];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"goldStar.png" ICONUM:m_goldStar];
    widthIndex = [self creatIcoImage:widthIndex ICONAME:@"graygoldStar.png" ICONUM:m_graygoldStar];
    
}

-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(width,33,13,13)];
        ico.image = RYCImageNamed(icoName);
        [ico setBackgroundColor:[UIColor clearColor]];
        [self addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(width + 2, 33 + 2, 13, 13)];
            icoNumLable.backgroundColor = [UIColor clearColor];
            icoNumLable.textAlignment = UITextAlignmentRight;
            icoNumLable.text = [NSString stringWithFormat:@"%d",icoNum];
            icoNumLable.textColor = [UIColor colorWithRed:148.0/255.0 green:118.0/255.0 blue:0.0/255.0 alpha:1.0];
            icoNumLable.font = [UIFont systemFontOfSize:9];
            [self addSubview:icoNumLable];
            [icoNumLable release];
        }
        width += 15;
    }
    
    return width;
}

- (void)dealloc
{
    [m_superViewController release];
    [m_recordLable release];
    [m_commissionBtn release];
    [m_sendNameLable release];
    [super dealloc];
}
@end
