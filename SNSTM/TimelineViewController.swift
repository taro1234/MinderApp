//
//  TimelineViewController.swift
//  SNSTM
//
//  Created by tarosekine on 2017/03/20.
//  Copyright © 2017年 tarosekine. All rights reserved.
//

import UIKit



// TableViewのDataSourceプロトコルとDelegateプロトコルを追加
class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var posts = [NCMBObject]()                       // NCMBから読み込んだつぶやきを入れるための配列
    @IBOutlet weak var timelineTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)     // xib化したカスタムセルを使う
        timelineTableView.register(nib, forCellReuseIdentifier: "Cell")            //reuseCellとして登録する
        
        timelineTableView.dataSource = self         // TableViewの基本設定
        timelineTableView.delegate = self
        
        loadTimeline()                              // TableViewの基本設定
        createSearchBar()
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search here!"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    /*
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return 100 // 適当なセルの高さ
     }
     */
    // テーブルのセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // テーブルのセルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの生成
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TimelineTableViewCell
        let imageURL = posts[indexPath.row].object(forKey: "imageURL") as? String

        if let url = imageURL {
            print(url)
            cell.mainImageView.sd_setImage(with: URL(string: url), placeholderImage: nil)
        } else {
            cell.mainImageView.image = nil
        }
        print(posts)
        cell.contentLabel.text = posts[indexPath.row].object(forKey: "date") as? String

        let place = posts[indexPath.row].object(forKey: "place") as! String
        cell.placeLabel.text = place
        cell.kyunTextView.text = posts[indexPath.row].object(forKey: "message") as? String
        cell.unTextLabel.text = posts[indexPath.row].object(forKey: "message") as? String
        // セルをTableViewに返す
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // リロードボタン
    @IBAction func reloadTimeline() {
        loadTimeline()
     }
    
    // タイムライン読み込み
    func loadTimeline() {
        // CRUDの「R」 = Read
        // Postクラス(データベース)から、全オブジェクトを取得している
        let query = NCMBQuery(className: "Post")
        query?.findObjectsInBackground({ (object, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                // データベースから読み込んだデータをNCMBのObject配列に変換
                // 読み込んだデータはAny?オブジェクトなので、ダウンキャストで変換
                let posts = object as! [NCMBObject]
                
                // 配列の中身を新しい順に並び替え(反転)
                self.posts = posts.reversed()
                
                // テーブルをリロード
                self.timelineTableView.reloadData()
            }
        })
    }
    
    func postedButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goTimelineSetting", sender: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func posted() {
        let storyboard: UIStoryboard = UIStoryboard(name: "TimelineViewController", bundle: nil)
        let TimelineTableViewCell = storyboard.instantiateInitialViewController()
        present(TimelineTableViewCell!, animated: true, completion: nil)
    }
    
}
            
