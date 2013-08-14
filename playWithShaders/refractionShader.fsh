/* 
  lightShader.fsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

http://imgur.com/qR7fdgS
http://imgur.com/awC6AKF

*/


varying lowp vec3 v_fragmentColor;
varying lowp vec2 v_texCoord;
varying lowp vec2 v_texCoordRefraction;



uniform sampler2D u_texture;
uniform sampler2D u_refraction;
uniform mediump vec2 u_refractionPosition;
uniform mediump float u_time;

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
    
    mediump vec4 refractionColor = texture2D(u_refraction,v_texCoordRefraction);
    mediump vec4 texColor = texture2D(u_texture, v_texCoord + vec2(refractionColor.r   ,refractionColor.g   ));
    
    //you can also use the blue color to change the alpha ...
    gl_FragColor = vec4(v_fragmentColor * texColor.rgb  , texColor.a + refractionColor.b);

}