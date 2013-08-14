//
//  CCShaderSprite.m
//  playWithShaders
//
//  Created by Stéphane Queraud on 08/08/13.
//
//
#import "cocos2d.h"
#import "CCShaderSprite.h"
#import "CCGLProgram.h"
#import "CCShaderCache.h"
#import "myEnums.h"

@implementation CCShaderSprite

@synthesize currentShaderProgram;
@synthesize lightIntensity,lightPosition;
@synthesize totalTime;


-(void) loadAllShaders
{
    maskTexture =  [[CCTextureCache sharedTextureCache] addImage:@"mask.png"] ;
    refractionTexture = [[CCTextureCache sharedTextureCache] addImage:@"textures_refraction5.jpg"] ;
    ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
    [refractionTexture setTexParameters:&params];
    
    
    CCGLProgram *program;
    
    //black and white
    [self loadShader:@"blackWhiteShader.vsh" withFragment:@"blackWhiteShader.fsh" forKey:@"blackWhiteShader"];
    program = [[CCShaderCache sharedShaderCache] programForKey:@"blackWhiteShader"];
    
    //spot light / mapping
    [self loadShader:@"lightShader.vsh" withFragment:@"lightShader.fsh" forKey:@"lightShader"];
    program = [[CCShaderCache sharedShaderCache] programForKey:@"lightShader"];
    lightIntensityLocation = glGetUniformLocation(program->program_, "u_lightIntensity");
    lightPositionLocation = glGetUniformLocation(program->program_, "u_lightPosition");
    maskLocation = glGetUniformLocation(program->program_,"u_mask");
    
    //refraction water
    [self loadShader:@"refractionShader.vsh" withFragment:@"refractionShader.fsh" forKey:@"refractionShader"];
    program = [[CCShaderCache sharedShaderCache] programForKey:@"refractionShader"];
    //lightIntensityLocation = glGetUniformLocation(program->program_, "u_lightIntensity");
    refractionPositionLocation = glGetUniformLocation(program->program_, "u_refractionPosition");
    refractionLocation = glGetUniformLocation(program->program_,"u_refraction");
    timeLocation = glGetUniformLocation(program->program_, "u_time");
    
    //light no mask
    [self loadShader:@"lightNoMask.vsh" withFragment:@"lightNoMask.fsh" forKey:@"lightNoMaskShader"];
    program = [[CCShaderCache sharedShaderCache] programForKey:@"lightNoMaskShader"];
    lightNoMaskIntensityLocation = glGetUniformLocation(program->program_, "u_lightIntensity");
    lightNoMaskPositionLocation = glGetUniformLocation(program->program_, "u_lightPosition");
    lightNoMaskResolutionLocation = glGetUniformLocation(program->program_, "u_resolution");
    lightNoMaskFallOffLocation = glGetUniformLocation(program->program_, "u_lightFallOff"); 
    
    
}
-(void) loadShader:(NSString *)vsh withFragment:(NSString *)fsh forKey:(NSString *)key
{
    CCGLProgram *program;
    
    program = [[CCGLProgram alloc] initWithVertexShaderFilename:vsh fragmentShaderFilename:fsh];
    [program addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
    [program addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
    [program addAttribute:kCCAttributeNameColor index:kCCVertexAttrib_Color];
    [program link];
    [program updateUniforms];
       
    [[CCShaderCache sharedShaderCache] addProgram:program forKey:key];
   // [program use];
    
}


-(void) draw
{
	CC_PROFILER_START_CATEGORY(kCCProfilerCategorySprite, @"CCSprite - draw");
    
	NSAssert(!batchNode_, @"If CCSprite is being rendered by CCSpriteBatchNode, CCSprite#draw SHOULD NOT be called");
    
	CC_NODE_DRAW_SETUP();
    
	ccGLBlendFunc( blendFunc_.src, blendFunc_.dst );
    
	ccGLBindTexture2D( [texture_ name] );
    
   
    
    //glViewport(0, 0, 500   , 768);
    
	//
	// Attributes
	//
    
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_PosColorTex );
        
#define kQuadSize sizeof(quad_.bl)
	long offset = (long)&quad_;
    
	// vertex
	NSInteger diff = offsetof( ccV3F_C4B_T2F, vertices);
	glVertexAttribPointer(kCCVertexAttrib_Position, 3, GL_FLOAT, GL_FALSE, kQuadSize, (void*) (offset + diff));
    
	// texCoods
	diff = offsetof( ccV3F_C4B_T2F, texCoords);
	glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, kQuadSize, (void*)(offset + diff));
    
	// color
	diff = offsetof( ccV3F_C4B_T2F, colors);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_UNSIGNED_BYTE, GL_TRUE, kQuadSize, (void*)(offset + diff));
    
    CCGLProgram *currentShaderProg;
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    switch (currentShaderProgram)
    {
        case shaderNoProg:
            currentShaderProg = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColor];
            shaderProgram_ = currentShaderProg;
            [shaderProgram_ use];
            break;
            
        case shaderBlackWhite:
            currentShaderProg = [[CCShaderCache sharedShaderCache] programForKey:@"blackWhiteShader"];
            shaderProgram_ = currentShaderProg;
            [shaderProgram_ use];
            break;
            
        case shaderLight:
            
            currentShaderProg = [[CCShaderCache sharedShaderCache] programForKey:@"lightShader"];
            shaderProgram_ = currentShaderProg;
            [shaderProgram_ use];
            [shaderProgram_ setUniformForModelViewProjectionMatrix];

            glActiveTexture(GL_TEXTURE1);
            glBindTexture( GL_TEXTURE_2D,  [maskTexture name] );
            glUniform1i(maskLocation, 1);
        
            glUniform1f(lightIntensityLocation,  lightIntensity);
            
            //re-calculate light/mask position (texture size is 512x512 but appears 1024x768 on ipad with gl_repeat)
            //doesn't work yet for retina
            glUniform2f(lightPositionLocation, ((-lightPosition.x + s.width/2 - self.texture.contentSizeInPixels.width/2) * (s.width/self.texture.contentSizeInPixels.width) )/ s.width,((lightPosition.y - s.height + self.texture.contentSizeInPixels.height/2) * (s.height/self.texture.contentSizeInPixels.height) / s.height));
           
            break;
            
        case shaderRefraction:
            currentShaderProg = [[CCShaderCache sharedShaderCache] programForKey:@"refractionShader"];
            shaderProgram_ = currentShaderProg;
            [shaderProgram_ use];
            [shaderProgram_ setUniformForModelViewProjectionMatrix];
            
            glActiveTexture(GL_TEXTURE1);
            glBindTexture( GL_TEXTURE_2D,  [refractionTexture name] );
            glUniform1i(refractionLocation, 1);
            
            glUniform1f(timeLocation, totalTime);
            
            break;
        
        case shaderLightNoMask:
            currentShaderProg = [[CCShaderCache sharedShaderCache] programForKey:@"lightNoMaskShader"];
            shaderProgram_ = currentShaderProg;
            [shaderProgram_ use];
            [shaderProgram_ setUniformForModelViewProjectionMatrix];
            
            glUniform2f(lightNoMaskPositionLocation, lightPosition.x / s.width,lightPosition.y  / s.height);
            glUniform2f(lightNoMaskResolutionLocation, s.width,s.height);
            glUniform1f(lightNoMaskIntensityLocation, 1.0);
            glUniform1f(lightNoMaskFallOffLocation, 5.9);

            break;

            
        default:
            break;
    }

    
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glActiveTexture(GL_TEXTURE0);
	//CHECK_GL_ERROR_DEBUG();
    
    
