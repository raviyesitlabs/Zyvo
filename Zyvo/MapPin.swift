//
//  MapPin.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 10/01/25.
//

import UIKit

class MapPin: UIView {

    @IBOutlet weak var lbl_Price: UILabel!
    var viewData:MapData?{
        didSet{
            upateView()
        }
    }
    func upateView(){
      
        self.lbl_Price.text = "$\(viewData?.hourly_rate ?? "")/h"

    }
       
    
}
