//
//  ReportPushService.m
//  CoreDataTest
//

#import "ReportPushService.h"
#import "Report.h"

@interface ReportPushService () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation ReportPushService

- (id) init {
    if (self = [super init]) {
        self.managedObjectContext = [NSManagedObjectContext MR_context];
        [self.managedObjectContext MR_setWorkingName:@"ReportPushService MOC"];
        [self.managedObjectContext MR_observeContext:[NSManagedObjectContext MR_defaultContext]];
        
        self.fetchedResultsController = [Report MR_fetchAllSortedBy:@"timestamp"
                                                               ascending:NO
                                                           withPredicate:[NSPredicate predicateWithFormat:@"dirty == YES"]
                                                                 groupBy:nil
                                                                delegate:self
                                                               inContext:self.managedObjectContext];
    }
    
    return self;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id) anObject atIndexPath:(NSIndexPath *) indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *) newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            NSLog(@"report inserted");
            [self pushReport:anObject];
            break;
        }
        case NSFetchedResultsChangeDelete:
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"report updated");
            [self pushReport:anObject];
            break;
        case NSFetchedResultsChangeMove:
            break;
    }
}


- (void) pushReport:(Report *) report {
    __weak ReportPushService *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:.5];  // simulate server
        report.remoteId = @"12345";
        report.dirty = [NSNumber numberWithBool:NO];
        
        [weakSelf.managedObjectContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            NSLog(@"Saved server info to Report");
        }];
    });
}

@end
