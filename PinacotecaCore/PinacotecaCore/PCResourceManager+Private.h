//
//  PCResourceManager+Private.h
//  PinacotecaCore
//
//  Created by Tobias Kräntzer on 23.06.13.
//  Copyright (c) 2013 Tobias Kräntzer. All rights reserved.
//

#import "PCResourceManager.h"

#import "PCServerAPIController.h"

@interface PCResourceManager (Private)

@property (nonatomic, readonly) PCServerAPIController *server;

@end
