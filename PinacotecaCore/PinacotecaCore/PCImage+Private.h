//
//  PCImage+Private.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCImage.h"

@interface PCImage (Private)

+ (NSEntityDescription *)entityDescriptionInManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)createOrUpdateWithValues:(NSDictionary *)values
                  inManagedObjectContext:(NSManagedObjectContext *)context
                                 created:(BOOL *)created
                                   error:(NSError **)error;

+ (instancetype)imageWithId:(NSString *)imageId
     inManagedObjectContext:(NSManagedObjectContext *)context
                      error:(NSError **)error;

@property (nonatomic, readwrite, strong) NSString *imageId;
@property (nonatomic, readwrite, strong) NSString *title;
@property (nonatomic, readwrite, strong) NSString *url;

@end
