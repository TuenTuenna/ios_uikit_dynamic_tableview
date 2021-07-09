//
//  ViewController.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2020/09/01.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet var prependButton: UIBarButtonItem!
    @IBOutlet var resetButton: UIBarButtonItem!
    @IBOutlet var appendButton: UIBarButtonItem!
    
    var appendingCount: Int = 0
    var prependingCount: Int = 0
    var prependingArray = ["1 앞에 추가" , "2 앞에 추가", "3 앞에 추가", "4 앞에 추가", "5 앞에 추가", "6 앞에 추가", "7 앞에 추가", "8 앞에 추가"]
    
    var addingArray = ["1 뒤에 추가" , "2 뒤에 추가", "3 뒤에 추가", "4 뒤에 추가", "5 뒤에 추가", "6 뒤에 추가", "7 뒤에 추가", "8 뒤에 추가"]
    
    var tempArray : [String] = []
//    var tempArray : [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 쎌 리소스 파일 가져오기
        let myTableViewCellNib = UINib(nibName: String(describing: MyTableViewCell.self), bundle: nil)
        
        // 쏄에 리소스 등록
        self.myTableView.register(myTableViewCellNib, forCellReuseIdentifier: "myTableViewCellId")
        
        self.myTableView.rowHeight = UITableView.automaticDimension
        self.myTableView.estimatedRowHeight = 120
        
        // 아주 중요
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
    }

    
    @IBAction func barButtonAction(_ sender: UIBarButtonItem) {
        print(#function, #line, "")
        switch sender {
        case prependButton:
            print("앞에 추가 버튼 클릭!")
            self.prependData()
        case resetButton:
            print("데이터 리셋 버튼 클릭!")
            self.resetData()
        case appendButton:
            print("뒤에 추가 버튼 클릭!")
            self.appendData()
        default: break
        }
    }
    
} // ViewController

//MARK: - 테이블뷰 관련 메소드
extension ViewController {
    
    fileprivate func prependData(){
        print(#fileID, #function, #line, "")
        
        prependingCount = prependingCount + 1
        
        let tempPrependingArray = prependingArray.map{ $0.appending(String(prependingCount)) }
        
        self.tempArray.insert(contentsOf: tempPrependingArray, at: 0)
//        self.myTableView.reloadData()
        self.myTableView.reloadDataAndKeepOffset()
    }
    
    fileprivate func appendData(){
        print(#fileID, #function, #line, "")
        
        appendingCount = appendingCount + 1
        
        let tempAddingArray = addingArray.map{ $0.appending(String(appendingCount)) }
        
        self.tempArray += tempAddingArray
        self.myTableView.reloadData()
    }
    
    fileprivate func resetData(){
        print(#fileID, #function, #line, "")
        appendingCount = 0
        prependingCount = 0
        tempArray = []
        self.myTableView.reloadData()
    }
}

//MARK: - UITableViewDelegate 관련 메소드
extension ViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource 관련 메소드
extension ViewController: UITableViewDataSource {
    
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempArray.count
      }
      
    // 각 쎌에 대한 설정
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myTableViewCellId", for: indexPath) as! MyTableViewCell
        
        cell.userContentLabel.text = tempArray[indexPath.row]
        
        return cell
        
      }
}

extension UITableView {
    func reloadDataAndKeepOffset() {
        // 스크롤링 멈추기
        setContentOffset(contentOffset, animated: false)
        
        // 데이터 추가전 컨텐트 사이즈
        let beforeContentSize = contentSize
        reloadData()
        layoutIfNeeded()
        
        // 데이터 추가후 커텐트 사이즈
        let afterContentSize = contentSize
        
        // 데이터가 변경되고 리로드 되고 나서 컨텐트 옵셋 계산
        let calculatedNewOffset = CGPoint(
            x: contentOffset.x + (afterContentSize.width - beforeContentSize.width),
            y: contentOffset.y + (afterContentSize.height - beforeContentSize.height)
        )
        
        // 변경된 옵셋 설정
        setContentOffset(calculatedNewOffset, animated: false)
    }
}
