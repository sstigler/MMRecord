// MMRecordOrphanDeleter.m
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

#import "MMRecordOrphanDeleter.h"

@implementation MMRecordOrphanDeleter

+ (void)conditionallyDeleteRecordsWithEntityName:(NSString *)entityName
                              orphanedByResponse:(id)responseObject
                                populatedRecords:(NSArray *)populatedRecords
                                      deleteRule:(MMRecordOptionsDeleteOrphanedRecordBlock)deleteRule
                                         context:(NSManagedObjectContext *)context {
    
    NSParameterAssert(entityName != nil);
    NSParameterAssert(context != nil);
    
    if (deleteRule != nil) {
        NSArray *orphanedRecords = [self orphanedRecordsFromContext:context populatedRecords:populatedRecords entityName: entityName];
        
        BOOL stop = NO;
        
        for (MMRecord *orphanedRecord in orphanedRecords) {
            BOOL deleteOrphan = deleteRule(orphanedRecord, populatedRecords, responseObject, &stop);
            
            if (deleteOrphan) {
                [context deleteObject:orphanedRecord];
            }
            
            if (stop) {
                break;
            }
        }
    }
}

+ (NSArray *)orphanedRecordsFromContext:(NSManagedObjectContext *)context
                       populatedRecords:(NSArray *)populatedRecords
                             entityName:(NSString *)entityName  {
    NSMutableArray *populatedObjectIDs = [NSMutableArray array];
    NSMutableSet *orphanedObjectIDs = [NSMutableSet set];
    
    for (MMRecord *record in populatedRecords) {
        [populatedObjectIDs addObject:[record objectID]];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.fetchBatchSize = 20;
    
    NSArray *allRecords = [context executeFetchRequest:fetchRequest error:NULL];
    
    for (MMRecord *record in allRecords) {
        [orphanedObjectIDs addObject:[record objectID]];
    }
    
    for (NSManagedObjectID *objectID in populatedObjectIDs) {
        [orphanedObjectIDs removeObject:objectID];
    }
    
    NSMutableArray *orphanedRecords = [NSMutableArray array];
    
    for (NSManagedObjectID *orphanedObjectID in orphanedObjectIDs) {
        [orphanedRecords addObject:[context objectWithID:orphanedObjectID]];
    }
    
    return orphanedRecords;
}

@end
