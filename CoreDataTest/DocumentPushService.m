//
//  DocumentPushService.m
//  CoreDataTest
//

#import "DocumentPushService.h"
#import "Document.h"
#import <AFNetworking/AFNetworking.h>

@interface DocumentPushService () <NSFetchedResultsControllerDelegate>
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation DocumentPushService

- (id) initWithManagedObjectContext:(NSManagedObjectContext *) managedObjectContext {
    if (self = [super init]) {
        _managedObjectContext = managedObjectContext;
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
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://echo.jsontest.com/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        document.remoteId = @"12345"; // fake id from server
        document.dirty = [NSNumber numberWithBool:NO];
        
        [weakSelf.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Saved server info to Document");
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
