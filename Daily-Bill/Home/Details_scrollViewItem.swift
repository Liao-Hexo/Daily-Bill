//
//  Details_scrollViewItem.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/21.
//

import UIKit

@objc protocol Details_scrollViewItemDelegate: NSObjectProtocol{
    @objc optional func tableView(delete tally: TallyList)
    @objc optional func tableView(didSelect tally: TallyList, indexPath: IndexPath, InView item: Details_scrollViewItem)
    @objc optional func loadMore()
    @objc optional func pullRefresh()

}

class Details_scrollViewItem: UIView, UITableViewDelegate, UITableViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let identifier: String = "cellIdentifier"
    let headerIdentifier: String = "headerIdentifier"

    weak var delegate: Details_scrollViewItemDelegate?

    lazy var tableView: UITableView = {

        let aTableView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        aTableView.tableFooterView = UIView.init()
        aTableView.tableHeaderView = UIView.init()
        aTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        aTableView.delegate = self
        aTableView.dataSource = self
    
//        let tempImageView = UIImageView(image: UIImage(named: "yourImage"))
//        tempImageView.frame = self.tableView.frame
//        self.tableView.backgroundView = tempImageView;
        
//        let imageView = UIImageView(image: UIImage(named: "背景"))
//        imageView.frame = aTableView.frame
//        aTableView.backgroundView = imageView
        aTableView.backgroundColor = themeColor

        aTableView.register(Details_ListTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)
        aTableView.register(Details_ListTableViewHeader.classForCoder(), forCellReuseIdentifier: headerIdentifier)

        return aTableView
    }()
    
    var refreshControl = UIRefreshControl()

    let dataArray: NSMutableArray = NSMutableArray.init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     // MARK: - SetupUI

    func setupUI(frame: CGRect) -> Void {

        self.tableView.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(self.tableView)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "账单已更新")
        refreshControl.overrideUserInterfaceStyle = .dark
        self.tableView.addSubview(refreshControl)
        
    }
    
    @objc func refreshData() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

     // MARK: - LoadData

    func loadData(array: [TallyList]?) -> Void {

        self.dataArray.removeAllObjects()

        if array?.count == 0 {
            self.tableView.reloadData()
            return
        }


        let firstTally: TallyList = array?.first ?? TallyList.init()
        let month = CalendarHelper.month(date: firstTally.date ?? "", dateFormat: "yyyyMMdd")
        let days = CalendarHelper.days(month: month)

        for i in (1...days).reversed() {

            let yearAndMonth = CalendarHelper.dateString(date: firstTally.date ?? "", originFromat: "yyyyMMdd", resultFromat: "yyyyMM")

            var nowDate = yearAndMonth
            if i < 10{
                nowDate = nowDate.appending(String(format: "0%d", i))
            }else{
                nowDate = nowDate.appending(String(format: "%d", i))
            }

            let flagArray: NSMutableArray = NSMutableArray.init()

            for aTally in array ?? NSArray.init() as! [TallyList]{

                if aTally.date == nowDate{
                    flagArray.add(aTally)
                }

            }

            if flagArray.count > 0{

                let headerModel = TallyListHeaderModel.init()
                //headerModel.date = CalendarHelper.dateString(date: nowDate, originFromat: "yyyyMMdd", resultFromat: "MM月dd日")
                headerModel.date = String(format: "%@ %@", CalendarHelper.dateString(date: nowDate, originFromat: "yyyyMMdd", resultFromat: "MM.dd"), CalendarHelper.weekDay(dateString: nowDate , format:"yyyyMMdd"))
                
                var incomeSum: Float = 0
                var spendingSum: Float = 0

                for tally: TallyList in flagArray as! [TallyList]{

                    if tally.tallyType == 1{
                        spendingSum += (tally.amount! as NSString).floatValue  //支出

                    }else{
                        incomeSum += (tally.amount! as NSString).floatValue  //收入
                    }

                }

                headerModel.spendingAmount = String(format: "%.2f", spendingSum)
                headerModel.incomeAmount = String(format: "%.2f", incomeSum)


                flagArray.insert(headerModel, at: 0)
                self.dataArray.add(flagArray)
             }
          }

        self.tableView.reloadData()

        self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: UITableView.ScrollPosition.middle, animated: true)

    }

    // MARK: - Methods

    func deleteRow(indexPath: IndexPath){

        let array: [TallyList] = self.dataArray.object(at: indexPath.section) as! Array
        let tallyModel: TallyList = array[indexPath.row]

        if array.count > 2{
            let arr: NSMutableArray = NSMutableArray.init(array: array as NSArray)
            arr.removeObject(at: indexPath.row)
            self.dataArray.replaceObject(at: indexPath.section, with: arr)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }else{
            self.dataArray.removeObject(at: indexPath.section)
            self.tableView.deleteSections(IndexSet.init(arrayLiteral: indexPath.section), with: UITableView.RowAnimation.fade)
        }



        DispatchQueue.global().async {

            let sqlManager: SqlManager = SqlManager.shareInstance
            let result = sqlManager.tallylist_delete(id: tallyModel.id)
            if result {
                sqlManager.summary_update(tally: tallyModel, type: SqlManager.SummaryType.reduce)
            }
            DispatchQueue.main.async {
                self.delegate?.tableView!(delete: tallyModel)
            }

        }


    }

     // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 30
        }

        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)

        let array: [TallyList] = self.dataArray.object(at: indexPath.section) as! Array
        let tallyModel = array[indexPath.row]
        self.delegate?.tableView!(didSelect: tallyModel, indexPath: indexPath, InView: self)

    }

     // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array: [TallyList] = self.dataArray.object(at: section) as! Array
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0{

            let cell: Details_ListTableViewHeader = tableView.dequeueReusableCell(withIdentifier: headerIdentifier, for: indexPath) as! Details_ListTableViewHeader
            let array: NSArray = self.dataArray.object(at: indexPath.section) as! NSArray
            cell.headrModel = array.firstObject as! TallyListHeaderModel
            cell.isUserInteractionEnabled = false
            return cell

        }else{

            let cell: Details_ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Details_ListTableViewCell

            if self.dataArray.count == 0{
                return cell
            }

            let array: [TallyList] = self.dataArray.object(at: indexPath.section) as! Array
            cell.tallyModel = array[indexPath.row]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if indexPath.row == 0 {
            return false
        }
        return true

    }

//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == UITableViewCell.EditingStyle.delete{
//                self.deleteRow(indexPath: indexPath)
//        }
//
//
//    }


}

