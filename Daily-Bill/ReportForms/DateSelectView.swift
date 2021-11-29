//
//  DateSelectView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class DateSelectView: UIView,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private enum DateSelectType {
        case month
        case year
    }
    
    
    //MARK: - Property
    
    private var type: DateSelectType = .month
    private var selectedType: DateSelectType = .month
    private var _year: Int = Int(CalendarHelper.nowDateString(dateFormat: "yyyy")) ?? 2019
    private var year: Int{
        set{
            _year = newValue
            if self.showYearCallback != nil {
                self.showYearCallback?(newValue)
            }
        }
        get{
            return _year
        }
    }
    private let identifier: String = "identifier"
    private var collectionView: UICollectionView?
    private let years: Int = ReportFormsDateSelectView.years
    private var dataArray: Array<Any> = Array.init()
    private var showYearCallback: ((Int)->Void)?
    private var didSelectedCallback: ((Int, Int)->Void)?
    private var cancelCallback:((Int, Int)->Void)?
    private var segment: UISegmentedControl?
    private var contentView: UIView?
    
    var selectedMonth: Int = 1
    var selectedYear: Int = 2019
    
    //MARK: - Instance
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupUI()
        self.loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LoadData
    
    private func loadData() {
        
        if self.type == .month{
              self.dataArray = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        }else{
            self.dataArray = Array.init()
            var array: Array<Any> = Array.init()
            let current: Int = Int(CalendarHelper.nowDateString(dateFormat: "yyyy")) ?? 2019
            for i: Int in (0...(self.years-1)).reversed(){
                let year: Int = current - i
                array.append(String(format: "%d", year))
                if array.count == 12{
                    self.dataArray.append(array)
                    array = Array.init()
                }
            }
        }
        
        self.collectionView?.reloadData()
    }
    

    //MARK: - SetupUI
    
    private func setupUI() -> Void {
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        let contentView: UIView = UIView.init()
        contentView.backgroundColor = UIColor.white
        self.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(200)
        }
        self.contentView = contentView
        
        let items = ["月账单", "年账单"]
        let segment: UISegmentedControl = UISegmentedControl.init(items: items)
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        segment.addTarget(self, action: #selector(segmentBtnAction(aSegment:)), for: UIControl.Event.valueChanged)
        contentView.addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.equalTo(200)
            make.height.equalTo(25)
            make.top.equalTo(20)
        }
        self.segment = segment
        
        let leftBtn: UIButton = UIButton.init()
        leftBtn.setImage(UIImage.init(named: "左箭头"), for: UIControl.State.normal)
        leftBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        leftBtn.addTarget(self, action: #selector(leftBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        contentView.addSubview(leftBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(segment.snp.bottom).offset(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(30)
        }
        
        let rightBtn: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        rightBtn.setImage(UIImage.init(named: "右箭头"), for: UIControl.State.normal)
        rightBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        rightBtn.addTarget(self, action: #selector(rightBtnAction(aBtn:)), for: UIControl.Event.touchUpInside)
        contentView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(leftBtn.snp.top)
            make.bottom.equalTo(leftBtn.snp.bottom)
            make.width.equalTo(leftBtn.snp.width)
        }
        
        let layout: DateShowCollectionViewFlowLayout = DateShowCollectionViewFlowLayout.init()
        let collectionView: UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right).offset(5)
            make.top.equalTo(segment.snp.bottom).offset(15)
            make.right.equalTo(rightBtn.snp.left).offset(-5)
            make.bottom.equalTo(-15)
        }
        collectionView.register(UINib.init(nibName: "DateShowCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: identifier)
        self.collectionView = collectionView
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        self.addGestureRecognizer(tap)
        
        
    }
    
    //MARK: - Responder
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event){
            if point.y < 200{
                if super.hitTest(point, with: event) == self.contentView{
                    return UIView.init()
                }else{
                    return super.hitTest(point, with: event)
                }
            }else{
                return super.hitTest(point, with: event)
            }
        }
        return super.hitTest(point, with: event)
    }
   
    
    //MARK: - Actions
    
    @objc private func tapGesAction(tap: UITapGestureRecognizer) {
        self.dismiss()
        if self.type == .month{
           self.cancelCallback?(self.selectedYear, self.selectedMonth)
        }else{
           self.cancelCallback?(self.selectedYear, 0)
        }
    }
    
    
    @objc private func segmentBtnAction(aSegment: UISegmentedControl){
        
        if aSegment.selectedSegmentIndex == 0{
            self.type = .month
        }

        if aSegment.selectedSegmentIndex == 1{
            self.type = .year
            if self.showYearCallback != nil {
                self.showYearCallback?(self.selectedYear)
            }
        }
        
        self.loadData()
        self.scrollToSelected()
    }
    
    @objc private func leftBtnAction(aBtn: UIButton){
        
        if self.collectionView?.contentOffset.x ?? 0 > self.collectionView?.frame.width ?? 0{
            
            let scale:Int  = lround(Double(Float((self.collectionView?.contentOffset.x ?? 0)/(self.collectionView?.frame.width ?? 0))))
            
            if scale > 0{
                let x: CGFloat = CGFloat(scale - 1) * (self.collectionView?.frame.width ?? 0)
                self.collectionView?.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)
            }
            
        }
        
    }
    
    @objc private func rightBtnAction(aBtn: UIButton){
        
        
        let max: CGFloat = (self.collectionView?.contentSize.width ?? 0) - (self.collectionView?.frame.width ?? 0) * 1.5
        if self.collectionView?.contentOffset.x ?? 0 < max{
            
            let scale:Int  = lround(Double(Float((self.collectionView?.contentOffset.x ?? 0)/(self.collectionView?.frame.width ?? 0))))
            
            let x: CGFloat = CGFloat(scale + 1) * (self.collectionView?.frame.width ?? 0)
            self.collectionView?.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)

        }
        

        
    }
    
    private func scrollToSelected() {
        
        if self.type == .month {
            let currentYear: Int = Int(CalendarHelper.nowDateString(dateFormat: "yyyy")) ?? 2019
            let x = CGFloat(self.years - currentYear + self.selectedYear - 1) * (self.collectionView?.frame.width ?? 0.00)
            self.collectionView?.setContentOffset(CGPoint.init(x: x , y: 0), animated: false)
        }else{
            
        
            var index: Int = 0
            for i: Int in 0...(self.dataArray.count-1){
                
                let element = self.dataArray[i]
                if element is Array<Any>{
                    let array: Array<String> = self.dataArray[i] as! Array<String>
                    let flag: Bool = false
                    for year: String in array{
                        if Int.init(year) == self.selectedYear{
                            index = i
                            break
                        }
                    }
                    if flag{
                        break
                    }
                }
                
               
            }
            
            let x = CGFloat(index) * (self.collectionView?.frame.width ?? 0.00)
            self.collectionView?.setContentOffset(CGPoint.init(x: x , y: 0), animated: false)
            
        }
        
    }
    
    func showYear(callback: @escaping ((Int)->Void)) {
        self.showYearCallback = callback;
    }
    
    
    func show(year: Int, month: Int) -> Void {
        
        self.isHidden = false
        
        if month == 0{
            self.type = .year
            self.selectedYear = year
            self.segment?.selectedSegmentIndex = 1
        }else{
            self.type = .month
            self.selectedYear = year
            self.selectedMonth = month
            self.segment?.selectedSegmentIndex = 0
        }
        
        self.loadData()
        self.scrollToSelected()
      
    }
    
    func dismiss() -> Void {
        self.isHidden = true
    }
    
    func didSelected(callback:@escaping (Int, Int)->Void) -> Void {
        self.didSelectedCallback = callback
    }
    
    func cancel(handler:@escaping((Int, Int)->Void)) -> Void {
        self.cancelCallback = handler
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.type == .month{
            let currentYear: Int = Int.init(CalendarHelper.nowDateString(dateFormat: "yyyy")) ?? 2019
            if scrollView.contentOffset.x == 0{
                self.year = currentYear - self.years + 1
            }else{
                
                self.year = currentYear - (self.years - lroundf(Float(scrollView.contentOffset.x / scrollView.frame.width))) + 1
            }
        }
        
    }
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - UICollectionViewDelegate
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.type == .month{
            return self.years
        }else{
            return self.dataArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DateShowCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! DateShowCollectionViewCell
        cell.clearSelected()
        if self.type == .month {
            /*
            if indexPath.row == self.years - 1{
                var array: Array<String> = Array.init()
                for i: Int in 1...12{
                    if i <= (Int.init(CalendarHelper.nowDateString(dateFormat: "MM")) ?? 0){
                        array.append(String(format: "%d", i))
                    }else{
                        array.append("")
                    }
                }
                cell.data = array
            }else{
                cell.data = self.dataArray as! Array<String>
            }
            */
            
            cell.data = self.dataArray as! Array<String>
            if indexPath.row == self.years - 1{
                cell.canSelect(number: Int.init(CalendarHelper.nowDateString(dateFormat: "MM")) ?? 0)
            }else{
                cell.canSelect(number: 12)
            }
            
            if self.selectedType == .month{
                let currentYear: Int = Int.init(CalendarHelper.nowDateString(dateFormat: "yyyy")) ?? 2019
                if currentYear - (self.years - indexPath.row - 1) == self.selectedYear{
                    cell.setSelected(index: self.selectedMonth - 1)
                }
            }
            
            
        }else{
            cell.data = self.dataArray[indexPath.row] as! Array<String>
            cell.canSelect(number: 12)
            
            if self.selectedType == .year{
                if cell.data.contains(String(format: "%d", self.selectedYear)){
                    let index: Int = cell.data.index(of: String(format: "%d", self.selectedYear)) ?? 0
                    cell.setSelected(index: index)
                }
            }
        }
        
        
        cell.clicked { (value) in
            if self.type == .month{
                self.selectedMonth = value
                self.selectedYear = self.year
                self.selectedType = .month
                if self.didSelectedCallback != nil{
                    self.didSelectedCallback?(self.selectedYear, self.selectedMonth)
                }
            }else{
                self.selectedYear = value
                self.selectedType = .year
                if self.didSelectedCallback != nil{
                    self.didSelectedCallback?(self.selectedYear, 0)
                }
            }
            self.dismiss()
        }
        
        return cell
    }

}
