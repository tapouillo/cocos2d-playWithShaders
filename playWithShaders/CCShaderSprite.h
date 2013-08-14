//
//  CCShaderSprite.h
//  playWithShaders
//
//  Created by Stéphane Queraud on 08/08/13.
//
//

#import "CCSprite.h"
#import "CCGLProgram.h"

@interface CCShaderSprite : CCSprite
{
    int currentShaderProgram;
    
    GLuint programLocation;
    
    //light shader
    GLint lightIntensityLocation;
    GLint lightPositionLocation;
    
    //refraction shader
    GLint refractionPositionLocation;
    GLint timeLocation;
    
    //light no mask shader
    GLint lightNoMaskIntensityLocation;
    GLint lightNoMaskPositionLocation;
    GLint lightNoMaskResolutionLocation;
    GLint lightNoMaskFallOffLocation;
    
    //
    float lightIntensity;
    CGPoint lightPosition;
    
    CCTexture2D *maskTexture;
    GLint maskLocation;
    
    CCTexture2D *refractionTexture;
    GLint refractionLocation;

    float totalTime;
}

@property (nonatomic, readwrite) int currentShaderProgram;
@property (nonatomic, readwrite) float lightIntensity;
@property (nonatomic, readwrite, assign) CGPoint lightPosition;
@property (nonatomic, readwrite) float totalTime;

-(void) loadAllShaders;


@end
