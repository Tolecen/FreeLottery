//
//  RuYiCaiNetworkManager+RuYiCaiDownLoad_Net.m
//  RuYiCai
//
//  Created by  on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RuYiCaiNetworkManager.h"
#import "NSLog.h"

@implementation RuYiCaiNetworkManager (RuYiCaiDownLoad_Net)

- (void)sendException:(NSString*)excContent
{
    NSString *updateUrl =[NSString stringWithFormat:@"%@", kRuYiCaiServer];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:updateUrl]];
	request.allowCompressedResponse = NO;
    
    NSMutableDictionary* mDict = [self getCommonCookieDictionary];
    [mDict setObject:@"feedback" forKey:@"command"];
    [mDict setObject:@"exceptionSubmit" forKey:@"type"];
    [mDict setObject:self.phonenum forKey:@"phonenum"];
    [mDict setObject:self.userno forKey:@"userno"];
    [mDict setObject:excContent forKey:@"content"];
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString* cookieStr = [jsonWriter stringWithObject:mDict];
    [jsonWriter release];
    
    NSData* cookieData = [cookieStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData* sendData = [cookieData newAESEncryptWithPassphrase:kRuYiCaiAesKey];
    [request appendPostData:sendData];  
    [request buildPostBody];
    
    NSLog(@"异常值:%@", cookieStr);
    
    [request setRequestType:ASINetworkRequestTypeBase];
	[request setDelegate:self];
	[request startAsynchronous];
    
    //清空异常文件
    NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* excPath = [docPath stringByAppendingPathComponent:@"Exception.txt"];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:excPath] == YES)
    {
        [mgr removeItemAtPath:excPath error:nil];
    }
}

- (void)getStartImage:(NSString*)image_url
{
    NSURL *imgURL = [[NSURL alloc] initWithString:image_url];
    NSLog(@"----------image_url%@",image_url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imgURL];
    [request setTimeOutSeconds:20];
    request.allowCompressedResponse = NO;
    
    [request setRequestType:ASINetworkReqestTypeGetStartImage];
    
    [request buildPostBody];
    [request setDelegate:self];
    [request startAsynchronous];
    [imgURL release];
}

- (void)getStartImageComplete:(NSData*)imageData
{
    NSTrace();
    
    NSLog(@"开机图片下载完成…………………………………………");
    [CommonRecordStatus commonRecordStatusManager].startImage = imageData;
    [self saveStartImagePath];
    
    [CommonRecordStatus commonRecordStatusManager].useStartImage = YES;
    [self saveStartImgRecordPath];
}

- (BOOL)sameStartImageId
{
    NSTrace();
    NSString* strPath_image = [self getStartImagePath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath_image] == NO)
		return NO;
	
	NSMutableArray* sameImageList = [[NSMutableArray alloc] initWithContentsOfFile:strPath_image];
	NSString* strId = [sameImageList objectAtIndex:0];
    
    if([[CommonRecordStatus commonRecordStatusManager].startImageId isEqualToString:strId])
    {
        [sameImageList release];
        return YES;
    }
    else
    {
        [sameImageList release];
        return NO;
    }
       
}

- (NSString*)getStartImagePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        //第一位保存服务器上开机界面的id，第二位保存服务器上开机界面的图片
		NSString* strSub = @"/startimage.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readStartImagePath
{
    NSString* strPaths = [self getStartImagePath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPaths] == NO)
		return;
	
	NSMutableArray* readImageList = [[NSMutableArray alloc] initWithContentsOfFile:strPaths];
    if([readImageList count] == 2)
    {
        NSString* strImageId = [readImageList objectAtIndex:0];
        NSData* imageData = [readImageList objectAtIndex:1];
        if (strImageId.length > 0 && imageData.length > 0)
        {
            [CommonRecordStatus commonRecordStatusManager].startImageId = strImageId;
            [CommonRecordStatus commonRecordStatusManager].startImage = imageData;
        }
    }
    [readImageList release];
}

