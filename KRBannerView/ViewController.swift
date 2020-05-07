//
//  ViewController.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/6.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        button = UIButton.init(frame: CGRect.init(x: 60, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.blue
        button.setTitle("Push", for: .normal)
        button.addTarget(self, action: #selector(pushToOther), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    @objc func pushToOther(){
        let otherVC = OtherViewController()
        self.navigationController?.pushViewController(otherVC, animated: true)
    }
}

