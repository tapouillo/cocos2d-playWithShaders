/* 
  lightShader.vsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

*/
attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

uniform mat4 u_MVPMatrix;
uniform mediump float u_time;
uniform mediump vec2 u_refractionPosition;

varying mediump vec2 v_texCoord;
varying mediump vec2 v_texCoordRefraction;

varying mediump vec3 v_fragmentColor;

void main()
{
    
    gl_Position = u_MVPMatrix * a_position;
    v_fragmentColor = a_color.rgb;
    v_texCoord = a_texCoord;
    
    //div by 4.0 to slown down, or you need to adjust the refraction texture
    v_texCoordRefraction = a_texCoord + vec2(sin(u_time),cos(u_time)) / vec2(4.0,4.0);
          
}