#import "MyNavigationController.h"

@implementation MyNavigationController


-(void)viewDidLoad
{
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"ButtonSegue" sender:self];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"hi");
    
}



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

