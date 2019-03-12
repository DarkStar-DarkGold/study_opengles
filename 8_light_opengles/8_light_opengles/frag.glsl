
precision mediump float;

//varying vec4 YcolorOut;
//
//varying vec2 texCoord;
//
//uniform sampler2D uSampler;
uniform vec3 objectColor;
uniform vec3 lightColor;

void main()
{
    
    gl_FragColor = vec4(objectColor * lightColor,1.0); //texture2D(uSampler,texCoord) ;
}
//texture2D(uSampler,texCoord) *
