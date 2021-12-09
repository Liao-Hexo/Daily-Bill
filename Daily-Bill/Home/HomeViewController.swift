//
//  HomeViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

class HomeViewController: UIViewController, Details_scrollViewItemDelegate, Details_TopViewDelegate, Details_DateSelectViewDelegate, UIScrollViewDelegate, AddViewControllerDelegate {
    
    var scrollView_Item: Details_scrollViewItem?
    var topView: Details_TopView?
    var scrollView: UIScrollView?
    var datePickerBackView: Details_DateSelectView?
    var currentDate: String = "000000"
    
    var billingDetailBottomView: BillingDetails_BottomView = BillingDetails_BottomView()
    
    var delHandler: ((TallyList)->Void)?
    var editHandler: ((String)->Void)?
    
    var _tallyModel: TallyList?
    var tallyModel: TallyList{
        set{
            _tallyModel = newValue
        }
        get{
            return _tallyModel ?? TallyList.init()
        }
    }
    
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
        
        loadData()
    }
    
    // MARK: - SetupUI
    
    func setupUI() -> Void {
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = true
        
        let topView: Details_TopView = Details_TopView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 190))
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
        
        let month = CalendarHelper.month(date: date, dateFormat: "yyyyMM")
        let days = CalendarHelper.days(month: month)
        let startDate = date.appending("01")
        let endDate = date.appending(String(format: "%d", days))
        let array: [TallyList] = sqlManager.tallylist_query(startDate: startDate, endDate: endDate, userid: userid)
        self.scrollView_Item?.loadData(array: array)
        
    }
    
    // MARK: - Methods
    
    func shownDatePicker() -> Void {
        
        self.billingDetailBottomView.removeFromSuperview()
        
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
        
        self.billingDetailBottomView.removeFromSuperview()
        
        let billingDetailBottomView: BillingDetails_BottomView = BillingDetails_BottomView.init(frame: CGRect.init(x: 25, y: self.view.frame.height/2-140, width: kScreenWidth-50, height: 280))
        billingDetailBottomView.layer.cornerRadius = 8
        billingDetailBottomView.backgroundColor = UIColor.init(red: 105 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1)//themeColor
        
        self.tallyModel = tally
        
        billingDetailBottomView.dateLabel?.text = String(format: "%@ %@", CalendarHelper.dateString(date: _tallyModel?.date ?? "00000000", originFromat: "yyyyMMdd", resultFromat: "yyyy年MM月dd日"), CalendarHelper.weekDay(dateString: _tallyModel?.date ?? "20190103" , format:"yyyyMMdd"))
        
        let imageName: String = (_tallyModel?.consumeType ?? "餐饮").appending("high")
        billingDetailBottomView.imageView?.image = UIImage.init(named: imageName)
        if _tallyModel?.tallyType == 1{
            billingDetailBottomView.amountLabel?.text = "-".appending(_tallyModel?.amount ?? "0.00")
            billingDetailBottomView.imageBackView?.backgroundColor = spendingColor
            billingDetailBottomView.titleLabel?.textColor = spendingColor
            billingDetailBottomView.amountLabel?.textColor = spendingColor
        }else{
            billingDetailBottomView.amountLabel?.text = "+".appending(_tallyModel?.amount ?? "0.00")
            billingDetailBottomView.imageBackView?.backgroundColor = incomeColor
            billingDetailBottomView.titleLabel?.textColor = incomeColor
            billingDetailBottomView.amountLabel?.textColor = incomeColor
            
        }
        
        billingDetailBottomView.titleLabel?.text = tally.consumeType
        
        self.del { (tallList) in
            item.deleteRow(indexPath: indexPath)
        }
        self.edit { (date) in
            self.loadData(loadDate: date)
        }
        
        billingDetailBottomView.delBtn {
            let alert = UIAlertController(title: "提示", message: "确定要删除该记录吗，一旦删除该记录将无法找回？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: {_ in
                self.delHandler?(self.tallyModel)
                //                self.navigationController?.popViewController(animated: true)
                //                self.dismiss(animated: true, completion: nil)
                self.billingDetailBottomView.removeFromSuperview()
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        billingDetailBottomView.editBtn {
            
            let addVC: AddViewController = AddViewController.init()
            addVC.delegate = self
            let addNavC: UINavigationController = UINavigationController.init(rootViewController: addVC)
            addVC.tallyModel = TallyModel.init(tallList: self.tallyModel)
            addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(addNavC, animated: true, completion: nil)
            
        }
        
        self.view.addSubview(billingDetailBottomView)
        self.billingDetailBottomView = billingDetailBottomView
    }
    
    func del(handler:@escaping ((TallyList)->Void)) -> Void {
        self.delHandler = handler
    }
    
    func edit(handler:@escaping ((String)->Void)) -> Void {
        self.editHandler = handler
    }
    
    // MARK: - LoadData
    
    func loadData() -> Void {
        
        let imageName: String = (_tallyModel?.consumeType ?? "餐饮").appending("high")
        self.billingDetailBottomView.imageView?.image = UIImage.init(named: imageName)
        self.billingDetailBottomView.titleLabel?.text = _tallyModel?.consumeType
        
        self.billingDetailBottomView.dateLabel?.text = String(format: "%@ %@", CalendarHelper.dateString(date: _tallyModel?.date ?? "00000000", originFromat: "yyyyMMdd", resultFromat: "yyyy年MM月dd日"), CalendarHelper.weekDay(dateString: _tallyModel?.date ?? "20190103" , format:"yyyyMMdd"))
        
        if _tallyModel?.tallyType == 1{
            self.billingDetailBottomView.amountLabel?.text = "-".appending(_tallyModel?.amount ?? "0.00")
            self.billingDetailBottomView.imageBackView?.backgroundColor = spendingColor
        }else{
            self.billingDetailBottomView.amountLabel?.text = _tallyModel?.amount ?? "0.00"
            let highColor2: UIColor = UIColor.init(red: 0, green: 179 / 255.0, blue: 125 / 255.0, alpha: 1.0)
            self.billingDetailBottomView.imageBackView?.backgroundColor = highColor2
        }
        
    }
    
    
    // MARK: - AddViewControllerDelegate
    
    func addComplete(tally: TallyModel) {
        
        DispatchQueue.main.async {
            
            let aTally: TallyList = TallyList.init(tally: tally)
            aTally.id = self.tallyModel.id
            
            let sql: SqlManager = SqlManager.shareInstance
            let result = sql.tallylist_update(tally: aTally)
            
            if result{
                let result1 = sql.summary_update(tally: self.tallyModel, type: SqlManager.SummaryType.reduce)
                let result2 = sql.summary_update(tally: aTally, type: SqlManager.SummaryType.add)
                if result1 && result2{
                    let date: String = CalendarHelper.dateString(date: tally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyyMM")
                    self.tallyModel = aTally
                    self.loadData()
                    self.editHandler?(date)
                }
            }else{
                print("list数据插入失败")
            }
        }
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
