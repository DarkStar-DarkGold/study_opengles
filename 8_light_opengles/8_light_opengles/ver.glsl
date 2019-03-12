precision mediump float;

attribute vec4 Yposition;

uniform mat4 Model_M;
uniform mat4 View;
uniform mat4 Projection;

void main()
{
    gl_Position =  Projection * View * Model_M * Yposition;
//    YcolorOut = Ycolor;
//    texCoord = texIoord;
}
