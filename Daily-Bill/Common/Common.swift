//
//  Common.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit


typealias CommonBlock = () -> Void
typealias OneBackBlock = (_ params: Any) -> Void

//状态栏高度
let kStatusBarHeight =  UIApplication.shared.statusBarFrame.size.height
//导航栏高度
let kNavigationHeight = (kStatusBarHeight + 44)
//tabbar高度
let kTabBarHeight =  (CGFloat)(kStatusBarHeight == 44 ? 83 : 49)
//顶部的安全距离
let kTopSafeAreaHeight = (kStatusBarHeight - 20)
//底部的安全距离
let kBottomSafeAreaHeight = (kTabBarHeight - 49)
//屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width
//屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height
//主题颜色
//let themeColor = UIColor.init(red: 0, green: 153 / 255.0, blue: 217 / 255.0, alpha: 1.0)
let themeColor = UIColor.init(red: 240 / 255.0, green: 123 / 255.0, blue: 114 / 255.0, alpha: 1.0)
//收入主题色
let incomeColor = UIColor.init(red: 0, green: 179 / 255.0, blue: 125 / 255.0, alpha: 1.0)


//系统版本号
let systemVersion =  (UIDevice.current.systemVersion as NSString).floatValue

//默认适配宽度
func autoScaleNomarl(value: CGFloat) -> CGFloat {
    return (CGFloat.init(kScreenWidth) / 360.0) * value
}
//自定义适配宽度
func autoScale(value: CGFloat, key: CGFloat) -> CGFloat {
    return (CGFloat.init(kScreenWidth) / key) * value
}
