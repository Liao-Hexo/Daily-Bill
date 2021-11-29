//
//  CustomTabBar.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

class CustomTabBar: UITabBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


    typealias AddBtnBlock = ()->Void
    var addBtn: UIButton?
    var addItem: UITabBarItem?
    var block: AddBtnBlock!

    override init(frame: CGRect) {
        super.init(frame: frame)
        let oneItem:UITabBarItem = UITabBarItem.init(title: "账单", image: UIImage.init(named: "账单-3"), tag: 0)
        let twoItem:UITabBarItem = UITabBarItem.init(title: "图表", image: UIImage.init(named: "图表-1"), tag: 1)
//        let threeItem:UITabBarItem = UITabBarItem.init(title: "发现", image: UIImage.init(named: "发现"), tag: 2)
//        let fourItem:UITabBarItem = UITabBarItem.init(title: "资产", image: UIImage.init(named: "我"), tag: 3)
        self.addItem = UITabBarItem.init(title: "", image: UIImage.init(named: ""), tag: 4)



        self.items = [oneItem, self.addItem, twoItem] as? [UITabBarItem]

        self.selectedItem = oneItem
        self.backgroundImage = UIImage.init()
        self.shadowImage = UIImage.init()

//        self.backgroundColor = UIColor.init(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)

        self.addBtn = UIButton.init(type: UIButton.ButtonType.system)
        self.addBtn?.setBackgroundImage(UIImage.init(named: "添加"), for: UIControl.State.normal)
//        self.addBtn?.setTitle("记账", for: .normal)
        self.addSubview(self.addBtn ?? UIView.init())
        self.addBtn?.frame = CGRect.init(x: (kScreenWidth - 40) / 2, y: 4, width: 44, height: 44)
        self.addBtn?.addTarget(self, action:#selector(addBtnAction), for: UIControl.Event.touchUpInside)

        self.tintColor = themeColor
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.addBtn?.frame.contains(point) ?? false{
            return addBtn
        }else{
            return super.hitTest(point, with: event)
        }
    }

    @objc private func addBtnAction() -> Void {

        print("addBtn响应了")

        if self.block != nil{
            self.block()
        }
    }

    func addBtnHandler(handler:@escaping AddBtnBlock) -> Void {
        self.block = handler
    }

}

