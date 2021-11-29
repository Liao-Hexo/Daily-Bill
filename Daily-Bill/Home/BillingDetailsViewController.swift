//
//  BillingDetailsViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class BillingDetailsViewController: UIViewController, AddViewControllerDelegate {

     // MARK: - Property
    var detailLabel: UILabel?
    var cancleButton: UIButton?
    var dateLabel: UILabel?
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var amountLabel: UILabel?
    var imageBackView: UIView?
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

    let containerView: UIView = {
        $0.backgroundColor = UIColor.clear
        return $0
    }(UIView())

    let backgroudView = UIView()

     // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }


     // MARK: - SetupUI

    func setupUI() -> Void {

        self.view.backgroundColor = .clear

        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width * (316.0 / 375.0))
            make.height.equalTo(UIScreen.main.bounds.width * (280.0 / 375.0))
        }

        containerView.addSubview(backgroudView)
        backgroudView.backgroundColor = .white
        backgroudView.layer.cornerRadius = 8
        backgroudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let detailLabel: UILabel = UILabel.init()
        detailLabel.text = "详情"
        detailLabel.font = UIFont.systemFont(ofSize: 18)
        detailLabel.textColor = .black
        backgroudView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.height.equalTo(20)
        }
        self.detailLabel = detailLabel
        
        let cancleButton: UIButton = UIButton()
        cancleButton.setBackgroundImage(UIImage.init(named: "close"), for: .normal)
        backgroudView.addSubview(cancleButton)
        cancleButton.addTarget(self, action: #selector(cancel), for: UIControl.Event.touchUpInside)
        cancleButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(24)
        }

        let dateLabel: UILabel = UILabel.init()
        dateLabel.text = "2019年03月28日 星期四"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = UIColor.init(red: 160 / 255.0, green: 160 / 255.0, blue: 160 / 255.0, alpha: 1.0)
        backgroudView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        self.dateLabel = dateLabel


        let imageBackView_Width: CGFloat =  50
        let imageBackView: UIView = UIView.init()
        imageBackView.backgroundColor = themeColor
        imageBackView.layer.cornerRadius = imageBackView_Width / 2.0
        imageBackView.clipsToBounds = true
        backgroudView.addSubview(imageBackView)
        imageBackView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
            make.width.height.equalTo(imageBackView_Width)
        }
        self.imageBackView = imageBackView

        let photoView: UIImageView = UIImageView.init()
        photoView.image = UIImage.init(named: "餐饮high")
        imageBackView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.left.top.equalTo(5)
            make.bottom.right.equalTo(-5)
        }
        self.imageView = photoView


        let titleLabel: UILabel = UILabel.init()
        titleLabel.text = "支付"
        titleLabel.textColor = UIColor.init(red: 30 / 255.0, green: 30 / 255.0, blue: 30 / 255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        backgroudView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageBackView.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(imageBackView)
        }
        self.titleLabel = titleLabel

        let amountLabel: UILabel = UILabel.init()
        amountLabel.text = "13.00"
        amountLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 18)
        amountLabel.textAlignment = NSTextAlignment.right
        backgroudView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(-15)
            make.height.equalTo(30)
            make.centerY.equalTo(imageBackView)
        }
        self.amountLabel = amountLabel

        let bottom: BillingDetails_BottomView = BillingDetails_BottomView.init()
        backgroudView.addSubview(bottom)

        bottom.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(amountLabel.snp.bottom).offset(15)
        }

        bottom.delBtn {
            let alert = UIAlertController(title: "提示", message: "确定要删除该记录吗，一旦删除该记录将无法找回？", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: {_ in
                self.delHandler?(self.tallyModel)
//                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }

        bottom.editBtn {

            let addVC: AddViewController = AddViewController.init()
            addVC.delegate = self
            let addNavC: UINavigationController = UINavigationController.init(rootViewController: addVC)
            addVC.tallyModel = TallyModel.init(tallList: self.tallyModel)
            addNavC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            self.present(addNavC, animated: true, completion: {

            })

        }

    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

     // MARK: - LoadData

    func loadData() -> Void {

        let imageName: String = (_tallyModel?.consumeType ?? "餐饮").appending("high")
        self.imageView?.image = UIImage.init(named: imageName)
        self.titleLabel?.text = _tallyModel?.consumeType
        self.dateLabel?.text = String(format: "%@ %@", CalendarHelper.dateString(date: _tallyModel?.date ?? "00000000", originFromat: "yyyyMMdd", resultFromat: "yyyy年MM月dd日"), CalendarHelper.weekDay(dateString: _tallyModel?.date ?? "20190103" , format:"yyyyMMdd"))

        if _tallyModel?.tallyType == 1{
            self.amountLabel?.text = "-".appending(_tallyModel?.amount ?? "0.00")
            self.imageBackView?.backgroundColor = themeColor
        }else{
            self.amountLabel?.text = _tallyModel?.amount ?? "0.00"
            let highColor2: UIColor = UIColor.init(red: 0, green: 179 / 255.0, blue: 125 / 255.0, alpha: 1.0)
            self.imageBackView?.backgroundColor = highColor2
        }

    }

    func del(handler:@escaping ((TallyList)->Void)) -> Void {
        self.delHandler = handler
    }

    func edit(handler:@escaping ((String)->Void)) -> Void {
        self.editHandler = handler
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

}

