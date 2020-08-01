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

class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    
    let userData: PublishSubject<User> = PublishSubject()
    var userViewModel = UserViewModel()
    let disposeBag = DisposeBag()
    
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
            self.nameLabel.text = receivedUser.name
            self.surnameLabel.text = receivedUser.surname
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        print("Calling API....")
        userViewModel.getUserData()
    }
}

