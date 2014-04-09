//
//  BuyRemindCell.h
//  Boyacai
//
//  Created by qiushi on 13-5-17.
//
//

#import <UIKit/UIKit.h>

@interface My_WeiBoCell : UITableViewCell
{
    UIImageView     *m_accessoryImageView;
    UILabel         *m_titleLable;
    UISwitch        *m_swith;
}
@property (retain,nonatomic)UIImageView     *accessoryImageView;
@property (retain,nonatomic)UILabel         *titleLable;
@property (retain,nonatomic)UISwitch        *swith;
@end
