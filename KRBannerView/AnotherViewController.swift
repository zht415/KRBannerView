//
//  AnotherViewController.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/7.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit
class AnotherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
//        let bannerView = KRBannerView(frame: CGRect(x:12,y:100,width: UIScreen.main.bounds.width - 12*2,height: 100))
        
        let bannerView = KRBannerView()
        bannerView.backgroundColor = UIColor.lightGray
        self.view.addSubview(bannerView)
        
          
        bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.top.equalTo(100)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(82)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
