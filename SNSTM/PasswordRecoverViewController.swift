//
//  PasswordRecoverViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/07/02.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit

class PasswordRecoverViewController: UIViewController, UINavigationControllerDelegate {
    

    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "forgot password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recoberBtn(_ sender: Any) {
        let userEmail = userEmailTextField.text

    }
    
    
    
    
}
