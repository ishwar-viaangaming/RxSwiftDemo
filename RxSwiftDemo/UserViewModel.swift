//
//  UserViewModel.swift
//  RxSwiftDemo
//
//  Created by iSHU on 01/08/20.
//  Copyright © 2020 iSHU. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct UserViewModel {
    
    public let userData: PublishSubject<User> = PublishSubject()
    
    func getUserData() {
        // Webservice call
        print("Setting user data from API")
        var tempUser = User()
        tempUser.name = "Ishwar"
        tempUser.surname = "Chauhan"
        self.userData.onNext(tempUser)
    }
    
    
}
