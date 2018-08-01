//
//  CustomAppViewController.m
//  Created by lukasz karluk on 8/02/12.
//

#import "ofAppViewController.h"


@implementation CAEAGLLayerView

+ (Class) layerClass 
{
    return [CAEAGLLayer class];
}
@end

@implementation ofAppViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activeTouches = [[NSMutableDictionary alloc] init];

    NSLog(@"x: %f y: %f w: %f h: %f", 
          self.glLayerView.bounds.origin.x,
          self.glLayerView.bounds.origin.y,
          self.glLayerView.bounds.size.width,
          self.glLayerView.bounds.size.height);
    
    
    CAEAGLLayer * eaglLayer = (CAEAGLLayer *)self.glLayerView.layer;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    
    self.glLayerView.multipleTouchEnabled = true;
    self.glLayerView.opaque = YES;
    self.glLayerView.clipsToBounds = YES;   
    
    ofiOSWindowSettings settings;
    settings.enableRetina = false; // enables retina resolution if the device supports it.
    settings.enableDepth = false; // enables depth buffer for 3d drawing.
    settings.enableAntiAliasing = false; // enables anti-aliasing which smooths out graphics on the screen.
    settings.numOfAntiAliasingSamples = 0; // number of samples used for anti-aliasing.
    settings.enableHardwareOrientation = false; // enables native view orientation.
    settings.enableHardwareOrientationAnimation = false; // enables native orientation changes to be animated.
    settings.glesVersion = OFXIOS_RENDERER_ES1; // type of renderer to use, ES1, ES2, ES3
    settings.windowMode = OF_FULLSCREEN;
    
    self->window = (ofAppiOSWindow *)(ofCreateWindow(settings).get());
    
    rendererVersion = ESRendererVersion_11;
    self.renderer = [[ES1Renderer alloc] initWithDepth:settings.enableDepth 
                                            andAA:settings.enableAntiAliasing 
                                            andFSAASamples:settings.numOfAntiAliasingSamples 
                                             andRetina:settings.enableRetina];
    
    if(self->window->isProgrammableRenderer() == true) {
        static_cast<ofGLProgrammableRenderer*>(self->window->renderer().get())->setup(settings.glesVersion, 0);
    } else{
        static_cast<ofGLRenderer*>(self->window->renderer().get())->setup();
    }
}


- (void)drawView:(id)sender 
{
    self->window->events().notifyUpdate();
    
    
    [self.glLock lock];
    [self.renderer startRender];
    
    self->window->renderer()->startRender();
    
    if(self->window->isSetupScreenEnabled())
    {
        self->window->renderer()->setupScreen();
    }
    
    self->window->events().notifyDraw();
    
    self->window->renderer()->finishRender();
    
    [self.renderer finishRender];
    [self.glLock unlock];
}


-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self printDimensions];
    [self updateScaleFactor];
    
    [self.renderer startRender];
    [self.renderer resizeFromLayer:(CAEAGLLayer*)self.glLayerView.layer];
    [self.renderer finishRender];
    [self updateDimensions];
    

    
    


}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self printDimensions];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self->app = new ofApp();
    ofRunApp(app);
    
    
    
    ofxiOSAlerts.addListener(self->app);
    
    ofDisableTextureEdgeHack();
    
    self->window->events().notifySetup();
    //self->window->renderer()->clear();
    
    

    
    int animationFrameInterval = 1;
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) 
                                                           target:self 
                                                         selector:@selector(drawView:) 
                                                         userInfo:nil 
                                                          repeats:TRUE];
}

-(void)printFrame:(CGRect)rect label:(NSString*)comment
{   NSLog(@"%@ x: %f y: %f w: %f h: %f", 
          comment,
          rect.origin.x,
          rect.origin.y,
          rect.size.width,
          rect.size.height);
    
}
-(void)printDimensions
{
    [self printFrame:self.view.frame label:@"view.frame"];
    [self printFrame:self.glLayerView.frame label:@"glLayerView.frame"];
    [self printFrame:[[UIScreen mainScreen] bounds] label:@"currentScreen.bounds"];
}

- (void)updateScaleFactor 
{
    UIScreen * currentScreen = self.view.window.screen;
    if(currentScreen == nil) {
        currentScreen = [UIScreen mainScreen];
    }
    
    if([currentScreen respondsToSelector:@selector(scale)] == NO) {
        return;
    }
    
    scaleFactor = MIN(scaleFactorPref, [currentScreen scale]);
    if(!scaleFactor)
    {
        scaleFactor = 1;
    }
    if(scaleFactor != self.glLayerView.contentScaleFactor) 
    {
        self.glLayerView.contentScaleFactor = scaleFactor;
    }
}


