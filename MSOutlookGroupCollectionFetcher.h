/*******************************************************************************
**NOTE** This code was generated by a tool and will occasionally be
overwritten. We welcome comments and issues regarding this code; they will be
addressed in the generation tool. If you wish to submit pull requests, please
do so for the templates in that tool.

This code was generated by Vipr (https://github.com/microsoft/vipr) using
the T4TemplateWriter (https://github.com/msopentech/vipr-t4templatewriter).

Copyright (c) Microsoft Corporation. All Rights Reserved.
Licensed under the Apache License 2.0; see LICENSE in the source repository
root for authoritative license information.﻿
******************************************************************************/


#ifndef MSOUTLOOKGROUPCOLLECTIONFETCHER_H
#define MSOUTLOOKGROUPCOLLECTIONFETCHER_H

@class MSOutlookGroupFetcher;

#import "core/MSOrcCollectionFetcher.h"
#import "api/api.h"
#import "core/core.h"
#import "MSOutlookModels.h"

/** MSOutlookGroupCollectionFetcher
 *
 */
@interface MSOutlookGroupCollectionFetcher : MSOrcCollectionFetcher

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;

- (void)readWithCallback:(void (^)(NSArray *, MSOrcError *))callback;

- (MSOutlookGroupFetcher *)getById: (id) identifier;
- (void)add:(MSOutlookGroup *)entity callback:(void (^)(MSOutlookGroup *, MSOrcError *))callback;

- (MSOutlookGroupCollectionFetcher *)select:(NSString *)params;
- (MSOutlookGroupCollectionFetcher *)filter:(NSString *)params;
- (MSOutlookGroupCollectionFetcher *)search:(NSString *)params;
- (MSOutlookGroupCollectionFetcher *)top:(int)value;
- (MSOutlookGroupCollectionFetcher *)skip:(int)value;
- (MSOutlookGroupCollectionFetcher *)expand:(NSString *)value;
- (MSOutlookGroupCollectionFetcher *)orderBy:(NSString *)params;
- (MSOutlookGroupCollectionFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookGroupCollectionFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@end

#endif