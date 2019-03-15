precision mediump float;

attribute vec4 Yposition_L;

uniform mat4 Model_M;
uniform mat4 View;
uniform mat4 Projection;

void main()
{
    gl_Position =  Projection * View * Model_M * Yposition_L;
    //    YcolorOut = Ycolor;
    //    texCoord = texIoord;
}

