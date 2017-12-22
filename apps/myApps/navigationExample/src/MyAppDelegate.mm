#import "MyAppDelegate.h"


@implementation MyAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    [self.window makeKeyAndVisible];

    ofSetDataPathRoot([[NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]] cStringUsingEncoding:NSUTF8StringEncoding]);

    
    self.storyboard = [UIStoryboard storyboardWithName:@"MainInterface" bundle:nil];
    self.navigationController = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MyNavigationController"];
    [self.window setRootViewController:self.navigationController];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
                                                    
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    //[super applicationWillResignActive:application];
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    //[super applicationDidEnterBackground:application];
    
}



- (void)applicationWillTerminate:(UIApplication *)application 
{
    //[super applicationWillTerminate:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    //[super applicationDidReceiveMemoryWarning:application];

}




@end
