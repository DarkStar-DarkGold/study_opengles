attribute vec4 vPosition;

attribute vec2 TexCoordIn;
varying vec2 TexCoordOut;

void main(void)
{
    gl_Position = vPosition;
//    gl_Position = vec4(vPosition.x,vPosition.y,vPosition.z,vPosition.w);
    
    TexCoordOut = TexCoordIn;
//    TexCoordOut = vec2(TexCoordIn.x, 1.0-TexCoordIn.y); // 解决图片颠倒的问题
}
