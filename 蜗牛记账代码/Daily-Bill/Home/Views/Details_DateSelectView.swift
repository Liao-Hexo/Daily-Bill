//
//  Details_DateSelectView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/20.
//

import UIKit

@objc protocol Details_DateSelectViewDelegate: NSObjectProtocol{
    @objc optional func ok(_ datePicker: Details_DateSelectView, date: Date)
    @objc optional func selected(_ datePicker: Details_DateSelectView) -> Date
}


class Details_DateSelectView: UIView, CustomDatePickerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var picker: CustomDatePicker?
    weak var delegate: Details_DateSelectViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI(frame: CGRect) -> Void {

        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        let picker: CustomDatePicker = CustomDatePicker.init(frame: CGRect.init(x: 0, y: frame.height - 260, width: kScreenWidth, height: 260))
        picker.type = CustomDatePicker.CustomDatePickerType.yearsAndMonths
        picker.delegate = self
        self.addSubview(picker)
        self.picker = picker

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapGesAction(tap:)))
        self.addGestureRecognizer(tap)
    }


    func hiddenDatePicker() -> Void {

       UIView.animate(withDuration: 0.2, animations: {
            var frame: CGRect = self.picker?.frame ?? CGRect.zero
            frame.origin.y = self.frame.height
            self.picker?.frame = frame
        }) { (flag) in
            self.removeFromSuperview()
        }

    }

    @objc func tapGesAction(tap: UITapGestureRecognizer) -> Void {
        hiddenDatePicker()
    }

     // MARK: - Responder

//    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//
//        if point.y < self.frame.height - (self.picker?.frame ?? CGRect.zero).height - 5 && point.y >= 0{
//            return self
//        }
//        return super.hitTest(point, with: event)
//    }

     // MARK: - CustomDatePickerDelegate

    func cancel(_ datePicker: CustomDatePicker) {
        hiddenDatePicker()
    }

    func ok(_ datePicker: CustomDatePicker, date: Date) {
        hiddenDatePicker()
        self.delegate?.ok!(self, date: date)
    }

    func selected(_ datePicker: CustomDatePicker) -> Date {
        return self.delegate?.selected!(self) ?? Date.init()
    }

}

