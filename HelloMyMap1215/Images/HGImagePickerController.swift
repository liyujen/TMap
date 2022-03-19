//
//  HGImageAlbumItem.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
struct HGImageAlbumItem {
    //相簿名稱
    var title:String?
    //相簿資料
    var fetchResult:PHFetchResult<PHAsset>
}

//相簿列控制頁
class HGImagePickerController: UIViewController {
    //顯示相簿列表格
    @IBOutlet weak var tableView:UITableView!
    
    //相簿列表集
    var items:[HGImageAlbumItem] = []
    
    //可選擇的照片數量上限
    var maxSelected:Int = Int.max
    
    //照片选择完毕后的回调
    var completeHandler:((_ assets:[PHAsset])->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //申請權限
        PHPhotoLibrary.requestAuthorization({ (status) in
            if status != .authorized {
                return
            }
            
            // 列出所有相簿
            let smartOptions = PHFetchOptions()
            let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .albumRegular,
                                                              options: smartOptions)
            self.convertCollection(collection: smartAlbums)
            
            //列出所有使用者創建的相簿
            let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
            self.convertCollection(collection: userCollections
                as! PHFetchResult<PHAssetCollection>)
            
            //相簿按包含的照片數量排序（降序）
            self.items.sort { (item1, item2) -> Bool in
                return item1.fetchResult.count > item2.fetchResult.count
            }
            
            //異步加載表格數據,調用reloadData() 方法
            DispatchQueue.main.async{
                self.tableView?.reloadData()
                
                //首次點擊直接進入相機膠卷
                if let imageCollectionVC = self.storyboard?
                    .instantiateViewController(withIdentifier: "hgImageCollectionVC")
                    as? HGImageCollectionViewController{
                    imageCollectionVC.title = self.items.first?.title
                    imageCollectionVC.assetsFetchResults = self.items.first?.fetchResult
                    imageCollectionVC.completeHandler = self.completeHandler
                    imageCollectionVC.maxSelected = self.maxSelected
                    self.navigationController?.pushViewController(imageCollectionVC,
                                                                  animated: false)
                }
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定標題
        title = "相簿"
        //表格樣式
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.rowHeight = 55
        //添加取消button
        let rightBarItem = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                           action: #selector(cancel))
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    //轉換相簿
    private func convertCollection(collection:PHFetchResult<PHAssetCollection>){
        for i in 0..<collection.count{
            //取得相簿圖片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            let c = collection[i]
            let assetsFetchResult = PHAsset.fetchAssets(in: c , options: resultsOptions)
            //沒有圖片的空相簿不顯示
            if assetsFetchResult.count > 0 {
                let title = titleOfAlbumForChinse(title: c.localizedTitle)
                items.append(HGImageAlbumItem(title: title,
                                              fetchResult: assetsFetchResult))
            }
        }
    }
    
    //相簿名稱
    private func titleOfAlbumForChinse(title:String?) -> String? {
        if title == "Slo-mo" {
            return "慢動作"
        } else if title == "Recently Added" {
            return "最近添加"
        } else if title == "Favorites" {
            return "個人收藏"
        } else if title == "Recently Deleted" {
            return "最近刪除"
        } else if title == "Videos" {
            return "影片"
        } else if title == "All Photos" {
            return "所有照片"
        } else if title == "Selfies" {
            return "自拍"
        } else if title == "Screenshots" {
            return "螢幕截圖"
        } else if title == "Camera Roll" {
            return "相機膠卷"
        }
        return title
    }
    
    //取消button
    @objc func cancel() {
        //退回tapvc
        self.dismiss(animated: true, completion: nil)
    }
    
    //畫面跳轉
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //如果是跳到展示相簿縮圖頁
        if segue.identifier == "showImages"{
            //取得照片展示
            guard let imageCollectionVC = segue.destination
                as? HGImageCollectionViewController,
                let cell = sender as? HGImagePickerCell else{
                return
            }
            
            imageCollectionVC.completeHandler = completeHandler
            //標題
            imageCollectionVC.title = cell.titleLabel.text
            //最多可選圖片數量
            imageCollectionVC.maxSelected = self.maxSelected
            guard  let indexPath = self.tableView.indexPath(for: cell) else { return }
            
            //取得相簿資料
            let fetchResult = self.items[indexPath.row].fetchResult
            //相簿内的圖片資料
            imageCollectionVC.assetsFetchResults = fetchResult
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension HGImagePickerController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        //縮圖格
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HGImagePickerCell
        let item = self.items[indexPath.row]
        cell.titleLabel.text = "\(item.title ?? "") "
        cell.countLabel.text = "（\(item.fetchResult.count)）"
        return cell
    }
    
    //縮圖格數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //選曲縮圖格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIViewController {
    func presentHGImagePicker(maxSelected:Int = Int.max,
                              completeHandler:((_ assets:[PHAsset])->())?)
        -> HGImagePickerController?{
        
        if let vc = UIStoryboard(name: "HGImage", bundle: Bundle.main)
            .instantiateViewController(withIdentifier: "imagePickerVC")
            as? HGImagePickerController{
            
            vc.completeHandler = completeHandler
            vc.maxSelected = maxSelected
            
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return vc
        }
        return nil
    }
}
