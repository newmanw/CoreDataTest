//
//  DocumentPushService.m
//  CoreDataTest
//

#import "DocumentPushService.h"
#import "Document.h"

@interface DocumentPushService () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DocumentPushService

- (id) init {
    if (self = [super init]) {
        self.managedObjectContext = [NSManagedObjectContext MR_context];
        [self.managedObjectContext MR_setWorkingName:@"ReportPushService MOC"];
        [self.managedObjectContext MR_observeContext:[NSManagedObjectContext MR_defaultContext]];
        
        self.fetchedResultsController = [Document MR_fetchAllSortedBy:@"timestamp"
                                                          ascending:NO
                                                      withPredicate:[NSPredicate predicateWithFormat:@"report.remoteId != nil && dirty == YES"]
                                                            groupBy:nil
                                                           delegate:self
                                                          inContext:self.managedObjectContext];
    }
    
    return self;
}


// This will not get fired.  Seems the predicate on parent entity attribute and attribute on myself screws it up.
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id) anObject atIndexPath:(NSIndexPath *) indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *) newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            NSLog(@"report inserted");
            [self pushDocument:anObject];
            break;
        }
        case NSFetchedResultsChangeDelete:
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"report updated");
            [self pushDocument:anObject];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}


- (void) pushDocument:(Document *) document {
    __weak DocumentPushService *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:.5];  // simulate server
        document.remoteId = @"6789";
        document.dirty = [NSNumber numberWithBool:NO];
        
        [weakSelf.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Saved server info to Document");
        }];
    });
}

@end
