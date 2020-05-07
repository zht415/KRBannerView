//
//  KRBannerCollectionCell.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/6.
//  Copyright © 2020 Pata. All rights reserved.
//

/*
 CollectionViewCell
 */
import UIKit
import Kingfisher
import SnapKit
class KRBannerCollectionCell: UICollectionViewCell {
    
    //时间
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.layer.cornerRadius = 2
        label.layer.masksToBounds = true
        return label
    }()
    //title
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.backgroundColor = UIColor.clear
        return label
    }()
    //subTitle
    lazy var subTitleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = UIColor.gray
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView(){
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subTitleLabel)

        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(14)
            make.top.equalTo(12)
            make.height.equalTo(18)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeLabel.snp.left)
            make.top.equalTo(self.timeLabel.snp.bottom).offset(2)
            make.height.equalTo(20)
            make.right.equalTo(0)
        }
       
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.timeLabel.snp.left)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(2)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
    }
    func configData(_ data: KRBannerViewModel?){
        guard let _ = data else {
            return
        }
        timeLabel.text = data?.time
        titleLabel.text = data?.title
        subTitleLabel.text = data?.subTitle
    }
    deinit {
        print("deinit")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
