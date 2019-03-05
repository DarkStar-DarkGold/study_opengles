
attribute vec4 Position;
attribute vec4 SourceColor;

uniform mat4 modelViewprojection;


varying vec4 DestinationColor;

void main() {
    DestinationColor = SourceColor;
    gl_Position = modelViewprojection  * Position;
}
