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


#ifndef MSOUTLOOKRECURRENCERANGETYPE_H
#define MSOUTLOOKRECURRENCERANGETYPE_H

#import <Foundation/Foundation.h>

/** Enum MSOutlookRecurrenceRangeTypeEnum
 *
 */
typedef NS_ENUM(NSInteger, MSOutlookRecurrenceRangeType) {

    /** Enum entry MSOutlookRecurrenceRangeTypeEndDate
     * */
    MSOutlookRecurrenceRangeTypeEndDate,
    /** Enum entry MSOutlookRecurrenceRangeTypeNoEnd
     * */
    MSOutlookRecurrenceRangeTypeNoEnd,
    /** Enum entry MSOutlookRecurrenceRangeTypeNumbered
     * */
    MSOutlookRecurrenceRangeTypeNumbered
};


@interface MSOutlookRecurrenceRangeTypeSerializer : NSObject
+(MSOutlookRecurrenceRangeType) fromString:(NSString *) string;
+(NSString *) toString: (MSOutlookRecurrenceRangeType) value;
@end

#endif