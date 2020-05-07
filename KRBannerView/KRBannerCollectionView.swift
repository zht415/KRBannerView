//
//  KRBannerCollectionView.swift
//  KRBannerView
//
//  Created by Pata on 2020/5/6.
//  Copyright © 2020 Pata. All rights reserved.
//

import UIKit
import Foundation
import SnapKit
//MARK:ClickDelegate
protocol KRBannerCollectionViewItemClickDelegate: NSObjectProtocol {
    func selectBannerCycleView(_ scrollView:KRBannerCollectionView, didSelectItemAtIndex index: Int)
}
extension KRBannerCollectionViewItemClickDelegate {
    func selectBannerCycleView(_ scrollView:KRBannerCollectionView, didSelectItemAtIndex index: Int){}
}

class KRBannerCollectionView: UIView {
   
    
    var bannerList : [KRBannerViewModel] = [KRBannerViewModel]()//数据源
    
    weak var delegate: KRBannerCollectionViewItemClickDelegate? //代理
    
    var clickItemClosure:((Int)->Void)?
    
    var autoScollTimeInterval:CGFloat = 2.0{//滚动时间间隔
        didSet{
            setAutoScroll(isAutoScroll)
        }
    }
    var isAutoScroll:Bool = true {//是否自动滚动
        didSet{
            setAutoScroll(isAutoScroll)
        }
    }
    var isInfiniteLoop:Bool = true //是否循环滚动 默认: YES
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            layout.scrollDirection = scrollDirection
        }
    }
    var totalItemsCount: Int = 0
    //timer 定时器
    var timer: Timer?

    var layout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!//collectionView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        setupView()
        disableScrollGesture()
    }
    //MARK:setupView
    func setupView(){
        //layout
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
    
        //collectionView
        collectionView = UICollectionView(frame:self.bounds, collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(KRBannerCollectionCell.self, forCellWithReuseIdentifier: KRBannerCollectionCell.identifier)
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = self.bounds.size
        if (collectionView.contentOffset.x == 0) && (totalItemsCount > 0) {
            var targetIndex = 0
            if isInfiniteLoop{
                targetIndex = totalItemsCount / 2
            }
            collectionView.scrollToItem(at: NSIndexPath.init(row: targetIndex, section: 0) as IndexPath, at: .init(rawValue: 0), animated: false)
        }
    }
    
    //MARK:赋值
    func configData(_ listData: [KRBannerViewModel]?){
           
        guard let data = listData,data.count > 0  else {
            return
        }
        self.bannerList.removeAll()
        self.bannerList = listData!
        
        removeTimer()
        
        isInfiniteLoop = bannerList.count > 1 ? true : false
        totalItemsCount = isInfiniteLoop ? bannerList.count * 100:bannerList.count

        if self.bannerList.count > 1 {
            collectionView.isScrollEnabled = true
            setAutoScroll(isAutoScroll)
        }else{
            collectionView.isScrollEnabled = false
            setAutoScroll(false)
        }
        self.collectionView .reloadData()
    }
    
    func disableScrollGesture() {
        collectionView.canCancelContentTouches = false
        for gesture in collectionView.gestureRecognizers ?? [] {
            if (gesture is UIPanGestureRecognizer) {
                collectionView.removeGestureRecognizer(gesture)
            }
        }
    }
    
    deinit {
        print("deinit")
    }
    func releaseTimer(){
        collectionView.delegate = nil
        collectionView.dataSource = nil
        removeTimer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:CollectionViewDelegate
extension KRBannerCollectionView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //MARK:collectionViewDelegate
      
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if bannerList.count == 0 {
            return CGSize.zero
        }
        return CGSize(width: self.bounds.size.width, height: self.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:KRBannerCollectionCell.identifier, for: indexPath) as! KRBannerCollectionCell
    
        let cellIndex = getPageControlIndex(indexPath.item)
        let data: KRBannerViewModel = bannerList[cellIndex]
        
        cell.configData(data)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = getPageControlIndex(indexPath.item)
        delegate?.selectBannerCycleView(self, didSelectItemAtIndex: index)
        clickItemClosure?(index)
    }
    //MARK:ScorllView
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//    }
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {//拖动时操作
//        if isAutoScroll{
//            removeTimer()
//        }
//    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if isAutoScroll {
//            removeTimer()
//        }
//    }
    
    func getCurrentIndex() -> Int {//获取当前cell下标
        
        if collectionView.bounds.width == 0 || collectionView.bounds.height == 0 {
            return 0
        }
        var  index: Int = 0
        if layout.scrollDirection == .horizontal {
            index = Int((collectionView.contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width)
        } else {
            index = Int((collectionView.contentOffset.y + layout.itemSize.height * 0.5) / layout.itemSize.height)
        }
        return index
    }
    fileprivate func getPageControlIndex(_ currentCellIndex: Int) -> Int {
        return currentCellIndex % bannerList.count
    }
}
//MARK:Timer
extension KRBannerCollectionView{
    
    func setAutoScroll(_ autoScroll:Bool) {
        removeTimer()
        if isAutoScroll {
            addTimer()
        }
    }
    //MARK:timer
    func addTimer(){
    
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(automaticScrollAction), userInfo: nil, repeats: true)
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        }
    }
    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func automaticScrollAction() {//定时器
        if bannerList.count == 1 {
            return
        }
        let currentIndex = currentPageIndex()
        let targetIndex = currentIndex + 1
        print("currentIndex:\(currentIndex)")
        scrollToIndex(targetIndex:targetIndex)
    }
    
    func currentPageIndex() -> Int {
        if collectionView.bounds.size.width == 0 || collectionView.bounds.size.height == 0 {
            return 0
        }
        let index : Int = Int((collectionView.contentOffset.y + layout.itemSize.height * 0.5) / layout.itemSize.height)
        return max(0, index)
    }
    
    //MARK：滚动至指定index
    func scrollToIndex(targetIndex: Int){
        var targetIndex = targetIndex
        let indexPath = IndexPath(item: targetIndex, section: 0)
        if targetIndex >= totalItemsCount{
            if isInfiniteLoop{
                targetIndex = totalItemsCount / 2
                collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: false)
            }
            return
        }
        collectionView.scrollToItem(at: indexPath, at: .init(rawValue: 0), animated: true)
    }
    
}

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: self)
    }
    
}

