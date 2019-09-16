//
//  CalendarCollectionViewCell.swift
//  Scheduling
//
//  Created by DayHR on 2018/10/25.
//  Copyright © 2018年 zhcx. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    public var data: LsqCalendarModel!{
        didSet{
            if data == nil{
                self.dateLabel.text = nil
                self.valueLabel.text = nil
                self.valueLabel.attributedText = nil
                self.dateLabel.backgroundColor = UIColor.clear
            }else{
                
                self.dateLabel.text = data.gregorian
                self.valueLabel.text = data.lunar
                
                if data.isToday{
                    self.dateLabel.backgroundColor = UIColor.hexColor(with: "#3386EF")
                    self.dateLabel.textColor = UIColor.white
                }else{
                    self.dateLabel.backgroundColor = UIColor.clear
                    self.dateLabel.textColor = UIColor.hexColor(with: "#333333")
                }
                
                switch data.dayType {
                case .none:
                    self.valueLabel.text = data.lunar
                    self.valueLabel.textColor = UIColor.black
                case .holiday:
                    if let d = data.lunarHoliday {
                        self.valueLabel.text = d
                    }else if let d = data.gregorianHoliday {
                        self.valueLabel.text = d
                    }else{
                        self.valueLabel.text = data.lunar
                    }
                    self.valueLabel.textColor = UIColor.purple
                }
               
            }
            
        }
    }
   
    public var isSelect: Bool? = false {
        didSet {
            guard let dd = self.data else {return}
            guard let ss = self.isSelect else {
                self.dateLabel.backgroundColor = LsqCalendarColor.dateBgNormalColor
                self.dateLabel.textColor = LsqCalendarColor.dateTextNormalColor
                return
            }
            if dd.isToday {
                if ss {
                    self.dateLabel.backgroundColor = LsqCalendarColor.dateBgSelectColor
                    self.dateLabel.textColor = LsqCalendarColor.dateTextSelectColor
                }else{
                    self.dateLabel.backgroundColor = LsqCalendarColor.todayBgColor
                    self.dateLabel.textColor = LsqCalendarColor.dateTextSelectColor
                }
            }else{
                if ss {
                    self.dateLabel.backgroundColor = LsqCalendarColor.dateBgSelectColor
                    self.dateLabel.textColor = LsqCalendarColor.dateTextSelectColor
                }else{
                    self.dateLabel.backgroundColor = LsqCalendarColor.dateBgNormalColor
                    self.dateLabel.textColor = LsqCalendarColor.dateTextNormalColor
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.layer.cornerRadius = dateLabel.frame.height / 2.0
        dateLabel.layer.masksToBounds = true
        
    }

}


