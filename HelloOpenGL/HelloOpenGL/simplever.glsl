
attribute vec4 Position;
attribute vec4 SourceColor;

uniform mat4 modelViewprojection;
uniform mat4 projection;


varying vec4 DestinationColor;

void main() {
    DestinationColor = SourceColor;
    gl_Position = modelViewprojection * projection * Position;
}
