/* 
  lightShader.vsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

*/

attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

uniform mat4 u_MVPMatrix;

uniform mediump float u_lightIntensity;
uniform mediump vec2 u_lightPosition;

varying lowp vec2 v_texCoord;
varying lowp vec2 v_textCoordMask;
varying lowp vec3 v_fragmentColor;

void main()
{
    gl_Position = u_MVPMatrix * a_position ;
    
    v_fragmentColor = a_color.rgb  * u_lightIntensity;
    v_texCoord = a_texCoord ;
    v_textCoordMask = a_texCoord + u_lightPosition ;
}