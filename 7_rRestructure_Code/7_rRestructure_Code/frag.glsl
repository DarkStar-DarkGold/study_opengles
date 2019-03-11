
precision mediump float;

varying vec4 YcolorOut;

varying vec2 texCoord;

uniform sampler2D uSampler;

void main()
{
    gl_FragColor = texture2D(uSampler,texCoord) ;
}
//texture2D(uSampler,texCoord) *
