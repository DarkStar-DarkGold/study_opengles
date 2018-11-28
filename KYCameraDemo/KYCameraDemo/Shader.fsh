
varying highp vec2 texCoordVarying;
precision mediump float;

uniform sampler2D Sampler;

void main()
{
    gl_FragColor = texture2D(Sampler, texCoordVarying);
}
