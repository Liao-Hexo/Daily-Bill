//
//  ConsumeTypeView.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

@objc protocol ConsumeTypeViewDelegate: NSObjectProtocol {
    func consumeTypeViewPanGesture(ges: UIPanGestureRecognizer)
    @objc optional func consumeTypeView(didSelected consumeType: ConsumeTypeModel)
}


class ConsumeTypeView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate{

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
     // MARK: - Property
    
    let identifier: String = "identifier"
    weak var delegate: ConsumeTypeViewDelegate?
    var dataArray: NSMutableArray = NSMutableArray.init()
    var selectedConsumeTypeIndexPath: IndexPath?
    
     // MARK: - HitTest
    
     // MARK: - Touch
    
     // MARK: - Lazy
    
//    lazy var pageIndicator: UIPageControl = {
//        let pageControl: UIPageControl = UIPageControl.init()
//        pageControl.numberOfPages = 3
//        pageControl.currentPage = 0
//        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 57 / 255.0, green: 69 / 255.0, blue: 85 / 255.0, alpha: 1.0)
//        pageControl.pageIndicatorTintColor = UIColor.lightGray
//        return pageControl
//    }()
    
    
    
    lazy var collectionView: UICollectionView = {
        
        let layout: ConsumeTypeUICollectionViewFlowLayout = ConsumeTypeUICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 40, height: 60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 20, bottom: 5, right: 20)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        let aCollectionView: UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        aCollectionView.backgroundColor = themeColor//UIColor.white
        aCollectionView.showsVerticalScrollIndicator = false
        aCollectionView.showsHorizontalScrollIndicator = false
        aCollectionView.delegate = self
        aCollectionView.dataSource = self
        aCollectionView.isPagingEnabled = true
        
        aCollectionView.register(ConsumeTypeCollectionViewCell.classForCoder()
            , forCellWithReuseIdentifier: self.identifier)
        
        return aCollectionView
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
        
//        self.addSubview(self.pageIndicator)
//        pageIndicator.backgroundColor = .red
//        self.pageIndicator.snp.makeConstraints { (make) in
//            make.left.bottom.right.equalTo(0)
//            make.height.equalTo(10)
//        }
        
        self.addSubview(self.collectionView)
        collectionView.backgroundColor = cellColor
        collectionView.layer.cornerRadius = 8
        self.collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.bottom.equalToSuperview()
        }
        
        let panGes: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureAction(panGes:)))
        panGes.delegate = self
        self.addGestureRecognizer(panGes)
                
    }
    
     // MARK: - LoadData
    
    func loadData(aConsumeType: ConsumeTypeModel?,talleyType: TallyModel.TalleyType) -> Void {
        
        var plistName: String = "ConsumeType"
        
        if talleyType == TallyModel.TalleyType.income {
            plistName = "IncomeType"
        }
        
        let path: String = Bundle.main.path(forResource: plistName, ofType: "plist") ?? ""
        let plist: NSArray = NSArray(contentsOfFile: path) ?? NSArray.init()
        
        self.dataArray.removeAllObjects()
        
        var flag: Bool = true
        
        for dic in plist as! [Dictionary<String, String>]  {
            
            let consumeTypeModel: ConsumeTypeModel = ConsumeTypeModel.init()
            consumeTypeModel.name = dic["name"]
            consumeTypeModel.imageName = dic["imageName"]
            consumeTypeModel.highImageName = dic["highImageName"]
            consumeTypeModel.tallyType = talleyType
            
            if aConsumeType == nil && flag{
                flag = false
                consumeTypeModel.isSelected = true
                self.delegate?.consumeTypeView!(didSelected: consumeTypeModel)
            }else{
                if aConsumeType?.name == consumeTypeModel.name{
                    consumeTypeModel.isSelected = true
                }
            }
            
            self.dataArray.add(consumeTypeModel)
            
        }
        
        self.collectionView.reloadData()

    }
    
     // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) {
            let point: CGPoint = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self)
            if point.y / point.x > 1.5{
                return true
            }
        }
        
        return false
        
    }
    
     // MARK: - Methods
    
    @objc func panGestureAction(panGes: UIPanGestureRecognizer) -> Void {
        
        if let delegate = self.delegate {
            delegate.consumeTypeViewPanGesture(ges: panGes)
        }
    
    }
    
    
     // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedConsumeTypeIndexPath == indexPath{
            return
        }
        
        let consumeType: ConsumeTypeModel = self.dataArray.object(at: indexPath.row) as! ConsumeTypeModel
        consumeType.isSelected = true
        self.dataArray.replaceObject(at: indexPath.row, with: consumeType)

        if self.selectedConsumeTypeIndexPath == nil{
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [indexPath])
            }
            
        }else{
            
            let beforeConsumeType: ConsumeTypeModel = self.dataArray.object(at: self.selectedConsumeTypeIndexPath?.row ?? 0) as! ConsumeTypeModel
            beforeConsumeType.isSelected = false
            self.dataArray.replaceObject(at: self.selectedConsumeTypeIndexPath?.row ?? 0, with: beforeConsumeType)
            UIView.performWithoutAnimation {
                collectionView.reloadItems(at: [indexPath, self.selectedConsumeTypeIndexPath ?? IndexPath.init()])
            }
            
        }
        


        
        self.delegate?.consumeTypeView!(didSelected: consumeType)

    }
    
     // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let items: Int = self.dataArray.count
        
        var pages: NSInteger?
        if items % 20 == 0 {
            pages = items / 20;
        }else{
            pages = items / 20 + 1
        }
//        self.pageIndicator.numberOfPages = pages ?? 0
        
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell: ConsumeTypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as! ConsumeTypeCollectionViewCell
        cell.data = self.dataArray.object(at: indexPath.row) as! ConsumeTypeModel
        if cell.data.isSelected{
            self.selectedConsumeTypeIndexPath = indexPath
        }
        return cell
        
    }
    
     // MARK: - UIScrollViewDelegate
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / CGFloat.init(kScreenWidth))
//        self.pageIndicator.currentPage = page
    }
    
    
}
