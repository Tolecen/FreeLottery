//
//  KS_HeaderViewController.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-8-16.
//
//

#import <UIKit/UIKit.h>
@protocol NextIssueDelegate <NSObject>

-(void)refreshWinningHistoryData:(id)data;

@end

@interface KS_HeaderViewController : UIViewController
{
    id <NextIssueDelegate> _delegate;
}
@property (nonatomic, assign) id <NextIssueDelegate> delegate;
-(void)refreshHistoryData:(id)data;
@end
