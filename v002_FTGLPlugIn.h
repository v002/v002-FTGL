//
//  v002_FTGLPlugIn.h
//  v002 FTGL
//
//  Created by vade on 9/28/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Quartz/Quartz.h>
#import <OpenGL/OpenGL.h>

#import "ftgl.h"

@interface v002_FTGLPlugIn : QCPlugIn
{
    float bounds[6];
    FTGLfont *font;
    
    NSUInteger currentEncoding;
	NSString* internalString;
}
@property (readwrite, retain) NSString* internalString;

@property (assign) NSUInteger inputFont;
@property (assign) NSString* inputString;
@property (assign) id<QCPlugInInputImageSource> inputImage;
@property (assign) CGColorRef inputColor;
@property (assign) double inputDepth;
@property (assign) double inputFrontOutset;
@property (assign) double inputBackOutset;

// 3D / rendering control
@property (assign) BOOL inputWireframe;
@property (assign) NSUInteger inputUVGenMode;
@property (assign) double inputTranslationX;
@property (assign) double inputTranslationY;
@property (assign) double inputTranslationZ;
@property (assign) double inputRotationX;
@property (assign) double inputRotationY;
@property (assign) double inputRotationZ;
@property (assign) double inputScaleX;
@property (assign) double inputScaleY;
@property (assign) double inputScaleZ;
@property (assign) NSUInteger inputBlendMode; 
@property (assign) NSUInteger inputDepthMode;
@property (assign) NSUInteger inputFaceCull;

@end

@interface v002_FTGLPlugIn (Execution)

- (void) destroy;

@end

