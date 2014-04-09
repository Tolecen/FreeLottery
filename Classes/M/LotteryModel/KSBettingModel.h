//
//  KSBettingModel.h
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import <Foundation/Foundation.h>
#import "KSLotterysModel.h"

@interface KSBettingModel : NSObject

@property (nonatomic, retain) NSMutableArray *kSBettingArrayModel;

-(id)init;
+(KSBettingModel *)share;
-(void)addLotterys:(KSLotterysModel *)lotters;
-(void)updateFromOldLotterys:(KSLotterysModel *)oldLotters ToNewLotterys:(id)newLotters;
-(void)updateFromOldLotterys:(KSLotterysModel *)lotters;
-(void)removeLotters:(KSLotterysModel *)lotters;
-(void)removeAll;
-(void)removeLottersAtIndex:(NSInteger)indexRow;
@end
