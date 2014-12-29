//
//  ViewController.m
//  CoreDataTest
//

#import "ViewController.h"
#import "Report.h"
#import "Document.h"

@interface ViewController ()<NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *reportFetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *documentFetchedResultsController;
@property (weak, nonatomic) IBOutlet UITextView *reportLabel;
@property (weak, nonatomic) IBOutlet UITextView *documentLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.reportFetchedResultsController = [Report MR_fetchAllSortedBy:@"timestamp"
                                                      ascending:NO
                                                  withPredicate:[NSPredicate predicateWithFormat:@"remoteId != nil"]
                                                        groupBy:nil
                                                       delegate:self
                                                      inContext:[NSManagedObjectContext MR_defaultContext]];
    
    self.documentFetchedResultsController = [Document MR_fetchAllSortedBy:@"timestamp"
                                                            ascending:NO
                                                        withPredicate:[NSPredicate predicateWithFormat:@"remoteId != nil"]
                                                              groupBy:nil
                                                             delegate:self
                                                            inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id) anObject atIndexPath:(NSIndexPath *) indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *) newIndexPath {
    
    if ([anObject isKindOfClass:[Report class]]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                self.reportLabel.textColor = [UIColor greenColor];
                self.reportLabel.text = @"Report has been sent to the server";
        }
    } else if ([anObject isKindOfClass:[Document class]]) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                self.documentLabel.textColor = [UIColor greenColor];
                self.documentLabel.text = @"Document has been sent to the server";
        }
    }
}


- (IBAction) saveToCoreData:(UIButton *)sender {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    Report *report = [Report MR_createInContext:context];
    report.dirty = [NSNumber numberWithBool:YES];
    report.timestamp = [NSDate date];
    
    Document *document = [Document MR_createInContext:context];
    document.dirty = [NSNumber numberWithBool:YES];
    document.timestamp = [NSDate date];
    document.report = report;
    
    [report addDocumentsObject:document];
    
    NSLog(@"Saving.................................");
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Saved report and document to PS");
    }];
}

@end
