/* 
  bump.fsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.


  source: https://github.com/mattdesl/lwjgl-basics/wiki/ShaderLesson6
  bump tool: http://crazybump.com/mac/
  
*/

varying lowp vec3 v_fragmentColor;
varying lowp vec2 v_texCoord;


uniform sampler2D u_texture;
uniform sampler2D u_bumpTexture;

uniform mediump vec2 u_lightPosition;
uniform mediump vec2 u_resolution;
uniform mediump float u_lightIntensity;
uniform mediump vec3 u_lightFallOff;

void main()
{
    mediump vec4 LightColor = vec4(1.0, 0.9, 0.7, 1.0);
    mediump vec4 AmbientColor = vec4(0.7, 0.7, 1.0, 0.1);
    mediump vec4 DiffuseColor = texture2D(u_texture, v_texCoord);
	mediump vec3 NormalMap = texture2D(u_bumpTexture, v_texCoord).rgb;
    NormalMap.g = 1.0 - NormalMap.g;

    mediump vec3 LightDir = vec3(u_lightPosition.xy - (gl_FragCoord.xy / u_resolution.xy), 0.095);
    LightDir.x *= u_resolution.x / u_resolution.y;
    

    mediump vec2 position = (gl_FragCoord.xy / u_resolution.xy) - u_lightPosition;
	mediump float len = length(LightDir);
	
    //mediump vec3 LightDir = vec3(u_lightPosition.xy - (gl_FragCoord.xy / u_resolution.xy), 1.0);
	
    mediump vec3 N = normalize(NormalMap *2.0 - 1.0);
	//mediump vec3 L = normalize(vec3(position.x,position.y,1.0));
    mediump vec3 L = normalize(LightDir);
    
    mediump vec3 Diffuse = (LightColor.rgb * LightColor.a)  * max(dot(N, L), 0.0);
    mediump vec3 Ambient = AmbientColor.rgb * AmbientColor.a;
    mediump float Attenuation = 1.0 / ( u_lightFallOff.x + (u_lightFallOff.y*len) + (u_lightFallOff.z*len*len) );
	
    mediump vec3 Intensity = Ambient + Diffuse * Attenuation;
	mediump vec3 FinalColor = DiffuseColor.rgb * Intensity;
	gl_FragColor =   vec4(v_fragmentColor * FinalColor.rgb, DiffuseColor.a);

}