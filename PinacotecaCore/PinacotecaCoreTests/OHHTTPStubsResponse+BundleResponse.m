//
//  OHHTTPStubsResponse+BundleResponse.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "OHHTTPStubsResponse+BundleResponse.h"

@implementation OHHTTPStubsResponse (BundleResponse)

+ (OHHTTPStubsResponse*)responseNamed:(NSString *)responseName
                           fromBundle:(NSBundle *)responsesBundle
                         responseTime:(NSTimeInterval)responseTime
{
    if (responsesBundle == nil) {
        responsesBundle = [NSBundle mainBundle];
    }
    
    NSURL *responseURL = [responsesBundle URLForResource:responseName
                                           withExtension:@"response"];
    
    NSData *responseData = [NSData dataWithContentsOfURL:responseURL];
    
    if (responseData == nil) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Could not find HTTP response named '%@' in bundle '%@'",
                                               responseName, responsesBundle]
                                     userInfo:nil];
    }
    return [self responseWithRawResponse:responseData responseTime:responseTime];
}

+ (OHHTTPStubsResponse*)responseWithRawResponse:(NSData *)responseData
                                   responseTime:(NSTimeInterval)responseTime
{
    NSData *data = [NSData data];
    NSInteger statusCode = 200;
    NSDictionary *headers = @{};
    
    CFHTTPMessageRef httpMessage = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, FALSE);
    if (httpMessage) {
        CFHTTPMessageAppendBytes(httpMessage, [responseData bytes], [responseData length]);
        
        data = responseData; // By default
        
        if (CFHTTPMessageIsHeaderComplete(httpMessage)) {
            statusCode = (NSInteger)CFHTTPMessageGetResponseStatusCode(httpMessage);
            headers = (__bridge_transfer NSDictionary *)CFHTTPMessageCopyAllHeaderFields(httpMessage);
            data = (__bridge_transfer NSData *)CFHTTPMessageCopyBody(httpMessage);
        }
        CFRelease(httpMessage);
    }
    
    return [self responseWithData:data statusCode:(int)statusCode responseTime:responseTime headers:headers];
}

@end
