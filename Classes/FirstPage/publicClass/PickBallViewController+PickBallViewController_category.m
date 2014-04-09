//
//  PickBallViewController+PickBallViewController_category.m
//  RuYiCai
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PickBallViewController.h"

@implementation PickBallViewController (PickBallViewController_category)

#pragma mark YiLuo view may
//- (NSInteger)bigOneIndex:(NSArray*)dataA
//{
//    NSInteger index = 0;
//    for(int i = 1; i < [dataA count]; i++)
//    {
//        if([[dataA objectAtIndex:i] intValue] > [[dataA objectAtIndex:index] intValue])
//        {
//            index = i;
//        }
//    }
//    return index;
//}

- (void)bigTwoNumber:(NSArray*)dataA maxOne:(int*)maxOneIndex maxTwo:(int*)maxTwoIndex
{
    if([dataA count] < 2)
    {
        return;
    }
    if([[dataA objectAtIndex:0] intValue] > [[dataA objectAtIndex:1] intValue])
    {
        *maxOneIndex = 0;
        *maxTwoIndex = 1;
    }
    else
    {
        *maxOneIndex = 1;
        *maxTwoIndex = 0;
    }
    for(int i = 2; i < [dataA count]; i++)
    {
        if([[dataA objectAtIndex:i] intValue] > [[dataA objectAtIndex:*maxOneIndex] intValue])
        {
            *maxTwoIndex = *maxOneIndex;
            *maxOneIndex = i;
        }
        else if([[dataA objectAtIndex:i] intValue] > [[dataA objectAtIndex:*maxTwoIndex] intValue])
        {
            *maxTwoIndex = i;
        }
    }
}

- (void)creatYiLuoViewWithData:(NSArray*)dataArr rowNumber:(NSInteger)rowNumber
{
    //NSLog(@"dateArr:: %@", dataArr);
    for(int k = 0; k <= labelCount; k++)
    {
        [[self.view viewWithTag:k + kLabelStartTag] removeFromSuperview];
    }
    NSInteger largIndex;
    NSInteger largIndex_two; 
    [self bigTwoNumber:dataArr maxOne:&largIndex maxTwo:&largIndex_two];
    
    NSInteger indexs;
    NSInteger rowCount = [dataArr count]/rowNumber;
    for (int j = 0; j <= rowCount; j++)
    {
        int pearNum = ([dataArr count] - j * rowNumber) < rowNumber ? ([dataArr count] - j * rowNumber):rowNumber;
        float label_width = (rowNumber == 9) ? kBallWidth:kSmallBallWidth;
        
        for(int i = 0; i < pearNum; i++)
        {
            UILabel* numLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * (label_width + kBallVerticalSpacing) , j * (kBallHeight + kBallLineSpacing + kYiLuoHeight) + kBallHeight, label_width , kYiLuoHeight)];
            indexs = i + j * rowNumber;
            numLabel.text = [NSString stringWithFormat:@"%d", [[dataArr objectAtIndex:indexs] intValue]];
            numLabel.textAlignment = UITextAlignmentCenter;
            [numLabel setFont:[UIFont systemFontOfSize:kLabelFont]];
            [numLabel setBackgroundColor:[UIColor clearColor]];
            numLabel.tag = indexs + kLabelStartTag;
            if(largIndex == indexs || largIndex_two == indexs)
            {
                [numLabel setTextColor:[UIColor redColor]];
            }
            else
            {
                [numLabel setTextColor:[UIColor grayColor]];
            }
            [self.view addSubview:numLabel];
            [numLabel release];
        }
    }
    labelCount = indexs;
}

@end
