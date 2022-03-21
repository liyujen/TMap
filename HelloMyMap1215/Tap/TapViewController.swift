//
//  TapViewController.swift
//  TMap
//
//  Created by student on 2022/3/15.
//

import UIKit
import Photos
import Firebase

protocol TapViewControllerDelegate {
    func didPublishLocationData(data: AnnotationData)
}

class TapViewController: UIViewController, UIImagePickerControllerDelegate &  UINavigationControllerDelegate, UICollectionViewDataSource {
    
    var photos = [UIImage]()
    var photosUrl : [String] = []
    var photoNumberNeedToPut = 0 //需要上傳的照片數量
    var successedPutPhotoNumber = 0 //已經照片上傳的數量
    let noURLString = "noURL"
    
    private var latitude:Double?
    private var longitude:Double?
    
    
    func setCoordinate(latitude:Double,longitude:Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyImageCell
        cell.imageView.image = self.photos[indexPath.row]
       
        return cell
        
    }
    
    //主標題
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    //副標題
    @IBOutlet weak var subtitleTextField: UITextField!
    //圖片
    //@IBOutlet weak var imageView: UIImageView!
    //說明文字
    @IBOutlet weak var textView: UITextView!
    
    var annotationData : AnnotationData?
    var delegate : TapViewControllerDelegate?
    var myAsset : PHAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        
        
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
        
        //  @IBAction func done(_ sender: Any) {
        
        
        
        
        
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
        
        
        //確認照片都上傳了
        photoNumberNeedToPut = photos.count
        successedPutPhotoNumber = 0
        view.setLoadingView(true)
        
        for i in 0 ... photos.count - 1 {
            //上傳photos[i]
            putItemPhoto(image: photos[i], completion: { url -> () in
                
                //這一段，就是講說，我上傳了一張照片，並且得到了Server説，你上傳好了
                //我收到說喔我上傳好了，那你生成照片的下載位置給我
                //Server說，好，我生成給你，這是你的url
                self.photosUrl[i] = url
                self.successedPutPhotoNumber += 1
                
                if self.successedPutPhotoNumber == self.photoNumberNeedToPut{
                    
                    //上傳AnnotaionData
                    self.annotationData = AnnotationData(title: self.titleTextField.text!, subTitle: self.subtitleTextField.text!, latitude: String(self.latitude!), longitude: String(self.longitude!), photosUrl:self.photosUrl)
                    self.delegate?.didPublishLocationData(data: self.annotationData!)
                    
                    //關閉畫面
                    self.view.setLoadingView(false)
                    self.dismiss(animated: true, completion: nil)
                }
                
            })
        }
        
        
        //把url放進AnnotaionData
        
        
        
        
        
        //        NotificationCenter.default.post(name: .tapUpdated, object: nil, userInfo:["tap":self.locationData!])
        
        //        let annotation=MKPointAnnotation()
        //        annotation.title=""
        //        annotation.coordinate=tapMapCoordinate
        //        annotation.subtitle = ""
        //        self.myMapView.addAnnotation(annotation)
        //        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImageBtn(_ sender: Any) {
        
        
        //        let photoPicker = UIImagePickerController()
        //        photoPicker.delegate = self
        //        self.present(photoPicker,animated: true,completion: nil)//a成一對
        
        //開始選照片，最多4張
        self.presentHGImagePicker(maxSelected:4) { (assets) in
            
            print("共選擇了\(assets.count)張圖片，分別如下：")
            self.photos.removeAll()
            self.photosUrl.removeAll()
            for asset in assets {
                let image = self.convertImageFromAsset(asset: asset)
                self.photos.append(image)
                self.photosUrl.append(self.noURLString)
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
    
    
    func putItemPhoto(image:UIImage,completion: @escaping ((String) -> ())){
        
        var compressedPhoto = image.imageWithNewSize(size: CGSize(width: 1024, height: 1024))
        compressedPhoto = compressedPhoto!.compressQuality(maxLength: 1024 * 1024)//照片的目標壓縮大小
        
        let storageRefForItemPhoto = Storage.storage().reference().child("annotationPhoto/" + NSUUID().uuidString)
        
        //這一段，就是講說，我上傳了一張照片，並且得到了Server説，你上傳好了
        //我收到說喔我上傳好了，那你生成照片的下載位置給我
        //Server說，好，我生成給你，這是你的url
        if let compressedPhotoUploadData = compressedPhoto!.jpegData(compressionQuality: 1){
            storageRefForItemPhoto.putData(compressedPhotoUploadData,metadata: nil,completion: {
                (metadata,error) in
                if error != nil {
                    print(error ?? "上傳item的photo失敗")
                }
                
                storageRefForItemPhoto.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print(error ?? "itemPhoto產生url失敗")
                        return
                    }
                    completion(downloadURL.absoluteString)
                }
            }
            )}
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