- (void)updateDimensions 
{

    self->window->windowPos.set(self.glLayerView.frame.origin.x * scaleFactor, self.glLayerView.frame.origin.y * scaleFactor, 0);
    self->window->windowSize.set(self.glLayerView.bounds.size.width * scaleFactor, self.glLayerView.bounds.size.height * scaleFactor, 0);
    
    UIScreen * currentScreen = self.glLayerView.window.screen;  // current screen is the screen that GLView is attached to.
    if(!currentScreen) {                            // if GLView is not attached, assume to be main device screen.
        currentScreen = [UIScreen mainScreen];
    }
    self->window->screenSize.set(currentScreen.bounds.size.width * scaleFactor, currentScreen.bounds.size.height * scaleFactor, 0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    

    for(UITouch *touch in touches) {
        int touchIndex = 0;
        while([[self.activeTouches allValues] containsObject:[NSNumber numberWithInt:touchIndex]]){
            touchIndex++;
        }
        
        [self.activeTouches setObject:[NSNumber numberWithInt:touchIndex] forKey:[NSValue valueWithPointer:touch]];
        
        CGPoint touchPoint = [touch locationInView:self.glLayerView];
        
        touchPoint.x *= scaleFactor; // this has to be done because retina still returns points in 320x240 but with high percision
        touchPoint.y *= scaleFactor;
        //touchPoint = [self orientateTouchPoint:touchPoint];
        
        if( touchIndex==0 ){
            window->events().notifyMousePressed(touchPoint.x, touchPoint.y, 0);
        }
        
        ofTouchEventArgs touchArgs;
        touchArgs.numTouches = [[event touchesForView:self.glLayerView] count];
        touchArgs.x = touchPoint.x;
        touchArgs.y = touchPoint.y;
        touchArgs.id = touchIndex;
        if([touch tapCount] == 2){
            touchArgs.type = ofTouchEventArgs::doubleTap;
            ofNotifyEvent(window->events().touchDoubleTap,touchArgs);   // send doubletap
        }
        touchArgs.type = ofTouchEventArgs::down;
        ofNotifyEvent(window->events().touchDown,touchArgs);    // but also send tap (upto app programmer to ignore this if doubletap came that frame)
    }   
}

//------------------------------------------------------
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    for(UITouch *touch in touches){
        int touchIndex = [[self.activeTouches objectForKey:[NSValue valueWithPointer:touch]] intValue];
        
        CGPoint touchPoint = [touch locationInView:self.glLayerView];
        
        touchPoint.x *= scaleFactor; // this has to be done because retina still returns points in 320x240 but with high percision
        touchPoint.y *= scaleFactor;
        
        if( touchIndex==0 ){
            window->events().notifyMouseDragged(touchPoint.x, touchPoint.y, 0);
        }       
        ofTouchEventArgs touchArgs;
        touchArgs.numTouches = [[event touchesForView:self.glLayerView] count];
        touchArgs.x = touchPoint.x;
        touchArgs.y = touchPoint.y;
        touchArgs.id = touchIndex;
        touchArgs.type = ofTouchEventArgs::move;
        ofNotifyEvent(window->events().touchMoved, touchArgs);
    }
}

//------------------------------------------------------
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
   
    
    for(UITouch *touch in touches){
        int touchIndex = [[self.activeTouches objectForKey:[NSValue valueWithPointer:touch]] intValue];
        
        [self.activeTouches removeObjectForKey:[NSValue valueWithPointer:touch]];
        
        CGPoint touchPoint = [touch locationInView:self.glLayerView];
        
        touchPoint.x *= scaleFactor; // this has to be done because retina still returns points in 320x240 but with high percision
        touchPoint.y *= scaleFactor;
        
        if( touchIndex==0 ){
            window->events().notifyMouseReleased(touchPoint.x, touchPoint.y, 0);
        }
        
        ofTouchEventArgs touchArgs;
        touchArgs.numTouches = [[event touchesForView:self.glLayerView] count] - [touches count];
        touchArgs.x = touchPoint.x;
        touchArgs.y = touchPoint.y;
        touchArgs.id = touchIndex;
        touchArgs.type = ofTouchEventArgs::up;
        ofNotifyEvent(window->events().touchUp, touchArgs);
    }
}

//------------------------------------------------------
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    for(UITouch *touch in touches){
        int touchIndex = [[self.activeTouches objectForKey:[NSValue valueWithPointer:touch]] intValue];
        
        CGPoint touchPoint = [touch locationInView:self.glLayerView];
        
        touchPoint.x *= scaleFactor; // this has to be done because retina still returns points in 320x240 but with high percision
        touchPoint.y *= scaleFactor;
        
        ofTouchEventArgs touchArgs;
        touchArgs.numTouches = [[event touchesForView:self.glLayerView] count];
        touchArgs.x = touchPoint.x;
        touchArgs.y = touchPoint.y;
        touchArgs.id = touchIndex;
        touchArgs.type = ofTouchEventArgs::cancel;
        ofNotifyEvent(window->events().touchCancelled, touchArgs);
    }
    
    [self touchesEnded:touches withEvent:event];
}

@end