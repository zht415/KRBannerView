//
//  KRBannerView.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/6.
//  Copyright © 2020 Pata. All rights reserved.
//

/*
  竖直滚动View
 */
import UIKit
import Kingfisher
import SnapKit
class KRBannerView: UIView,KRBannerCollectionViewItemClickDelegate{
    
    //数据源
    var BannerList : [KRBannerViewModel] = [KRBannerViewModel]()
    //左边标题
    var titleLabel: UILabel = {
        let label = UILabel() 
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.white
        label.numberOfLines = 2
        label.text = "直播预告"
        return label
    }()
    
    //中间竖线
    var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.red
        return lineView
    }()
    //collectionView
    var bannerCollectionView:KRBannerCollectionView = {
        let bannerCollectionView = KRBannerCollectionView()
        return bannerCollectionView
    }()
    
    override init(frame: CGRect) {
       
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    
        setupView()
        configData(nil)
    }
    func setupView(){
        //构造数据源
        addSubview(self.titleLabel)
        addSubview(self.lineView)
        addSubview(self.bannerCollectionView)
        
        bannerCollectionView.scrollDirection = .vertical
        bannerCollectionView.delegate = self
    
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.height.width.equalTo(42)
            make.centerY.equalTo(self.snp.centerY)
        }
       
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(74)
            make.width.equalTo(1)
            make.height.equalTo(30)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
        }
        
        bannerCollectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp.right)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalToSuperview()
        }
    }
    
    //赋值
    func configData( _ data: [KRBannerViewModel]?){
        
        //假数据
        for i in 1...1{
            let model: KRBannerViewModel = KRBannerViewModel()
            model.time = "\(i) - 测试"
            model.title = "title:第\(i)个标题"
            model.subTitle = "subTitle:第:\(i)个副标题"
            BannerList.append(model)
        }
        
        bannerCollectionView.configData(BannerList)
    }
    
    //MARK:bannerCollectionViewDelegate
    func selectBannerCycleView(_ scrollView: KRBannerCollectionView, didSelectItemAtIndex index: Int) {
        
        print(index)
    }
    
    deinit {
        print("KRBannerView - deinit")
        bannerCollectionView.releaseTimer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
}
