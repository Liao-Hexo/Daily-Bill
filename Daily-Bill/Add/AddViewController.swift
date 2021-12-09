//
//  AddViewController.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/19.
//

import UIKit

@objc protocol AddViewControllerDelegate: NSObjectProtocol{
    @objc optional func addComplete(tally: TallyModel)
}



class AddViewController: UIViewController, ConsumeTypeViewDelegate, KeyboardViewDelegate, RemarkViewDelegate, DateShownViewDelegate, SelectDateViewDelegate, Add_InputAmountViewDelegate {

    enum MovementSpaceType {
        case increasingY
        case pointY
    }
    
     // MARK: - Property
    
    var tallyModel: TallyModel?
    weak var delegate: AddViewControllerDelegate?

    private var spendingModel: ConsumeTypeModel?
    private var incomeModel: ConsumeTypeModel?
    private var consumeTypeView: ConsumeTypeView?
    private var topView: AddTopView?
    private var keyboardView: KeyboardView?
    private var inputAmountView: Add_InputAmountView?
    private var remarkView: RemarkView?
    private var isSwitchFirstResponder: Bool = true
    private var selectDateView: SelectDateView?
    
    private lazy var datePicker: DateShownView = {
        let dateShown: DateShownView = DateShownView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 350))
        dateShown.delegate = self
        return dateShown
    }()
    
     // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        loadData()
    }
    

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: UITouch in touches {
            
            let length: CGFloat = touch.location(in: UIApplication.shared.delegate?.window ?? UIView.init()).y - touch.previousLocation(in: UIApplication.shared.delegate?.window ?? UIView.init()).y
            movement(value: length, type: MovementSpaceType.increasingY)
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movementEnd()
    }
    
    
    

     // MARK: - SetupUI
    
    func setupUI() -> Void {
                
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = themeColor
        
        let topView:AddTopView = AddTopView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kNavigationHeight))
        self.navigationController?.view.addSubview(topView)
        topView.backBtnCallback {
            self.isSwitchFirstResponder = false
            self.dismiss(animated: true, completion: {
                
            })
        }
        topView.segmentCallback { (index: Int) in
            
            if index == 0{
              self.consumeTypeView?.loadData(aConsumeType: self.spendingModel, talleyType: TallyModel.TalleyType.spending)
            }else{
              self.consumeTypeView?.loadData(aConsumeType: self.incomeModel, talleyType: TallyModel.TalleyType.income)
            }
 
        }
        self.topView = topView
        
        let selectDateView: SelectDateView = SelectDateView.init(frame: CGRect.init(x: 0, y: topView.frame.maxY, width: 220, height: 50))
        selectDateView.delegate = self
        selectDateView.layer.cornerRadius = 8
        self.view.addSubview(selectDateView)
        self.selectDateView = selectDateView
        
        let inputAmountView: Add_InputAmountView = Add_InputAmountView.init(frame: CGRect.init(x: selectDateView.frame.maxX, y: topView.frame.maxY, width: kScreenWidth - selectDateView.frame.maxX, height: 50))
        inputAmountView.delegate = self
        inputAmountView.layer.cornerRadius = 8
        self.view.addSubview(inputAmountView)
        self.inputAmountView = inputAmountView
        
//        let lineView: UIView = UIView.init()
//        lineView.backgroundColor = .red//UIColor.init(red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
//        self.view.addSubview(lineView)
//        lineView.frame = CGRect.init(x: 0, y: inputAmountView.frame.maxY, width: kScreenWidth, height: 10)
        
        let consumeTypeView: ConsumeTypeView = ConsumeTypeView.init(frame: CGRect.init(x: 0, y: inputAmountView.frame.maxY, width: kScreenWidth, height: 290)) //150
        consumeTypeView.delegate = self
        self.view.addSubview(consumeTypeView)
        self.consumeTypeView = consumeTypeView
        
        //RemarkView
