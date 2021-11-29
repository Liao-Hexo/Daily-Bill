//
//  HomeViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

class HomeViewController: UIViewController, Details_scrollViewItemDelegate, Details_TopViewDelegate, Details_DateSelectViewDelegate, UIScrollViewDelegate {

    var scrollView_Item: Details_scrollViewItem?
    var topView: Details_TopView?
    var scrollView: UIScrollView?
    var datePickerBackView: Details_DateSelectView?
    var currentDate: String = "000000"

//    var chartButton: UIButton = {
//        let chartButton: UIButton = UIButton.init()
//        chartButton.setImage(UIImage.init(named: "图表-1"), for: .normal)
//        return chartButton
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupUI()

        let nowDate: String = CalendarHelper.nowDateString(dateFormat: "yyyyMM")
        loadData(loadDate: nowDate)

    }




    // MARK: - SetupUI

    func setupUI() -> Void {

        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true

        let topView: Details_TopView = Details_TopView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 150))
        topView.delegate = self
        self.view.addSubview(topView)
        self.topView = topView

        let aScrollView: UIScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: topView.frame.maxY, width: kScreenWidth, height: kScreenHeight - topView.frame.height - kTabBarHeight))
        aScrollView.delegate = self
        self.view.addSubview(aScrollView)
        self.scrollView = aScrollView

        let item: Details_scrollViewItem = Details_scrollViewItem.init(frame: CGRect.init(x: 0, y: aScrollView.frame.height, width: aScrollView.frame.width, height: aScrollView.frame.height))
        item.delegate = self
        aScrollView.addSubview(item)
        self.scrollView_Item = item

        aScrollView.contentSize = CGSize.init(width: aScrollView.frame.width, height: aScrollView.frame.height * 3)
        aScrollView.isScrollEnabled = false
        aScrollView.setContentOffset(CGPoint.init(x: 0, y: aScrollView.frame.height), animated: false)

//        topView.addSubview(chartButton)
//        chartButton.addTarget(self, action: #selector(chartAction), for: .touchUpInside)
//        chartButton.snp.makeConstraints { (make) in
//            make.top.equalTo(kStatusBarHeight)
//            make.trailing.equalToSuperview().offset(-10)
//            make.height.equalTo(40)
//        }

    }

//    @objc func chartAction() {
//        self.navigationController?.pushViewController(ReportFormsViewController(), animated: true)
//    }

     // MARK: - LoadData

    func loadData(loadDate: String) -> Void {

        self.currentDate = loadDate
        loadItemDate(date: self.currentDate, item: self.scrollView_Item)

    }

    func loadItemDate(date: String, item: Details_scrollViewItem?) -> Void {

        if date.count != 6{
            return
        }

        let nowDate = date
        let month = CalendarHelper.month(date: nowDate, dateFormat: "yyyyMM")
        let days = CalendarHelper.days(month: month)
        let startDate = nowDate.appending("01")
        let endDate = nowDate.appending(String(format: "%d", days))

        let sqlManager: SqlManager = SqlManager.shareInstance

        let array: [TallyList] = sqlManager.tallylist_query(startDate: startDate, endDate: endDate, userid: "00000000")
        item?.loadData(array: array)

        if item == self.scrollView_Item{
            updateSummary(userid: "00000000", date: nowDate)
        }


    }


    func updateSummary(userid: String, date: String) -> Void {

        let sqlManager: SqlManager = SqlManager.shareInstance
        let summary_spending = sqlManager.query(userid: userid, tallyType: 1, summaryType: 1, date: date)
        let summary_income = sqlManager.query(userid: userid, tallyType: 2, summaryType: 1, date: date)

        if summary_spending != nil{
            self.topView?.loadData(date: date, spending: summary_spending?.totalamount ?? "0.00", income: nil)
        }

        if summary_income != nil{
            self.topView?.loadData(date: date, spending: nil, income: summary_income? .totalamount ?? "0.00")
        }

    }

     // MARK: - Methods

    func shownDatePicker() -> Void {

        if self.tabBarController?.view.subviews.contains(self.datePickerBackView ?? UIView.init()) ?? false{
            self.datePickerBackView?.hiddenDatePicker()
            return
        }

        let datePickerBackView: Details_DateSelectView = Details_DateSelectView.init(frame: CGRect.init(x: 0, y:self.topView?.frame.height ?? 0, width: kScreenWidth, height: kScreenHeight - (self.topView?.frame.height ?? 0)))
        datePickerBackView.delegate = self
        self.tabBarController?.view.addSubview(datePickerBackView)
        self.datePickerBackView = datePickerBackView
    }



     // MARK: - Details_scrollViewItemDelegate

    func tableView(delete tally: TallyList) {

        let date = CalendarHelper.dateString(date: tally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyyMM")
        updateSummary(userid: "00000000", date: date)

    }

    func tableView(didSelect tally: TallyList, indexPath: IndexPath, InView item: Details_scrollViewItem) {
        let billingDetailsVC = BillingDetailsViewController.init()
        billingDetailsVC.hidesBottomBarWhenPushed = true
        billingDetailsVC.tallyModel = tally
        billingDetailsVC.del { (tallyList) in
            item.deleteRow(indexPath: indexPath)
        }
        billingDetailsVC.edit { (date) in
            self.loadData(loadDate: date)
        }
//        self.navigationController?.pushViewController(billingDetailsVC, animated: true)
        self.present(billingDetailsVC, animated: true, completion: nil)
    }

    func loadMore() {

        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.setContentOffset(CGPoint.init(x: 0, y: (self.scrollView?.frame.height ?? 0.00) * 2), animated: false)
        })
       self.loadData(loadDate:CalendarHelper.last(dateString: self.currentDate) )
       self.scrollView?.setContentOffset(CGPoint.init(x: 0, y: self.scrollView?.frame.height ?? 0.00) , animated: false)

    }

    func pullRefresh(){

        if CalendarHelper.nowDateString(dateFormat: "yyyyMM") == self.currentDate{
            return
        }

        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView?.setContentOffset(CGPoint.init(x: 0, y: (self.scrollView?.frame.height ?? 0.00) * 0), animated: false)
        })
        self.loadData(loadDate:CalendarHelper.next(dateString: self.currentDate) )
        self.scrollView?.setContentOffset(CGPoint.init(x: 0, y: self.scrollView?.frame.height ?? 0.00) , animated: false)

    }

     // MARK: - Details_TopViewDelegate

    func selectDateClicked() {
        shownDatePicker()
    }

     // MARK: - Details_DateSelectViewDelegate

    func selected(_ datePicker: Details_DateSelectView) -> Date {
        return Date.init()
    }

    func ok(_ datePicker: Details_DateSelectView, date: Date) {
        loadData(loadDate: CalendarHelper.dateString(date: date, dateFormat: "yyyyMM"))
    }

     // MARK: - UIScrollViewDelegate

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {



    }

}

