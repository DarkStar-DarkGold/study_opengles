
attribute vec4 Yposition;

attribute vec4 Ycolor;

varying vec4 YcolorOut;

uniform mat4 mvp;

void main()
{
    gl_Position = mvp * Yposition;
    YcolorOut = Ycolor;
}
