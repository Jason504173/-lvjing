//
//  SelfMadeFitleView.swift
//  绘图Demo
//
//  Created by xuwenhao on 2018/2/24.
//  Copyright © 2018年 Hiniu. All rights reserved.
//  自定义滤镜  暂时有  遮罩  高斯  沙雕

import UIKit
class SelfMadeFitleView: OpenBasView {
    //fittype  0 高斯模糊  1 沙雕  2 马赛克 3 圆透
    var fitleType :Int8 = 0
    private var mPrame              : GLuint = 0
    private var myColorRenderBuffer : GLuint = 0
    private var myColorFrameBuffer  : GLuint = 0
    private var attarrs   = [GLfloat]()
    private var indexArry = [GLuint]()
    private let verNum    = 6
    private let floatSize = MemoryLayout<GLfloat>.size
    private let image0 = UIImage.init(named: "22222.jpg")  //第一张图片
    private let image1 = UIImage.init(named: "999.jpg")  //第一张图片

    
    private var scarw_h :GLfloat = GLfloat(SCREEN_WIDTH/SCREEN_HEIGHT)
    override func setUI() {
        super.setUI()
        setBuff()
        setData()

        blinkShader()
    }
    
    func setData()  {
        //位置  颜色 纹理
        attarrs = [
            -1.0,  1.0, 0.0,  1.0, 1.0, 0.0,   0.0, 1.0,       //左上
            -1.0, -1.0, 0.0,  1.0, 0.0, 1.0,   0.0, 0.0,       //左下
            1.0, -1.0, 0.0,  0.0, 1.0, 1.0,   1.0, 0.0,       //右下
            1.0,  1.0, 0.0,  0.0, 0.0, 1.0,   1.0, 1.0,       //右上
        ]
        indexArry = [ 0,1,2,
                      2,3,0
        ]
    }
    
    func remeBuff()  {
        glDeleteFramebuffers(1, &myColorFrameBuffer)
        myColorFrameBuffer = 0
        glDeleteRenderbuffers(1, &myColorRenderBuffer)
        myColorRenderBuffer = 0
    }
    
    func setBuff()  {
        remeBuff()
        //绑定  渲染缓存
        glGenRenderbuffers(1, &myColorRenderBuffer)//申请一个
        glBindRenderbuffer(GLenum(GL_RENDERBUFFER), myColorRenderBuffer)//绑定
        mContent?.renderbufferStorage(Int(GL_RENDERBUFFER), from: self.layer)
        glGenFramebuffers(1, &myColorFrameBuffer)
        glBindFramebuffer(GLenum(GL_FRAMEBUFFER), myColorFrameBuffer)
        glFramebufferRenderbuffer(GLenum(GL_FRAMEBUFFER), GLenum(GL_COLOR_ATTACHMENT0), GLenum(GL_RENDERBUFFER), myColorRenderBuffer)
    }
    
    func blinkShader()  {
        let scar :CGFloat = 1
        let bouns = self.bounds
        glViewport(0, 0, GLsizei(bouns.width*scar), GLsizei(bouns.height*scar))
        //读取文件
        let verFile = Bundle.main.path(forResource: "verRend2", ofType: "glsl")
        let framFile = Bundle.main.path(forResource: "fragRend2", ofType: "glsl")
        mPrame = loadShader(versl: verFile!, framsl: framFile!)
        guard mPrame != 0 else {
            return
        }
        
        glUseProgram(mPrame)

        
        var verBuff : GLuint = 0
        glGenBuffers(1, &verBuff)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), verBuff)
        glBufferData(GLenum(GL_ARRAY_BUFFER), attarrs.size(), attarrs, GLenum(GL_STATIC_DRAW))
        
        var indexBuff:GLuint = 0
        glGenBuffers(1, &indexBuff)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuff)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexArry.size(), indexArry, GLenum(GL_STATIC_DRAW))
        
        //位置
        let position = glGetAttribLocation(mPrame, "position")
        glVertexAttribPointer(GLuint(position), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(floatSize*8), nil)
        glEnableVertexAttribArray(GLuint(position))
        
        //颜色
        let color = glGetAttribLocation(mPrame, "color")
        glVertexAttribPointer(GLuint(color), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(floatSize*8), BUFFER_OFFSET(n: 3*floatSize))
        glEnableVertexAttribArray(GLuint(color))
        
        //纹理
        let texcord = glGetAttribLocation(mPrame, "textcord")
        glVertexAttribPointer(GLuint(texcord), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(floatSize*8), BUFFER_OFFSET(n: 6*floatSize))
        glEnableVertexAttribArray(GLuint(texcord))
        
        
        scarw_h = GLfloat(self.bounds.width/self.bounds.height)
        let scrw_h = glGetUniformLocation(mPrame, "scrw_h")
        glUniform1f(scrw_h, GLfloat(scarw_h))
        //获取纹理
        let textTure0 = setupTextCord(image: image0!)
        let textTure1 = setupTextCord(image: image1!)
        guard textTure1 != 0 else {
            return
        }
        guard textTure0 != 0 else {
            return
        }
        //激活纹理单元
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), textTure0)
        glUniform1i(glGetUniformLocation(mPrame, "courTexture"), 0)
        
     
        //激活纹理单元
        glEnable(GLenum(GL_TEXTURE_2D))
        glActiveTexture(GLenum(GL_TEXTURE1))
        glBindTexture(GLenum(GL_TEXTURE_2D), textTure1)
        glUniform1i(glGetUniformLocation(mPrame, "courTexture1"), 1)
        
        
    }
    
    func fiterRender(value:Float)  {
        //多实例渲染
        glUseProgram(mPrame)
        glUniform1i(glGetUniformLocation(mPrame, "col_type"), GLint(fitleType))
        glUniform1f(glGetUniformLocation(mPrame, "solve"), value)
        glUniform2f(glGetUniformLocation(mPrame, "centPoint"), 0.5, 0.5)
        render()
    }
    
    
    func render()  {
        //顶点缓存
        guard mPrame != 0 else {
            return
        }
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))

        glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indexArry.count), GLenum(GL_UNSIGNED_INT), nil)
        mContent?.presentRenderbuffer(Int(GL_RENDERBUFFER))
    }

    
    

}
