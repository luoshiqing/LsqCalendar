//
//  CalendarData.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/9.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

enum LsqCalendarType {
    case none
    case holiday
}

struct LsqCalendarModel {
    let gregorian   : String//公历
    let lunarInfo   : String//农历详情
    let lunar       : String//农历
    let date        : Date  //时间
    let isToday     : Bool  //是否是今日
    let dayType     : LsqCalendarType
    let lunarHoliday: String?//农历节日
    let gregorianHoliday: String?//公历节日
}


struct CalendarData {

    public static let weekdays = ["日","一","二","三","四","五","六"]
    
    //获取当前和前后n月日历
    public static func getCalendarData(with date: Date, months: Int , handler: (([[LsqCalendarModel?]])->Swift.Void)?) {
        
        DispatchQueue.global().async {
            var dataArray = [[LsqCalendarModel?]]()
            let current = self.getCalendarData(with: date)
            dataArray.append(current)
            
            var first: LsqCalendarModel?
            for m in current {
                if m != nil{
                    first = m
                    break
                }
            }
            if let f = first {
                CalendarData.getBeforeModelArray(beforeDate: f.date, months: months, handler: { (ms) in
                    let d = ms + dataArray
                    dataArray = d
                    
                    let last = dataArray.last?.last??.date
                    CalendarData.getLastModelArray(lastDate: last!, months: months, handler: { (ys) in
                        dataArray += ys
                        
                        DispatchQueue.main.async {
                            handler?(dataArray)
                        }
                    })
                })
            }
        }
    }
    
    
    
    
    
    
    //获取当月日历
    public static func getCalendarData(with date: Date) -> [LsqCalendarModel?] {
        
        let dates = self.getMonthStartEndDate(date: date)
        let index = self.weekDayIndex(date: dates.start)
        var modelArray = [LsqCalendarModel?]()
        //前段
        if index != 0 {
            for _ in 0..<index {
                modelArray.append(nil)
            }
        }
        //当前月份
        let startTimeInterval = dates.start.timeIntervalSince1970
        let endTimeInterval = dates.end.timeIntervalSince1970
        
        var currentTimeInterval = startTimeInterval
        var day = 1
        while currentTimeInterval <= endTimeInterval {
            let date = Date(timeIntervalSince1970: currentTimeInterval)
            
            let md = date.toString(type: .MM_dd)
            
            let isToday = self.isToday(date: date)
            let lunar = self.solarToLunar(date: date)
            var lHoliday = lunar.2
            var dType = lunar.3
            //腊月廿九 还是三十 除夕
            if lunar.0 == "腊月廿九" {
                //加一天，看看是不是腊月三十
                let timeInterval = currentTimeInterval + 24 * 60 * 60
                let nextDate = Date(timeIntervalSince1970: timeInterval)
                let lll = self.solarToLunar(date: nextDate).1
                if lll != "三十" {
                    dType = .holiday
                    lHoliday = "除夕"
                }
            }
            var hValue: String?
            let gregorianHoliday = LsqHoliday.gregorianHoliday
            for h in gregorianHoliday {
                if h.key == md {
                    hValue = h.value
                    break
                }
            }
            var dayType = dType
            if let _ = hValue {
                dayType = .holiday
            }
                        
            let m = LsqCalendarModel(gregorian: "\(day)", lunarInfo: lunar.0, lunar: lunar.1, date: date, isToday: isToday, dayType: dayType, lunarHoliday: lHoliday, gregorianHoliday: hValue)
            modelArray.append(m)
            currentTimeInterval += 24 * 60 * 60
            day += 1
        }
        
        return modelArray
    }
    
    //获取前n个月
    public static func getBeforeModelArray(beforeDate: Date, months: Int, handler: (([[LsqCalendarModel?]])->Swift.Void)?){
        if months <= 0 {
            handler?([])
        }
        DispatchQueue.global().async {
            var datas = [[LsqCalendarModel?]]()
            
            var currentIndex = 0
            var befor = beforeDate
            while currentIndex < months {
                let lastDay = self.getBeforeDay(date: befor)
                let current = self.getCalendarData(with: lastDay)
                datas.append(current)
                for model in current {
                    if let m = model{
                        befor = m.date
                        break
                    }
                }
                currentIndex += 1
            }
            datas.reverse()
            
            DispatchQueue.main.async {
                handler?(datas)
            }
        }
        
    }
    //获取后n个月
    public static func getLastModelArray(lastDate: Date, months: Int, handler: (([[LsqCalendarModel?]])->Swift.Void)?){
        if months <= 0 {
            handler?([])
        }
        DispatchQueue.global().async {
            var datas = [[LsqCalendarModel?]]()
            var currentIndex = 0
            var last = lastDate
            while currentIndex < months {
                let lastDay = self.getLastDay(date: last)
                let current = self.getCalendarData(with: lastDay)
                datas.append(current)
                if current.isEmpty{
                    break
                }
                last = current[current.count - 1]!.date
                currentIndex += 1
            }
            DispatchQueue.main.async {
                handler?(datas)
            }
        }
        
    }
    
}

