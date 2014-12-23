//
//  ViewController.m
//  CoreDataTest
//

#import "ViewController.h"
#import "Report.h"
#import "Document.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
