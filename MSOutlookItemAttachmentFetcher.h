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



#ifndef MSOUTLOOKITEMATTACHMENTFETCHER_H
#define MSOUTLOOKITEMATTACHMENTFETCHER_H

#import "MSOutlookModels.h"
#import "api/api.h"
#import "core/core.h"
#import "core/MSOrcEntityFetcher.h"

@class MSOutlookItemFetcher;
@class MSOutlookItemFetcher;
@class MSOutlookItemAttachmentOperations;


/** MSOutlookItemAttachmentFetcher
 *
 */
@interface MSOutlookItemAttachmentFetcher : MSOrcEntityFetcher

@property (copy, nonatomic, readonly) MSOutlookItemAttachmentOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)readWithCallback:(void (^)(MSOutlookItemAttachment *, MSOrcError *))callback;
- (void)update:(MSOutlookItemAttachment *)ItemAttachment callback:(void (^)(MSOutlookItemAttachment *, MSOrcError*))callback ;
- (void)delete:(void(^)(int status, MSOrcError *))callback;
- (MSOutlookItemAttachmentFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookItemAttachmentFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSOutlookItemAttachmentFetcher *)select:(NSString *)params;
- (MSOutlookItemAttachmentFetcher *)expand:(NSString *)value;

@property (strong, nonatomic, readonly, getter=item) MSOutlookItemFetcher *item;

@end

#endif
