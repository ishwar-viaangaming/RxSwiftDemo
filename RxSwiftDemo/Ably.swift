//
//  Ably.swift
//  RxSwiftDemo
//
//  Created by iSHU on 06/08/20.
//  Copyright © 2020 iSHU. All rights reserved.
//

import Foundation
import Ably

class Ably {
    static let ablyKey = ""
}

extension UIViewController {
    private func getAblyEngine() -> ARTRealtime {
        return ARTRealtime(key: Ably.ablyKey)
    }
    
    private func getAblyChannel(withChannelName channelName: String) -> ARTRealtimeChannel {
        return getAblyEngine().channels.get(channelName)
    }
    
    func subscribeAblyChannel(withChannelName channelName: String, onCompletion: @escaping ([String: Any]) -> Void) {
        getAblyChannel(withChannelName: channelName).subscribe(channelName) { (receivedData) in
            if let formattedDict = receivedData.data as? [String: Any] {
                onCompletion(formattedDict)
            }
            else {
                do {
                    if let receivedDataString = receivedData.data as? String, let formattedResponse = receivedDataString.data(using: .utf8) {
                        let formattedDict = try JSONSerialization.jsonObject(with: formattedResponse, options: .mutableContainers)
                        if let formattedDic = formattedDict as? [String: Any] {
                            onCompletion(formattedDic)
                        }
                    }
                }
                catch let error {
                    print("Comment Parsing Error - ", error)
                }
            }
        }
    }
}
