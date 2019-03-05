
attribute vec4 Yposition;

attribute vec4 Ycolor;
varying vec4 YcolorOut;
attribute vec2 texIoord;
varying vec2 texCoord;

uniform mat4 mvp;
uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;



void main()
{
    gl_Position =  Projection * View * Model * Yposition;
    YcolorOut = Ycolor;
    texCoord = texIoord;
}
