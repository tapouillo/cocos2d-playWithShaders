//
//  HelloWorldLayer.m
//  playWithShaders
//
//  Created by Stéphane Queraud on 08/08/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCShaderSprite.h"
#import "myEnums.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		self.isTouchEnabled = YES;
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
        
        //NSString *spriteName = @"dark-metal-grid-1.jpg";
        NSString *spriteName = @"stone.jpg";
        
        CCShaderSprite *sprite = [[CCShaderSprite alloc] initWithFile:spriteName  rect:CGRectMake(0, 0, size.width, size.height)] ;
        ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT };
        [[sprite texture] setTexParameters:&params];
        
        [sprite loadAllShaders];
        sprite.currentShaderProgram = shaderNoProg;
        sprite.tag = 42;
        [self addChild:sprite];
        sprite.position = ccp(size.width/2, size.height/2);
        
        sprite.lightIntensity = 2.5f;
        sprite.lightPosition = ccp(size.width/2,size.height/2);
        
       
		// top menu --------
		[CCMenuItemFont setFontSize:20];
		CCMenuItem *itemNoShader = [CCMenuItemFont itemWithString:@"[No Shader]" block:^(id sender)
        {
			sprite.currentShaderProgram = shaderNoProg;
		}];

		
		CCMenuItem *itemBW = [CCMenuItemFont itemWithString:@"[Black And White]" block:^(id sender)
        {
			sprite.currentShaderProgram = shaderBlackWhite;
		}];
        
		CCMenuItem *itemLight = [CCMenuItemFont itemWithString:@"[Light]" block:^(id sender)
        {
			sprite.currentShaderProgram = shaderLight;
		}];
        CCMenuItem *itemLightNoMask = [CCMenuItemFont itemWithString:@"[LightNoMask]" block:^(id sender)
        {
            sprite.currentShaderProgram = shaderLightNoMask;
        }];
        
        
		CCMenuItem *itemWater = [CCMenuItemFont itemWithString:@"[Water]" block:^(id sender)
        {
			sprite.currentShaderProgram = shaderRefraction;
		}];
		
		CCMenu *menu = [CCMenu menuWithItems:itemNoShader, itemBW, itemLight, itemLightNoMask, itemWater, nil];
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height - 50)];
		[self addChild:menu];
        //----------
        
        
        [self scheduleUpdate];

	}
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];

    CCShaderSprite *s = (CCShaderSprite *)[self getChildByTag:42];
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    s.lightPosition = location;
    
    NSLog(@"%f %f",location.x,s.lightPosition.y);
    
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CCShaderSprite *s = (CCShaderSprite *)[self getChildByTag:42];
    
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    s.lightPosition = location;
    // NSLog(@"%f %f",location.x,s.lightPosition.y);
}

- (void)update:(float)dt
{
    CCShaderSprite *s = (CCShaderSprite *)[self getChildByTag:42];
    s.totalTime += dt;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
