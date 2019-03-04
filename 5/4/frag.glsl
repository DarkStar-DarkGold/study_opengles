
precision mediump float;

varying vec2 tecO;
uniform sampler2D tex;

void main()
{
    gl_FragColor = texture2D(tex,tecO);
    
}
