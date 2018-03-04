//
//  OpenBasView.swift
//  Opengl_swift_Demo
//
//  Created by xuwenhao on 2018/1/31.
//  Copyright © 2018年 hh. All rights reserved.
//  这个是一个基本opengl视图类

import UIKit

class OpenBasView: UIView {
    override class var layerClass : AnyClass{
        return CAEAGLLayer.self
    }
    
    override var layer: CAEAGLLayer{
        return super.layer as! CAEAGLLayer
    }

    var mContent : EAGLContext?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI()  {
        mContent = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
        layer.drawableProperties = [kEAGLDrawablePropertyRetainedBacking:false,kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8]
        EAGLContext.setCurrent(mContent)
    }
    
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
    
    func compilShade( shader:inout GLuint,type:GLenum,file:String) ->Bool {
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
    
   //生成纹理
    func setupTextCord(image:UIImage) ->GLuint  {
        let sprcgImage = image.cgImage
        guard sprcgImage != nil else {
            print("换个图")
            return 0
        }
        let size   = image.size
        let width  = size.width
        let height = size.height
        
        let alphaInfo : CGImageAlphaInfo = sprcgImage!.alphaInfo
        var hasAlpha = false
        switch alphaInfo {
        case .first,.last,.premultipliedFirst,.premultipliedLast:
            hasAlpha = true
        default:
            hasAlpha = false
        }
        let alph = hasAlpha ? CGImageAlphaInfo.premultipliedLast : CGImageAlphaInfo.noneSkipLast
        let bitInfo :CGBitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | alph.rawValue)
        let pixnum :Int = Int(width * height * 4)
        let sprData = UnsafeMutablePointer<GLubyte>.allocate(capacity: pixnum)
        
        let bitePer = sprcgImage?.bitsPerComponent
        let byteRow = sprcgImage?.bytesPerRow
        let content = CGContext.init(data: sprData, width: Int(width), height: Int(height), bitsPerComponent: bitePer!, bytesPerRow: byteRow!, space: (sprcgImage?.colorSpace)!, bitmapInfo: bitInfo.rawValue)
        guard content != nil else {
            print("画布未创建成功")
            return 0
        }
        content?.draw(sprcgImage!, in: CGRect.init(origin: CGPoint.zero, size: size))
        let texCord = getTextCodeWithData(formt: GLenum(GL_RGBA), width: GLsizei(width), height: GLsizei(height), data: sprData)
        sprData.deallocate(capacity: 1)
        return texCord
    }
    
    func getTextCodeWithData(formt:GLenum,width:GLsizei,height:GLsizei,data:UnsafeRawPointer!) ->GLuint {
        var texCord :GLuint = 0
        glGenTextures(1, &texCord)
        glBindTexture(GLenum(GL_TEXTURE_2D), texCord)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR )
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR )
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri( GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
        glTexImage2D(GLenum(GL_TEXTURE_2D), 0, GL_RGBA, GLsizei(width), GLsizei(height), 0, GLenum(GL_RGBA), GLenum(GL_UNSIGNED_BYTE), data)
        glGenerateMipmap(GLenum(GL_TEXTURE_2D))
//        glBindTexture(GLenum(GL_TEXTURE_2D), 0)
        return texCord
    }
    
    
    //保存图片  这个暂时没有完成  之后再说吧
    func saveImage() ->UIImage? {
        glReadBuffer(GLenum(GL_FRONT))
        let scare :CGFloat = 1.0
        let width = SCREEN_WIDTH * scare
        let height = SCREEN_HEIGHT * scare
        let lenth :Int = Int(width * height * 4)
        let buff  = UnsafeMutablePointer<GLubyte>.allocate(capacity: lenth)
        glReadPixels(0, 0, GLsizei(width), GLsizei(height), GLenum(GL_RGBA), GLenum(GL_FLOAT), buff)
        let arryBuff =    UnsafeMutableBufferPointer<GLubyte>.init(start: buff, count: lenth)
        for (index,value) in arryBuff.enumerated() {
            if value != 0{
                print("****\(index)")
                break
            }
        }
        let privider = CGDataProvider.init(dataInfo: nil, data: buff, size: lenth) { (_, _, leng) in }
   
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        let bytesPerRow = 4 * width
        let bitInfo :CGBitmapInfo = CGBitmapInfo.init(rawValue: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue)

        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let cgimage = CGImage.init(width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: bitInfo, provider: privider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        
        buff.deallocate(capacity: lenth)
        guard cgimage != nil else {
            print("失败")
            return nil
        }
        let image = UIImage.init(cgImage: cgimage!)
        return image
    }
    
    //因为暂时不知道怎么获取像素   暂时搁置此功能
//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if point.y  > SCREEN_HEIGHT/2 {
//           saveToPhy()
//        }
//        return super.hitTest(point, with: event)
//    }
    
    //保存到相册
    func saveToPhy()  {
        
//        let image = saveImage()
//        guard image != nil else {
//            return
//        }
//        saveImageToPhy(image: image!)
    }
}




/*
 //纹理贴图
 https://www.jianshu.com/p/4d8d35288a0f
 */
