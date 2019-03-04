
attribute vec4 Yposition;

attribute vec2 tec;

varying vec2 tecO;

void main()
{
    gl_Position = Yposition;
    tecO = tec;
}
