//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver


#import <UIKit/UIKit.h>


@interface PullRefreshTableViewController : UITableViewController {
    UIView                  *refreshHeaderView;
    UILabel                 *refreshLabel;
	UILabel                 *refreshDate;
    UIImageView             *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL                    isDragging;
    BOOL                    isLoading;
    NSString                *textPull;
    NSString                *textRelease;
    NSString                *textLoading;
}

@property (nonatomic, retain) UIView  *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UILabel *refreshDate;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)addPullToRefreshHeader;
- (void)startLoading;
- (void)stopLoading;
- (void)refresh;

@end
