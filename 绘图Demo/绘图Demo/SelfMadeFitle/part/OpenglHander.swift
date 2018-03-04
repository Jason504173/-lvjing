//
//  OpenglHander.swift
//  Opengl_swift_Demo
//
//  Created by xuwenhao on 2018/1/31.
//  Copyright © 2018年 hh. All rights reserved.
//  这个类作为助手 帮助处理渲染事务

import UIKit
class OpenglHander: NSObject {

    private override init() {
        super.init()
    }
    

    
    //方法  链接文件
    func loadShader(versl:String,framsl:String) -> GLuint {
        var vershader :GLuint = 0 ,framShader :GLuint = 0
        let program = glCreateProgram()  //创建
        var isSuccess = true
        isSuccess = compilShade(shader: &vershader, type: GLenum(GL_VERTEX_SHADER), file: versl)
        guard isSuccess else {
            print("顶点着色器编译失败")
            return 0
        }
        isSuccess = compilShade(shader: &framShader, type: GLenum(GL_FRAGMENT_SHADER), file: framsl)
        guard isSuccess else {
            print("片元着色器编译失败")
            return 0
        }
        //装配
        glAttachShader(program, vershader)
        glAttachShader(program, framShader)
        
        glLinkProgram(program)//链接程序
        var linkSucess :GLint = 0
        //是否链接成功
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkSucess)
        guard linkSucess == GL_TRUE else {
            let message  = UnsafeMutablePointer<GLchar>.allocate(capacity: 1)
            message.initialize(to: 0)
            glGetProgramInfoLog(program, 256, nil, message)
            let str = String.init(utf8String: message) ?? ""
            print("error =\(str)")
            glDeleteShader(vershader)
            glDeleteShader(framShader)
            glDeleteProgram(program)
            
            return 0
        }
        print("link OK")
        
        //验证程序是否可执行
        glValidateProgram(program)
        glGetProgramiv(program, GLenum(GL_VALIDATE_STATUS), &linkSucess)
        guard linkSucess == GL_TRUE else {
            let message  = UnsafeMutablePointer<GLchar>.allocate(capacity: 1)
            message.initialize(to: 0)
            glGetProgramInfoLog(program, 256, nil, message)
            let str = String.init(utf8String: message) ?? ""
            print("error =\(str)")
            glDeleteShader(vershader)
            glDeleteShader(framShader)
            glDeleteProgram(program)
            return 0
        }
        //删除
        glDetachShader(program, vershader)
        glDetachShader(program, framShader)
        glDeleteShader(vershader)
        glDeleteShader(framShader)
        return program
    }
    
     private func compilShade( shader:inout GLuint,type:GLenum,file:String) ->Bool {
        var conent : String = ""
        do {
            conent = try String.init(contentsOfFile: file, encoding: .utf8)
        } catch _ {
            return false
        }
        let charArry = Array(conent.utf8CString)
        var point = UnsafePointer<GLchar>?(charArry)
        shader = glCreateShader(type)   //创建
        glShaderSource(shader, 1, &point, nil)  //添加程序
        glCompileShader(shader) //编译
        var staus : GLint = 0
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &staus)//获取编译状态
        guard staus == GL_TRUE else {
            let message  = UnsafeMutablePointer<GLchar>.allocate(capacity: 1)
            message.initialize(to: 0)
            glGetShaderInfoLog(shader, 256, nil, message)
            let str = String.init(utf8String: message) ?? ""
            print("error =\(str)")
            return false
        }
        return true
    }
  
}

class BuffHander: NSObject {
    
    
    
    
    
    
}














