//
//  Report.h
//  CoreDataTest
//
//  Created by William Newman on 12/23/14.
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Document;

@interface Report : NSManagedObject

@property (nonatomic, retain) NSNumber * dirty;
@property (nonatomic, retain) NSString * remoteId;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSSet *documents;
@end

@interface Report (CoreDataGeneratedAccessors)

- (void)addDocumentsObject:(Document *)value;
- (void)removeDocumentsObject:(Document *)value;
- (void)addDocuments:(NSSet *)values;
- (void)removeDocuments:(NSSet *)values;

@end
