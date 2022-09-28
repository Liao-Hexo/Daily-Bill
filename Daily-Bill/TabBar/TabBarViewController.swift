//
//  TabBarViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit
import AudioToolbox

class TabBarViewController: UITabBarController, AddViewControllerDelegate {

    var homeViewController: HomeViewController?
    var customTabBar:CustomTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    // MARK: - SetupUI
    func setupUI() {

        // overrideUserInterfaceStyle = .light//dark
        Thread.sleep(forTimeInterval: 1)  //设置启动页的时间

        let homeViewController = HomeViewController()
        homeViewController.tabBarItem.image = UIImage(named: "账单")
        homeViewController.tabBarItem.title = "账单"
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let reportFormsViewController = ReportFormsViewController()
        reportFormsViewController.tabBarItem.image = UIImage(named: "图表")
        reportFormsViewController.tabBarItem.title = "图表"
        let reportFormsNavigationController = UINavigationController(rootViewController: reportFormsViewController)
        self.viewControllers = [homeNavigationController, reportFormsNavigationController]
        self.selectedIndex = 0
        
        self.homeViewController = homeViewController

        //自定义tabBar添加之前必须先添加viewControllers，否则自定义tabBar无效
        let customTabBar:CustomTabBar = CustomTabBar(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTabBarHeight))
        customTabBar.delegate = self
        customTabBar.addBtnHandler {

            let addViewController = AddViewController()
            addViewController.delegate = self
            let addNavigationController = UINavigationController(rootViewController: addViewController)
            addNavigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(addNavigationController, animated: true, completion: nil)
        }
        self.customTabBar = customTabBar
        
//        self.tabBar.addSubview(customTabBar)
        self.setValue(customTabBar, forKeyPath: "tabBar")

    }

    // MARK: - UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        tabBarButtonClick(tabBarButton: getTabBarButton())

    }

    private func getTabBarButton() -> UIControl {

        var tabBarButtons = Array<UIView>()
        for tabBarButton in self.customTabBar!.subviews {
            if (tabBarButton.isKind(of:NSClassFromString("UITabBarButton")!)) {

                tabBarButtons.append(tabBarButton)
            }
        }
        return tabBarButtons[selectedIndex] as! UIControl
    }

    private func tabBarButtonClick(tabBarButton : UIControl) {

        for imageView in tabBarButton.subviews {
            if (imageView.isKind(of: NSClassFromString("UITabBarSwappableImageView")!)) {

                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.duration = 0.3
                animation.calculationMode = CAAnimationCalculationMode(rawValue: "cubicPaced")
                animation.values = [1.0,1.1,0.9,1.0]
                imageView.layer.add(animation, forKey: nil)
            }
        }

        let soundID = SystemSoundID(1519)
        AudioServicesPlaySystemSound(soundID)
    }


    // MARK: - AddViewControllerDelegate
    func addComplete(tally: TallyModel) {

        DispatchQueue.main.async {

            let aTally: TallyList = TallyList.init(tally: tally)

            let sql: SqlManager = SqlManager.shareInstance
            let result = sql.tallylist_insert(tally: aTally)

            if result{
                let result1 = sql.summary_update(tally: aTally, type: SqlManager.SummaryType.add)
                if result1{
                    let date: String = CalendarHelper.dateString(date: tally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyyMM")
                    self.homeViewController?.loadData(loadDate: date)
                    self.selectedIndex = 0
//                    let tabBarItem: UITabBarItem = self.customTabBar?.items?[0] ?? UITabBarItem.init()
//                    self.customTabBar?.selectedItem = tabBarItem
                    
                }
            } else {
                print("list数据插入失败")
            }
        }
    }

}
