//
//  NSURLHelper.m
//  Helper
//
//  Created by LiTengjie on 11-7-30.
//  Copyright 2011 China. All rights reserved.
//

#import "NSURLHelper.h"
#import "NSLog.h"

NSString* stringOfCachePolicy(NSURLRequestCachePolicy cachePolicy)
{
	switch (cachePolicy) 
	{
		case NSURLRequestUseProtocolCachePolicy:
			return @"NSURLRequestUseProtocolCachePolicy";
		case NSURLRequestReloadIgnoringLocalCacheData:
			return @"NSURLRequestReloadIgnoringLocalCacheData or NSURLRequestReloadIgnoringCacheData";
		case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
			return @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData";
		case NSURLRequestReturnCacheDataElseLoad:
			return @"NSURLRequestReturnCacheDataElseLoad";
		case NSURLRequestReturnCacheDataDontLoad:
			return @"NSURLRequestReturnCacheDataDontLoad";
		case NSURLRequestReloadRevalidatingCacheData:
			return @"NSURLRequestReloadRevalidatingCacheData";
		default:
			return nil;
	}
}
	
void DumpURLRequest(NSURLRequest*urlRequest)
{
	NSLog(@"0x%X:%@",urlRequest,urlRequest);
	NSLog(@"URL:%@",[urlRequest URL]);
	NSLog(@"cachePolicy:%@",stringOfCachePolicy([urlRequest cachePolicy]));
	NSLog(@"timeoutInterval:%f",[urlRequest timeoutInterval]);
	NSLog(@"mainDocumentURL:%@",[urlRequest mainDocumentURL]);
}

void DumpHTTPURLRequest(NSURLRequest *httpRequest)
{
	NSLog(@"0x%X:%@",httpRequest,httpRequest);
	NSLog(@"URL:%@",[httpRequest URL]);
	NSLog(@"cachePolicy:%@",stringOfCachePolicy([httpRequest cachePolicy]));
	NSLog(@"timeoutInterval:%f",[httpRequest timeoutInterval]);
	NSLog(@"mainDocumentURL:%@",[httpRequest mainDocumentURL]);
	
	NSLog(@"HTTPMethod:%@",[httpRequest HTTPMethod]);
	NSLog(@"allHTTPHeaderFields:%@",[httpRequest allHTTPHeaderFields]);
//	NSDictionary *headerDict = [httpRequest allHTTPHeaderFields];
//	for (id field in [headerDict allKeys]) 
//		NSLog(@"%@:%@",field,[httpRequest valueForHTTPHeaderField:field]);
	NSLog(@"HTTPBody length:%d",[[httpRequest HTTPBody] length]);
	//NSLog(@"NSInputStream:%@",[httpRequest NSInputStream]);
	NSLog(@"HTTPShouldHandleCookies:%d",[httpRequest HTTPShouldHandleCookies]);
}

void DumpURLResponse(NSURLResponse*urlResponse)
{
	NSLog(@"%@",urlResponse);
	NSLog(@"URL:%@",[urlResponse URL]);
	NSLog(@"MIMEType:%@",[urlResponse MIMEType]);
	NSLog(@"expectedContentLength:%lld",[urlResponse expectedContentLength]);
	NSLog(@"textEncodingName:%@",[urlResponse textEncodingName]);
	NSLog(@"suggestedFilename:%@",[urlResponse suggestedFilename]);	
}

void DumpHTTPURLResponse(NSHTTPURLResponse*httpResponse)
{
	NSLog(@"%@",httpResponse);
	NSLog(@"URL:%@",[httpResponse URL]);
	NSLog(@"MIMEType:%@",[httpResponse MIMEType]);
	NSLog(@"expectedContentLength:%lld",[httpResponse expectedContentLength]);
	NSLog(@"textEncodingName:%@",[httpResponse textEncodingName]);
	NSLog(@"suggestedFilename:%@",[httpResponse suggestedFilename]);	
	
	NSLog(@"statusCode:%d,%@",[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
	NSLog(@"allHeaderFields:%@",[httpResponse allHeaderFields]);
}

