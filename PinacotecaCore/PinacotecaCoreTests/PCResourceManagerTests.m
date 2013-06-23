//
//  PCResourceManagerTests.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import <SenTestingKitAsync/SenTestingKitAsync.h>
#import <OCMock/OCMock.h>

#import "PCResourceManager.h"
#import "PCResourceManager+Private.h"

@interface PCResourceManagerTests : SenTestCase
@property (nonatomic, strong) PCResourceManager *resourceManager;
@property (nonatomic, strong) OCMockObject *serverMock;
@end

@implementation PCResourceManagerTests

- (void)setUp
{
    [super setUp];
    self.resourceManager = [[PCResourceManager alloc] init];
}

#pragma mark Tests

- (void)testGetImageAsync
{
    NSDictionary *values = @{@"id":@"123",
                             @"title":@"My first Image",
                             @"url":@"http://data.example.com/239f8z3z48g3.jpeg"};
    
    // Stub the Server API Method to fetch the image
    
    self.serverMock = [OCMockObject partialMockForObject:self.resourceManager.server];
    [[[self.serverMock stub] andDo:^(NSInvocation *invocation) {
        
        __unsafe_unretained NSString *imageId = nil;
        [invocation getArgument:&imageId atIndex:2];
        STAssertEqualObjects(imageId, @"123", nil);
        
        __unsafe_unretained NSOperationQueue *queue = nil;
        [invocation getArgument:&queue atIndex:3];
        
        __unsafe_unretained void (^_handler)(id JSONObject, NSError *error);
        [invocation getArgument:&_handler atIndex:4];
        
        void (^handler)(id JSONObject, NSError *error) = _handler;
        
        [queue addOperationWithBlock:^{
            handler(values, nil);
        }];
        
    }] fetchImageWithId:OCMOCK_ANY queue:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    // Get the image
    
    __block PCImage *image = [self.resourceManager imageWithId:@"123"
                                     usingManagedObjectContext:self.resourceManager.mainManagedObjectContext
                                                         queue:[NSOperationQueue mainQueue]
                                                 updateHandler:^(BOOL updated, NSError *error) {
                                                     STAssertNil(error, [error localizedDescription]);
                                                     STAssertTrue(updated, nil);
                                                     
                                                     STAssertEqualObjects(image.title, @"My first Image", nil);
                                                     STAssertEqualObjects(image.url, @"http://data.example.com/239f8z3z48g3.jpeg", nil);
                                                     
                                                     STSuccess();
                                                 }];
    STAssertNotNil(image, nil);
    STAssertEqualObjects(image.managedObjectContext, self.resourceManager.mainManagedObjectContext, nil);
    STAssertEqualObjects(image.imageId, @"123", nil);
    STAssertNil(image.title, nil);
    STAssertNil(image.url, nil);
    
    STFailAfter(2.0, @"Timeout");
}

@end