extension CalendarData {
    //TODO:获取当前月份的起始结束日期
    private static func getMonthStartEndDate(date: Date)->(start: Date, end: Date){
        let dformatter = DateFormatter()
        dformatter.dateFormat = TimeFormat.yyyy_MM.rawValue
        //当前时间
        let yyyymm = dformatter.string(from: date)
        let yearMonth = yyyymm.components(separatedBy: "-")
        var year = Int(yearMonth[0]) ?? 1
        let month = Int(yearMonth[1]) ?? 1
        var nextMont = 1
        if month == 12{
            year += 1
            nextMont = 1
        }else{
            nextMont = month + 1
        }
        let nextYyyymm = "\(year)" + "-" + "\(nextMont)"
        let curretn = yyyymm.toDate(type: .yyyy_MM)
        let next = nextYyyymm.toDate(type: .yyyy_MM)
        let dformatter1 = DateFormatter()
        dformatter1.dateFormat = TimeFormat.yyyy_MM_dd.rawValue
        let nextInterval = next!.timeIntervalSince1970 - 24 * 60 * 60
        let nextDate = Date(timeIntervalSince1970: nextInterval)
        return (start: curretn!, end: nextDate)
    }
    //获取当前月份第一天的星期的下标位置
    private static func weekDayIndex(date: Date) -> Int {
        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.current
        calendar.timeZone = timeZone
        let theComponents = calendar.component(.weekday, from: date)
        return theComponents - 1
    }
    private static func isToday(date: Date)->Bool{
        let st1 = date.toString(type: .yyyy_MM_dd)
        let curent = Date().toString(type: .yyyy_MM_dd)
        if st1 == curent{
            return true
        }
        return false
    }
    //获取计算农历
    private static func solarToLunar(date: Date) -> (String,String,String?,LsqCalendarType) {
        let solarCalendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        
        let ymd = date.toString(type: .yyyy_MM_dd)
        let times = ymd.components(separatedBy: "-")
        
        components.year = Int(times[0])
        components.month = Int(times[1])
        components.day = Int(times[2])
        components.hour = 12
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
        guard let solarDate = solarCalendar.date(from: components) else{
            return ("","",nil,.none)
        }
        
        let lunarCalendar = Calendar(identifier: .chinese)
        
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "zh_CN")
        //2019年八月初八 .medium
        //2019己亥年八月初八 .long
        
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        let str = formatter.string(from: solarDate)
        //八月初三
        let lunarInfo = str.components(separatedBy: "年").last ?? ""
        //初三
        let lunar = lunarInfo.components(separatedBy: "月").last ?? ""
        
        var hValue: String?
        let traditionalHoliday = LsqHoliday.traditionalHoliday
        for h in traditionalHoliday {
            if h.key == lunarInfo {
                hValue = h.value
                break
            }
        }
        var dayType = LsqCalendarType.none
        if let _ = hValue {
            dayType = .holiday
        }
        if lunar == "初一" && hValue == nil {
            let l = lunarInfo.components(separatedBy: "月").first ?? ""
            return (lunarInfo, l + "月", hValue, dayType)
        }else{
            return (lunarInfo, lunar, hValue, dayType)
        }
    }
    
    
    //获取前一天
    private static func getBeforeDay(date: Date)->Date{
        let time = date.timeIntervalSince1970 - 24 * 60 * 60
        let end = Date(timeIntervalSince1970: time)
        return end
    }
    //获取后一天
    private static func getLastDay(date: Date)->Date{
        let time = date.timeIntervalSince1970 + 24 * 60 * 60
        let end = Date(timeIntervalSince1970: time)
        return end
    }
}


extension String{
    //字符串转date
    public func toDate(type: TimeFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = type.rawValue
        let date = formatter.date(from: self)
        return date
    }
}
extension Date{
    //转字符串格式
    func toString(type: TimeFormat)->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = type.rawValue
        let dateStr = dateFormat.string(from: self)
        return dateStr
    }
}
//时间戳转换
public enum TimeFormat: String {
    //y表示年份，m表示月份，d表示日，h表示小时，m表示分钟，s表示秒
    case yyyy_MM_dd_HH_mm_ss    = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm       = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH          = "yyyy-MM-dd HH"
    case yyyy_MM_dd             = "yyyy-MM-dd"
    case yyyyMMdd               = "yyyy.MM.dd"
    case yyyyMM                 = "yyyy.MM"
    case yyyy_MM                = "yyyy-MM"
    case HH_mm                  = "HH:mm"
    case yyyy                   = "yyyy"
    case MM_dd                  = "MM-dd"
    case MM                     = "MM"
}
