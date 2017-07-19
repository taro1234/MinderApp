//
//  SignInViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/07/02.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var emailAdress: String!
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailAddressTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        mailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(SignInViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(SignInViewController.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        emailAdress = mailAddressTextField.text
        password = passwordTextField.text
        textField.resignFirstResponder()
        return true
    }
    
    func handleKeyboardWillShowNotification(_ notification: Notification) {
        
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        
        var txtLimit = mailAddressTextField.frame.origin.y + mailAddressTextField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    func handleKeyboardWillHideNotification(_ notification: Notification) {
        
        
        scrollView.contentOffset.y = 0
    }
    
    @IBAction func signIn() {
        
        // メールアドレス、パスワードに何も入力されていなかったら反応しないようにする
        guard let address = mailAddressTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        // ログイン
        NCMBUser.logInWithMailAddress(inBackground: address, password: password) { (user, error) in
            if error != nil {
                // エラーが起きた場合は出力
                print(error!.localizedDescription)
            } else {
                // ログインが成功した場合はMain.storyboardを起動
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateInitialViewController()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window!?.rootViewController = viewController
                appDelegate?.window!?.makeKeyAndVisible()
                
                // UserDefaultsのログイン情報をログイン済に変更
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isSignIn")
                ud.synchronize()
            }
        }
    }
    
    @IBAction func SwitchPassword(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    func touchBtnClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
