//
//  TrackDetailViewController.h
//  RuYiCai
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView           *m_myTableView;
    
    NSMutableArray        *m_contentArray;
    
    NSString*             m_trackId;
    
    NSMutableArray   *m_titleButtonState;
    
    NSMutableArray        *m_dataArray;
    
    BOOL                  isCanStopTrack;
}

@property(nonatomic, retain) NSMutableArray        *contentArray;
@property(nonatomic, retain) UITableView           *myTableView;
@property(nonatomic, retain) NSString*             trackId;
@property(nonatomic, retain) NSMutableArray        *titleButtonState;
@property(nonatomic, retain) NSMutableArray        *dataArray;
@property(nonatomic, assign) BOOL                  isCanStopTrack;
@property(nonatomic, retain) NSString*             stopIdNo;

- (void)setUpTopView;
- (void)detailButtonClick:(id)sender;
- (void)queryHistoryTrackOK:(NSNotification*)notification;
- (void)StopTrackNotification:(NSNotification*)notification;
- (void)cancelTrackOK:(NSNotification*)notification;
@end
