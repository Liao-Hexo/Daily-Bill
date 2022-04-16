//
//  Common.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

typealias CommonBlock = () -> Void
typealias OneBackBlock = (_ params: Any) -> Void

//主题颜色
let themeColor = UIColor.init(red: 54 / 255.0, green: 54 / 255.0, blue: 54 / 255.0, alpha: 1)
//支出主题色
let spendingColor = UIColor.init(red: 255 / 255.0, green: 106 / 255.0, blue: 106 / 255.0, alpha: 1.0)//UIColor.init(red: 255 / 255.0, green: 140 / 255.0, blue: 155 / 255.0, alpha: 1.0)
//收入主题色
let incomeColor = UIColor.init(red: 60 / 255, green: 179 / 255, blue: 113 / 255, alpha: 1.0)
//cell主题色
let cellColor = UIColor.init(red: 79 / 255.0, green: 79 / 255.0, blue: 79 / 255.0, alpha: 1)//UIColor.init(red: 105 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1)
//图表背景色
let drawColor = UIColor.init(red: 105 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1)//UIColor.init(red: 216 / 255.0, green: 191 / 255.0, blue: 216 / 255.0, alpha: 1)//UIColor.init(red: 255 / 255.0, green: 222 / 255.0, blue: 173 / 255.0, alpha: 1)
//随机颜色
//let anyColor = UIColor.init(red: CGFloat(arc4random() % 256) / 255.0, green: CGFloat(arc4random() % 256) / 255.0, blue: CGFloat(arc4random() % 256) / 255.0, alpha: 1)

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
