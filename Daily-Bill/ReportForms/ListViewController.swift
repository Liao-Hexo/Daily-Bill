//
//  ListViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Property
    private let identifier = "identifier"
    private let headerIdentifier = "headerIdentifier"
    private lazy var tableView: UITableView = {
        let aTableView: UITableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        aTableView.delegate = self
        aTableView.dataSource = self
        aTableView.tableFooterView = UIView.init()
        aTableView.tableHeaderView = UIView.init()
        aTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        aTableView.register(Details_ListTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        aTableView.register(ListHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: self.headerIdentifier)
        return aTableView
    }()
    var consumeType: ConsumeType?
    var summary: Summary?
    var dataArray: Array<Any> = Array.init()
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        self.loadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: - SetupUI
    
    private func setupUI() -> Void {
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(CustomNavigationBar.getInstance(title: self.consumeType?.keyName, leftBtn: {
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(kNavigationHeight)
        }
        
    }
    
    //MARK: - LoadData
    
    private func loadData() {
        
        let sqlManager: SqlManager = SqlManager.shareInstance
        
        var startDate: String = ""
        var endDate: String = ""
        if self.summary?.date?.count == 4{
            startDate = self.summary?.date?.appendingFormat("%@", "0101") ?? "0"
            endDate = self.summary?.date?.appendingFormat("%@", "1231") ?? "0"
        }
        
        if self.summary?.date?.count == 6{
            let date:String = self.summary?.date ?? ""
            let month: String =  date[4..<6]
            let days: Int = CalendarHelper.days(month: month)
            startDate = self.summary?.date?.appendingFormat("%@", "01") ?? "0"
            endDate = self.summary?.date?.appendingFormat("%2d", days) ?? "0"
        }
        
        let array: Array<TallyList> = sqlManager.tallylist_query(startDate: startDate, endDate: endDate, userid: summary?.userid ?? "00000000")
        
        var listArray: Array<Any> = Array.init()
        
        var myArray: Array<TallyList> = Array.init()
        var last: TallyList?
        self.dataArray.removeAll()
        for tally: TallyList in array {
            if tally.consumeType == self.consumeType?.keyName{
                
                if last == nil{
                    myArray.append(tally)
                }else{
                    if tally.date == last?.date{
                        myArray.append(tally)
                    }else{
                        listArray.append(myArray)
                        myArray = Array.init()
                        myArray.append(tally)
                    }
                }
                last = tally
            }
        }
        
        if myArray.count > 0{
            listArray.append(myArray)
        }
        
      self.dataArray =  listArray.sorted { (now, last) -> Bool in
        
            let one = (now as! Array<TallyList>).first?.date
            let two = (last as! Array<TallyList>).first?.date
        
            if Int.init(one ?? "") ?? 1 > Int.init(two ?? "") ?? 0{
                return true
            }
            return false
        
        }
        
        
        self.tableView.reloadData()

    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let array: Array<Any> = self.dataArray[indexPath.section] as! Array
        let tally: TallyList = array[indexPath.row] as! TallyList
        let billingDetailsVC = BillingDetailsViewController.init()
        billingDetailsVC.hidesBottomBarWhenPushed = true
        billingDetailsVC.tallyModel = tally
        billingDetailsVC.del { (tallyList) in
            
            let sqlManager: SqlManager = SqlManager.shareInstance
            let result = sqlManager.tallylist_delete(id: tally.id)
            if result {
                sqlManager.summary_update(tally: tally, type: SqlManager.SummaryType.reduce)
            }
            self.loadData()
            
        }
        billingDetailsVC.edit { (date) in
            self.loadData()
        }
//        self.navigationController?.pushViewController(billingDetailsVC, animated: true)
        self.present(billingDetailsVC, animated: true, completion: nil)
        
    }
    
    //MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array: Array<Any> = self.dataArray[section] as! Array
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Details_ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Details_ListTableViewCell
        let array: Array<Any> = self.dataArray[indexPath.section] as! Array
        cell.tallyModel = array[indexPath.row] as! TallyList
        if indexPath.row == array.count - 1{
            cell.isHiddenSeparateLine = true
        }else{
            cell.isHiddenSeparateLine = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ListHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! ListHeaderView
        let array: Array<Any> = self.dataArray[section] as! Array
        let tally: TallyList = array.first as! TallyList
        let dateString: String = CalendarHelper.dateString(date: tally.date ?? "20190101", originFromat: "yyyyMMdd", resultFromat: "yyyy年MM月dd日")
        headerView.contentLabel?.text = dateString
        return headerView
    }
}
