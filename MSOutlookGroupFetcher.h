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



#ifndef MSOUTLOOKGROUPFETCHER_H
#define MSOUTLOOKGROUPFETCHER_H

#import "MSOutlookModels.h"
#import "api/api.h"
#import "core/core.h"
#import "core/MSOrcEntityFetcher.h"

@class MSOutlookConversationThreadCollectionFetcher;
@class MSOutlookCalendarFetcher;
@class MSOutlookEventCollectionFetcher;
@class MSOutlookConversationCollectionFetcher;
@class MSOutlookSubscriptionCollectionFetcher;
@class MSOutlookPhotoFetcher;
@class MSOutlookDirectoryObjectCollectionFetcher;
@class MSOutlookConversationThreadCollectionFetcher;
@class MSOutlookCalendarFetcher;
@class MSOutlookEventCollectionFetcher;
@class MSOutlookConversationCollectionFetcher;
@class MSOutlookSubscriptionCollectionFetcher;
@class MSOutlookPhotoFetcher;
@class MSOutlookDirectoryObjectCollectionFetcher;
@class MSOutlookConversationThreadFetcher;
@class MSOutlookEventFetcher;
@class MSOutlookConversationFetcher;
@class MSOutlookSubscriptionFetcher;
@class MSOutlookDirectoryObjectFetcher;
@class MSOutlookGroupOperations;


/** MSOutlookGroupFetcher
 *
 */
@interface MSOutlookGroupFetcher : MSOrcEntityFetcher

@property (copy, nonatomic, readonly) MSOutlookGroupOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)readWithCallback:(void (^)(MSOutlookGroup *, MSOrcError *))callback;
- (void)update:(MSOutlookGroup *)Group callback:(void (^)(MSOutlookGroup *, MSOrcError*))callback ;
- (void)delete:(void(^)(int status, MSOrcError *))callback;
- (MSOutlookGroupFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOutlookGroupFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSOutlookGroupFetcher *)select:(NSString *)params;
- (MSOutlookGroupFetcher *)expand:(NSString *)value;
@property (strong, nonatomic, readonly, getter=threads) MSOutlookConversationThreadCollectionFetcher *threads;

- (MSOutlookConversationThreadFetcher *)threadsById:(id)identifier;


@property (strong, nonatomic, readonly, getter=calendar) MSOutlookCalendarFetcher *calendar;
@property (strong, nonatomic, readonly, getter=calendarView) MSOutlookEventCollectionFetcher *calendarView;

- (MSOutlookEventFetcher *)calendarViewById:(id)identifier;

@property (strong, nonatomic, readonly, getter=events) MSOutlookEventCollectionFetcher *events;

- (MSOutlookEventFetcher *)eventsById:(id)identifier;

@property (strong, nonatomic, readonly, getter=conversations) MSOutlookConversationCollectionFetcher *conversations;

- (MSOutlookConversationFetcher *)conversationsById:(id)identifier;

@property (strong, nonatomic, readonly, getter=subscriptions) MSOutlookSubscriptionCollectionFetcher *subscriptions;

- (MSOutlookSubscriptionFetcher *)subscriptionsById:(id)identifier;


@property (strong, nonatomic, readonly, getter=photo) MSOutlookPhotoFetcher *photo;
@property (strong, nonatomic, readonly, getter=acceptedSenders) MSOutlookDirectoryObjectCollectionFetcher *acceptedSenders;

- (MSOutlookDirectoryObjectFetcher *)acceptedSendersById:(id)identifier;

@property (strong, nonatomic, readonly, getter=rejectedSenders) MSOutlookDirectoryObjectCollectionFetcher *rejectedSenders;

- (MSOutlookDirectoryObjectFetcher *)rejectedSendersById:(id)identifier;


@end

#endif
