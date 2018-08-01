//
//  MyAppDelegate.m
//  Created by lukasz karluk on 12/12/11.
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:bounds];
    [self.window makeKeyAndVisible];

    ofSetDataPathRoot([[NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] resourcePath]] cStringUsingEncoding:NSUTF8StringEncoding]);

    
    self.storyboard = [UIStoryboard storyboardWithName:@"MainInterface" bundle:nil];
    self.navigationController = (AppNavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"AppNavigationController"];
    [self.window setRootViewController:self.navigationController];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.topItem.title = @"Home";
    ofAppViewController* appViewController = (ofAppViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ofAppViewController"];
    
    //[self.navigationController pushViewController:appViewController animated:NO];
    
    [self.navigationController presentViewController:appViewController animated:NO completion:nil];
                                                    
    
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
