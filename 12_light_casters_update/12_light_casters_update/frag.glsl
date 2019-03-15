
precision mediump float;

//uniform vec3 objectColor;
//uniform vec3 lightColor;
varying vec2 texCoord;
varying vec3 Fnormal;
varying vec3 FragPos;

uniform sampler2D tex1;
uniform sampler2D letter;


uniform vec3 amb;
uniform sampler2D diff;
uniform vec3 spe;
uniform float shininess;

uniform vec3 directionLight;
uniform vec3 ambLight;
uniform vec3 diffLight;
uniform vec3 speLight;

uniform float d;
uniform float k1;
uniform float k2;

uniform vec3 fangxiang;
uniform float cutoff;
uniform float outcutoff;

void main()
{
    // 灯光位置 这里写死
    vec3 lightpos = vec3(0.0,0.0,3.0);
    vec3 viewpos = vec3(0.0,0.0,3.0); // 观察者位置画也就是眼睛的位置 这里写死
    vec3 lightDir = normalize(lightpos - FragPos); // 求出灯光位置
    // ambient 环境光
    vec3 ambient = ambLight * texture2D(diff,texCoord).rgb;
    // diffuse
    vec3 norm = normalize(Fnormal); // 标准化法线
    float dif = max(dot(norm, lightDir), 0.0); // 点乘计算夹角的cos值 --》n漫反射因子
    vec3 diffuse = diffLight * dif * texture2D(diff,texCoord).rgb;
    // specular
    vec3 viewDir = normalize(viewpos - FragPos); // 视线向量
    vec3 reflectDir = reflect(-lightDir, norm); // 对应的沿着法线轴的反射向量：
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 4.0); // 256 高光的反光度  越大高光点越小！
    vec3 specular = speLight * spec * (texture2D(tex1,texCoord).rgb);
    // spotLight (soft edge)
    float theta = dot(lightDir,normalize(-fangxiang));
    float epsilon = (cutoff - outcutoff);
    float intensity = clamp((theta - outcutoff) / epsilon, 0.0, 1.0);
    diffuse *= intensity;
    specular *= intensity;
//    // attenuations衰减因子
    float dis   = length(lightpos - FragPos);
    float attenuation = 1.0 / (d + k1 * dis +
                               k2 * (dis * dis));
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    
    vec3 result = ambient + diffuse + specular;
    gl_FragColor = vec4(result,1.0);
    
//    if (theta > cutoff) {
//        vec3 ambient = ambLight * texture2D(diff,texCoord).rgb;
////        diff
//        vec3 norm = normalize(Fnormal); // 标准化法线
//        float dif = max(dot(norm, lightDir), 0.0); // 点乘计算夹角的cos值 --》n漫反射因子
//        // vec3 diffuse = diffLight * (dif * diff);
//        vec3 diffuse = diffLight * dif * texture2D(diff,texCoord).rgb;
//        //specular
//        vec3 viewDir = normalize(viewpos - FragPos); // 视线向量
//        vec3 reflectDir = reflect(-lightDir, norm); // 对应的沿着法线轴的反射向量：
//        float spec = pow(max(dot(viewDir, reflectDir), 0.0), 4.0); // 256 高光的反光度  越大高光点越小！
//        vec3 specular = speLight * spec * (texture2D(tex1,texCoord).rgb);
//        // attenuation
//        float dis   = length(lightpos - FragPos);
//        float attenuation = 1.0 / (d + k1 * dis +
//                                   k2 * (dis * dis));
//        //    vec3 emission = texture2D(letter , texCoord).rgb;
////        ambient *= attenuation;
//        diffuse *= attenuation;
//        specular *= attenuation;
//        //ambient =vec3(0.,0.,0.);
//        //diffuse =vec3(0.,0.,0.);
////        specular =vec3(0.,0.,0.);
//
//        vec3 result = ambient + diffuse + specular;
//        gl_FragColor = vec4(result,1.0);
//    }else{
//         gl_FragColor = vec4(ambLight * texture2D(diff,texCoord).rgb,1.0);
//    }
//
    
///    float specularStrength = 0.5;  // 镜面高度强度
//    float ambientStrength = 0.1; // 环境光强度
//    vec3 ambient = ambientStrength * lightColor;  // 环境光
//    vec3 norm = normalize(Fnormal); // 标准化法线
//    vec3 lightDir = normalize(lightpos - FragPos); // 求出灯光位置
//    float diff = max(dot(norm, lightDir), 0.0); // 点乘计算夹角的cos值 --》n漫反射因子
//    vec3 diffuse = diff * lightColor; // 漫反射光
//
//    vec3 viewDir = normalize(viewpos - FragPos); // 视线向量
//    vec3 reflectDir = reflect(-lightDir, Fnormal); // 对应的沿着法线轴的反射向量：
//    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 256.0); // 256 高光的反光度  越大高光点越小！
//    vec3 specular = specularStrength * spec * lightColor;
//
//    vec3 result = (ambient + diffuse + specular ) * objectColor;

    //texture2D(uSampler,texCoord) ;
}

// 更新了灯光 更新了光照贴图
