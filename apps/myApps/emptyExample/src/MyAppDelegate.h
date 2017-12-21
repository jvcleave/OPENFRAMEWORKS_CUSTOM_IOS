#import <UIKit/UIKit.h>

#import "AppNavigationController.h"
#import "ofMain.h"
#import "SquareApp.h"

#import "ofAppViewController.h"

@interface MyAppDelegate : NSObject <UIApplicationDelegate> 


@property( strong, nonatomic) UIWindow* window;
@property (strong, nonatomic)  AppNavigationController* navigationController;
@property (strong, nonatomic)UIStoryboard* storyboard;

@end
