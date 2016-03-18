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


#ifndef MSOUTLOOKMESSAGE_H
#define MSOUTLOOKMESSAGE_H

#import <Foundation/Foundation.h>
#import "core/MSOrcChangesTrackingArray.h"

@class MSOutlookItemBody;
@class MSOutlookRecipient;
@class MSOutlookAttachment;
#import "MSOutlookImportance.h"
#import "MSOutlookItem.h"
#import "api/MSOrcInteroperableWithDictionary.h"

/** Interface MSOutlookMessage
 *
 */
@interface MSOutlookMessage : MSOutlookItem <MSOrcInteroperableWithDictionary>

/** Property receivedDateTime
 *
 */
@property (nonatomic,  copy, setter=setReceivedDateTime:, getter=receivedDateTime) NSDate * receivedDateTime;

/** Property sentDateTime
 *
 */
@property (nonatomic,  copy, setter=setSentDateTime:, getter=sentDateTime) NSDate * sentDateTime;

/** Property hasAttachments
 *
 */
@property (nonatomic,  setter=setHasAttachments:, getter=hasAttachments) bool hasAttachments;

/** Property subject
 *
 */
@property (nonatomic,  copy, setter=setSubject:, getter=subject) NSString * subject;

/** Property body
 *
 */
@property (nonatomic,  copy, setter=setBody:, getter=body) MSOutlookItemBody * body;

/** Property bodyPreview
 *
 */
@property (nonatomic,  copy, setter=setBodyPreview:, getter=bodyPreview) NSString * bodyPreview;

/** Property importance
 *
 */
@property (nonatomic,  setter=setImportance:, getter=importance) MSOutlookImportance importance;

- (void)setImportanceString:(NSString *)string;

/** Property parentFolderId
 *
 */
@property (nonatomic,  copy, setter=setParentFolderId:, getter=parentFolderId) NSString * parentFolderId;

/** Property sender
 *
 */
@property (nonatomic,  copy, setter=setSender:, getter=sender) MSOutlookRecipient * sender;

/** Property from
 *
 */
@property (nonatomic,  copy, setter=setFrom:, getter=from) MSOutlookRecipient * from;

/** Property toRecipients
 *
 */
@property (nonatomic,  copy, setter=setToRecipients:, getter=toRecipients) NSMutableArray * toRecipients;

/** Property ccRecipients
 *
 */
@property (nonatomic,  copy, setter=setCcRecipients:, getter=ccRecipients) NSMutableArray * ccRecipients;

/** Property bccRecipients
 *
 */
@property (nonatomic,  copy, setter=setBccRecipients:, getter=bccRecipients) NSMutableArray * bccRecipients;

/** Property replyTo
 *
 */
@property (nonatomic,  copy, setter=setReplyTo:, getter=replyTo) NSMutableArray * replyTo;

/** Property conversationId
 *
 */
@property (nonatomic,  copy, setter=setConversationId:, getter=conversationId) NSString * conversationId;

/** Property uniqueBody
 *
 */
@property (nonatomic,  copy, setter=setUniqueBody:, getter=uniqueBody) MSOutlookItemBody * uniqueBody;

/** Property isDeliveryReceiptRequested
 *
 */
@property (nonatomic,  setter=setIsDeliveryReceiptRequested:, getter=isDeliveryReceiptRequested) bool isDeliveryReceiptRequested;

/** Property isReadReceiptRequested
 *
 */
@property (nonatomic,  setter=setIsReadReceiptRequested:, getter=isReadReceiptRequested) bool isReadReceiptRequested;

/** Property isRead
 *
 */
@property (nonatomic,  setter=setIsRead:, getter=isRead) bool isRead;

/** Property isDraft
 *
 */
@property (nonatomic,  setter=setIsDraft:, getter=isDraft) bool isDraft;

/** Property webLink
 *
 */
@property (nonatomic,  copy, setter=setWebLink:, getter=webLink) NSString * webLink;

/** Property attachments
 *
 */
@property (nonatomic,  copy, setter=setAttachments:, getter=attachments) NSMutableArray * attachments;


+ (NSDictionary *) $$$_$$$propertiesNamesMappings;


@end

#endif
