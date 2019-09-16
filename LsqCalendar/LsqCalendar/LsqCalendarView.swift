//
//  LsqCalendarView.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/16.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

class LsqCalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var selectHandler: ((LsqCalendarModel)->Swift.Void)?
    
    private var headView: LsqCalendarHeadView!
    private var myCollectionView: UICollectionView?
    
    private var dataArray = [[LsqCalendarModel?]]()
    private var showIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.loadHeadView()
        self.loadCollectionView()
        
        self.generateDatas()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //生成数据
    private func generateDatas(){
        CalendarData.getCalendarData(with: Date(), months: 4) { [weak self](datas: [[LsqCalendarModel?]]) in
            self?.dataArray = datas
            let show = datas.count / 2
            self?.showIndex = show
            self?.myCollectionView?.reloadData()
            self?.myCollectionView?.contentOffset = CGPoint(x: CGFloat(show) * self!.frame.width, y: 0)
            if let t = datas[show].last??.date.toString(type: .yyyy_MM) {
                self?.headView.dateString = t
            }
            self?.headView.toTodayBtn.isEnabled = true
        }
    }
    
    
    private func loadHeadView() {
        headView = LsqCalendarHeadView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 75))
        headView.backgroundColor = UIColor.clear
        self.addSubview(headView)
        headView.touchHandler = { [weak self](index) in
            switch index {
            case -1://上个月
                let index = self!.showIndex - 1
                guard let ms = self!.dataArray.first else {
                    return
                }
                var firstDate: Date?
                for m in ms {
                    if let a = m {
                        firstDate = a.date
                        break
                    }
                }
                guard let date = firstDate else {return}
                self?.addBefor(current: index, date: date, addPage: 1)
            case 1://点击了日期
                break
            case 2://下个月
                let index = self!.showIndex + 1
                guard let ms = self?.dataArray.last else {return}
                guard let lastDate = ms.last??.date else {return}
                self?.addLast(current: index, date: lastDate, addPage: 1)
            case 10://回到今日
                self?.headView.toTodayBtn.isEnabled = false
                self?.generateDatas()
            default:
                break
            }
        }
    }
    
    private func loadCollectionView(){
        //---UICollectionView---
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.frame.width, height: self.frame.height - self.headView.frame.height)
        layout.minimumLineSpacing = 0 //上下间隔
        layout.minimumInteritemSpacing = 0 //左右间隔
        layout.headerReferenceSize = CGSize(width: 0, height: 0) //头部间距
        layout.footerReferenceSize = CGSize(width: 0, height: 0) //尾部间距
        layout.sectionInset.left = 0
        layout.sectionInset.right = 0
        
        let rect = CGRect(x: 0, y: self.headView.bottom, width: self.frame.width, height: self.frame.height - self.headView.bottom)
        myCollectionView = UICollectionView(frame: rect, collectionViewLayout: layout)
        myCollectionView?.isPagingEnabled = true
        myCollectionView?.backgroundColor = UIColor.clear
        myCollectionView?.delegate = self
        myCollectionView?.dataSource = self
        myCollectionView?.showsHorizontalScrollIndicator = false
        self.addSubview(myCollectionView!)
        myCollectionView?.register(LsqCalendarCollectionViewCell.self, forCellWithReuseIdentifier: "LsqCalendarCollectionViewCell")
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LsqCalendarCollectionViewCell", for: indexPath) as! LsqCalendarCollectionViewCell
        cell.dataArray = self.dataArray[indexPath.row]
        cell.selectHandler = { [weak self] (model) in
            self?.selectHandler?(model)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let index = Int(offsetX / scrollView.frame.width)
        if index < 0 || index >= self.dataArray.count {
            return
        }
        let addPage = 3
        if index <= 1 {
            guard let ms = self.dataArray.first else {
                return
            }
            var firstDate: Date?
            for m in ms {
                if let a = m {
                    firstDate = a.date
                    break
                }
            }
            guard let date = firstDate else {return}
            self.addBefor(current: index, date: date, addPage: addPage)
        }else if index >= self.dataArray.count - 2 {
            guard let ms = self.dataArray.last else {return}
            guard let lastDate = ms.last??.date else {return}
            self.addLast(current: index, date: lastDate, addPage: addPage)
        }else{
            if let t = self.dataArray[index].last??.date.toString(type: .yyyy_MM) {
                self.headView.dateString = t
            }
            if index != self.showIndex {
                self.myCollectionView?.reloadData()
            }
            self.showIndex = index
        }
    }
    
    private func addLast(current index: Int, date: Date, addPage: Int){
        CalendarData.getLastModelArray(lastDate: date, months: addPage) { [weak self](ms) in
            //移除前边addPage个
            self?.dataArray = Array(self!.dataArray[(addPage - 1)..<self!.dataArray.count])
            self?.dataArray += ms
            self?.myCollectionView?.reloadData()
            let current = index - addPage + 1
            self?.showIndex = current
            self?.myCollectionView?.contentOffset = CGPoint(x: CGFloat(current) * self!.frame.width, y: 0)
            
            if let t = self?.dataArray[current].last??.date.toString(type: .yyyy_MM) {
                self?.headView.dateString = t
            }
        }
    }
    
    private func addBefor(current index: Int, date: Date, addPage: Int){
        CalendarData.getBeforeModelArray(beforeDate: date, months: addPage) { [weak self] (ms) in
            //移除后边的addPage个
            self?.dataArray = Array(self!.dataArray[0..<self!.dataArray.count - addPage])
            
            let d = ms + self!.dataArray
            self?.dataArray = d
            self?.myCollectionView?.reloadData()
            let current = addPage + index
            self?.showIndex = current
            self?.myCollectionView?.contentOffset = CGPoint(x: CGFloat(current) * self!.frame.width, y: 0)
            if let t = self?.dataArray[current].last??.date.toString(type: .yyyy_MM) {
                self?.headView.dateString = t
            }
        }
    }
    
}

