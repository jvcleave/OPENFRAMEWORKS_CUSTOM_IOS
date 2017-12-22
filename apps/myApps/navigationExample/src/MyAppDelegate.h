#import <UIKit/UIKit.h>

#import "ofMain.h"
#import "SquareApp.h"


@interface MyAppDelegate : NSObject <UIApplicationDelegate> 


@property( strong, nonatomic) UIWindow* window;
@property (strong, nonatomic)  UINavigationController* navigationController;
@property (strong, nonatomic)UIStoryboard* storyboard;

@end
