//
//  ConsumeTypeCollectionViewCell.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ConsumeTypeCollectionViewCell: UICollectionViewCell {
    
    
     // MARK: - Property
    
    private var _data: ConsumeTypeModel?
    private var imageViewSuperView: UIView?
    
    private let nomarlColor: UIColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
    private let highColor1: UIColor = spendingColor
    private let highColor2: UIColor = UIColor.init(red: 0, green: 179 / 255.0, blue: 125 / 255.0, alpha: 1.0)
    
    var data: ConsumeTypeModel{
        set{
            _data = newValue
            self.titleLabel.text = _data?.name
            
            if _data?.isSelected ?? false {
                
                self.imageView.image = UIImage.init(named: _data?.highImageName ?? "")
                if _data?.tallyType == TallyModel.TalleyType.spending{
                    self.imageViewSuperView?.backgroundColor = highColor1
                }else{
                    self.imageViewSuperView?.backgroundColor = highColor2
                }
                
            }else{
                self.imageView.image = UIImage.init(named: _data?.imageName ?? "")
                self.imageViewSuperView?.backgroundColor = nomarlColor
            }
            
        }
        
        get{
            return _data ?? ConsumeTypeModel.init()
        }
    }
    
     // MARK: - Lazy
    
    lazy var imageView: UIImageView = {
        let aImageView: UIImageView = UIImageView.init()
//        aImageView.contentMode = UIView.ContentMode.scaleAspectFit
        aImageView.image = UIImage.init(named: "做明细")
        return aImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let aTitleLabel: UILabel = UILabel.init()
        aTitleLabel.textAlignment = NSTextAlignment.center
        aTitleLabel.font = UIFont.systemFont(ofSize: 12)
        aTitleLabel.text = "美容"
        aTitleLabel.textColor = .white//UIColor.init(red: 70 / 255.0, green: 70 / 255.0, blue: 74 / 255.0, alpha: 1.0)
//        aTitleLabel.backgroundColor = UIColor.orange
        return aTitleLabel
    }()
    
     // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     // MARK: - SetupUI
    
    func setupUI(frame: CGRect) -> Void {
        
        
        
        let titleLabelHeight: CGFloat = 15
        self.addSubview(self.titleLabel)
        self.titleLabel.frame = CGRect.init(x: 0, y: frame.height - titleLabelHeight, width: frame.width, height: titleLabelHeight)
        
        let imageViewSuperViewWidth: CGFloat = frame.height - titleLabelHeight - 10
        let originX: CGFloat = (frame.width - imageViewSuperViewWidth) / 2.0
        let imageViewSuperView: UIView = UIView.init(frame: CGRect.init(x: originX, y: 5, width: imageViewSuperViewWidth, height: imageViewSuperViewWidth))
        imageViewSuperView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        imageViewSuperView.layer.cornerRadius = imageViewSuperViewWidth / 2.0
        imageViewSuperView.clipsToBounds = true
        self.addSubview(imageViewSuperView)
        self.imageViewSuperView = imageViewSuperView

        
        let imageViewWidth: CGFloat = imageViewSuperViewWidth - 10
        self.imageView.frame = CGRect.init(x: 5, y: 5, width: imageViewWidth, height: imageViewWidth)
        self.imageView.layer.cornerRadius = imageViewWidth / 2.0
        imageViewSuperView.addSubview(self.imageView)
        

        
    }
    
    
}
