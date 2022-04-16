//
//  CustomDatePicker.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/20.
//

import UIKit


@objc protocol CustomDatePickerDelegate: NSObjectProtocol{
    @objc optional func cancel(_ datePicker: CustomDatePicker)
    @objc optional func ok(_ datePicker: CustomDatePicker, date: Date)
    @objc optional func selected(_ datePicker: CustomDatePicker) -> Date
}


class CustomDatePicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    public enum CustomDatePickerType {
        case years
        case yearsAndMonths
        case yearsAndMonthsAndDays
    }

     // MARK: - Property

    weak var delegate: CustomDatePickerDelegate?
    var years: NSMutableArray = NSMutableArray.init()
    var months: NSMutableArray = NSMutableArray.init()
    var days: NSMutableArray = NSMutableArray.init()
    var components: Int = 1
    var picker: UIPickerView?
    var okBtn: UIButton?

    private var _type: CustomDatePickerType = CustomDatePickerType.years
    var type: CustomDatePickerType{
        set{
            _type = newValue

            let date: Date = self.delegate?.selected!(self) ?? Date.init()
            switch _type {
            case .years:

                self.components = 1
                self.picker?.reloadAllComponents()
                let year = CalendarHelper.year(date: date)
                selectYear(year: year)

                break
            case .yearsAndMonths:
                self.components = 2
                self.picker?.reloadAllComponents()
                let year = CalendarHelper.year(date: date)
                let month = CalendarHelper.month(date: date)
                selectYear(year: year)
                selectMonth(month: month)

                break
            case .yearsAndMonthsAndDays:
                self.components = 3
                self.picker?.reloadAllComponents()
                let year = CalendarHelper.year(date: date)
                let month = CalendarHelper.month(date: date)
                let day = CalendarHelper.day(date: date)
                selectYear(year: year)
                selectMonth(month: month)
                selectDay(day: day)
                break
            }

        }
        get{
            return _type
        }
    }

     // MARK: - Responder

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        if point.y > 0 && point.y < 48 && point.x > self.frame.width / 2.0{
            return self.okBtn
        }

        return super.hitTest(point, with: event)
    }


     // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
        loadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


     // MARK: - SetupUI

    func setupUI(frame: CGRect) -> Void {

        let topView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: 35))
        topView.backgroundColor = themeColor
        self.addSubview(topView)

        let picker: UIPickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: topView.frame.maxY, width: topView.frame.width, height: frame.height - topView.frame.height))
        picker.backgroundColor = themeColor
        picker.overrideUserInterfaceStyle = .dark
        picker.delegate = self
        picker.dataSource = self
        self.addSubview(picker)
        self.picker = picker
        
        let cancelBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        cancelBtn.backgroundColor = themeColor
        cancelBtn.setTitle("取消选择", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        cancelBtn.tintColor = .white
        topView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.left.equalTo(10)
            make.bottom.equalToSuperview()
        }

        let okBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
        okBtn.backgroundColor = themeColor
        okBtn.setTitle("确认选择", for: .normal)
        okBtn.addTarget(self, action: #selector(okBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        okBtn.tintColor = .white
        topView.addSubview(okBtn)
        okBtn.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.height.equalTo(25)
            make.right.equalTo(-10)
            make.bottom.equalToSuperview()
        }
        self.okBtn = okBtn

    }

     // MARK: - LoadData

    func loadData() -> Void {

        let nowYear = CalendarHelper.nowDateString(dateFormat: "yyyy")

        let start = (nowYear as NSString).integerValue - 20
        for i: Int in (0 ... 39) {
            let year = String(format: "%ld", start + i)
            self.years.add(year)
        }

        for i: Int in (1...12){
            let month = String(format: "%02ld", i)
            self.months.add(month)
        }

    }

    func updateDays(month: String) -> Void {

        let days = CalendarHelper.days(month: month)
        for i: Int in (1 ... days){
            let day = String(format: "%ld", i)
            self.days.add(day)
        }

    }


    // MARK: - BtnActions

    @objc func cancelBtnAction(aBtn: UIButton) -> Void {

        if let delegate = self.delegate{
            delegate.cancel!(self)
        }

    }

    @objc func okBtnAction(aBtn: UIButton) -> Void {

        var date: Date?
        let yearIndex = self.picker?.selectedRow(inComponent: 0)
        let year: String = self.years.object(at: yearIndex ?? 0) as! String

        if self.type == CustomDatePickerType.years{
            date = CalendarHelper.date(dateString: year, dateFormat: "yyyy")
        }

        if self.type == CustomDatePickerType.yearsAndMonths{
            let monthIndex = self.picker?.selectedRow(inComponent: 1)
            let month: String = self.months.object(at: monthIndex ?? 0) as! String
            let dateString = year.appending(month)
            date = CalendarHelper.date(dateString: dateString, dateFormat: "yyyyMM")
        }

        if self.type == CustomDatePickerType.yearsAndMonthsAndDays{

            let monthIndex = self.picker?.selectedRow(inComponent: 1)
            let month: String = self.months.object(at: monthIndex ?? 0) as! String
            let dayIndex = self.picker?.selectedRow(inComponent: 2)
            let day: String = self.days.object(at: dayIndex ?? 0) as! String
            let dateString = year.appending(month).appending(day)
            date = CalendarHelper.date(dateString: dateString, dateFormat: "yyyyMMdd")

        }


        if let delegate = self.delegate {
            delegate.ok!(self, date: date ?? Date.init())
        }

    }

     // MARK: - Methods

    func selectYear(year: String) -> Void {

        if year.count != 4 {
            return
        }

        for element: String in self.years as! [String]{
            if element == year{
                let index = self.years.index(of: element)
                self.picker?.selectRow(index, inComponent: 0, animated: false)
                break
            }
        }

    }

    func selectMonth(month: String) -> Void {
        if month.count > 2{
            return
        }
        for element: String in self.months as! [String]{
            if (element as NSString).intValue == (month as NSString).intValue{
                let index = self.months.index(of: element)
                self.picker?.selectRow(index, inComponent: 1, animated: false)
                break
            }
        }
    }

    func selectDay(day: String) -> Void {
        if day.count > 2{
            return
        }
        for element: String in self.days as! [String]{
            if (element as NSString).intValue == (day as NSString).intValue{
                let index = self.days.index(of: element)
                self.picker?.selectRow(index, inComponent: 2, animated: false)
                break
            }
        }
    }


     // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35.00
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {


        switch component {
        case 0:
            return (self.years.object(at: row) as? String)?.appending("年")
        case 1:
            return (self.months.object(at: row) as? String)?.appending("月")
        case 2:
            let index = pickerView.selectedRow(inComponent: 1)
            updateDays(month: self.months.object(at: index) as! String)
            return (self.days.object(at: row) as? String)?.appending("日")
        default:
            return "2019"
        }


    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {



    }

     // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.components
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.years.count
        case 1:
            return self.months.count
        case 2:
            let index = pickerView.selectedRow(inComponent: 1)
            updateDays(month: self.months.object(at: index) as! String)
            return self.days.count
        default:
            return 0
        }
    }

}

