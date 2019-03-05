
attribute vec4 Yposition;

attribute vec2 tec;
attribute vec4 color;

varying vec2 tecO;
varying vec4 color0;

void main()
{
    gl_Position = Yposition;
    tecO = tec;
    color0 = color;
}
