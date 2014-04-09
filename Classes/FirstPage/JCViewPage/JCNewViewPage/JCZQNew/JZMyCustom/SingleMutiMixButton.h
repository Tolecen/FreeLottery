//
//  SingleMutiMixButton.h
//  Boyacai
//
//  Created by qiushi on 13-9-6.
//
//

#import <UIKit/UIKit.h>
#import "JZ_CombineListModel.h"
#import "JZ_NoteNumEditeViewController.h"

@interface SingleMutiMixButton : UIButton

{
    double                         m_minWinAmount;//最小奖金
    double                         m_maxWinAmount;
    int                            m_numGameCount;
}

@property (nonatomic,assign) NSInteger moreCount;
@property (nonatomic,retain) JZ_NoteNumEditeViewController  *jz_NoteNumEditeViewController;;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title Tag:(NSInteger)radioTag minWinAmount:(double)minWinAmount maxWinAmount:(double)maxWinAmount numGameCount:(int)numGameCount;

//传进来一个X串Y的字符串，返回这种串法的个数
-(NSInteger) getNoteNumberByDuoChuanRadioTag:(NSString*)DuoChuanRadioTag;

@end
