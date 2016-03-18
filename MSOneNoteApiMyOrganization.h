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


#ifndef MSONENOTEAPIMYORGANIZATION_H
#define MSONENOTEAPIMYORGANIZATION_H

#import <Foundation/Foundation.h>
#import "core/MSOrcChangesTrackingArray.h"

@class MSOneNoteApiSiteCollection;
@class MSOneNoteApiGroup;
#import "core/MSOrcBaseEntity.h"
#import "api/MSOrcInteroperableWithDictionary.h"

/** Interface MSOneNoteApiMyOrganization
 *
 */
@interface MSOneNoteApiMyOrganization : MSOrcBaseEntity <MSOrcInteroperableWithDictionary>

/** Property _id
 *
 */
@property (nonatomic,  copy, setter=setId:, getter=_id) NSString * _id;

/** Property siteCollections
 *
 */
@property (nonatomic,  copy, setter=setSiteCollections:, getter=siteCollections) NSMutableArray * siteCollections;

/** Property groups
 *
 */
@property (nonatomic,  copy, setter=setGroups:, getter=groups) NSMutableArray * groups;


+ (NSDictionary *) $$$_$$$propertiesNamesMappings;


@end

#endif
