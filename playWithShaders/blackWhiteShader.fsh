/* 
  lightShader.fsh
  playWithShaders

  Created by Stéphane Queraud on 08/08/13.

*/

precision lowp float;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()

{
    vec4 normalColor = texture2D(u_texture, v_texCoord);
    
    float gray = 0.299*normalColor.r + 0.587*normalColor.g + 0.114*normalColor.b;
    gl_FragColor = vec4(gray, gray, gray, normalColor.a);

}
