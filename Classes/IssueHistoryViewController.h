//
//  IssueHistoryViewController.h
//  Boyacai
//
//  Created by wangxr on 14-5-30.
//
//

#import <UIKit/UIKit.h>
enum {
    QueryTypeIssueHistory ,
    QueryTypeGameOrder   ,
};
typedef NSInteger QueryType;
@interface IssueHistoryViewController : UIViewController
@property (nonatomic,assign)QueryType type;
@end
