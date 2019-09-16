//
//  ViewController.swift
//  LsqCalendar
//
//  Created by 罗石清 on 2019/9/16.
//  Copyright © 2019 HunanChangxingTrafficWisdom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCalendarView()
    }

    private func loadCalendarView(){
        let cv = LsqCalendarView(frame: CGRect(x: 12, y: 200, width: self.view.frame.width - 12 * 2, height: 350))
        cv.center.x = self.view.frame.width / 2
        cv.backgroundColor = UIColor.groupTableViewBackground
        cv.layer.cornerRadius = 6
        cv.layer.masksToBounds = true
        self.view.addSubview(cv)
        
        cv.selectHandler = { [weak self] (model) in
            print(model)
        }
    }

}

