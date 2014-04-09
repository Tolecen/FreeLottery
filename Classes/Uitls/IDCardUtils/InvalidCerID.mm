//
//  InvalidCerID.m
//  cerdIDTest
//
//  Created by qiushi on 13-4-12.
//  Copyright (c) 2013年 qiushi. All rights reserved.
//

#import "InvalidCerID.h"

@implementation InvalidCerID


const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表


int checkID( int IDNumber[], char ID[] )
{
    int i = 0;//i为计数
    int checksum = 0;
    for ( ; i < 17; i ++ )
        checksum += IDNumber[ i ] * factor[ i ];
    
    if ( IDNumber[ 17 ] == checktable[ checksum % 11 ] || ( ID[ 17 ] == 'x' && checktable[ checksum % 11 ] == 10 ))
        return 1;
    else
        return 0;
}
- (int)checkIDfromchar:(char *)ID
{
    if (strlen(ID)!=18) {//验证18位
        return 0;
    }
    int IDNumber[ 19 ];
    for ( int i = 0; i < 18; i ++ )//相当于类型转换
        IDNumber[ i ] = ID[ i ] - 48;
    return checkID( IDNumber, ID );
}




@end
