//
//  v002_FTGLPlugIn.m
//  v002 FTGL
//
//  Created by vade on 9/28/10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
//#import <OpenGL/CGLMacro.h>

#import "v002_FTGLPlugIn.h"

#define	kQCPlugIn_Name				@"v002 FTGL"
#define	kQCPlugIn_Description		@"v002 FTGL renders True Type fonts in 3D using the Freetype GL library"

static NSArray* fontArray;

@implementation v002_FTGLPlugIn

@synthesize internalString;

@dynamic inputFont;
@dynamic inputString;
@dynamic inputImage;
@dynamic inputColor;
@dynamic inputDepth;
@dynamic inputFrontOutset;
@dynamic inputBackOutset;

@dynamic inputWireframe;
@dynamic inputUVGenMode;
@dynamic inputTranslationX;
@dynamic inputTranslationY;
@dynamic inputTranslationZ;
@dynamic inputRotationX;
@dynamic inputRotationY;
@dynamic inputRotationZ;
@dynamic inputScaleX;
@dynamic inputScaleY;
@dynamic inputScaleZ;
@dynamic inputBlendMode;     
@dynamic inputDepthMode;
@dynamic inputFaceCull;

+ (NSDictionary*) attributes
{
	return [NSDictionary dictionaryWithObjectsAndKeys:kQCPlugIn_Name, QCPlugInAttributeNameKey, kQCPlugIn_Description, QCPlugInAttributeDescriptionKey,
            kQCPlugIn_Category, @"categories", nil];
}

