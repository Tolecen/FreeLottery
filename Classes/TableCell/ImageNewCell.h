//
//  NewMoreCell.h
//  Boyacai
//
//  Created by qiushi on 13-4-18.
//
//

#import <UIKit/UIKit.h>

@interface ImageNewCell : UITableViewCell

{
    UILabel         *titleLable;
    UIImageView     *accessoryImageView;
    UIImageView     *logImageView;
}

@property (nonatomic,retain)UILabel         *titleLable;
@property (nonatomic,retain)UIImageView     *accessoryImageView;
@property (nonatomic,retain)UIImageView     *logImageView;

@end
