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



#ifndef MSOUTLOOKEVENTMESSAGEFETCHER_H
#define MSOUTLOOKEVENTMESSAGEFETCHER_H

#import "MSOutlookModels.h"
#import "api/api.h"
#import "core/core.h"
#import "core/MSOrcEntityFetcher.h"

@class MSOutlookEventFetcher;
@class MSOutlookEventFetcher;
@class MSOutlookEventMessageOperations;


/** MSOutlookEventMessageFetcher
 *
 */
@interface MSOutlookEventMessageFetcher : MSOrcEntityFetcher

@property (copy, nonatomic, readonly) MSOutlookEventMessageOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)readWithCallback:(void (^)(MSOutlookEventMessage *, MSOrcError *))callback;
- (void)update:(MSOutlookEventMessage *)EventMessage callback:(void (^)(MSOutlookEventMessage *, MSOrcError*))callback ;
- (void)delete:(void(^)(int status, MSOrcError *))callback;
- (MSOutlookEventMessageFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookEventMessageFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSOutlookEventMessageFetcher *)select:(NSString *)params;
- (MSOutlookEventMessageFetcher *)expand:(NSString *)value;

@property (strong, nonatomic, readonly, getter=event) MSOutlookEventFetcher *event;

@end

#endif