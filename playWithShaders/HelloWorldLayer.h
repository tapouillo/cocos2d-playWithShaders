//
//  HelloWorldLayer.h
//  playWithShaders
//
//  Created by Stéphane Queraud on 08/08/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//


#import <GameKit/GameKit.h>


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CGPoint lightPos;
    float lightFalloff;
    float lightIntensity;
    
    CCSpriteBatchNode *background;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
