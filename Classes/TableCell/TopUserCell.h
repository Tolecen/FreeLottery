//
//  TopUserCell.h
//  Boyacai
//
//  Created by qiushi on 13-4-16.
//
//

#import <UIKit/UIKit.h>

@interface TopUserCell : UITableViewCell

{
    UIImageView     *m_headTopImageView;
    UILabel         *m_headTitleLable;
    UILabel         *m_subTitleLable;
    UIButton        *m_sectionButton;
}

@property(nonatomic,retain)UIImageView     *headTopImageView;
@property(nonatomic,retain)UILabel         *headTitleLable;
@property(nonatomic,retain)UILabel         *subTitleLable;
@property(nonatomic,retain)UIButton        *sectionButton;
@end
