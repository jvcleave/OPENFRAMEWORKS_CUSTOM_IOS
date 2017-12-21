#pragma once

#import <UIKit/UIKit.h>

#include "ofMain.h"
#import "ofAppiOSWindow.h"
#import "ES1Renderer.h"
#include "SquareApp.h"

@interface CAEAGLLayerView : UIView

@end


@interface ofAppViewController : UIViewController
{
    SquareApp* app;
    ofAppiOSWindow * window;
    ESRendererVersion rendererVersion;
    CGFloat scaleFactor;
    CGFloat scaleFactorPref;
}
@property (strong, nonatomic) IBOutlet CAEAGLLayerView *glLayerView;
@property (strong, nonatomic) ES1Renderer* renderer;
@property (strong, nonatomic) NSLock * glLock;
@property (strong, nonatomic) NSTimer* animationTimer;

@end
