//
//  SenderInformationCell.h
//  RuYiCai
//
//  Created by qiushi on 13-1-24.
//
//

#import <UIKit/UIKit.h>
#import "HMDTBetCaseLotViewController.h"


@interface SenderInformationCell : UITableViewCell
{
    IBOutlet UILabel         *m_sendNameLable;
    IBOutlet UILabel         *m_recordLable;
    IBOutlet UIButton        *m_commissionBtn;
    
    NSInteger   m_graygoldStar;
    NSInteger   m_graydiamond;
    NSInteger   m_graycup;
    NSInteger   m_graycrown;
    
    NSInteger   m_goldStar;
    NSInteger   m_diamond;
    NSInteger   m_cup;
    NSInteger   m_crown;
    
    HMDTBetCaseLotViewController* m_superViewController;
}

@property (nonatomic,retain) HMDTBetCaseLotViewController* superViewController;
@property (nonatomic,retain) UILabel       *sendNameLable;
@property (nonatomic,retain) UILabel       *recordLable;
@property (nonatomic,retain) UIButton      *commissionBtn;

@property (nonatomic, assign) NSInteger graygoldStar;
@property (nonatomic, assign) NSInteger graydiamond;
@property (nonatomic, assign) NSInteger graycup;
@property (nonatomic, assign) NSInteger graycrown;
@property (nonatomic, assign) NSInteger goldStar;
@property (nonatomic, assign) NSInteger diamond;
@property (nonatomic, assign) NSInteger cup;
@property (nonatomic, assign) NSInteger crown;
- (IBAction)orderButtonPress;
- (void)refreshCell;

@end
