precision mediump float;

attribute vec3 Yposition;
attribute vec3 Onormal;
attribute vec2 texIoord;
varying vec2 texCoord;

varying vec3 FragPos;
varying vec3 Fnormal;
uniform mat3 timodel;

uniform mat4 Model_M;
uniform mat4 View;
uniform mat4 Projection;

void main()
{
    Fnormal =  timodel *  Onormal;
//    Fnormal = vec3(Model_M * vec4(Onormal,1.0));
    FragPos = vec3(Model_M * vec4(Yposition, 1.0));
    gl_Position =   Projection * View * Model_M * vec4(Yposition,1.0);
//    YcolorOut = Ycolor;
    texCoord = vec2(texIoord);
}
