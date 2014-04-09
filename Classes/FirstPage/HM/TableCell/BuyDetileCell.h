//
//  BuyDetileCell.h
//  RuYiCai
//
//  Created by qiushi on 13-1-23.
//
//

#import <UIKit/UIKit.h>

@interface BuyDetileCell : UIView
{
    IBOutlet UILabel         *m_priceLable;
    IBOutlet UITextField     *m_buyTextFiled;
    IBOutlet UITextField     *m_comBottomFiled;
    IBOutlet UILabel         *m_bestlitLable;
}
@property (nonatomic,retain) UILabel             *bestlitLable;
@property (nonatomic,retain) UILabel             *priceLable;
@property (nonatomic,retain) UITextField         *buyTextFiled;
@property (nonatomic,retain) UITextField         *comBottomFiled;
@end
