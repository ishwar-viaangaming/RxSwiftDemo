//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by iSHU on 01/08/20.
//  Copyright © 2020 iSHU. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import AgoraRtcKit

class ViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    
    let userData: PublishSubject<User> = PublishSubject()
    var userViewModel = UserViewModel()
    let disposeBag = DisposeBag()
    let userArray = PublishSubject<[String]>()
    var mytbl = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Adding observer to user data")
        print("Binding userviewmodel's user data to vc's user data")
        userViewModel
            .userData
            .observeOn(MainScheduler.instance)
            .bind(to: self.userData)
            .disposed(by: disposeBag)
        
        print("Subscription on user data in current VC")
        userData.subscribe(onNext: { (receivedUser) in
            print("Received user data from API")
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        print("Calling API....")
        userViewModel.getUserData()
        
        
        
        
        setUp()
        userArray.onNext(["Ishwar", "Sonali", "Divyesh", "Mitali"])
        
        
        self.setupAgoraVideo()
        self.setAgoraClientRole(withRole: .audience)
        self.joinAgoraChannel(withChannelName: "Ishwar", withUserToken: nil)
    }
    
    func setUp() {
        userArray.bind(to: userTableView.rx.items(cellIdentifier: "DemoCell", cellType: DemoCell.self)) {
            index, user, cell in
            cell.textLabel?.text = user
        }.disposed(by: disposeBag)
    }
}

