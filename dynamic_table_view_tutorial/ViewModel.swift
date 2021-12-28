//
//  ViewModel.swift
//  dynamic_table_view_tutorial
//
//  Created by Jeff Jeong on 2021/12/12.
//  Copyright © 2021 Tuentuenna. All rights reserved.
//

import Foundation
import Combine

// 뷰모델 - 뷰와 관련된 모델 - 즉 데이터 상태를 가지고 있음
class ViewModel: ObservableObject {

    enum AddingType {
        case append, prepend, reset
    }
    
    var appendingCount: Int = 0
    var prependingCount: Int = 0
    var prependingArray = ["1 앞에 추가" , "2 앞에 추가", "3 앞에 추가", "4 앞에 추가", "5 앞에 추가", "6 앞에 추가", "7 앞에 추가", "8 앞에 추가"]
    
    var addingArray = ["1 뒤에 추가" , "2 뒤에 추가", "3 뒤에 추가", "4 뒤에 추가", "5 뒤에 추가", "6 뒤에 추가", "7 뒤에 추가", "8 뒤에 추가"]
    
    @Published var tempArray : [String] = []

    lazy var arrayCount : AnyPublisher<Int, Never> = $tempArray.map { (array: [String]) -> Int in
        return array.count
    }.eraseToAnyPublisher()
    
    var dataUpdatedAction = PassthroughSubject<AddingType, Never>()
    
    init(){
        print("ViewModel - init()")
    }
    
}

//MARK: - 리스트 관련
extension ViewModel {
    
    func prependData(){
        print(#fileID, #function, #line, "")
        
        prependingCount = prependingCount + 1
        
        let tempPrependingArray = prependingArray.map{ $0.appending(String(prependingCount)) }
        
        self.tempArray.insert(contentsOf: tempPrependingArray, at: 0)
        self.dataUpdatedAction.send(.prepend)
//        self.myTableView.reloadData()
//        self.myTableView.reloadDataAndKeepOffset()
    }
    
    func appendData(){
        print(#fileID, #function, #line, "")
        
        appendingCount = appendingCount + 1
        
        let tempAddingArray = addingArray.map{ $0.appending(String(appendingCount)) }
        
        self.tempArray += tempAddingArray
        
        self.dataUpdatedAction.send(.append)
//        self.myTableView.reloadData()
    }
    
    func resetData(){
        print(#fileID, #function, #line, "")
        appendingCount = 0
        prependingCount = 0
        tempArray = []
        self.dataUpdatedAction.send(.reset)
//        self.myTableView.reloadData()
    }
}
