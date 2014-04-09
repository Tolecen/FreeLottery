//
//  BuyRemindCell.h
//  Boyacai
//
//  Created by qiushi on 13-5-17.
//
//

#import <UIKit/UIKit.h>

@interface BuyRemindCell : UITableViewCell
{
    UIImageView     *m_accessoryImageView;
    UILabel         *m_titleLable;
    UILabel         *m_subLable;
}
@property (retain,nonatomic)UIImageView     *accessoryImageView;
@property (retain,nonatomic)UILabel         *titleLable;
@property (retain,nonatomic)UILabel         *subLable;
@end
