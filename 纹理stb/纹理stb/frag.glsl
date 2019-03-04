

precision mediump float;

varying vec4 texCoordOut;

uniform sampler2D tex;


void main()
{
    gl_FragColor = texture2D(tex,texCoordOut);
    
}
