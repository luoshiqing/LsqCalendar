//
//  LsqCalendarCollectionViewCell.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/12.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

class LsqCalendarCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var selectHandler: ((LsqCalendarModel)->Swift.Void)?
    
    public var dataArray = [LsqCalendarModel?]() {
        didSet {
            var sss = [Bool?]()
            for m in self.dataArray {
                if let model = m {
                    if model.isToday {
                        sss.append(true)
                    }else{
                        sss.append(false)
                    }
                }else{
                    sss.append(nil)
                }
            }
            self.selectArray = sss
            
            let dataCount = self.dataArray.count
            let weekCount = CalendarData.weekdays.count
            var line = dataCount / weekCount
            if dataCount % weekCount != 0 {
                line += 1
            }
            let h = (self.frame.height - CGFloat(line - 1) * LsqCalendarCollectionViewCell.spaceX) / CGFloat(line)
            self.layout.itemSize = CGSize(width: self.oneItemWidth, height: h)
            
            self.myCollectionView?.reloadData()
        }
    }
    
    private var selectArray = [Bool?]()

    private var myCollectionView: UICollectionView?
    
    public static let spaceX: CGFloat = 1
    private lazy var oneItemWidth: CGFloat = {
        let count = CalendarData.weekdays.count
        let widht = (self.frame.width - CGFloat(count - 1) * LsqCalendarCollectionViewCell.spaceX) / CGFloat(count)
        return widht
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadCollectionView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var layout: UICollectionViewFlowLayout!
    private func loadCollectionView(){
        //---UICollectionView---
        layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.oneItemWidth, height: 0)
        layout.minimumLineSpacing = LsqCalendarCollectionViewCell.spaceX //上下间隔
        layout.minimumInteritemSpacing = LsqCalendarCollectionViewCell.spaceX //左右间隔
        layout.headerReferenceSize = CGSize(width: 0, height: 0) //头部间距
        layout.footerReferenceSize = CGSize(width: 0, height: 0) //尾部间距
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        
        let rect = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        myCollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        myCollectionView?.backgroundColor = UIColor.clear
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        self.addSubview(myCollectionView!)
        let nib = UINib(nibName: "CalendarCollectionViewCell", bundle: Bundle.main)
        myCollectionView?.register(nib, forCellWithReuseIdentifier: "CalendarCollectionViewCell")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.data = self.dataArray[indexPath.row]
        cell.isSelect = self.selectArray[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let m = self.dataArray[indexPath.row] {
            self.selectArray = [Bool?].init(repeating: false, count: self.selectArray.count)
            self.selectArray[indexPath.row] = true
            self.myCollectionView?.reloadData()
            self.selectHandler?(m)
        }else{
            print("点击无效")
        }
    }
}
