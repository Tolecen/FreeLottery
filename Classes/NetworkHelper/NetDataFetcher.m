//
//  NetDataFetcher.m
//

#import "NetDataFetcher.h"


@implementation NetDataFetcher

+ (id)asynchronousFetcherWithRequest:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	return [[[NetDataFetcher alloc] initWithRequest:aRequest delegate:aDelegate didFinishSelector:finishSelector didFailSelector:failSelector] autorelease];
}

- (id)initWithRequest:(NSMutableURLRequest *)aRequest delegate:(id)aDelegate didFinishSelector:(SEL)finishSelector didFailSelector:(SEL)failSelector
{
	if (self = [super init])
	{
		request = [aRequest retain];
		delegate = aDelegate;
		didFinishSelector = finishSelector;
		didFailSelector = failSelector;	
	}
	return self;
}

- (void)start
{    
  //  [request prepare];
	
	if (connection)
		[connection release];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
	if (connection)
	{
		if (responseData)
			[responseData release];
		responseData = [[NSMutableData data] retain];
	}
	else
	{

        [delegate performSelector:didFailSelector
                       withObject:nil];
	}
}

- (void)cancel
{
	if (connection)
	{
		[connection cancel];
		[connection release];
		connection = nil;
	}
}

- (void)dealloc
{
	if (request) [request release];
	if (connection) [connection release];
	if (response) [response release];
	if (responseData) [responseData release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
	if (response)
		[response release];
	response = [aResponse retain];
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{

	[delegate performSelector:didFailSelector
				   withObject:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{

	[delegate performSelector:didFinishSelector
				   withObject:responseData];
	
}


@end
