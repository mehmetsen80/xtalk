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


#ifndef MSOUTLOOKATTENDEETYPE_H
#define MSOUTLOOKATTENDEETYPE_H

#import <Foundation/Foundation.h>

/** Enum MSOutlookAttendeeTypeEnum
 *
 */
typedef NS_ENUM(NSInteger, MSOutlookAttendeeType) {

    /** Enum entry MSOutlookAttendeeTypeRequired
     * */
    MSOutlookAttendeeTypeRequired,
    /** Enum entry MSOutlookAttendeeTypeOptional
     * */
    MSOutlookAttendeeTypeOptional,
    /** Enum entry MSOutlookAttendeeTypeResource
     * */
    MSOutlookAttendeeTypeResource
};


@interface MSOutlookAttendeeTypeSerializer : NSObject
+(MSOutlookAttendeeType) fromString:(NSString *) string;
+(NSString *) toString: (MSOutlookAttendeeType) value;
@end

#endif
