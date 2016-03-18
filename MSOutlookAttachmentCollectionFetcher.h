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


#ifndef MSOUTLOOKATTACHMENTCOLLECTIONFETCHER_H
#define MSOUTLOOKATTACHMENTCOLLECTIONFETCHER_H

@class MSOutlookAttachmentFetcher;

#import "core/MSOrcCollectionFetcher.h"
#import "api/api.h"
#import "core/core.h"
#import "MSOutlookModels.h"

/** MSOutlookAttachmentCollectionFetcher
 *
 */
@interface MSOutlookAttachmentCollectionFetcher : MSOrcCollectionFetcher

- (instancetype)initWithUrl:(NSString *)urlComponent parent:(id<MSOrcExecutable>)parent;

- (void)readWithCallback:(void (^)(NSArray *, MSOrcError *))callback;

- (MSOutlookAttachmentFetcher *)getById: (id) identifier;
- (void)add:(MSOutlookAttachment *)entity callback:(void (^)(MSOutlookAttachment *, MSOrcError *))callback;

- (MSOutlookAttachmentCollectionFetcher *)select:(NSString *)params;
- (MSOutlookAttachmentCollectionFetcher *)filter:(NSString *)params;
- (MSOutlookAttachmentCollectionFetcher *)search:(NSString *)params;
- (MSOutlookAttachmentCollectionFetcher *)top:(int)value;
- (MSOutlookAttachmentCollectionFetcher *)skip:(int)value;
- (MSOutlookAttachmentCollectionFetcher *)expand:(NSString *)value;
- (MSOutlookAttachmentCollectionFetcher *)orderBy:(NSString *)params;
- (MSOutlookAttachmentCollectionFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookAttachmentCollectionFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;

@end

#endif
