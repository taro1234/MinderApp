//
//  UserPageViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/07/02.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var createdDateLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ユーザー名が編集されて、キーボードの閉じるが押されたときにサーバーのユーザー名も変更
    // CRUDの「U」(Update)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 自分のユーザーオブジェクトのobjectIdが一致するものを取得し、更新
        let query = NCMBUser.query()
        query?.getObjectInBackground(withId: NCMBUser.current().objectId, block: { (object, error) in
            if error != nil {
                // サーバーのユーザーオブジェクトの取得にエラーがあったら出力
                print(error!.localizedDescription)
            } else {
                object?.setObject(textField.text, forKey: "userName")
                object?.saveInBackground({ (error) in
                    if error != nil {
                        // 更新に失敗した場合エラーを出力
                        print(error!.localizedDescription)
                    }
                })
            }
        })
        
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    // ユーザー情報の読み込み
    func loadUserInfo() {
        // アプリのクラッシュを防ぐため、今ユーザー情報がnilになっていないかチェックし、nil出なければ現在のユーザーを取得
        // CRUDの「R」(Read)
        if let user = NCMBUser.current() {
            
            // ユーザー名
            if let username = user.userName {
                usernameTextField.text = username
            }
            
            // 登録日時
            if let date = user.createDate {
                createdDateLabel.text = date.description
            }
        }
    }
    
    @IBAction func signOut() {
        
        // ログアウト
        NCMBUser.logOutInBackground { (error) in
            if error != nil {
                // エラーが出たら出力
                print(error!.localizedDescription)
            } else {
                // ログアウトに成功したらログイン画面のStoryboardを起動
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let viewController = storyboard.instantiateInitialViewController()
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window!?.rootViewController = viewController
                appDelegate?.window!?.makeKeyAndVisible()
                
                // UserDefaultsのログイン情報をfalseに
                let ud = UserDefaults.standard
                ud.set(false, forKey: "isSignIn")
                ud.synchronize()
            }
        }
    }
}
