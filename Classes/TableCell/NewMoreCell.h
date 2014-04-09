//
//  NewMoreCell.h
//  Boyacai
//
//  Created by qiushi on 13-4-18.
//
//

#import <UIKit/UIKit.h>

@interface NewMoreCell : UITableViewCell

{
    UILabel         *titleLable;
    UIImageView     *accessoryImageView;
    UILabel         *numberLable;
    UILabel         *subLable;
}

@property (nonatomic,retain)UILabel         *titleLable;
@property (nonatomic,retain)UIImageView     *accessoryImageView;
@property (nonatomic,retain)UILabel         *numberLable;
@property (nonatomic,retain)UILabel         *subLable; 
@end
