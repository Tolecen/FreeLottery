//
//  Math.m
//  Boyacai
//
//  Created by 纳木 那咔 on 13-9-12.
//
//

#import "Math.h"

@implementation Math

+ (NSInteger)combinationN:(NSInteger)n M:(NSInteger)m
{
    
    if (m > n)
    {
        return 0;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *allChooseArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    // (1,1,1,0,0)
    for(int i=0 ;i < n; i++)
    {
        if (i < m)
        {
            [array addObject:@"1"];
        }
        else
        {
            [array addObject:@"0"];
        }
    }
    NSMutableArray *retArray = [array copy];
    NSMutableArray *firstArray = [[NSMutableArray alloc] init];
    
    for(int i=0; i<n; i++)
    {
        if ([[array objectAtIndex:i] intValue] == 1)
        {
            [firstArray addObject:[retArray objectAtIndex:i]];
        }
    }
    
    [allChooseArray addObject:firstArray];
    [firstArray release];
    int count = 0;
    for(int i = 0; i < n-1; i++)
    {
        if ([[array objectAtIndex:i] intValue] == 1 && [[array objectAtIndex:(i + 1)] intValue] == 0)
        {
            [array replaceObjectAtIndex:i withObject:@"0"];
            [array replaceObjectAtIndex:(i + 1) withObject:@"1"];
            
            for (int k = 0; k < i; k++)
            {
                if ([[array objectAtIndex:k] intValue] == 1)
                {
                    count ++;
                }
            }
            if (count > 0)
            {
                for (int k = 0; k < i; k++)
                {
                    if (k < count)
                    {
                        [array replaceObjectAtIndex:k withObject:@"1"];
                    }
                    else
                    {
                        [array replaceObjectAtIndex:k withObject:@"0"];
                    }
                }
            }
            
            NSMutableArray *middleArray = [[NSMutableArray alloc] init];
            
            for (int k = 0; k < n; k++)
            {
                if ([[array objectAtIndex:k] intValue] == 1)
                {
                    [middleArray addObject:[retArray objectAtIndex:k]];
                }
            }
            
            [allChooseArray addObject:middleArray];
            [middleArray release];
            i = -1;
            count = 0;
        }
    }
    [array release];
    [retArray release];
    return [allChooseArray count];
    
}


@end
