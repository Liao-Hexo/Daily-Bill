//
//  CalendarHelper.swift
//  Daily-Bill
//
//  Created by 廖家龙 on 2021/11/20.
//

import UIKit

class CalendarHelper: NSObject {





  static func days(month: String) -> Int{

       let oneState = ["2", "02"]
       let twoState = ["1","01", "3","03", "5","05", "7","07", "8", "08", "10", "12"]
//        let threeState = ["4", "04", "6", "06", "9", "09", "11"]

        if oneState.contains(month){
            return 28
        }

        if twoState.contains(month) {
            return 31
        }

        return 30
    }

    static func days(date: Date) -> Int {

        let format = DateFormatter.init()
        format.dateFormat = "MM"
        let month = format.string(from: date)
        return days(month: month)

    }

    static func month(date: String, dateFormat: String) -> String{
        let format = DateFormatter.init()
        format.dateFormat = dateFormat
        let d = format.date(from: date)
        format.dateFormat = "MM"
        return format.string(from: d ?? Date.init())
    }



    static func weekday(date: Date) -> String {

        let weekDays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]

        var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        calendar.timeZone = timeZone!
        let components = calendar.component(Calendar.Component.weekday, from: date)
        if components < 8 && components > 0 {
            return weekDays[components - 1]
        }
        return ""

    }

    static func dateString(date: String, originFromat: String, resultFromat: String) -> String {

        let format = DateFormatter.init()
        format.dateFormat = originFromat
        let d = format.date(from: date)
        format.dateFormat = resultFromat
        return format.string(from: d ?? Date.init())

    }

    static func nowDateString(dateFormat: String) -> String{
        let format = DateFormatter.init()
        format.dateFormat = dateFormat
        return format.string(from: Date.init())
    }

    static func dateString(date: Date, dateFormat: String) -> String{
        let format = DateFormatter.init()
        format.dateFormat = dateFormat
        return format.string(from: date)
    }

    static func year(date: Date) -> String{
        return dateString(date: date, dateFormat: "yyyy")
    }

    static func month(date: Date) -> String{
        return dateString(date: date, dateFormat: "MM")
    }

    static func day(date: Date) -> String{
        return dateString(date: date, dateFormat: "dd")
    }

    static func date(dateString: String, dateFormat: String) -> Date{
        let format = DateFormatter.init()
        format.dateFormat = dateFormat
        return format.date(from: dateString) ?? Date.init()
    }


    static func last(dateString: String) -> String{

        var date: String = ""

        if dateString.count == 4{
            var year = (dateString as NSString).integerValue
            year -= 1
            date = String(format: "%ld", year)
        }

        if dateString.count == 6{

            var year = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMM", resultFromat: "yyyy") as NSString).integerValue
            var month = (CalendarHelper.month(date: dateString, dateFormat: "yyyyMM") as NSString).integerValue
            if month == 1{
                month = 12
                year -= 1
            }else{
                month -= 1
            }

            date = String(format: "%d%02d", year, month)
        }

        if dateString.count == 8{

            var year = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMMdd", resultFromat: "yyyy") as NSString).integerValue
            var month = (CalendarHelper.month(date: dateString, dateFormat: "yyyyMMdd") as NSString).integerValue
            var day = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMMdd", resultFromat: "dd") as NSString).integerValue

            if day == 1{

                if month == 1{
                    month = 12
                    year -= 1
                }else{
                    month -= 1
                }

                day = CalendarHelper.days(month: String(format:"%d", month))

            }else{
                day -= 1
            }

            date = String(format: "%d%02d%02d",year, month, day)

        }

        return date
    }

    static func next(dateString: String) -> String{

        var date: String = ""

        if dateString.count == 4{
            var year = (dateString as NSString).integerValue
            year += 1
            date = String(format: "%ld", year)
        }

        if dateString.count == 6{

            var year = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMM", resultFromat: "yyyy") as NSString).integerValue
            var month = (CalendarHelper.month(date: dateString, dateFormat: "yyyyMM") as NSString).integerValue
            if month == 12{
                month = 1
                year += 1
            }else{
                month += 1
            }

            date = String(format: "%d%02d", year, month)
        }

        if dateString.count == 8{

            var year = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMMdd", resultFromat: "yyyy") as NSString).integerValue
            var month = (CalendarHelper.month(date: dateString, dateFormat: "yyyyMMdd") as NSString).integerValue
            var day = (CalendarHelper.dateString(date: dateString, originFromat: "yyyyMMdd", resultFromat: "dd") as NSString).integerValue

            let currentDays = CalendarHelper.days(month: String(format:"%d", month))


            if day == currentDays{

                if month == 12{
                    month = 1
                    year += 1
                }else{
                    month += 1
                }

                day = 1

            }else{
                day += 1
            }

            date = String(format: "%d%02d%02d",year, month, day)

        }

        return date
    }

    static func weekDay(dateString: String, format: String) -> String {
        let date = CalendarHelper.date(dateString: dateString, dateFormat: format)
        return CalendarHelper.weekday(date: date)
    }

}

