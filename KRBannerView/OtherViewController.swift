//
//  OtherViewController.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/7.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    var button: UIButton!
    override func viewDidLoad() {
        
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.white
      button = UIButton.init(frame: CGRect.init(x: 60, y: 100, width: 100, height: 100))
      button.backgroundColor = UIColor.blue
      button.setTitle("Push", for: .normal)
      button.addTarget(self, action: #selector(pushToOther), for: .touchUpInside)
    self.view.addSubview(button)
    }
    
    @objc func pushToOther(){
        let otherVC = AnotherViewController()
        self.navigationController?.pushViewController(otherVC, animated: true)
    }

}
