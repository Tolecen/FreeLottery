//
//  KSBettingModel.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-3.
//
//

#import "KSBettingModel.h"

@interface KSBettingModel()
    


@end

@implementation KSBettingModel


@synthesize kSBettingArrayModel;

+(KSBettingModel *)share{
    static KSBettingModel *sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedModel = [KSBettingModel new];});
    return sharedModel;
}

-(id)init{
    if (self = [super init]) {
        kSBettingArrayModel = [NSMutableArray new];
    }
    return self;
}

-(void)addLotterys:(KSLotterysModel *)lotters{
    [self.kSBettingArrayModel insertObject:lotters atIndex:0];
}
-(void)updateFromOldLotterys:(KSLotterysModel *)oldLotters ToNewLotterys:(id)newLotters{
    
    NSUInteger i = [self.kSBettingArrayModel indexOfObject:oldLotters];
    [self.kSBettingArrayModel replaceObjectAtIndex:i withObject:newLotters];
}
-(void)updateFromOldLotterys:(KSLotterysModel *)lotters {
    
    NSUInteger i = [self.kSBettingArrayModel indexOfObject:lotters];
    [self.kSBettingArrayModel replaceObjectAtIndex:i withObject:lotters];


}
-(void)removeLotters:(KSLotterysModel *)lotters{

//    NSUInteger i = [self.kSBettingArrayModel indexOfObject:lotters];
//    [self.kSBettingArrayModel removeObjectAtIndex:i];
    
    [self.kSBettingArrayModel removeObject:lotters];
}

-(void)removeLottersAtIndex:(NSInteger)indexRow{
    
    //    NSUInteger i = [self.kSBettingArrayModel indexOfObject:lotters];
    //    [self.kSBettingArrayModel removeObjectAtIndex:i];
    
    [self.kSBettingArrayModel removeObjectAtIndex:indexRow];
}

-(void)removeAll{
    
    [self.kSBettingArrayModel removeAllObjects];
    
}

@end
