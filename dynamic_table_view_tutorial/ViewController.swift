//
//  ViewController.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2020/09/01.
//  Copyright © 2020 Tuentuenna. All rights reserved.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet var prependButton: UIBarButtonItem!
    @IBOutlet var resetButton: UIBarButtonItem!
    @IBOutlet var appendButton: UIBarButtonItem!
    
    var viewModel: ViewModel = ViewModel()
  
    var disposalbleBag = Set<AnyCancellable>()
    
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
        
        
        // 뷰모델의 데이터 상태를 연동시킨다
        self.setBindings()
    }

    
    @IBAction func barButtonAction(_ sender: UIBarButtonItem) {
        print(#function, #line, "")
        switch sender {
        case prependButton:
            print("앞에 추가 버튼 클릭!")
            self.viewModel.prependData()
        case resetButton:
            print("데이터 리셋 버튼 클릭!")
            self.viewModel.resetData()
        case appendButton:
            print("뒤에 추가 버튼 클릭!")
            self.viewModel.appendData()
        default: break
        }
    }
    
} // ViewController

//MARK: - 테이블뷰 관련 메소드
extension ViewController {
    
}

//MARK: - 뷰모델 관련
extension ViewController {
    
    /// 뷰모델의 데이터를 뷰컨의 리스트 데이터와 연동
    fileprivate func setBindings(){
        print("ViewController - setBindings()")
        
        // list 에 대한 바인딩
        self.viewModel.$tempArray.sink{ (updatedList : [String]) in
            print("ViewController - updatedList.count: \(updatedList.count)")
            self.tempArray = updatedList
//            self.myTableView.reloadData()
        }.store(in: &disposalbleBag)
        
        // action에 대한 바인딩
        self.viewModel.dataUpdatedAction.sink{ (addingType : ViewModel.AddingType) in
            print("ViewController - dataUpdatedAction: \(addingType)")
            switch addingType{
//            case .append, .reset:
//                self.myTableView.reloadData()
            case .prepend:
                self.myTableView.reloadDataAndKeepOffset()
            default:
                self.myTableView.reloadData()
            }
        }.store(in: &disposalbleBag)
        
        self.viewModel.arrayCount.sink { arrayCount in
            print("ViewController - arrayCount: \(arrayCount)")
            self.navigationItem.title = "배열갯수: \(arrayCount)"
        }.store(in: &disposalbleBag)
        
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
