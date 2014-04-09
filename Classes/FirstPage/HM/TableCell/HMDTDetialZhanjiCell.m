//
//  HMDTDetialZhanjiCell.m
//  RuYiCai
//
//  Created by ruyicai on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HMDTDetialZhanjiCell.h"
#import "RYCImageNamed.h"
#import "HMDTBetCaseLotViewController.h"
#import "HMDTAutoOrderViewController.h"
@interface HMDTDetialZhanjiCell (internal)
-(void) orderButtonPress;
@end

@implementation HMDTDetialZhanjiCell
@synthesize cellTitle;

@synthesize graygoldStar = m_graygoldStar;
@synthesize graydiamond = m_graydiamond;
@synthesize graycup = m_graycup;
@synthesize graycrown = m_graycrown;

@synthesize goldStar = m_goldStar;
@synthesize diamond = m_diamond;
@synthesize cup = m_cup;
@synthesize crown = m_crown;
@synthesize superViewController = m_superViewController;
- (void)dealloc
{
    [cellLabel release];
    
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
        cellLabel.textAlignment = UITextAlignmentCenter;
        cellLabel.font = [UIFont systemFontOfSize:15.0f];
        cellLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0];
        cellLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:cellLabel];
        
        if (![@"Cells_removeOrder" isEqual:reuseIdentifier]) {
            //合买 定制跟单
//            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(230, 5, 70, 30)];
//            [button setBackgroundImage:RYCImageNamed(@"auto_order_normal.png") forState:UIControlStateNormal];
//            [button setBackgroundImage:RYCImageNamed(@"auto_order_click.png") forState:UIControlStateHighlighted];
//            button.backgroundColor = [UIColor clearColor];
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setTitle:@"定制跟单" forState:UIControlStateNormal];
//            button.titleLabel.textAlignment = UITextAlignmentCenter;
//            button.titleLabel.font = [UIFont systemFontOfSize:13];
//            [button addTarget:self action:@selector(orderButtonPress) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:button];
//            [button release];
        }
	}
    return self;
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
    
    cellLabel.text = self.cellTitle;
}

-(NSInteger)creatIcoImage:(NSInteger)widthIndex ICONAME:(NSString*)icoName ICONUM:(NSInteger)icoNum
{
    NSInteger width = widthIndex;
    if (icoNum > 0) {
        
        UIImageView*  ico = [[UIImageView alloc] initWithFrame:CGRectMake(width,13,13,13)];
        ico.image = RYCImageNamed(icoName);
        [ico setBackgroundColor:[UIColor clearColor]];
        [self addSubview:ico];
        [ico release];
        
        if (icoNum > 1) {
            UILabel* icoNumLable = [[UILabel alloc] initWithFrame:CGRectMake(width + 2, 13 + 2, 13, 13)];
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
-(void) orderButtonPress
{
    [self.superViewController hidesBottomBarWhenPushed];
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
@end
