//
//  TapViewController.swift
//  TMap
//
//  Created by student on 2022/3/15.
//

import UIKit
import Photos

protocol TapViewControllerDelegate {
    func didFinishUpdateTap(tap: Tap)
}

class TapViewController: UIViewController, UIImagePickerControllerDelegate &  UINavigationControllerDelegate, UICollectionViewDataSource {
    var images = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyImageCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    //主標題
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pointLabel: UITextField!
    //副標題
    @IBOutlet weak var viewPointLabel: UITextField!
    //圖片
    //@IBOutlet weak var imageView: UIImageView!
    //說明文字
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var toorbar: UIToolbar!
    
    var tap : Tap?
    var delegate : TapViewControllerDelegate?
    var myAsset : PHAsset!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        //主標
        self.pointLabel.text = self.tap?.pointtext
        //副標
        self.viewPointLabel.text = self.tap?.viewpointtext
        //說明文字
        self.textView.text = self.tap?.text
        //圖片
     
       // self.imageView.image = self.tap.image()
     
//            PHImageManager.default().requestImage(for: myAsset,
//                                     targetSize: PHImageManagerMaximumSize , contentMode: .default,
//                                     options: nil, resultHandler: {
//                                        (image, _: [AnyHashable : Any]?) in
//                self.imageView.image = image
//
//    })
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
               tap.cancelsTouchesInView = false
               view.addGestureRecognizer(tap)
    }
    //done之後儲存
    @IBAction func done(_ sender: Any) {
        self.tap?.pointtext = self.pointLabel.text
        self.tap?.viewpointtext = self.viewPointLabel.text
        self.tap?.text = self.textView.text
//        
        //self.tap.image = self.imageView.image
//        if let image = self.imageView.image,
//           let imageData = image.jpegData(compressionQuality: 1){
//            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
//            let docURL = homeURL.appendingPathComponent("Documents")
//            let photoURL = docURL.appendingPathComponent("\(self.tap.tapID).jpg")
//            self.tap.imageName = "\(self.tap.tapID).jpg"
////            let photoURL = docURL.appendingPathComponent("\(editingNote.noteID).jpg")
////            editingNote.imageName = "\(photoURL.tapID).jpg"
//            do{
//                try imageData.write(to:photoURL,options:[.atomicWrite])
//            }catch{
//                print("error\(error)")
//            }
//        }
        
       // self.delegate?.didFinishUpdateTap(tap: self.tap)
        NotificationCenter.default.post(name: .tapUpdated, object: nil, userInfo:["tap":self.tap!])
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addImageBtn(_ sender: Any) {
   
        
//        let photoPicker = UIImagePickerController()
//        photoPicker.delegate = self
//        self.present(photoPicker,animated: true,completion: nil)//a成一對
        
        //開始選照片，最多4張
        _ = self.presentHGImagePicker(maxSelected:4) { (assets) in
            
            print("共選擇了\(assets.count)張圖片，分別如下：")
            self.images.removeAll()
            for asset in assets {
                let image = self.convertImageFromAsset(asset: asset)
                self.images.append(image)
                print(asset)
            }
            self.collectionView.reloadData()
            
        }
    }
    //多張圖片
    func convertImageFromAsset(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var image = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            image = result!
        })
        return image
    }
    
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    }
//    var isNewImage = false//判斷使用者有沒有更動照片
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        self.isNewImage = true//有更動照片才重新存
//        if let image = info[.originalImage] as? UIImage{
//            self.imageView.image = image
//        }
        //跳出關閉
      //image picker關掉用dismiss
       // self.dismiss(animated:true,completion: nil)  //a成一對
      //  picker.dismiss(animated:true,completion: nil)
 //   }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



//定義通知的名稱
extension Notification.Name{
    static let tapUpdated = Notification.Name("tapUpdated")
}