- (void)saveStartImagePath
{
    NSMutableArray* imageList = [[NSMutableArray alloc] init];
    [imageList addObject:[CommonRecordStatus commonRecordStatusManager].startImageId];
    [imageList addObject:[CommonRecordStatus commonRecordStatusManager].startImage];
    
    NSString* strPath = [self getStartImagePath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    
    [imageList writeToFile:strPath atomically:YES];
    [imageList release];
}


- (void)resetImagePlist
{	
    NSString* strPath = [self getStartImagePath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
}

#pragma mark record use start image


- (void)getADImage:(NSArray*)imageUrls{
    for (int i = 0; i<[imageUrls count]; i++) {
        NSURL *imgURL = [[NSURL alloc] initWithString:[imageUrls objectAtIndex:i]];
        NSLog(@"----------image_url%@",[imageUrls objectAtIndex:i]);

        __block ASIHTTPRequest *request = [ ASIHTTPRequest requestWithURL :imgURL];
        [request buildPostBody];
        [request setTimeOutSeconds:20];
        request.allowCompressedResponse = NO;
        [request setCompletionBlock :^{
            
            NSLog(@" 下载成功%d",i);
            int j = i+1;
            NSArray *arr = [[imageUrls objectAtIndex:i] componentsSeparatedByString:NSLocalizedString(@"_", nil)];
            NSString *extension = [(NSString *)[arr objectAtIndex:[arr count] - 1]substringToIndex:8];
            
            
            
            NSData *responseData = [request responseData];

            [self getADImageComplete:responseData andImageId:extension withIndex:j];
            
        }];
        [request setFailedBlock :^{
            // 请求响应失败，返回错误信息
            NSError *error = [request error ];
            NSLog ( @"error:%@" ,[error userInfo ]);
        }];
        [request startAsynchronous ];
        
        
    }
    
}
- (void)getADImageComplete:(NSData*)imageData andImageId:(NSString *)imageId withIndex:(NSInteger)index{
    

    NSLog(@"%@",imageId);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",index]);
    
    
    [[CommonRecordStatus commonRecordStatusManager].useADImageIds setObject:imageId forKey:[NSString stringWithFormat:@"%d",index]];
    [[CommonRecordStatus commonRecordStatusManager].useADImages setObject:imageData forKey:[NSString stringWithFormat:@"%d",index]];
    [self saveADImagePath];

}

- (NSString*)getStartImgRecordPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        //第一位保存服务器上开机界面的id，第二位保存服务器上开机界面的图片
		NSString* strSub = @"/recordstartimage.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readStartImgRecordPath
{
    NSString* strPath = [self getStartImgRecordPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath] == NO)
		return;
	
	NSMutableArray* userList = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
	NSString* strRecord = [userList objectAtIndex:0];
    if (strRecord.length > 0)
    {
        if([strRecord isEqualToString:@"0"])
        {
            [CommonRecordStatus commonRecordStatusManager].useStartImage = NO;
        } 
        else
        {
            [CommonRecordStatus commonRecordStatusManager].useStartImage = YES;
        }
    }
    [userList release];
}

- (void)saveStartImgRecordPath
{
    NSMutableArray* imageList = [[NSMutableArray alloc] init];
    if([CommonRecordStatus commonRecordStatusManager].useStartImage)
    {
        [imageList addObject:@"1"];
    }
    else
    {
        [imageList addObject:@"0"];
    }
    
    NSString* strPath = [self getStartImgRecordPath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    
    [imageList writeToFile:strPath atomically:YES];
    [imageList release];
} 



#pragma mark record use ad image
- (BOOL)sameADImageIdWithNewUrl:(NSArray *)urls;
{
    NSTrace();
    NSString* strPath_image = [self getADImagePath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath_image] == NO){
        [CommonRecordStatus commonRecordStatusManager].useADImageIds =[NSMutableDictionary dictionaryWithCapacity:[urls count]];
        [CommonRecordStatus commonRecordStatusManager].useADImages = [NSMutableDictionary dictionaryWithCapacity:[urls count]];
        return NO;
    }

	NSMutableArray* sameImageList = [[NSMutableArray alloc] initWithContentsOfFile:strPath_image];
    
    NSMutableDictionary *sameDic = [sameImageList objectAtIndex:0];
    [sameImageList release];
    if([sameDic count] != [urls count]){
        [CommonRecordStatus commonRecordStatusManager].useADImageIds =[NSMutableDictionary dictionaryWithCapacity:[urls count]];
        [CommonRecordStatus commonRecordStatusManager].useADImages = [NSMutableDictionary dictionaryWithCapacity:[urls count]];
        return NO;
    }
    

    
    for (int i = 0; i<[urls count]; i++) {
        NSString *url = [urls objectAtIndex:i];
        
        NSArray *arr = [url componentsSeparatedByString:NSLocalizedString(@"_", nil)];
        NSString *extension = [(NSString *)[arr objectAtIndex:[arr count] - 1]substringToIndex:8];
        NSLog(@"extension = %@", extension);
        NSLog(@"sameDic = %@",[sameDic objectForKey:[NSString stringWithFormat:@"%d",i+1]]);
        
        if (![[sameDic objectForKey:[NSString stringWithFormat:@"%d",i+1]] isEqual:extension]) {
            return NO;
        }
        
    }
    
    return YES;
}

- (NSString*)getADImagePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        //第一位保存服务器上开机界面的id，第二位保存服务器上开机界面的图片
		NSString* strSub = @"/ADimage.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}

- (void)readADImagePath
{
    NSString* strPaths = [self getADImagePath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPaths] == NO)
		return;
	
	NSMutableArray* readImageList = [[NSMutableArray alloc] initWithContentsOfFile:strPaths];
    if([readImageList count] == 2)
    {
        NSMutableDictionary* adImageIds = [readImageList objectAtIndex:0];
        NSMutableDictionary* imageDatas = [readImageList objectAtIndex:1];
        if ([adImageIds count] > 0 && [imageDatas count] > 0)
        {

            [CommonRecordStatus commonRecordStatusManager].useADImageIds = adImageIds;
            [CommonRecordStatus commonRecordStatusManager].useADImages = imageDatas;
        }
    }
    [readImageList release];
}

