// MMRecordOrphanDeleter.h
//
// Copyright (c) 2015 Mutual Mobile (http://www.mutualmobile.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

#import "MMRecord.h"

/**
 This class encapsulates MMRecord's orphan-deletion logic, and is designed to be mostly decoupled
 from the rest of the library. It acts by looking at the @c deleteOrphanedRecordBlock that is
 (optionally) part of the @c MMRecordOptions that are passed into this class's one public method.
 Default behavior (if the @c deleteOrphanedRecordBlock is nil) is to not delete orphans.
 */
@interface MMRecordOrphanDeleter : NSObject

/**
 Conditionally deletes any records with the specified @c entityName that were orphaned by the 
 specified @c responseObject.
 
 @param entityName The name of the entity in question
 @param responseObject The full response object that came back from the server request to get the
 updated records. Optional.
 @param populatedRecords The records that have been populated with the contents of @c responseObject.
 @param deleteRule A @c MMRecordOptionsDeleteOrphanedRecordBlock that encapsulates your logic for whether to delete an orphan. Return YES for "delete", and NO for "don't delete". Optional; defaults to NO.
 @param context The @c NSManagedObjectContext you are working in.
 
 @pre @c responseObject has already been imported (sans the orphan deletion) into @c context, and the results of that import are in the @c populatedRecords array.
 */
+ (void)conditionallyDeleteRecordsWithEntityName:(NSString *)entityName
                              orphanedByResponse:(id)responseObject
                                populatedRecords:(NSArray *)populatedRecords
                                      deleteRule:(MMRecordOptionsDeleteOrphanedRecordBlock)deleteRule
                                         context:(NSManagedObjectContext *)context;

@end
