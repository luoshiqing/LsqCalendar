//
//  LunarHoliday.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/12.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

struct HolidayKeyValue: Equatable {
    let key     : String
    let value   : String
}

struct LsqHoliday {
    //传统节日
    static let traditionalHoliday: [HolidayKeyValue] = [
        HolidayKeyValue(key: "正月初一", value: "春节"),
        HolidayKeyValue(key: "正月十五", value: "元宵节"),
        HolidayKeyValue(key: "五月初五", value: "端午节"),
        HolidayKeyValue(key: "七月初七", value: "七夕"),
        HolidayKeyValue(key: "七月十五", value: "中元节"),
        HolidayKeyValue(key: "八月十五", value: "中秋节"),
        HolidayKeyValue(key: "九月初九", value: "重阳节"),
        HolidayKeyValue(key: "腊月初八", value: "腊八节"),
        HolidayKeyValue(key: "腊月廿四", value: "祭灶"),
        HolidayKeyValue(key: "腊月三十", value: "除夕")
    ]
    //阳历节日
    static let gregorianHoliday: [HolidayKeyValue] = [
        HolidayKeyValue(key: "01-01", value: "元旦"),
        HolidayKeyValue(key: "02-14", value: "情人节"),
        HolidayKeyValue(key: "03-08", value: "妇女节"),
        HolidayKeyValue(key: "03-12", value: "植树节"),
        HolidayKeyValue(key: "04-01", value: "愚人节"),
        HolidayKeyValue(key: "05-01", value: "劳动节"),
        HolidayKeyValue(key: "05-04", value: "青年节"),
        HolidayKeyValue(key: "06-01", value: "儿童节"),
        HolidayKeyValue(key: "07-01", value: "建党节"),
        HolidayKeyValue(key: "08-01", value: "建军节"),
        HolidayKeyValue(key: "09-10", value: "教师节"),
        HolidayKeyValue(key: "10-01", value: "国庆节"),
        HolidayKeyValue(key: "12-24", value: "平安夜"),
        HolidayKeyValue(key: "12-25", value: "圣诞节")
    ]
}


struct LsqCalendarColor {
    //今日日期背景颜色
    public static let todayBgColor = UIColor.red
    //日期选中文字颜色
    public static let dateTextSelectColor = UIColor.hexColor(with: "#FFFFFF")
    //日期未选中文字颜色
    public static let dateTextNormalColor = UIColor.hexColor(with: "#333333")
    //日期选中背景颜色
    public static let dateBgSelectColor = UIColor.hexColor(with: "#3386EF")
    //日期未选中背景颜色
    public static let dateBgNormalColor: UIColor? = UIColor.clear
    //农历颜色
    public static let valueNormalColor = UIColor.hexColor(with: "#000000")
    //农历节日颜色
    public static let valueSelectColor: UIColor? = UIColor.purple
}
