//
//  PCServerAPIControllerTests.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <SenTestingKitAsync/SenTestingKitAsync.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

#import "PCServerAPIController.h"

@interface PCServerAPIControllerTests : SenTestCase
@property (nonatomic, strong) PCServerAPIController *server;
@end

@implementation PCServerAPIControllerTests

- (void)setUp
{
    [super setUp];
    self.server = [[PCServerAPIController alloc] init];
}

- (void)tearDown
{
    [OHHTTPStubs removeAllRequestHandlers];
    [super tearDown];
}

#pragma mark Tests

- (void)testFetchImageAsync
{
    // Stub HTTP Requests
    // ------------------
    
    NSURL *responsesBundleURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"ServerAPIResponses" withExtension:@"bundle"];
    NSBundle *responsesBundle = [NSBundle bundleWithURL:responsesBundleURL];
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return ([request.HTTPMethod isEqualToString:@"GET"] &&
                [request.URL.absoluteString isEqualToString:@"http://api.example.com/v1/images/123"]);
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseNamed:@"images/123"
                                       fromBundle:responsesBundle
                                     responseTime:0.1];
    }];
    
    // Fetch Image
    // -----------
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [self.server fetchImageWithId:@"123"
                            queue:queue
                completionHandler:^(id imageData, NSError *error) {
                    STAssertEqualObjects([NSOperationQueue currentQueue], queue, nil);
                    
                    STAssertNil(error, [error localizedDescription]);
                    
                    STAssertTrue([imageData isKindOfClass:[NSDictionary class]], nil);
                    
                    STAssertEqualObjects(imageData[@"id"],     @"123", nil);
                    STAssertEqualObjects(imageData[@"title"],  @"My first Image", nil);
                    STAssertEqualObjects(imageData[@"url"],    @"http://data.example.com/239f8z3z48g3.jpeg", nil);
                    
                    STSuccess();
                }];
    
    STFailAfter(2.0, nil);
}

@end
