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


#ifndef MSOUTLOOKITEMCOLLECTIONFETCHER_H
#define MSOUTLOOKITEMCOLLECTIONFETCHER_H

@class MSOutlookItemFetcher;

#import "core/MSOrcCollectionFetcher.h"
#import "api/api.h"
#import "core/core.h"
#import "MSOutlookModels.h"

/** MSOutlookItemCollectionFetcher
 *
 */
@interface MSOutlookItemCollectionFetcher : MSOrcCollectionFetcher

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;

- (void)readWithCallback:(void (^)(NSArray *, MSOrcError *))callback;

- (MSOutlookItemFetcher *)getById: (id) identifier;
- (void)add:(MSOutlookItem *)entity callback:(void (^)(MSOutlookItem *, MSOrcError *))callback;

- (MSOutlookItemCollectionFetcher *)select:(NSString *)params;
- (MSOutlookItemCollectionFetcher *)filter:(NSString *)params;
- (MSOutlookItemCollectionFetcher *)search:(NSString *)params;
- (MSOutlookItemCollectionFetcher *)top:(int)value;
- (MSOutlookItemCollectionFetcher *)skip:(int)value;
- (MSOutlookItemCollectionFetcher *)expand:(NSString *)value;
- (MSOutlookItemCollectionFetcher *)orderBy:(NSString *)params;
- (MSOutlookItemCollectionFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookItemCollectionFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@end

#endif