//
//  SignUpViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/07/02.
//  Copyright © 2017年 tarosekine. All rights reserved.
//
import UIKit

// TextFieldプロトコルを追加
class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // キーボードを閉じる(完了ボタンの検知の)ためにDelegateを設定
        usernameTextField.delegate = self
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        usernameTextField.placeholder = "username"
        mailAddressTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        confirmTextField.placeholder = "Password（Confirmation）"
        
        scrollView.delegate = self
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(mailAddressTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(confirmTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(SignUpViewController.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShowNotification(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        
        var usernameLimit = usernameTextField.frame.origin.y + usernameTextField.frame.height + 8.0
        var mailAdressLimit = mailAddressTextField.frame.origin.y + mailAddressTextField.frame.height + 8.0
        var passwordLimit = passwordTextField.frame.origin.y + passwordTextField.frame.height + 8.0
        var confirmLimit = confirmTextField.frame.origin.y + confirmTextField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        
        
        
        if usernameLimit >= kbdLimit {
            scrollView.contentOffset.y = usernameLimit - kbdLimit
        }
        if mailAdressLimit >= kbdLimit{
            scrollView.contentOffset.y = mailAdressLimit - kbdLimit
        }
        if passwordLimit >= kbdLimit{
            scrollView.contentOffset.y = passwordLimit - kbdLimit
        }
        if confirmLimit >= kbdLimit{
            scrollView.contentOffset.y = confirmLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // キーボードのReturnキーが押されたときを検知し、キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
 
    @IBAction func registerUser(_ sender: Any) {
        
        // ちゃんと書き込まれているかチェックし、文字数が0なら反応しないようにする
        if usernameTextField.text?.characters.count == 0 {
            return
        }
        
        if mailAddressTextField.text?.characters.count == 0 {
            return
        }
        
        if passwordTextField.text?.characters.count == 0 {
            return
        }
        
        if passwordTextField.text != confirmTextField.text {
            return
        }
        
        // ユーザー情報をNCMBのユーザー情報を保存するクラスに保存
        // CRUDの「C」(Create)
        let users = NCMBUser()
        users.userName = usernameTextField.text
        users.mailAddress = mailAddressTextField.text
        users.password = passwordTextField.text
        
        NCMBUser.requestAuthenticationMail(mailAddressTextField.text, error: nil)
        users.signUpInBackground { (error) in
            if error != nil {
                // エラーが起きた場合
                print(error!.localizedDescription)
            } else {
                // 新規登録が完了した場合、Main.storyboardを起動
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateInitialViewController()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window!?.rootViewController = viewController
                appDelegate?.window!?.makeKeyAndVisible()
                
                // UserDefaultsにログイン済みと記録
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isSignIn")
                ud.synchronize()
            }
        }
    }
}