#if CC_SPRITE_DEBUG_DRAW == 1
	// draw bounding box
	CGPoint vertices[4]={
		ccp(quad_.tl.vertices.x,quad_.tl.vertices.y),
		ccp(quad_.bl.vertices.x,quad_.bl.vertices.y),
		ccp(quad_.br.vertices.x,quad_.br.vertices.y),
		ccp(quad_.tr.vertices.x,quad_.tr.vertices.y),
	};
	ccDrawPoly(vertices, 4, YES);
#elif CC_SPRITE_DEBUG_DRAW == 2
	// draw texture box
	CGSize s = self.textureRect.size;
	CGPoint offsetPix = self.offsetPosition;
	CGPoint vertices[4] = {
		ccp(offsetPix.x,offsetPix.y), ccp(offsetPix.x+s.width,offsetPix.y),
		ccp(offsetPix.x+s.width,offsetPix.y+s.height), ccp(offsetPix.x,offsetPix.y+s.height)
	};
	ccDrawPoly(vertices, 4, YES);
#endif // CC_SPRITE_DEBUG_DRAW
    
	CC_INCREMENT_GL_DRAWS(1);
    
	CC_PROFILER_STOP_CATEGORY(kCCProfilerCategorySprite, @"CCSprite - draw");
    
}

@end
