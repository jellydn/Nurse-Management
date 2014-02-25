//
//  OtherAppWS.m
//  MovingHouse
//
//  Created by Nick Lee on 4/13/13.
//  Copyright (c) 2013 tienlp. All rights reserved.
//

#import "OtherAppWS.h"
#import "Define.h"
#import "Common.h"
#import "AppDelegate.h"
#import "AppItem.h"
#import "JSON.h"

@interface OtherAppWS()
{
    NSURLConnection *_connection;
    NSMutableData   *_data;
    BOOL             _done;
    Error           *_error;
    NSMutableArray  *_apps;
    BOOL            _hasnext;
    
    int _offset,_limit;
}

- (void)parseData;
- (void)CallWSSuccess;
- (void)CallWSFail;

- (void) getAppsInNewThread;

@end

@implementation OtherAppWS

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _error.error_id = 1;
    _error.error_msg = error.localizedDescription;
    [self performSelectorOnMainThread:@selector(CallWSFail)
                           withObject:nil
                        waitUntilDone:YES];
    _done = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self parseData];
}

#pragma mark - Private method

- (void)parseData{
    NSString *tempStr = [[NSString alloc] initWithBytes: [_data mutableBytes]
                                                 length:[_data length]
                                               encoding:NSUTF8StringEncoding];
    //NSString *newString = [tempStr stringByReplacingOccurrencesOfString:@",}" withString:@"}" options:0 range:NSMakeRange(_data.length - 3, 3)];
    
    NSString *newString = [tempStr stringByReplacingOccurrencesOfString:@",}" withString:@"}"];
    NSMutableDictionary *dic = [newString JSONValue];
    
    //    NSLog(@"Data JSON: %@",dic);
    
    if (dic) {
        
        NSMutableDictionary *resultDic = [dic objectForKey:@"Result"];
        
        if ([[resultDic objectForKey:@"hasNext"] isEqual:@"true"]) {
            _hasnext = YES;
        } else {
            _hasnext = NO;
        }
        
        NSArray *listApp = [resultDic objectForKey:@"list"];
        for (NSDictionary *dicItem in listApp) {
            AppItem *item = [[AppItem alloc] init];
            
            item.adId       = [Common formatJSONValue:[dicItem objectForKey:@"adId"]];
            item.type       = [Common formatJSONValue:[dicItem objectForKey:@"type"]];
            item.createDate = [Common formatJSONValue:[dicItem objectForKey:@"createDate"]];
            item.appliName  = [Common formatJSONValue:[dicItem objectForKey:@"appliName"]];
            item.publisher  = [Common formatJSONValue:[dicItem objectForKey:@"publisher"]];
            item.scheme     = [Common formatJSONValue:[dicItem objectForKey:@"scheme"]];
            item.yen        = [Common formatJSONValue:[dicItem objectForKey:@"yen"]];
            item.url        = [Common formatJSONValue:[dicItem objectForKey:@"url"]];
            item.iconUrl    = [Common formatJSONValue:[dicItem objectForKey:@"iconUrl"]];
            item.siteOpen   = [Common formatJSONValue:[dicItem objectForKey:@"siteOpen"]];
            item.osusume    = [Common formatJSONValue:[dicItem objectForKey:@"osusume"]];
            
            [_apps addObject:item];
            
        }
        
    
        [self performSelectorOnMainThread:@selector(CallWSSuccess)
                               withObject:nil
                            waitUntilDone:YES];
        
    } else {
        _error.error_id = 1;
        _error.error_msg = @"jSON error";
        [self performSelectorOnMainThread:@selector(CallWSFail)
                               withObject:nil
                            waitUntilDone:YES];
    }
    
    _done = YES;
}

- (void)CallWSSuccess{
    if (_delegate && [_delegate respondsToSelector:@selector(didSuccessWithApps:hasnext:)]) {
        [_delegate didSuccessWithApps:_apps hasnext:_hasnext];
    }
}

- (void)CallWSFail{
    if (_delegate && [_delegate respondsToSelector:@selector(didFailWithError:)]) {
        [_delegate didFailWithError:_error];
    }
}

#pragma mark - Public method

- (void) getAppsWithOffset:(int)offset limit:(int)limit
{
    if (!_done) {
        _done = YES;
    }
    
    _offset = offset;
    _limit = limit;
    
    [NSThread detachNewThreadSelector:@selector(getAppsInNewThread)
                             toTarget:self
                           withObject:nil];
}

- (void) getAppsInNewThread
{
    @autoreleasepool {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        NSString *urlStr = [NSString stringWithFormat:URL_WS_OTHER_APP,_offset,_limit];
        NSLog(@"Get WS : %@",urlStr);
        
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        _apps   = [[NSMutableArray alloc] init];
        _data       = [NSMutableData data];
        _error      = [Error error];
        
        if (_connection) {
            _done = NO;
            do {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } while (!_done);
        }
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        _apps       = nil;
        _error      = nil;
        _connection = nil;
        _data       = nil;
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
    
    NSLog(@"GET OTHER APP DONE");
}

@end
