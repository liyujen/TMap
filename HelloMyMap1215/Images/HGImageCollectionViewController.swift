//
//  HGImageCollectionViewController.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos

//圖片集
class HGImageCollectionViewController: UIViewController {
    //用于顯示所有圖片縮圖的collectionView
    @IBOutlet weak var collectionView:UICollectionView!
    
    //下方工具列
    @IBOutlet weak var toolBar:UIToolbar!

    //取得的圖片结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>?
    
    //待緩存的圖片
    var imageManager:PHCachingImageManager!
    
    //縮圖大小
    var assetGridThumbnailSize:CGSize!
    
    //每次最多可選的照片量
    var maxSelected:Int = Int.max
    
    //照片選擇完畢後
    var completeHandler:((_ assets:[PHAsset])->())?
    
    //完成button
    var completeButton:HGImageCompleteButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //根據尺寸計算需要的縮圖大小
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width: cellSize.width*scale ,
                                        height: cellSize.height*scale)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景色設為白色（默认是黑色）
        self.collectionView.backgroundColor = UIColor.white
        
        //初始化和重置緩存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        //設置單元格尺寸
        let layout = (self.collectionView.collectionViewLayout as!
            UICollectionViewFlowLayout)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width/4-1,
                                 height: UIScreen.main.bounds.size.width/4-1)
        //允許多選
        self.collectionView.allowsMultipleSelection = true
        
        //添加右側的取消按鍵
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain,
                                           target: self, action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
      
        //添加下方工具欄的完成按鍵
        completeButton = HGImageCompleteButton()
        completeButton.addTarget(target: self, action: #selector(finishSelect))
        completeButton.center = CGPoint(x: UIScreen.main.bounds.width - 50, y: 22)
        completeButton.isEnabled = false
        toolBar.addSubview(completeButton)
    }

    //重置緩存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    
    //取消button
    @objc func cancel() {
        //退出相簿view
        self.navigationController?.dismiss(animated: true, completion: nil)
       
    }
    
    //取得已選擇個數
    func selectedCount() -> Int {
        return self.collectionView.indexPathsForSelectedItems?.count ?? 0
    }
//MARK:
    //完成button
    @objc func finishSelect(){
        //取出已選擇的圖片
        var assets : [PHAsset] = []
        if let indexPaths = self.collectionView.indexPathsForSelectedItems{
            for indexPath in indexPaths{
                assets.append(assetsFetchResults![indexPath.row] )
            }
        }
        //調用
        self.navigationController?.dismiss(animated: true, completion: {
            self.completeHandler?(assets)
        })
    }
}

//圖片縮圖UICollectionViewDataSource,UICollectionViewDelegate
extension HGImageCollectionViewController:UICollectionViewDataSource
,UICollectionViewDelegate{
    //CollectionView
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults?.count ?? 0
    }
    
    // 取得圖片格
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //取得圖片格storyboard里設計的圖片格
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                    for: indexPath) as! HGImageCollectionViewCell
        let asset = self.assetsFetchResults![indexPath.row]
        //取得縮圖
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,
                                       contentMode: .aspectFill, options: nil) {
                                        (image, nfo) in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    //選取圖片格
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)
            as? HGImageCollectionViewCell{
            //取得選中的個數數量
            let count = self.selectedCount()
            //如果選擇的個數大於最大選擇數
            if count > self.maxSelected {
                //設置為無法選取
                collectionView.deselectItem(at: indexPath, animated: false)
                //跳出警告
                let title = "你最多只能選\(self.maxSelected)張照片"
                let alertController = UIAlertController(title: title, message: nil,
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title:"我知道了", style: .cancel,
                                                 handler:nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            //最大選擇數以下
            else{
                //完成按鈕旁邊的數字
                completeButton.num = count
                if count > 0 && !self.completeButton.isEnabled{
                    completeButton.isEnabled = true
                }
                cell.playAnimate()
            }
        }
    }
    
    //取消選中的縮圖
    func collectionView(_ collectionView: UICollectionView,
                        didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath)
            as? HGImageCollectionViewCell{
             //取得選中個數
            let count = self.selectedCount()
            completeButton.num = count
             //更變完成按鈕旁邊的數字
            if count == 0{
                completeButton.isEnabled = false
            }
            cell.playAnimate()
        }
    }
}



