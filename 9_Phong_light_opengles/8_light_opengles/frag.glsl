
precision mediump float;

uniform vec3 objectColor;
uniform vec3 lightColor;
varying vec3 Fnormal;
varying vec3 FragPos;
void main()
{
    // 灯光位置 这里写死
    vec3 lightpos = vec3(0.0,2.0,2.0);
    vec3 viewpos = vec3(0.0,0.0,3.0); // 观察者位置画也就是眼睛的位置 这里写死
    float specularStrength = 0.5;  // 镜面高度强度
  
    
    float ambientStrength = 0.1; // 环境光强度
    vec3 ambient = ambientStrength * lightColor;  // 环境光
    vec3 norm = normalize(Fnormal); // 标准化法线
    vec3 lightDir = normalize(lightpos - FragPos); // 求出灯光位置
    float diff = max(dot(norm, lightDir), 0.0); // 点乘计算夹角的cos值 --》n漫反射因子
    vec3 diffuse = diff * lightColor; // 漫反射光
    
    vec3 viewDir = normalize(viewpos - FragPos); // 视线向量
    vec3 reflectDir = reflect(-lightDir, Fnormal); // 对应的沿着法线轴的反射向量：
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 256.0); // 256 高光的反光度  越大高光点越小！
    vec3 specular = specularStrength * spec * lightColor;
    
    vec3 result = (ambient + diffuse + specular ) * objectColor;

    gl_FragColor = vec4(result,1.0); //texture2D(uSampler,texCoord) ;
}