- (void)saveADImagePath
{
    NSMutableArray* imageList = [[NSMutableArray alloc] init];
    [imageList addObject:[CommonRecordStatus commonRecordStatusManager].useADImageIds];
    [imageList addObject:[CommonRecordStatus commonRecordStatusManager].useADImages];
    
    NSString* strPath = [self getADImagePath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    
    [imageList writeToFile:strPath atomically:YES];
    [imageList release];
}



- (NSString*)getADImgRecordPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0)
	{
        //第一位保存服务器上开机界面的id，第二位保存服务器上开机界面的图片
		NSString* strSub = @"/recordADimage.plist";
        NSString *dPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[strSub lastPathComponent]];
		return dPath;
	}
	return nil;
}
- (void)readADImgRecordPath
{
    NSString* strPath = [self getADImgRecordPath];
	NSFileManager* mgr = [NSFileManager defaultManager];
	if ([mgr fileExistsAtPath:strPath] == NO)
		return;
	
	NSMutableArray* userList = [[NSMutableArray alloc] initWithContentsOfFile:strPath];
	NSString* strRecord = [userList objectAtIndex:0];
    if (strRecord.length > 0)
    {
        if([strRecord isEqualToString:@"0"])
        {
            [CommonRecordStatus commonRecordStatusManager].useADImage = NO;
        }
        else
        {
            [CommonRecordStatus commonRecordStatusManager].useADImage = YES;
        }
    }
    [userList release];
}




#pragma mark 头部活动
- (NSString*)getTopActionIdPath
{
    NSArray *topAction_path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([topAction_path count] > 0)
	{
        //第一位保存服务器上开机界面的id，第二位保存服务器上开机界面的图片
		NSString* topAction_strSub = @"/topactionid.plist";
        NSString *topAction_Path = [[topAction_path objectAtIndex:0] stringByAppendingPathComponent:[topAction_strSub lastPathComponent]];
		return topAction_Path;
	}
	return nil;
}


- (void)readTopActionIdPath
{
    if(![CommonRecordStatus commonRecordStatusManager].topActionDic)
    {
        return;
    }
  
    NSString* topAction_strPath = [self getTopActionIdPath];
	NSFileManager* topAction_mgr = [NSFileManager defaultManager];
	if ([topAction_mgr fileExistsAtPath:topAction_strPath] == NO)
    {
        if ([[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] && ![[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] isEqualToString:@""]) {
//            [self showMessage:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] withTitle:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"title"] buttonTitle:@"确定"];
        }
            [self saveTopActionIdPath];
		return;
	}
    
	NSMutableArray* topAction_List = [[NSMutableArray alloc] initWithContentsOfFile:topAction_strPath];
	NSString* topAction_strRecord = [topAction_List objectAtIndex:0];
    if (topAction_strRecord.length > 0)
    {
        if(![topAction_strRecord isEqualToString:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"id"]])
        {
            if ([[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] && ![[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] isEqualToString:@""]) {
//                            [self showMessage:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"message"] withTitle:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"title"] buttonTitle:@"确定"];
            }

            [self saveTopActionIdPath];
        }
    }
    [topAction_List release];
}

- (void)saveTopActionIdPath
{
    NSMutableArray* imageList = [[NSMutableArray alloc] init];
    [imageList addObject:[[CommonRecordStatus commonRecordStatusManager].topActionDic objectForKey:@"id"]];
   
    NSString* strPath = [self getTopActionIdPath];
    NSFileManager* mgr = [NSFileManager defaultManager];
    if ([mgr fileExistsAtPath:strPath] == YES)
        [mgr removeItemAtPath:strPath error:nil];
    
    [imageList writeToFile:strPath atomically:YES];
    [imageList release];
} 

@end