+ (NSDictionary*) attributesForPropertyPortWithKey:(NSString*)key
{
    if([key isEqualToString:@"inputFont"])
    {
        fontArray = (NSArray*) CTFontManagerCopyAvailableFontFamilyNames();
        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Font", QCPortAttributeNameKey,
                fontArray, QCPortAttributeMenuItemsKey,
                [NSNumber numberWithUnsignedInteger:[fontArray count] -1], QCPortAttributeMaximumValueKey,
                [NSNumber numberWithUnsignedInteger:0], QCPortAttributeMinimumValueKey,
                [NSNumber numberWithUnsignedInteger:0], QCPortAttributeDefaultValueKey, nil];
    }

    if([key isEqualToString:@"inputString"])
    {
        return [NSDictionary dictionaryWithObjectsAndKeys:@"String", QCPortAttributeNameKey,
               @"", QCPortAttributeDefaultValueKey, nil];
    }

    if([key isEqualToString:@"inputImage"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Image", QCPortAttributeNameKey,nil];
    
    if([key isEqualToString:@"inputColor"])
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Color", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"inputDepth"])
    {        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Depth", QCPortAttributeNameKey,
                [NSNumber numberWithFloat:0.0], QCPortAttributeMinimumValueKey,
                [NSNumber numberWithFloat:0.5], QCPortAttributeDefaultValueKey, nil];
    }

    if([key isEqualToString:@"inputFrontOutset"])
    {        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Front Outset", QCPortAttributeNameKey,
                [NSNumber numberWithFloat:0.0], QCPortAttributeDefaultValueKey, nil];
    }

    if([key isEqualToString:@"inputBackOutset"])
    {        
        return [NSDictionary dictionaryWithObjectsAndKeys:@"Back Outset", QCPortAttributeNameKey,
                [NSNumber numberWithFloat:0.0], QCPortAttributeDefaultValueKey, nil];
    }
    
    
    if([key isEqualToString:@"inputWireframe"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Wireframe", QCPortAttributeNameKey, nil];
    
    if([key isEqualToString:@"inputUVGenMode"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Texture Coordinates", QCPortAttributeNameKey,
                [NSArray arrayWithObjects:@"Model", @"Object Linear", @"Eye Linear", @"Sphere Map", nil], QCPortAttributeMenuItemsKey,
                [NSNumber numberWithUnsignedInt:3], QCPortAttributeMaximumValueKey,
                [NSNumber numberWithUnsignedInt:0], QCPortAttributeDefaultValueKey,
                [NSNumber numberWithUnsignedInt:0], QCPortAttributeMinimumValueKey, nil];
    
    if([key isEqualToString:@"inputRotationX"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation X", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputRotationY"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation Y", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputRotationZ"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Rotation Z", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputTranslationX"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation X", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputTranslationY"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation Y", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputTranslationZ"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Translation Z", QCPortAttributeNameKey, [NSNumber numberWithDouble:0.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleX"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale X", QCPortAttributeNameKey, [NSNumber numberWithDouble:1.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleY"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale Y", QCPortAttributeNameKey, [NSNumber numberWithDouble:1.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputScaleZ"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Scale Z", QCPortAttributeNameKey, [NSNumber numberWithDouble:1.0],QCPortAttributeDefaultValueKey, nil];
    
    if([key isEqualToString:@"inputBlendMode"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Blending", QCPortAttributeNameKey,
                [NSArray arrayWithObjects:@"Replace", @"Over", @"Add", nil], QCPortAttributeMenuItemsKey,
                [NSNumber numberWithUnsignedInt:2], QCPortAttributeMaximumValueKey,
                [NSNumber numberWithUnsignedInt:1], QCPortAttributeDefaultValueKey,
                [NSNumber numberWithUnsignedInt:0], QCPortAttributeMinimumValueKey, nil];
    
    if([key isEqualToString:@"inputDepthMode"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Depth Testing", QCPortAttributeNameKey,
                [NSArray arrayWithObjects:@"None", @"Read/Write", @"Read-Only", nil], QCPortAttributeMenuItemsKey,
                [NSNumber numberWithUnsignedInt:2], QCPortAttributeMaximumValueKey,
                [NSNumber numberWithUnsignedInt:1], QCPortAttributeDefaultValueKey,
                [NSNumber numberWithUnsignedInt:0], QCPortAttributeMinimumValueKey, nil];

    if([key isEqualToString:@"inputFaceCull"])
		return [NSDictionary dictionaryWithObjectsAndKeys:@"Face Culling", QCPortAttributeNameKey,
                [NSArray arrayWithObjects:@"None", @"Front", @"Back", nil], QCPortAttributeMenuItemsKey,
                [NSNumber numberWithUnsignedInt:2], QCPortAttributeMaximumValueKey,
                [NSNumber numberWithUnsignedInt:2], QCPortAttributeDefaultValueKey,
                [NSNumber numberWithUnsignedInt:0], QCPortAttributeMinimumValueKey, nil];
    
    return nil;
}

+ (NSArray*) sortedPropertyPortKeys;
{
        return [NSArray arrayWithObjects:@"inputFont",
                @"inputString",
                @"inputImage",
                @"inputColor",
                @"inputDepth",
                @"inputFrontOutset",
                @"inputBackOutset",
                @"inputGenerateUVs",
                @"inputUVGenMode",
                @"inputRotationX",
                @"inputRotationY",
                @"inputRotationZ",
                @"inputTranslationX",
                @"inputTranslationY",
                @"inputTranslationZ",
                @"inputScaleX",
                @"inputScaleY",
                @"inputScaleZ", 
                @"inputBlendMode", 
                @"inputDepthMode", 
                @"inputFaceCull",
                nil];
}

+ (QCPlugInExecutionMode) executionMode
{
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode
{
	return kQCPlugInTimeModeNone;
}

- (id) init
{
	if(self = [super init])
    {
        font = nil;
		currentEncoding = NSUnicodeStringEncoding;
	}
	
	return self;
}

- (void) finalize
{	
	[super finalize];
}

- (void) dealloc
{
	[super dealloc];
}

@end

@implementation v002_FTGLPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context
{        
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context
{
    
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments
{
	// cant use CGLMacros due to using FTGL
    CGLContextObj cgl_ctx = [context CGLContextObj];
    CGLSetCurrentContext(cgl_ctx);
     
	if([self didValueForInputKeyChange:@"inputString"])
	{
		[self setInternalString:self.inputString]; 
	}
	
    if([self didValueForInputKeyChange:@"inputFont"] || (font == nil))
    {
        [self destroy];
        
        // make a CTFontDescriptor from our passed in font name, with size 0.0, 
        // so we can eventually get the URL for the font, to pass to ftgl
        
        CTFontDescriptorRef descriptor =  CTFontDescriptorCreateWithNameAndSize((CFStringRef) [fontArray objectAtIndex:self.inputFont], 0.0);
        NSURL* fontURL = (NSURL*) CTFontDescriptorCopyAttribute(descriptor, kCTFontURLAttribute);
        NSLog(@"Font URL: %@", fontURL); 

		NSDictionary* fontDescriptorDict = [NSDictionary dictionary];
		fontDescriptorDict = (NSDictionary*)CTFontDescriptorCopyAttributes(descriptor);

		NSLog(@"Font Descriptor Attributes %@", fontDescriptorDict);
		
		// Create a temp CTFontRef from our descritpor so we can introspect it.
		
		CTFontRef ctFont = CTFontCreateWithFontDescriptor(descriptor, 0.0, NULL);
		
		CFCharacterSetRef charSetAttribute = CTFontCopyAttribute(ctFont, kCTFontCharacterSetAttribute);	
		
        
		// cleanup
		CFRelease(ctFont);
		
		
		NSNumber* fontFormatNum = (NSNumber*) CTFontDescriptorCopyAttribute(descriptor, kCTFontFormatAttribute);
		NSUInteger fontFormat = [fontFormatNum unsignedIntValue];
		
        
        NSLog(@"Font format: %lu", (unsigned long)fontFormat);
        
        // kCTFontFormatAttribute OT PostScript, OT True Type, True Type, PostScript. Do we handle Bitmap fonts?
        // Looks like we have to be very careful about encoding here, or things go ape-shit.
        if((fontFormat > 0) )//&& (fontFormat < 5))
        {
            NSString* fontPath = [fontURL path];
            font = ftglCreateExtrudeFont([fontPath cStringUsingEncoding:NSUTF8StringEncoding]);
            
            if(!font || ftglGetFontError(font))
			{
				NSLog(@"Could not create font: Error %i:", ftglGetFontError(font));
				font = nil;   
                return NO;
            }
			
            // get the current character map
			//kCTFontFormatOpenTypePostScript = 1,
			//kCTFontFormatOpenTypeTrueType   = 2,
			//kCTFontFormatTrueType           = 3,
			//kCTFontFormatPostScript         = 4,			
            // Try to set the correct encoding;

			FT_Encoding *encodingArray = ftglGetFontCharMapList(font);
			
			int count = ftglGetFontCharMapCount(font);
			
			NSString* printString;
			int chosen = 0;
			for(int i = 0; i< count; i++)
			{
				switch (encodingArray[i])
				{
					case FT_ENCODING_UNICODE:
						printString = @"Unicode";
						break;
					case FT_ENCODING_APPLE_ROMAN:
						printString = @"Apple Roman";
						break;
					case FT_ENCODING_ADOBE_LATIN_1:
						printString = @"Latin 1";
						break;
					case FT_ENCODING_ADOBE_STANDARD:
						printString = @"Adobe Standard";
						break;
					case FT_ENCODING_NONE:
						printString = @"None";
						break;
					default:
						printString = @"Unknown";
						break;
				}
				
				NSLog(@"Encoding: %@", printString);
			}
			
			FT_Encoding encoding = encodingArray[chosen];
			
			switch (encoding) 
			{
				case FT_ENCODING_UNICODE:
				{
					if(1 == ftglSetFontCharMap(font, FT_ENCODING_UNICODE))
					{
						NSLog(@"Setting Unicode");
						currentEncoding = NSNonLossyASCIIStringEncoding;
					}
					else
					{
						NSLog(@"Failed setting char map");
					}
				}
					break;
					
				case FT_ENCODING_APPLE_ROMAN:
				{
					if(1 == ftglSetFontCharMap(font, FT_ENCODING_APPLE_ROMAN))
					{
						NSLog(@"Setting Mac OS Roman");
						currentEncoding = NSMacOSRomanStringEncoding;
					}
					else
					{
						NSLog(@"Failed setting char map");
					}
				}
					break;
					
				case FT_ENCODING_ADOBE_LATIN_1:
				{
					if(1 == ftglSetFontCharMap(font, FT_ENCODING_ADOBE_LATIN_1))
					{
						NSLog(@"Setting Latin 1");
						currentEncoding =  NSISOLatin1StringEncoding;
					}
					else
					{
						NSLog(@"Failed setting char map");
					}
				}
					break;
					
				default:
				{
					NSLog(@"unexpected encoding type: %u", encoding);
					[self destroy];
					return NO;
				}
					break;
			}
			
            ftglSetFontDisplayList(font, 1);
            
			if(ftglGetFontError(font))
				NSLog(@"FT Error %i:", ftglGetFontError(font));

			ftglSetFontDepth(font, (float) self.inputDepth);

			if(ftglGetFontError(font))
				NSLog(@"FT Error %i:", ftglGetFontError(font));
			
			ftglSetFontFaceSize(font, (float) 1.0, 1.0);
			
			if(ftglGetFontError(font))
				NSLog(@"FT Error %i:", ftglGetFontError(font));
			
            ftglSetFontOutset(font, (float) self.inputFrontOutset, (float) self.inputBackOutset);
            
			if(ftglGetFontError(font))
				NSLog(@"FT Error %i:", ftglGetFontError(font));
				
			
 			[self setInternalString:self.inputString]; 

			const char* string = NULL;
			
			if([self.internalString canBeConvertedToEncoding:currentEncoding])
			{
				string = [self.internalString cStringUsingEncoding:currentEncoding];
			}
            if(string)
			{
				ftglGetFontBBox(font, string, [self.internalString length], bounds);
				//ftglSetFontDisplayList(font, 1);
			}
			else
			{
				[context logMessage:@"Could not set font bounding box - bailing"];
				 return NO;
			}
        }

        // cleanup
        [fontFormatNum autorelease];
    }
    
    if([self didValueForInputKeyChange:@"inputDepth"] 
       || [self didValueForInputKeyChange:@"inputFrontOutset"]
       || [self didValueForInputKeyChange:@"inputBackOutset"])
    {
        if(font)
        {
            ftglSetFontDepth(font, (float) self.inputDepth);
            ftglSetFontFaceSize(font, (float) 1.0, 1.0);
            ftglSetFontOutset(font, (float) self.inputFrontOutset, (float) self.inputBackOutset);
           		
			const char* string = NULL;

			if([self.internalString canBeConvertedToEncoding:currentEncoding])
			{
				string = [self.internalString cStringUsingEncoding:currentEncoding];
			}
            if(string)
			{
				ftglGetFontBBox(font, string, [self.internalString length], bounds);
				//ftglSetFontDisplayList(font, 1);
			}
			else
			{
				[context logMessage:@"Could not set font bounding box - bailing"];
				return NO;
			}
        }
    }
    
    if(font)
    {
        glPushAttrib(GL_ALL_ATTRIB_BITS);
        
        const CGFloat* color;
        color = CGColorGetComponents(self.inputColor);
        glColor4f(color[0], color[1], color[2], color[3]);        
        
        glEnable(GL_NORMALIZE);
        
        if(self.inputBlendMode == 0)
            glDisable(GL_BLEND);
        else if(self.inputBlendMode == 1)
        {
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        }
        else
        {
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE);
        }
        
        if(self.inputDepthMode == 0)
            glDisable(GL_DEPTH_TEST);
        else if(self.inputDepthMode == 1)
        {
            glEnable(GL_DEPTH_TEST);
            glDepthFunc(GL_LEQUAL);
            glDepthMask(GL_TRUE);
        }
        else
        {
            glEnable(GL_DEPTH_TEST);
            glDepthMask(GL_FALSE);
        }   
        
        glTranslated(self.inputTranslationX, self.inputTranslationY, self.inputTranslationZ);
                
        glScaled(self.inputScaleX, self.inputScaleY, self.inputScaleZ);
        
        // rotate model.
        glRotated(self.inputRotationX, 1.0, 0.0, 0.0);
        glRotated(self.inputRotationY, 0.0, 1.0, 0.0);
        glRotated(self.inputRotationZ, 0.0, 0.0, 1.0);
        
        if(self.inputWireframe)
            glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        else
            glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);        
        
        glTranslated(-(bounds[3] - bounds[0]) * 0.5, -(bounds[4] - bounds[1]) * 0.5, 0.0);
        
        // image handling
        id<QCPlugInInputImageSource> image = self.inputImage; 
        if(image)
        {
            if([image lockTextureRepresentationWithColorSpace:[context colorSpace] forBounds:[image imageBounds]])
            {
                glActiveTexture(GL_TEXTURE0);
                
                [image bindTextureRepresentationToCGLContext:cgl_ctx textureUnit:GL_TEXTURE0 normalizeCoordinates:YES];
                
                if(GL_TEXTURE_2D == [image textureTarget])
                {
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); 
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT); 
                    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);                     
                }
                else
                {
                    glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
                    glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_MAG_FILTER, GL_LINEAR); 
                    glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE); 
                    glTexParameteri(GL_TEXTURE_RECTANGLE_EXT, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);                     
                }
                
                if(self.inputUVGenMode)
                {
                    glEnable(GL_TEXTURE_GEN_S);
                    glEnable(GL_TEXTURE_GEN_T);
                    
                    GLenum uvGenMode;
                    switch (self.inputUVGenMode)
                    {
                        case 1:
                            uvGenMode = GL_OBJECT_LINEAR;
                            break;
                        case 2:
                            uvGenMode = GL_EYE_LINEAR;
                            break;
                        case 3:
                            uvGenMode = GL_SPHERE_MAP;
                            break;
                        default:
                            uvGenMode = GL_OBJECT_LINEAR;
                            break;
                    }
                    
                    glTexGeni(GL_S, GL_TEXTURE_GEN_MODE, uvGenMode);
                    glTexGeni(GL_T, GL_TEXTURE_GEN_MODE, uvGenMode);
                } 
                else
                {
                    glDisable(GL_TEXTURE_GEN_S);
                    glDisable(GL_TEXTURE_GEN_T);
                }
            }
        }
        
        if(self.inputFaceCull == 0)
            glDisable(GL_CULL_FACE);
        else if(self.inputDepthMode > 0)
        {
            glEnable(GL_CULL_FACE);
            switch (self.inputFaceCull)
            {
                case 1:
                    glCullFace(GL_FRONT);
                    break;
                case 2:
                    glCullFace(GL_BACK);
                    break;
                default:
                    glCullFace(GL_BACK);
                    break;
            }
        }
        
		
		const char* string = NULL;
		
		if([self.internalString canBeConvertedToEncoding:currentEncoding])
		{
			string = [self.internalString cStringUsingEncoding:currentEncoding];
		}
		if(string)
		{
			ftglRenderFont(font,string, FTGL_RENDER_ALL);
		}
        else
            [context logMessage:@"Cannot convert to proper encoding"];
        
        if(image)
        {
            [image unbindTextureRepresentationFromCGLContext:cgl_ctx textureUnit:GL_TEXTURE0];
            [image unlockTextureRepresentation];
        }
        
        glPopAttrib();
    }    
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context
{
}

- (void) stopExecution:(id<QCPlugInContext>)context
{
}

- (void) destroy
{
	if(font)
	{
		ftglDestroyFont(font);
		font = nil;   
	}
}

@end
