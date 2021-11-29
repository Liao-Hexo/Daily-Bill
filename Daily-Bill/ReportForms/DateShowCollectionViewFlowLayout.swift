//
//  DateShowCollectionViewFlowLayout.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class DateShowCollectionViewFlowLayout: UICollectionViewFlowLayout {

    
    var frameArray: Array<CGRect> = Array.init()
    
    override func prepare() {
        
        super.prepare()
        
        let frame = self.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 0))?.frame ?? CGRect.zero
        let number:Int = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        self.frameArray.removeAll()
        for i: Int in 0...(number - 1){
            let origin: CGPoint = CGPoint.init(x: frame.size.width * CGFloat(i), y: 0)
            let aFrame: CGRect = CGRect.init(origin: origin, size: frame.size)
            self.frameArray.append(aFrame)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var array: Array<UICollectionViewLayoutAttributes> = Array.init()
        for frame: CGRect in self.frameArray {
            
            if rect.intersects(frame){
                
                let index: Int = self.frameArray.index(of: frame) ?? 0
                let att: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(row: index, section: 0))
                att.frame = frame
                array.append(att)
                
            }
            

        }
        
        return array
    }
    
    override var collectionViewContentSize: CGSize{

        var size: CGSize = super.collectionViewContentSize
        let frame = self.layoutAttributesForItem(at: IndexPath.init(row: 0, section: 0))?.frame ?? CGRect.zero
        let scale = size.height / frame.size.height
        size.height = frame.size.height
        size.width = frame.size.width * scale
        return size

    }
    
}
