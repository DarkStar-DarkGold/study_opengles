
attribute vec4 Yposition;

attribute vec4 texCoord;

varying vec4 texCoordOut;


void main()
{
    gl_Position = Yposition;
    texCoordOut = texCoord;
}

