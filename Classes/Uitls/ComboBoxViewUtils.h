//
//  ComboBoxViewUtils.h
//  Boyacai
//
//  Created by qiushi on 13-4-24.
//
//

#import <UIKit/UIKit.h>

@interface ComboBoxViewUtils : UIView <UITableViewDelegate, UITableViewDataSource> 
{
    UILabel         *selectContentLabel;
    UIButton        *pulldownButton;
    UIButton        *hiddenButton;
    UITableView     *comboBoxTableView;
    NSArray         *comboBoxDatasource;
    BOOL            showComboBox;
}
@property (nonatomic, retain) NSArray *comboBoxDatasource;

- (void)initVariables;
- (void)initCompentWithFrame:(CGRect)frame;
- (void)setContent:(NSString *)content;
- (void)show;
- (void)hidden;
- (void)drawListFrameWithFrame:(CGRect)frame withContext:(CGContextRef)context;
@end
