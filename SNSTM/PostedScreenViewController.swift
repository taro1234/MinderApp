//
//  PostedScreenViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/03/26.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

class PostedScreenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var screen: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var kyunTextView: UITextView!
    @IBOutlet weak var unTextView: UITextView!
    @IBOutlet weak var launchcamera: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateTextField.placeholder = "＃どんなデートでしたか？"
        placeTextField.placeholder = "#どこですか"
        
        dateTextField.delegate = self
        placeTextField.delegate = self
        kyunTextView.delegate = self
        unTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveTweet() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if screen.image != nil {
            // let imageW : Int = Int(screen.image!.size.width*0.2) /* 20%に縮小 */
            // let imageH : Int = Int(screen.image!.size.height*0.2) /* 20%に縮小 */
            let resizeImage = screen.image!.resize(ratio: 0.2)
            
            let pngData = NSData(data: UIImagePNGRepresentation(resizeImage)!)
            let file = NCMBFile.file(with: pngData as Data!) as! NCMBFile
            let acl = NCMBACL()
            // 全員に読み書き可とする
            acl.setPublicReadAccess(true)
            acl.setPublicWriteAccess(true)
            file.acl = acl
            
            // ファイルストアへ画像のアップロード
            file.saveInBackground({ (error) in
                if error != nil {
                    // 保存失敗時の処理
                } else {
                    print(file.url)
                    
                    // 保存成功時の処理
                    let object = NCMBObject(className: "Post")
                    object?.setObject(self.dateTextField.text, forKey: "date")
                    object?.setObject(self.placeTextField.text, forKey: "place")
                    object?.setObject(self.kyunTextView.text, forKey: "kyun")
                    object?.setObject(self.unTextView.text, forKey: "un")
                    object?.setObject(file.name, forKey: "filename")
                    let publicURL : String = "https://mb.api.cloud.nifty.com/2013-09-01/applications/brJIJGHJORmwJyq3/publicFiles/" + file.name
                    object?.setObject(publicURL, forKey: "imageURL")
                    object?.saveInBackground { error in
                        print("saved")
                    }
                }
            }) { (int) in
                // 進行状況を取得するためのBlock
                /* 1-100のpercentDoneを返す */
                /* このコールバックは保存中何度も呼ばれる */
                /*例）*/
                print("\(int)%")
            }
            
            let alertController = UIAlertController(title: "投稿完了", message: "投稿完了です", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            print("画像を投稿してください")
        }
    }
    
    @IBAction func intoButton(_ sender: UIButton) {
        
//        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
//        
//        if UIImagePickerController.isSourceTypeAvailable(.camera){
//            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction) in
//                let ipc : UIImagePickerController = UIImagePickerController()
//                ipc.sourceType = .camera
//                ipc.delegate = self
//                self.present(ipc, animated: true, completion: nil)
//            })
//            alertController.addAction(cameraAction)
//        }
//        
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: { (action:UIAlertAction) in
//                let ipc : UIImagePickerController = UIImagePickerController()
//                ipc.sourceType = .photoLibrary
//                ipc.delegate = self
//                self.present(ipc, animated: true, completion: nil)
//            })
//            alertController.addAction(photoLibraryAction)
//        }
//        
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        
//        alertController.popoverPresentationController?.sourceView = view
//        present(alertController, animated: true, completion: nil)
        
        
        let album = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(album) {
            let album = UIImagePickerController()
            album.delegate = self
            album.sourceType = UIImagePickerControllerSourceType.photoLibrary
            album.allowsEditing = true
            self.present(album, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
//    func resize (image: UIImage, width: Int, height: Int) -> UIImage {
//        let size: CGSize = CGSize(width: width, height: height)
//        UIGraphicsBeginImageContext(size)
//        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
//        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return resizeImage!
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.dateTextField.isFirstResponder) {
            self.dateTextField.resignFirstResponder()
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.frame = CGRect(x: 0, y: -180, width: self.view.bounds.width, height: self.view.bounds.height)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.4) {
            self.view.frame = CGRect(x: 0, y: 100, width: self.view.bounds.width, height: self.view.bounds.height)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    


}
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//        self.screen.image = image
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        self.dismiss(animated: true)
//    }




extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    // 比率だけ指定する場合
    func resize(ratio: CGFloat) -> UIImage {
        let resizedSize = CGSize(width: Int(self.size.width * ratio), height: Int(self.size.height * ratio))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}

