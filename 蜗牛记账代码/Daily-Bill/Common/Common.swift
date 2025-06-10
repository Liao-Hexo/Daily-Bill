//
//  Common.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import Foundation
import UIKit

typealias CommonBlock = () -> Void
typealias OneBackBlock = (_ params: Any) -> Void

struct ThemeColor {
    
}

//字体颜色适配
extension ThemeColor {

    static var blackWhiteFontColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
        } else {
            return .black
        }
    }
}

//主题颜色适配
extension ThemeColor {
    
    static var blackWhiteThemeColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkThemeColor
                } else {
                    return lightThemeColor
                }
            }
        } else {
            return lightThemeColor
        }
    }

}

//cell颜色适配
extension ThemeColor {
    
    static var blackWhiteCellColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkCellColor
                } else {
                    return lightCellColor
                }
            }
        } else {
            return lightCellColor
        }
    }
}

//图表颜色适配
extension ThemeColor {
    
    static var blackWhiteDrawColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkDrawColor
                } else {
                    return lightDrawColor
                }
            }
        } else {
            return lightDrawColor
        }
    }
}

//日历颜色适配
extension ThemeColor {
    
    static var blackWhiteDateColor: UIColor  {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkCellColor
                } else {
                    return lightDrawColor
                }
            }
        } else {
            return lightDrawColor
        }
    }
}

//主题颜色
let darkThemeColor = UIColor.init(red: 54 / 255.0, green: 54 / 255.0, blue: 54 / 255.0, alpha: 1)
let lightThemeColor = UIColor.init(red: 238 / 255.0, green: 203 / 255.0, blue: 173 / 255.0, alpha: 1)
//cell主题色
let darkCellColor = UIColor.init(red: 79 / 255.0, green: 79 / 255.0, blue: 79 / 255.0, alpha: 1)//UIColor.init(red: 105 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1)
let lightCellColor = UIColor.init(red: 255 / 255.0, green: 228 / 255.0, blue: 196 / 255.0, alpha: 1)
//图表背景色
let darkDrawColor = UIColor.init(red: 105 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1)//UIColor.init(red: 216 / 255.0, green: 191 / 255.0, blue: 216 / 255.0, alpha: 1)//UIColor.init(red: 255 / 255.0, green: 222 / 255.0, blue: 173 / 255.0, alpha: 1)
let lightDrawColor = UIColor.init(red: 255 / 255.0, green: 218 / 255.0, blue: 185 / 255.0, alpha: 1)

//支出主题色
let spendingColor = UIColor.init(red: 255 / 255.0, green: 106 / 255.0, blue: 106 / 255.0, alpha: 1.0)//UIColor.init(red: 255 / 255.0, green: 140 / 255.0, blue: 155 / 255.0, alpha: 1.0)
//收入主题色
let incomeColor = UIColor.init(red: 60 / 255, green: 179 / 255, blue: 113 / 255, alpha: 1.0)
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
