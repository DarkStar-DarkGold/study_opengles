
precision mediump float;

varying vec2 tecO;
varying vec4 color0;
uniform sampler2D tex;

void main()
{
    gl_FragColor = texture2D(tex,tecO)*color0;
    
}
