//
//  ConsumeTypeUICollectionViewFlowLayout.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/22.
//

import UIKit

class ConsumeTypeUICollectionViewFlowLayout: UICollectionViewFlowLayout {

    var attArray: NSMutableArray = NSMutableArray.init()
    
    override func prepare() {
        
       super.prepare()
        
        self.attArray.removeAllObjects()
        //定义当前行数、页数变量
        var lineNum: NSInteger = 1;
        var page: NSInteger = 0;
        //定义itemsize
        
        let originX: CGFloat = self.collectionView?.frame.width ?? 0
        let attWidth: CGFloat =  (self.collectionView?.frame.width ?? 0 - 22) / 5

        let attHeight: CGFloat = self.itemSize.height;

        let items: NSInteger = self.collectionView?.numberOfItems(inSection: 0) ?? 0

        for i in 0...(items - 1) {
            
            let index: NSIndexPath = NSIndexPath.init(row: i, section: 0)
            let att: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: index as IndexPath)
            
            //因为我是一行显示5个，所以取计算5的余数，如果==0就换行，一来i = 0，所以lineNum初始值为0，从第一行开始添加
            if (i % 5 == 0) {
                lineNum = lineNum == 0 ? 1 : 0;
            }
            //超过10个就加一页，让x坐标加上页数 * collectionview宽度
            if ((NSInteger)(i / 10) >= 0) {
                page = i / 10;
            }
            //计算frame
            att.frame = CGRect.init(x: CGFloat.init((i % 5))  * attWidth + (originX * CGFloat.init(page)), y: CGFloat.init(lineNum) * (attHeight + self.minimumLineSpacing) + self.sectionInset.top, width: attWidth, height: attHeight)
            
            self.attArray.add(att)
            
            
        }
        
    }
    
    override var collectionViewContentSize: CGSize{

        let items: NSInteger = self.collectionView?.numberOfItems(inSection: 0) ?? 0

        var pages: NSInteger?
        if items % 10 == 0 {
            pages = items / 10;
        }else{
            pages = items / 10 + 1
        }

        return CGSize.init(width: (self.collectionView?.frame.width ?? 0 ) * CGFloat.init(pages ?? 0), height:0)

    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let array: NSMutableArray = NSMutableArray.init()
        for att:UICollectionViewLayoutAttributes in self.attArray as! [UICollectionViewLayoutAttributes]{
            if rect.intersects(att.frame){
                array.add(att)
            }
        }
        return array as? [UICollectionViewLayoutAttributes]
    }
    
    
}
