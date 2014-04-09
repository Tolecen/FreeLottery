//
//  LotterPeopleZoneCell.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-4-18.
//
//

#import <UIKit/UIKit.h>

@interface LotterPeopleZoneCell : UITableViewCell
{
    UIImage *_iconImage;
    NSString *_titleString;
    NSString *_contentString1 ,*_contentString2;
    
    UIImageView *_backGroundImageView;
}
@property (nonatomic, retain)  UIImageView *backGroundImageView;

@property (nonatomic, retain) UIImage *iconImage;
@property (nonatomic, retain) NSString *titleString;
@property (nonatomic, retain) NSString *contentString1 ,*contentString2;

//刷新cell内数据
- (void)refreshDate;
@end
