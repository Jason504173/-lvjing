attribute vec3 position;
attribute vec2 textcord;
attribute vec3 color;

varying lowp vec2 vertextCord;
varying lowp vec3 frgBaseColor;

uniform float scrw_h ;

void main(){
    vec3 newPostion = position;
    newPostion.y *=  scrw_h;
    gl_Position  = vec4(newPostion,1.0);
    vertextCord  = textcord;
    frgBaseColor = color;
}
