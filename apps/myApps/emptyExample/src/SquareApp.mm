#include "SquareApp.h"

//--------------------------------------------------------------
SquareApp :: SquareApp () {
    cout << "creating SquareApp" << endl;
}

//--------------------------------------------------------------
SquareApp :: ~SquareApp () {
    cout << "destroying SquareApp" << endl;
}

//--------------------------------------------------------------
void SquareApp::setup() {	
    //ofBackground(ofColor::black);
    //ofEnableAlphaBlending();

    
    fbo.allocate(ofGetWidth(), ofGetHeight());   
    GLint previousFboId = 0;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &previousFboId);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo.getId());
        ofClear(0, 0, 0, 255);
    glBindFramebuffer(GL_FRAMEBUFFER, previousFboId); 
}


//--------------------------------------------------------------
void SquareApp::update(){

}

//--------------------------------------------------------------
void SquareApp::draw() {
    

 
    int w = MIN(ofGetWidth(), ofGetHeight()) * 0.6;
    int h = w;
    int x = (ofGetWidth() - w)  * 0.5;
    int y = (ofGetHeight() - h) * 0.5;
    int p = 0;
    
    ofPushStyle();
    
    GLint previousFboId = 0;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &previousFboId);
    glBindFramebuffer(GL_FRAMEBUFFER, fbo.getId());  
        ofSetColor(ofRandom(255), ofRandom(255), ofRandom(255), ofRandom(255));
        ofDrawCircle(ofRandom(ofGetWidth()), ofRandom(ofGetHeight()), 10);
    glBindFramebuffer(GL_FRAMEBUFFER, previousFboId);   
    ofPopStyle();
    
    
    fbo.draw(0, 0);
    
    ofPushStyle();
    ofSetColor(ofColor::red);
        ofDrawRectangle(x, y, w, h);
    ofPopStyle();
    
    stringstream info;
    info << "ofGetWidth(): " << ofGetWidth()  << endl;
    info << "ofGetHeight(): " << ofGetHeight()    << endl;
    info << "ofGetScreenWidth(): " << ofGetScreenWidth()  << endl;
    info << "ofGetScreenHeight: " << ofGetScreenHeight()    << endl;
    info << "ofGetWindowWidth: " << ofGetWindowWidth()  << endl;
    info << "ofGetWindowHeight: " << ofGetWindowHeight()    << endl;
    
    info << ofGetFrameNum()    << endl;
    ofDrawBitmapString(info.str(), 20, 20);
}

//--------------------------------------------------------------
void SquareApp::exit() {
    //
}

//--------------------------------------------------------------
void SquareApp::touchDown(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void SquareApp::touchMoved(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void SquareApp::touchUp(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void SquareApp::touchDoubleTap(ofTouchEventArgs &touch){

}

//--------------------------------------------------------------
void SquareApp::lostFocus(){

}

//--------------------------------------------------------------
void SquareApp::gotFocus(){

}

//--------------------------------------------------------------
void SquareApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void SquareApp::deviceOrientationChanged(int newOrientation){

}


//--------------------------------------------------------------
void SquareApp::touchCancelled(ofTouchEventArgs& args){

}

