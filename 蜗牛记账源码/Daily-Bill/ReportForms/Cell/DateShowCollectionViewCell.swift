//
//  DateShowCollectionViewCell.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class DateShowCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Proterty
    
    @IBOutlet weak var oneLabel: DateShowLabel!
    @IBOutlet weak var twoLabel: DateShowLabel!
    @IBOutlet weak var threeLabel: DateShowLabel!
    @IBOutlet weak var fourLabel: DateShowLabel!
    @IBOutlet weak var fiveLabel: DateShowLabel!
    @IBOutlet weak var sixLabel: DateShowLabel!
    @IBOutlet weak var sevenLabel: DateShowLabel!
    @IBOutlet weak var eightLabel: DateShowLabel!
    @IBOutlet weak var nineLabel: DateShowLabel!
    @IBOutlet weak var tenLabel: DateShowLabel!
    @IBOutlet weak var elevenLabel: DateShowLabel!
    @IBOutlet weak var twelveLabel: DateShowLabel!
    
    var selectLabel: DateShowLabel?
    var handler: ((Int)->Void)?
    
    //MARK: - SetOrGet
    
    private var _data: Array<String> = Array.init()
    var data: Array<String>{
        set{
            _data = newValue
            if _data.count >= 12{
                oneLabel.text = _data[0]
                twoLabel.text = _data[1]
                threeLabel.text = _data[2]
                fourLabel.text = _data[3]
                fiveLabel.text = _data[4]
                sixLabel.text = _data[5]
                sevenLabel.text = _data[6]
                eightLabel.text = _data[7]
                nineLabel.text = _data[8]
                tenLabel.text = _data[9]
                elevenLabel.text = _data[10]
                twelveLabel.text = _data[11]
            }
            
        }
        get{
            return _data
        }
    }
    
    //MARK: - Instance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        weak var weakSelf = self
        
        self.oneLabel.clicked {
            weakSelf?.setSelected(index: 0)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.oneLabel.text ?? "") ?? 0 )
            }
        }
        
        self.twoLabel.clicked {
            weakSelf?.setSelected(index: 1)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.twoLabel.text ?? "") ?? 0 )
            }
        }
        
        threeLabel.clicked {
            weakSelf?.setSelected(index: 2)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.threeLabel.text ?? "") ?? 0 )
            }
        }
        
        fourLabel.clicked {
            weakSelf?.setSelected(index: 3)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.fourLabel.text ?? "") ?? 0 )
            }
        }
        
        fiveLabel.clicked {
            weakSelf?.setSelected(index: 4)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.fiveLabel.text ?? "") ?? 0 )
            }
        }
        
        sixLabel.clicked {
            weakSelf?.setSelected(index: 5)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.sixLabel.text ?? "") ?? 0 )
            }
        }
        
        sevenLabel.clicked {
            weakSelf?.setSelected(index: 6)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.sevenLabel.text ?? "") ?? 0 )
            }
        }
        
        eightLabel.clicked {
            weakSelf?.setSelected(index: 7)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.eightLabel.text ?? "") ?? 0 )
            }
        }
        
        nineLabel.clicked {
            weakSelf?.setSelected(index: 8)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.nineLabel.text ?? "") ?? 0 )
            }
        }
        
        tenLabel.clicked {
            weakSelf?.setSelected(index: 9)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.tenLabel.text ?? "") ?? 0 )
            }
        }
        
        elevenLabel.clicked {
            weakSelf?.setSelected(index: 10)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.elevenLabel.text ?? "") ?? 0 )
            }
        }
        
        twelveLabel.clicked {
            weakSelf?.setSelected(index: 11)
            if weakSelf?.handler != nil{
                weakSelf?.handler?(Int.init(weakSelf?.twelveLabel.text ?? "") ?? 0 )
            }
        }
        
    }

    
    //MARK: - Actions
    
    func clearSelected() {
        self.selectLabel?.selected = false
    }
    
    func setSelected(index: Int) {
        
        let array:Array<DateShowLabel> = [oneLabel, twoLabel, threeLabel, fourLabel, fiveLabel, sixLabel, sevenLabel, eightLabel, nineLabel, tenLabel, elevenLabel, twelveLabel]
        
        if self.selectLabel != nil{
            self.selectLabel?.selected = false
            let label: DateShowLabel = array[index]
            label.selected = true
            self.selectLabel = label
        }else{
            for i: Int in 0...(array.count - 1) {
                let label: DateShowLabel = array[i]
                if i == index{
                    label.selected = true
                    self.selectLabel = label
                }else{
                    label.selected = false
                }
            }
        }
        
    }
    
    func clicked(handler: @escaping ((Int)) -> Void) {
        self.handler = handler
    }
    
    func canSelect(number: Int) -> Void {
        
        let array:Array<DateShowLabel> = [oneLabel, twoLabel, threeLabel, fourLabel, fiveLabel, sixLabel, sevenLabel, eightLabel, nineLabel, tenLabel, elevenLabel, twelveLabel]
        
        for i: Int in 0...(array.count - 1){
            let label: DateShowLabel = array[i]
            
            if i < number{
                label.canClicked = true
            }else{
                label.canClicked = false
            }
            
        }
        
        
    }
    
}
