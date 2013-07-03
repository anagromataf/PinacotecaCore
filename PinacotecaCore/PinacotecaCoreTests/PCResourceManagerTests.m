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
    // Stub the Server API Method to fetch the image
    
    OCMockObject *serverMock = [OCMockObject partialMockForObject:self.resourceManager.server];
    
    id expector = [[serverMock expect] andCall:@selector(fetchImageWithId:queue:completionHandler:) onObject:self];
    [expector fetchImageWithId:OCMOCK_ANY queue:OCMOCK_ANY completionHandler:OCMOCK_ANY];
    
    // Get the image
    
    __block PCImage *image = [self.resourceManager imageWithId:@"123"
                                     usingManagedObjectContext:self.resourceManager.mainManagedObjectContext
                                                         queue:[NSOperationQueue mainQueue]
                                                 updateHandler:^(NSError *error) {
                                                     STAssertNil(error, [error localizedDescription]);
                                                     
                                                     STAssertEqualObjects(image.title, @"My first Image", nil);
                                                     STAssertEqualObjects(image.url, @"http://data.example.com/239f8z3z48g3.jpeg", nil);
                                                     
                                                     STAssertNoThrow([serverMock verify], nil);
                                                     
                                                     STSuccess();
                                                 }];
    STAssertNotNil(image, nil);
    STAssertEqualObjects(image.managedObjectContext, self.resourceManager.mainManagedObjectContext, nil);
    STAssertEqualObjects(image.imageId, @"123", nil);
    STAssertNil(image.title, nil);
    STAssertNil(image.url, nil);
    
    STFailAfter(2.0, @"Timeout");
}

#pragma mark -

- (void)fetchImageWithId:(NSString *)imageId
                   queue:(NSOperationQueue *)queue
       completionHandler:(void (^)(id JSONObject, NSError *error))handler
{
    STAssertEqualObjects(imageId, @"123", nil);
    
    NSDictionary *values = @{@"id":@"123",
                             @"title":@"My first Image",
                             @"url":@"http://data.example.com/239f8z3z48g3.jpeg"};
    
    [queue addOperationWithBlock:^{
        handler(values, nil);
    }];
}

@end
