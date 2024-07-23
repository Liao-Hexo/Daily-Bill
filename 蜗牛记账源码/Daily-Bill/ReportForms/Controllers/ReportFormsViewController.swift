//
//  ReportFormsViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

class ReportFormsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum SummaryType {
        case month
        case year
    }

    enum TallyType {
        case monthlySpending
        case yearlySpending
        case monthlyIncome
        case yearlyIncome
    }

    //MARK: - Property
    let identifier: String = "identifier"
    var reportFormsView: ReportFormsView? = nil
    var date: String{
        get{
            if self.dateSelectView.month == 0{
                return  String(format: "%d", self.dateSelectView.year)
            }
            return  String(format: "%d%02d", self.dateSelectView.year, self.dateSelectView.month)
        }
    }
    var type: TallyType = TallyType.monthlySpending
//    var summaryType: SummaryType = SummaryType.month
    var list: Array<ReportFormsModel> = Array.init()
    var summary: Summary?

    //MARK: - Lazy

    lazy var spendingSelectView: SelectView = {
        let selectView: SelectView = SelectView.init()
        selectView.type = SelectView.SelectType.spending
        selectView.isSelected = true
        selectView.titleLabel.text = "💰本月支出："
        selectView.titleLabel.textColor = ThemeColor.blackWhiteFontColor//.white//spendingColor
        selectView.amountLabel.text = "￥ 0.00"
        return selectView
    }()

    lazy var incomeSelectView: SelectView = {
        let selectView: SelectView = SelectView.init()
        selectView.type = SelectView.SelectType.income
        selectView.titleLabel.text = "👏本月收入："
        selectView.titleLabel.textColor = ThemeColor.blackWhiteFontColor//.white//incomeColor
        selectView.amountLabel.text = "￥ 0.00"
        return selectView
    }()

    lazy var dateSelectView: ReportFormsDateSelectView = {
        let aDateSelectView: ReportFormsDateSelectView = ReportFormsDateSelectView.init()
        return aDateSelectView
    }()

    lazy var tableView: UITableView = {

        let aTableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        aTableView.backgroundColor = UIColor.clear
        aTableView.delegate = self
        aTableView.dataSource = self
        
//        let imageView = UIImageView(image: UIImage(named: "背景"))
//        imageView.frame = aTableView.frame
//        aTableView.backgroundView = imageView
        aTableView.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor

        aTableView.register(ReportFormsTableViewCell.classForCoder(), forCellReuseIdentifier: identifier)

        let headerView = UIView.init()
        headerView.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        headerView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 350)
        aTableView.tableHeaderView = headerView
        aTableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 30))

        let backView: UIView = UIView.init()
        backView.layer.cornerRadius = 8
        backView.backgroundColor = ThemeColor.blackWhiteDrawColor//drawColor
        headerView.addSubview(backView)
        backView.frame = CGRect.init(x: 0, y: 50, width: kScreenWidth, height: headerView.bounds.height - 50)


        let formsView: UIView = UIView.init()
        formsView.backgroundColor = ThemeColor.blackWhiteDrawColor//drawColor
        formsView.layer.cornerRadius = 8
        formsView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        formsView.layer.shadowColor = ThemeColor.blackWhiteFontColor.cgColor//UIColor.white.cgColor
        formsView.layer.shadowOpacity = 1
        headerView.addSubview(formsView)
        formsView.frame = CGRect.init(x: 15, y: 15, width: kScreenWidth - 15 * 2, height: headerView.bounds.height - 15 * 2)

        self.reportFormsView = ReportFormsView.init(frame: CGRect.init(x: 0, y: 80, width: formsView.frame.width, height: formsView.frame.height - 70 - 10))
        formsView.addSubview(self.reportFormsView ?? UIView.init())

        formsView.addSubview(self.spendingSelectView)
        self.spendingSelectView.frame = CGRect.init(x: 18, y: 10, width: 150, height: 60)

        formsView.addSubview(self.incomeSelectView)
        self.incomeSelectView.frame = CGRect.init(x: self.spendingSelectView.frame.maxX + 25, y: 10, width: 150, height: 60)

        weak var weakSelf = self
        self.spendingSelectView.selectedCallback(callback: { (flag) in
            weakSelf?.incomeSelectView.isSelected = false
            weakSelf?.spendingSelectView.isSelected = true


            if weakSelf?.type == TallyType.monthlyIncome{
                weakSelf?.type = TallyType.monthlySpending
            }else if weakSelf?.type == TallyType.monthlySpending{
                weakSelf?.type = TallyType.monthlySpending
            }else if weakSelf?.type == TallyType.yearlyIncome{
                weakSelf?.type = TallyType.yearlySpending
            }else{
                weakSelf?.type = TallyType.yearlySpending
            }

            weakSelf?.loadData()

        })

        self.incomeSelectView.selectedCallback(callback: { (flag) in
            weakSelf?.incomeSelectView.isSelected = true
            weakSelf?.spendingSelectView.isSelected = false

            if weakSelf?.type == TallyType.monthlySpending{
                weakSelf?.type = TallyType.monthlyIncome
            }else if weakSelf?.type == TallyType.monthlyIncome{
                weakSelf?.type = TallyType.monthlyIncome
            }else if weakSelf?.type == TallyType.yearlySpending{
                weakSelf?.type = TallyType.yearlyIncome
            }else{
                weakSelf?.type = TallyType.yearlyIncome
            }

            weakSelf?.loadData()
        })

        return aTableView
    }()

    lazy var quickDateSelectView: DateSelectView = {
        let aDateSelectView: DateSelectView = DateSelectView.init()
        return aDateSelectView
    }()
    
    var refreshControl = UIRefreshControl()

    //MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        setupUI();

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

    private func setupUI() -> Void {

        self.navigationController?.navigationBar.isHidden = true

        let oneView = UIView.init()
        oneView.backgroundColor = ThemeColor.blackWhiteThemeColor//themeColor
        self.view.addSubview(oneView)
        oneView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(44 + 60 + kNavigationHeight)
        }

        let titleLabel = UILabel.init()
        titleLabel.text = "年 · 月账单图表"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = ThemeColor.blackWhiteFontColor//UIColor.white
        oneView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(kStatusBarHeight)
            make.height.equalTo(44)
        }

        oneView.addSubview(self.dateSelectView)
        dateSelectView.backgroundColor = ThemeColor.blackWhiteDateColor//cellColor
        dateSelectView.layer.cornerRadius = 8
        self.dateSelectView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(50)
        }
        
        let twoView: UIView = UIView.init()
        twoView.layer.contents = UIImage(named: "蜗牛4")?.cgImage
        twoView.layer.cornerRadius = 8
        self.view.addSubview(twoView)
        twoView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(dateSelectView.snp.top).offset(14)
            make.width.equalTo(45)
            make.height.equalTo(50)
        }

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(oneView.snp.bottom).offset(-50)
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
        }

        self.view.addSubview(self.quickDateSelectView)
        self.quickDateSelectView.snp.makeConstraints { (make) in
            make.top.equalTo(oneView.snp.bottom).offset(-50)
            make.left.right.bottom.equalTo(0)
        }
        self.quickDateSelectView.isHidden = true

        weak var weakSelf = self;
        self.dateSelectView.selectedDateCallback { (year, month) in

            if month == 0{
                if self.type == .yearlySpending{
                    self.type = .yearlySpending
                }else if self.type == .monthlySpending{
                    self.type = .yearlySpending
                }else if self.type == .yearlyIncome{
                    self.type = .yearlyIncome
                }else{
                    self.type = .yearlyIncome
                }
            }else{
                if self.type == .yearlySpending{
                    self.type = .monthlySpending
                }else if self.type == .monthlySpending{
                    self.type = .monthlySpending
                }else if self.type == .yearlyIncome{
                    self.type = .monthlyIncome
                }else{
                    self.type = .monthlyIncome
                }
            }
            weakSelf?.loadData()
        }

        self.dateSelectView.selectYearCallback { (year, month) in

            if weakSelf?.quickDateSelectView.isHidden == false{
                weakSelf?.quickDateSelectView.dismiss()
                if month != 0{
                    weakSelf?.dateSelectView.tableView.isHidden = false
                }
            }else{
                weakSelf?.quickDateSelectView.show(year: year, month: month)
            }

        }

        self.quickDateSelectView.showYear { (year) in
            weakSelf?.dateSelectView.yearLabel?.text = String(format: "%d年", year)
        }

        self.quickDateSelectView.didSelected { (year, month) in
            weakSelf?.dateSelectView.setDate(year: year, month: month)

            if month == 0{
                weakSelf?.spendingSelectView.titleLabel.text = "💰本年支出："
                weakSelf?.incomeSelectView.titleLabel.text = "👏本年收入："
            }else{
                weakSelf?.spendingSelectView.titleLabel.text = "💰本月支出："
                weakSelf?.incomeSelectView.titleLabel.text = "👏本月收入："
            }
        }

        self.quickDateSelectView.cancel { (year, month) in
            if month != 0{
                weakSelf?.dateSelectView.tableView.isHidden = false
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "账单已更新")
        refreshControl.backgroundColor = ThemeColor.blackWhiteThemeColor
        self.tableView.addSubview(refreshControl)

    }
    
    @objc func refreshData() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }

    //MARK: - LoadData

    func loadData() -> Void {

        let date: String = self.date
        let type: TallyType = self.type

        if date.count < 4 {
            return
        }

        let sqlManager: SqlManager = SqlManager.shareInstance
        var spendingSummary: Summary?
        var incomeSummary: Summary?

        switch type {
            case .monthlySpending:
                spendingSummary =  sqlManager.query(userid: "00000000", tallyType: 1, summaryType: 1, date: date) ?? Summary.init()
                incomeSummary =  sqlManager.query(userid: "00000000", tallyType: 2, summaryType: 1, date: date) ?? Summary.init()
                break
            case .monthlyIncome:
                spendingSummary =  sqlManager.query(userid: "00000000", tallyType: 1, summaryType: 1, date: date) ?? Summary.init()
                incomeSummary =  sqlManager.query(userid: "00000000", tallyType: 2, summaryType: 1, date: date) ?? Summary.init()
                break
            case .yearlySpending:
                spendingSummary =  sqlManager.query(userid: "00000000", tallyType: 1, summaryType: 2, date: date) ?? Summary.init()
                incomeSummary =  sqlManager.query(userid: "00000000", tallyType: 2, summaryType: 2, date: date) ?? Summary.init()
                break
            case .yearlyIncome:
                spendingSummary =  sqlManager.query(userid: "00000000", tallyType: 1, summaryType: 2, date: date) ?? Summary.init()
                incomeSummary =  sqlManager.query(userid: "00000000", tallyType: 2, summaryType: 2, date: date) ?? Summary.init()
                break
        }

        self.spendingSelectView.amountLabel.text = String(format: "￥%@", spendingSummary?.totalamount ?? "0.00")
        self.incomeSelectView.amountLabel.text = String(format: "￥%@", incomeSummary?.totalamount ?? "0.00")

        let summary: Summary?
        if type == .monthlyIncome || type == .yearlyIncome {
            summary = incomeSummary
        }else{
            summary = spendingSummary
        }
        self.summary = summary

        let array: Array<ConsumeType> = sqlManager.consumetype_query(pid: summary?.id ?? 0)
        let sortArray: Array<ConsumeType> = array.sorted { (now: ConsumeType, last: ConsumeType) -> Bool in
            if Double.init(now.keyValue ?? "") ?? 0.00 > Double.init(last.keyValue ?? "") ?? 0.00{
                return true
            }
            return false
        }

        self.list.removeAll()
        var reportFormsViewParams: Array<Any> = Array.init()
        var angle: Double = self.reportFormsView?.startAngle ?? -180.00
        for consumeType: ConsumeType in sortArray{

            if Double.init(consumeType.keyValue ?? "") == 0.00{
                continue
            }

            let startAngle: Double = angle

            let scale: Double = (Double.init(consumeType.keyValue ?? "") ?? 0.00)/(Double.init(summary?.totalamount ?? "1") ?? 1.00)

            let reportFormsModel: ReportFormsModel = ReportFormsModel.init()
            reportFormsModel.consumeType = consumeType
            reportFormsModel.scale = scale
            if self.type == TallyType.yearlySpending || self.type == TallyType.monthlySpending{
                reportFormsModel.type = 1
            }else{
                reportFormsModel.type = 2
            }
            self.list.append(reportFormsModel)

            /*
            if scale < 0.035{
                otherScale += scale
                continue
            }
            */

            let endAngle: Double = angle - scale * 360

            var value1: UInt32 = arc4random() % 255
            var value2: UInt32 = arc4random() % 255
            let value3: UInt32 = arc4random() % 255
            if type == .monthlyIncome || type == .yearlyIncome{
//                value1 = arc4random() % 100
                value2 = arc4random() % (255 - 180) + 180
            }else{
                value1 = arc4random() % (255 - 180) + 180
//                value2 = arc4random() % 100
            }

            let color: UIColor = UIColor.init(red: CGFloat(value1) / 255.0, green: CGFloat(value2) / 255.0, blue: CGFloat(value3) / 255.0, alpha: 1.0)

            let text: String = String(format: "%@  %d%%", consumeType.keyName ?? "", lroundf(Float(Double.init(scale * 100))))

            /*
            let dic: Dictionary = ["startAngle": startAngle, "endAngle": endAngle, "color": color, "text" : text] as [String : Any]
            reportFormsViewParams.append(dic)
            */

            let params: ReportFormsViewParameters = ReportFormsViewParameters.init()
            params.startAngle = startAngle
            params.endAngle = endAngle
            params.color = color
            params.text = text
            params.scale = scale
            reportFormsViewParams.append(params)

            angle = endAngle

        }

        /*
        if otherScale > 0 {

            let startAngle: Double = angle
            let endAngle: Double = angle - otherScale * 360

            let value1: UInt32 = arc4random() % 255
            let value2: UInt32 = arc4random() % 150
            let value3: UInt32 = arc4random() % 150
            let color: UIColor = UIColor.init(red: CGFloat(value1) / 255.0, green: CGFloat(value2) / 255.0, blue: CGFloat(value3) / 255.0, alpha: 1.0)

            let text: String = String(format: "其它 %d%%", lroundf(Float(Double.init(otherScale * 100))))

            let dic: Dictionary = ["startAngle": startAngle, "endAngle": endAngle, "color": color, "text" : text] as [String : Any]
            reportFormsViewParams.append(dic)

        }
        */

        self.reportFormsView?.params = reportFormsViewParams
        self.tableView.reloadData()

    }
    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let reportFormsModel: ReportFormsModel = list[indexPath.row]

        let listVC: ListViewController = ListViewController.init()
        listVC.hidesBottomBarWhenPushed = false
        listVC.consumeType = reportFormsModel.consumeType
        listVC.summary = self.summary
        self.navigationController?.pushViewController(listVC, animated: true)

    }

    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ReportFormsTableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReportFormsTableViewCell
        cell.reportFormsModel = list[indexPath.row]
        return cell

    }
}

