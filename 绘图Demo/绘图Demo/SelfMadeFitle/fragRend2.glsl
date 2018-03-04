precision mediump float;

varying lowp vec2 vertextCord;
vec2 temCode;

const float PI = 3.141592655358;
uniform sampler2D courTexture ;//纹理采样器
uniform sampler2D courTexture1;//纹理采样器1

uniform int col_type; //类型
uniform float solve; //程度
uniform vec2 centPoint; //中心点


vec4 getGesPurColor(float solve);//高斯模糊
vec4 getDrawkColor();//沙雕
vec4 getMskColor(float solve);//马赛克
vec4 getWaveColor();
vec4 getGrayColor();
vec4 getNormPurColor(vec2 centPoint);
vec4 getMaxColor();
vec4 getMinColor();

void main(){
    temCode = vec2(vertextCord.x,1.0 - vertextCord.y);
    vec4 color = vec4(0);
    if (col_type == 0) {
        color = getGesPurColor(solve);
    }else if (col_type == 1){
        color = getDrawkColor();
    }else if (col_type == 2){
        color = getMskColor(solve);
    }else if (col_type == 3){
        color = getNormPurColor(centPoint);
    }else if (col_type == 4){
        color = getWaveColor();
    }else if (col_type == 5){
        color = getWaveColor();
    }else if (col_type == 6){
        color = getMaxColor();
    }else if (col_type == 7){
        color = getMinColor();
    }    
    gl_FragColor =  color;
}

//膨胀滤镜
vec4 getMaxColor(){
    float block = 100.0;
    float delta = 1.0/block;
    vec4 maxColor = vec4(-1.0);
    for (int i = -1; i<=1; i++) {
        for (int j = -1 ; j <= 1; j++) {
            float x = vertextCord.x + float(i) * delta;
            float y = vertextCord.y + float(j) * delta;
            maxColor = max(texture2D(courTexture, vec2(x,y)),maxColor);
        }
    }
    return maxColor;
}

//腐蚀滤镜
vec4 getMinColor(){
    float block = 100.0;
    float delta = 1.0/block;
    vec4 maxColor = vec4(1.0);
    for (int i = -1; i<=1; i++) {
        for (int j = -1 ; j <= 1; j++) {
            float x = temCode.x + float(i) * delta;
            float y = temCode.y + float(j) * delta;
            maxColor = min(texture2D(courTexture, vec2(x,y)),maxColor);
        }
    }
    return maxColor;
}

/*
 模糊滤镜
 普通模糊   周围像素取平均值
 高斯模糊   权重不同   按正态分布  中心点权重最大
 */
//普通模糊
vec4 getNormPurColor(vec2 centPoint){
    
    float r = distance(centPoint,temCode);
    vec4 block = vec4(0.0,0.0,0.0,1.0);
    if (r > 0.25) {
        return block;
    }
    if (r < 0.2) {
        return  texture2D(courTexture, temCode);
    }
    float solve = (r - 2.0)/0.5;
    //中间渐变
    vec4 newColor = vec4(0.0);
    
        float blck = 100.0;
        float delta = 1.0/blck;
//        mat3 factor  = mat3(1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0);
        for (int i = -3; i<=3; i++) {
            for (int j = -3 ; j <= 3; j++) {
                float x = temCode.x + float(i) * delta;
                float y = temCode.y + float(j) * delta;
                newColor += texture2D(courTexture, vec2(x,y));
            }
        }

    return  newColor/49.0 * (1.0 - solve) ;
}

//高斯模糊  暂时没有对应的高斯矩阵改变  先写图片混合吧
vec4 getGesPurColor(float solve){
//    vec4 a = texture2D(courTexture, temCode)*solve;
//    vec4 b = texture2D(courTexture1, temCode)*(1.0-solve);
//    return vec4(max(a.r,b.r),max(a.g,b.g),max(a.b,b.b),1.0);
    return  texture2D(courTexture, temCode)*solve + texture2D(courTexture1, temCode)*(1.0-solve);
}

//下面有几个滤镜  有旋涡 还有灰度之类的

/*
 灰度 有这么几种方法
 1.浮点算法：Gray=R*0.3+G*0.59+B*0.11
 2.整数方法：Gray=(R*30+G*59+B*11)/100
 3.移位方法：Gray =(R*76+G*151+B*28)>>8;
 4.平均值法：Gray=(R+G+B)/3;
 5.仅取绿色：Gray=G；
 */
vec4 getGrayColor(){
    vec3 grayFix = vec3(0.3,0.59,0.11);
    vec4 color = texture2D(courTexture, temCode);
    float gray = dot(color.rgb,grayFix);
    return vec4(vec3(gray),color.a);
}

/*
 旋涡图片  其实也很简单
 中心点就是（0.5，0.5）
 偏离中心点的地方用 距离的平方  应该就可以了
 有个bug  不知道怎么解决   已经解决  不用asin  acos  用atan
 */
vec4 getWaveColor(){
    //半径
    //
    vec2 cent = vec2(0.5,0.5);
    float r = distance(cent,temCode);
    float normR = 0.4;
    if (r>=normR) {
        return texture2D(courTexture, temCode);
    }
    //弧度
    float rad = atan((temCode.y - cent.y) /(temCode.x - cent.x));
    if (temCode.x < cent.x) {
        rad += PI;
    }
    float wavFixa = -2.0*PI/pow(normR,2.0);
    float wavFixb = 4.0*PI/normR;
    float wavFix  = wavFixa*pow(r,2.0) + wavFixb*r;
    float wavx = r * cos(rad + wavFix);
    float wavy = r * sin(rad + wavFix);
    vec2 newPoint = cent + vec2(wavx,wavy);
    return texture2D(courTexture, newPoint);
}

//马赛克
vec4 getMskColor(float solve){
    vec2 maxBord = vec2(400.0,400.0);
    vec2 mskBord = vec2(20.0*solve,20.0*solve);
    if (mskBord.x == 0.0 || mskBord.y == 0.0) {
        return texture2D(courTexture, temCode);
    }
    vec2 newTemCode = vec2(0.0);
    newTemCode.x = floor(temCode.x * maxBord.x/mskBord.x)*mskBord.x/maxBord.x;
    newTemCode.y = floor(temCode.y * maxBord.y/mskBord.y)*mskBord.y/maxBord.y;
    return texture2D(courTexture, newTemCode);
}

//浮雕效果 与左上角像素求差 然后做灰度效果
vec4 getDrawkColor(){
    float block = 100.0;
    vec3 grayFix = vec3(0.3,0.59,0.11);
    vec4 bkColor = vec4(0.5, 0.5, 0.5, 1.0);
    float delta = 1.0/block;
    vec4 color = texture2D(courTexture, temCode);
    vec4 lpColor = texture2D(courTexture, vec2(temCode.x + delta,temCode.y - delta));
    color -= lpColor;
    float gray = dot(color.rgb,grayFix);
    return vec4(vec3(gray),0.0) + bkColor;
}










