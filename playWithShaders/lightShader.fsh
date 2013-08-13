/* 
  lightShader.fsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

*/


varying lowp vec3 v_fragmentColor;
varying lowp vec2 v_texCoord;
varying lowp vec2 v_textCoordMask;

uniform sampler2D u_texture;
uniform sampler2D u_mask;


void main()                                                                                           
{
    /*
    //fragment lighting / per pixel: too slow
    mediump float distance = distance(gl_FragCoord.xyz,u_lightPosition.xyz);
    lowp float diffuse = 4.0;
    diffuse = diffuse * (1.0 / (1.0 + (0.0000025 * distance * distance)));
    */
    /*
     lowp vec4 fragColor = texture2D(u_texture, v_texCoord);
     gl_FragColor = vec4( v_fragmentColor * fragColor.rgb , fragColor.a);
    */
   
   
    lowp vec4 texColor = texture2D(u_texture,  v_texCoord);
    lowp vec4 maskColor = texture2D(u_mask, v_textCoordMask );
    //the current mask is not transparent, i'm using black and white only. to allow a little light
    //even after the spot, either use dark grey on the mask, or add +0.1 ...
    lowp vec4 finalColor = vec4((maskColor.r+0.1) *texColor.r, (maskColor.r+0.1) *texColor.g, (maskColor.r+0.1) *texColor.b, texColor.a);
    gl_FragColor = vec4(v_fragmentColor * finalColor.rgb  , finalColor.a);

}