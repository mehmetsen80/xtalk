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



#ifndef MSONENOTEAPIPAGEFETCHER_H
#define MSONENOTEAPIPAGEFETCHER_H

#import "MSOneNoteApiModels.h"
#import "api/api.h"
#import "core/core.h"
#import "core/MSOrcMediaEntityFetcher.h"

@class MSOneNoteApiPageLinksFetcher;
@class MSOneNoteApiSectionFetcher;
@class MSOneNoteApiNotebookFetcher;
@class MSOneNoteApiSectionFetcher;
@class MSOneNoteApiNotebookFetcher;
@class MSOneNoteApiPageOperations;


/** MSOneNoteApiPageFetcher
 *
 */
@interface MSOneNoteApiPageFetcher : MSOrcMediaEntityFetcher

@property (copy, nonatomic, readonly) MSOneNoteApiPageOperations *operations;

- (instancetype)initWithUrl:(NSString*)urlComponent parent:(id<MSOrcExecutable>)parent;
- (void)readWithCallback:(void (^)(MSOneNoteApiPage *, MSOrcError *))callback;
- (void)update:(MSOneNoteApiPage *)Page callback:(void (^)(MSOneNoteApiPage *, MSOrcError*))callback ;
- (void)delete:(void(^)(int status, MSOrcError *))callback;
- (MSOneNoteApiPageFetcher *)addCustomParametersWithName:(NSString *)name value:(id)value;
- (MSOneNoteApiPageFetcher *)addCustomHeaderWithName:(NSString *)name value:(NSString *)value;
- (MSOneNoteApiPageFetcher *)select:(NSString *)params;
- (MSOneNoteApiPageFetcher *)expand:(NSString *)value;
@property (strong, nonatomic, readonly, getter=content) MSOrcStreamFetcher *content;

@property (strong, nonatomic, readonly, getter=parentSection) MSOneNoteApiSectionFetcher *parentSection;

@property (strong, nonatomic, readonly, getter=parentNotebook) MSOneNoteApiNotebookFetcher *parentNotebook;

@end

#endif
