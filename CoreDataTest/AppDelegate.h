//
//  AppDelegate.h
//  CoreDataTest
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ReportPushService.h"
#import "DocumentPushService.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ReportPushService *reportPushService;
@property (strong, nonatomic) DocumentPushService *documentPushService;
@end