//        let remarkView: RemarkView = RemarkView.init(frame: CGRect.init(x: selectDateView.frame.maxX + 10, y: consumeTypeView.frame.maxY + 5, width: kScreenWidth - selectDateView.frame.maxX - 10 - 10, height: 30))
//        remarkView.delegate = self
//        self.view.addSubview(remarkView)
//        self.remarkView = remarkView
        
        let keyboardHeight: CGFloat = autoScaleNomarl(value: 220)
        let keyboard: KeyboardView = KeyboardView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: keyboardHeight))
        keyboard.delegate = self
        self.keyboardView = keyboard

        let inputView: UIView = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight - keyboardHeight - kBottomSafeAreaHeight, width: kScreenWidth, height: keyboardHeight + kBottomSafeAreaHeight))
        inputView.addSubview(keyboard)

        let safeArea: UIView = UIView.init(frame: CGRect.init(x: 0, y: keyboardHeight, width: kScreenWidth, height: kBottomSafeAreaHeight))
        inputView.addSubview(safeArea)

        self.inputAmountView?.setInputView(aInputView: inputView)
        
        
    }
    
     // MARK: - LoadData
    
    func loadData() -> Void {
        
        if self.tallyModel == nil {
            
            self.tallyModel = TallyModel.init()
            self.tallyModel?.amount = "0.00"
            
            let format: DateFormatter = DateFormatter.init()
            format.dateFormat = "yyyyMMdd"
            let nowDate: Date = Date.init()
            let nowDateString = format.string(from: nowDate)
            
            self.tallyModel?.date = nowDateString
            
            self.consumeTypeView?.loadData(aConsumeType: nil, talleyType: TallyModel.TalleyType.spending)
            
            
        }else{
            
            self.consumeTypeView?.loadData(aConsumeType: self.tallyModel?.consumeType, talleyType: self.tallyModel?.consumeType?.tallyType ?? TallyModel.TalleyType.spending)
            
            if self.tallyModel?.consumeType?.tallyType == TallyModel.TalleyType.income{
                self.topView?.setSegmentIndex(index: 1)
                self.incomeModel = self.tallyModel?.consumeType
            }else{
                self.spendingModel = self.tallyModel?.consumeType
            }
            
            self.inputAmountView?.setAmount(amount: self.tallyModel?.amount ?? "0.00")
            
            let format: DateFormatter = DateFormatter.init()
            format.dateFormat = "yyyyMMdd"
            let nowDate: Date = format.date(from: self.tallyModel?.date ?? "") ?? Date.init()
            format.dateFormat = "yyyy/MM/dd"
            let nowDateString = format.string(from: nowDate)
            self.selectDateView?.setTitle(title: nowDateString)
            
            self.remarkView?.setText(text: self.tallyModel?.remark ?? "")
            
        }
        
    }
    
    
     // MARK: - ConsumeTypeViewDelegate
    
    func consumeTypeViewPanGesture(ges: UIPanGestureRecognizer) {
        
        switch ges.state {
        case .changed:
            
            let point: CGPoint = ges.translation(in: self.view)
            movement(value: point.y, type: MovementSpaceType.pointY)
            
            break
        case .ended:
            movementEnd()
            break
        default: break
            
        }
        
    }
    
    func consumeTypeView(didSelected consumeType: ConsumeTypeModel) {
        
        if consumeType.tallyType == TallyModel.TalleyType.spending{
            self.spendingModel = consumeType
        }else{
            self.incomeModel = consumeType
        }
        
        self.tallyModel?.consumeType = consumeType
        
    }
    
     // MARK: - Methods
    
    func movement(value: CGFloat, type: MovementSpaceType) -> Void {
        
        var frame: CGRect = self.view.frame
        
        if frame.origin.y > 0 {
            
            if type == MovementSpaceType.increasingY {
                frame.origin.y += value
            }
            
            if type == MovementSpaceType.pointY {
                frame.origin.y = value
            }
            
            var topViewFrame: CGRect = self.topView?.frame ?? CGRect.zero
            topViewFrame.origin.y = frame.origin.y
            self.topView?.frame = topViewFrame
            
            let hostView: UIView = movementBottomView()
            var keyboardFrame: CGRect = hostView.frame
            if frame.origin.y > kScreenHeight - keyboardFrame.height - 150   {
                keyboardFrame.origin.y = frame.origin.y + 150
            }else{
                keyboardFrame.origin.y = kScreenHeight - keyboardFrame.height
            }
            hostView.frame  = keyboardFrame

            
        }else{
            
            let decrease: CGFloat = 1 + (frame.origin.y / frame.height)
            
            if type == MovementSpaceType.increasingY {
                frame.origin.y += value * decrease * 0.6
            }
            
            if type == MovementSpaceType.pointY {
                frame.origin.y = value * decrease
            }
            
            var topViewFrame: CGRect = self.topView?.frame ?? CGRect.zero
            topViewFrame.origin.y = 0
            self.topView?.frame = topViewFrame
            
        }
        
        self.view.frame = frame
        
    }
    
    func restoreMovement() -> Void {
        
        var frame: CGRect = self.view.frame
        frame.origin.x = 0
        frame.origin.y = 0
        self.view.frame = frame
        
        var topViewFrame: CGRect = self.topView?.frame ?? CGRect.zero
        topViewFrame.origin = CGPoint.zero
        self.topView?.frame = topViewFrame
        
        let  hostView: UIView = movementBottomView()
        var keyboardFrame: CGRect = hostView.frame
        keyboardFrame.origin.y = kScreenHeight - keyboardFrame.height
        hostView.frame  = keyboardFrame
        
    }
    
    func movementEnd() -> Void {
        
        let frame: CGRect = self.view.frame
        if frame.origin.y > kScreenHeight / 2.5 {
            self.navigationController?.view.backgroundColor = UIColor.clear
            self.isSwitchFirstResponder = false
            self.view.endEditing(true)
            self.dismiss(animated: true) {
                
            }
        }else{
            self.restoreMovement()
        }

        
    }
    
    func getHostView() -> UIView {
        
        
        var hostView: UIView?
        var containerView: UIView?
        let windowsArray =  UIApplication.shared.windows

        for window: UIWindow in windowsArray {

            let subArray = window.subviews

            for view: UIView in subArray {
                if view.description.hasPrefix("<UIInputSetContainerView"){
                    containerView = view
                    break
                }
            }

        }
        
        hostView = containerView?.subviews.first
        
        return hostView ?? UIView.init()
        
        
    }
    
    func getAmount() -> String {
        
        var amount: String = self.inputAmountView?.inputTFEditingResult() ?? "0.00"
        if amount.first == "-" {
            amount.removeFirst()
        }
        return amount
    }
    
    func tallyComplete() -> Void {
        
        self.tallyModel?.amount = self.getAmount()
        
        self.delegate?.addComplete!(tally: self.tallyModel ?? TallyModel.init())
        
        self.dismiss(animated: true) {
        }
        
    }
    
    func showDatePicker() -> Void {
        
        var frame: CGRect = self.datePicker.frame
        frame.origin.y = self.navigationController?.view.frame.height ?? kScreenHeight
        self.datePicker.frame = frame
        
        if !(self.navigationController?.view.subviews.contains(self.datePicker))! {
            self.navigationController?.view.addSubview(self.datePicker)
        }
        
        UIView.animate(withDuration: 0.2) {
            var frame: CGRect = self.datePicker.frame
            frame.origin.y = (self.navigationController?.view.frame.height ?? kScreenHeight) - frame.height
            self.datePicker.frame = frame
        }
        
    }
    
    func hiddenDatePicker() -> Void {
        
        if  (self.navigationController?.view.subviews.contains(self.datePicker))! {
            
            var frame: CGRect = self.datePicker.frame
            if frame.origin.y < (self.navigationController?.view.frame.height ?? kScreenHeight){

                UIView.animate(withDuration: 0.2) {

                }
                
                UIView.animate(withDuration: 0.2, animations: {
                    frame.origin.y = self.navigationController?.view.frame.height ?? kScreenHeight
                    self.datePicker.frame = frame
                }) { (flag) in
                    if flag {
                        self.datePicker.removeFromSuperview()
                    }
                }
                
            }
            
            
        }
        
    }
    
    func datePickerIsShown() -> Bool {
        
        if !(self.remarkView?.tvIsFirstResponder() ?? true) && !(self.inputAmountView?.tfIsFirstResponder())! && self.datePicker.superview != nil {
            return true
        }
        
        return false
    }
    
    func movementBottomView() -> UIView {
        
        if datePickerIsShown() {
            return self.datePicker
        }
        return getHostView()
        
    }
    
    
     // MARK: - KeyboardViewDelegate
    
    func keyboardHandler(title: String, key: Key.KeyNumber) {
        
        switch key {
        case .delete:
            self.inputAmountView?.deleteInputTF()
           break
        case .done:
            if (self.getAmount() as NSString).floatValue > 0.00 {
                tallyComplete()
                return
            }else{
                self.remarkView?.tvBecomeFirstResponder()
            }
            break
        case .equal:
            self.inputAmountView?.inputTFEditingResult()
            break
        default:
            self.inputAmountView?.inputTF(append: title)
            break
        }
        
    }
    
     // MARK: - RemarkViewDelegate
    
    func remarkTV(beginEditing textView: UITextView) {
        self.isSwitchFirstResponder = true
        hiddenDatePicker()
    }
    
    func remarkTV(endEditing textView: UITextView) {
    
        if self.isSwitchFirstResponder{
            self.inputAmountView?.tfBecomeFirstReponder()
        }
        
    }
    
    func remarkTV(editingComplete: UITextView) {
        
        self.tallyModel?.remark = editingComplete.text
        
        if (self.getAmount() as NSString).floatValue > 0 {
            self.isSwitchFirstResponder = false
            tallyComplete()
        }else{
            self.isSwitchFirstResponder = true
        }
        
    }
    
     // MARK: - DateShownViewDelegate
    
    func cancel(_ dateShown: DateShownView) {
        
        self.isSwitchFirstResponder = true
        hiddenDatePicker()
        self.remarkView?.tvBecomeFirstResponder()
        
    }
    
    func ok(_ dateShown: DateShownView, date: Date) {
        
        self.isSwitchFirstResponder = true
        hiddenDatePicker()
        self.remarkView?.tvBecomeFirstResponder()
//
        let format: DateFormatter = DateFormatter.init()
        format.dateFormat = "yyyy.MM.dd"
        let dateString: String = format.string(from: date)
//        let nowDate: Date = Date.init()
//        let nowDateString = format.string(from: nowDate)

        self.selectDateView?.setTitle(title: dateString)
//        if dateString == nowDateString {
//            self.selectDateView?.setTitle(title: "今天")
//        }else{
//            self.selectDateView?.setTitle(title: dateString)
//        }

        format.dateFormat = "yyyyMMdd"
        let string = format.string(from: date)
        self.tallyModel?.date = string
        
        
    }
    
     // MARK: - SelectDateViewDelegate
    
    func clicked(_ selectDateView: SelectDateView) {
        
        self.isSwitchFirstResponder = false
        self.view.endEditing(true)
        showDatePicker()
        
    }
    
     // MARK: - Add_InputAmountViewDelegate
    
    func inputAmountView(beginEditing textField: UITextField) {
        self.isSwitchFirstResponder = true
        hiddenDatePicker()
    }
}