class LsqCalendarHeadView: UIView {
    
    public var touchHandler: ((Int)->Swift.Void)?
    
    public var dateString: String? {
        didSet {
            self.showDateBtn.setTitle(self.dateString, for: .normal)
            self.showDateBtn.sizeToFit()
            self.showDateBtn.height = self.frame.height - self.weekdayHeight
            self.showDateBtn.left = self.inABtn.right + 5
            
            self.nextBtn.left = self.showDateBtn.right + 5
        }
    }
    
    private var inABtn: UIButton!//上一个
    private var showDateBtn: UIButton!//显示当前月份
    private var nextBtn: UIButton!//下一个
    
    public var toTodayBtn: UIButton!//回到今日
    
    private let weekdayHeight: CGFloat = 30
    
    private lazy var oneItemWidth: CGFloat = {
        let count = CalendarData.weekdays.count
        let widht = (self.frame.width - CGFloat(count - 1) * LsqCalendarCollectionViewCell.spaceX) / CGFloat(count)
        return widht
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow
        self.loadSomeView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadSomeView() {
        let dateView = UIView(frame: CGRect(x: 0, y: self.frame.height - weekdayHeight, width: self.frame.width, height: weekdayHeight))
        dateView.backgroundColor = UIColor.clear
        self.addSubview(dateView)
        let h: CGFloat = 20
        for i in 0..<CalendarData.weekdays.count{
            let day = CalendarData.weekdays[i]
            let x = CGFloat(i) * (self.oneItemWidth + LsqCalendarCollectionViewCell.spaceX)
            let label = UILabel(frame: CGRect(x: x, y: 0, width: self.oneItemWidth, height: h))
            label.center.y = dateView.height / 2
            label.textColor = UIColor.hexColor(with: "#999999")
            label.font = UIFont.systemFont(ofSize: 14)
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.text = day
            dateView.addSubview(label)
        }
        
        inABtn = UIButton(frame: CGRect(x: 20, y: 0, width: 20, height: self.frame.height - weekdayHeight))
        inABtn.setTitle("<", for: .normal)
        inABtn.setTitleColor(UIColor.green, for: .normal)
        inABtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        inABtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        inABtn.tag = -1
        self.addSubview(inABtn)
        
        showDateBtn = UIButton(frame: CGRect(x: inABtn.right + 5, y: 0, width: 70, height: self.frame.height - weekdayHeight))
        showDateBtn.setTitle("日历时间", for: .normal)
        showDateBtn.setTitleColor(UIColor.green, for: .normal)
        showDateBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        showDateBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        showDateBtn.tag = 1
        self.addSubview(showDateBtn)
        
        nextBtn = UIButton(frame: CGRect(x: showDateBtn.right + 5, y: 0, width: 20, height: self.frame.height - weekdayHeight))
        nextBtn.setTitle(">", for: .normal)
        nextBtn.setTitleColor(UIColor.green, for: .normal)
        nextBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        nextBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        nextBtn.tag = 2
        self.addSubview(nextBtn)
        
        toTodayBtn = UIButton(frame: CGRect(x: self.frame.width - 80 - 20, y: 0, width: 80, height: self.frame.height - weekdayHeight))
        toTodayBtn.setTitle("回到今日", for: .normal)
        toTodayBtn.setTitleColor(UIColor.blue, for: .normal)
        toTodayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        toTodayBtn.addTarget(self, action: #selector(self.someBtnAct(_:)), for: .touchUpInside)
        toTodayBtn.tag = 10
        self.addSubview(toTodayBtn)
    }
    
    
    @objc private func someBtnAct(_ send: UIButton) {
        let tag = send.tag
        self.touchHandler?(tag)
    }
}

