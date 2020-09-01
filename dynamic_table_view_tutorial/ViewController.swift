//
//  ViewController.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2020/09/01.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    let contentArray = [
        "simply dummy text of the printing and",
        
        "um has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type ",
        
        "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribestablished fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, co",
        
        "ho loves pain itself, who seeks after it and wants to have it, simply because it is pai",
        
        "established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, co",
        
        "ho loves pain itself, who seeks after it and wants to have it, simply because it is pai",
        
        "a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is thaai",
        
        "ho loves pain ita reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is to have it, simply because it is pai",
        
        "ho loves pain itself, who seeks after it and wants to have it, simplho loves pain ita reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is to have it, simply because it y because it is pai",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 쎌 리소스 파일 가져오기
//        let myTableViewCellNib = UINib(nibName: "MyTableViewCell", bundle: <#T##Bundle?#>)
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        // 쏄에 리소스 등록
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCellId")
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 120
        
        // 아주 중요
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        print("contentArray.count : \(contentArray.count)")
        
    }


  
    
}


extension ViewController: UITableViewDelegate {
    
}


extension ViewController: UITableViewDataSource {
    
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray.count
      }
      
    // 각 쎌에 대한 설정
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCellId", for: indexPath) as! MyTableViewCell
        
        cell.userContentLabel.text = contentArray[indexPath.row]
        
//        cell.userProfileImg.layer.cornerRadius = cell.userProfileImg.frame.height / 2
        
        return cell
        
      }
}
