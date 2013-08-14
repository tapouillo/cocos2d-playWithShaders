/* 
  lightnomask.fsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

*/

varying lowp vec3 v_fragmentColor;
varying lowp vec2 v_texCoord;


uniform sampler2D u_texture;

uniform mediump vec2 u_lightPosition;
uniform mediump vec2 u_resolution;
uniform mediump float u_lightIntensity;
uniform mediump float u_lightFallOff;

void main() 
{
	mediump vec4 texColor = texture2D(u_texture, v_texCoord);
	
	mediump vec2 position = (gl_FragCoord.xy / u_resolution.xy) - u_lightPosition;
		
	//determine the vector length of the center position
	mediump float len = length(position);
	mediump float diffuse = u_lightIntensity;
    diffuse = diffuse * (1.0 / (1.0 + (u_lightFallOff * len * len)));

	//fall off / distance
	gl_FragColor =  vec4( texColor.rgb * diffuse, 1.0 );
    
    //linear
    //gl_FragColor =  vec4( texColor.rgb * (1.0 - len), 1.0 );
}

