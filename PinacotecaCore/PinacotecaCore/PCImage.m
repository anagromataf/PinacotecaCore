//
//  PCImage.m
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCImage.h"
#import "PCImage+Private.h"

@implementation PCImage

@dynamic imageId;
@dynamic title;
@dynamic url;

@end

#pragma mark -

@implementation PCImage (Private)

+ (instancetype)createOrUpdateWithValues:(NSDictionary *)values
                  inManagedObjectContext:(NSManagedObjectContext *)context
                                 created:(BOOL *)created
                                   error:(NSError **)error
{
    return nil;
}

@dynamic imageId;
@dynamic title;
@dynamic url;

@end
