//
//  TabBarViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

class TabBarViewController: UITabBarController, AddViewControllerDelegate {

    var homeViewController: HomeViewController?
    var customTabBar:CustomTabBar?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            setupUI()
        } else {
            // Fallback on earlier versions
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - SetupUI
    @available(iOS 13.0, *)
    func setupUI() -> Void {
//        overrideUserInterfaceStyle = .light//dark
        Thread.sleep(forTimeInterval: 2)  //设置启动页的时间

        let homeVC:HomeViewController = HomeViewController.init()
        let homeNavC: UINavigationController = UINavigationController.init(rootViewController: homeVC)
        let reportFormsVC:ReportFormsViewController = ReportFormsViewController.init()
        let reportFormsNavC: UINavigationController = UINavigationController.init(rootViewController: reportFormsVC)
        self.viewControllers = [homeNavC, reportFormsNavC]

        self.homeViewController = homeVC

        //自定义tabBar添加之前必须先添加viewControllers，否则自定义tabBar无效
        let customTabBar:CustomTabBar = CustomTabBar.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kTabBarHeight))
        customTabBar.delegate = self;
        customTabBar.addBtnHandler {
            print("addbtnHandler响应了")

            let addVC: AddViewController = AddViewController.init()
            addVC.delegate = self
            let addNavC: UINavigationController = UINavigationController.init(rootViewController: addVC)
            addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(addNavC, animated: true, completion: {

            })
        }
        self.tabBar.addSubview(customTabBar)

        self.tabBar.shadowImage = UIImage.init()
        self.tabBar.backgroundColor = themeColor
        self.tabBar.backgroundImage = UIImage.init()
        

        self.customTabBar = customTabBar




    }

    // MARK: - UITabBarDelegate

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        self.selectedIndex = item.tag
        print("\(item.tag)")

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
                    let tabBarItem: UITabBarItem = self.customTabBar?.items?[0] ?? UITabBarItem.init()
                    self.customTabBar?.selectedItem = tabBarItem
                }
            }else{
                print("list数据插入失败")
            }






        }

    }





}

