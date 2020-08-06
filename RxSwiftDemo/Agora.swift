//
//  Agora.swift
//  RxSwiftDemo
//
//  Created by iSHU on 05/08/20.
//  Copyright © 2020 iSHU. All rights reserved.
//

import Foundation
import AgoraRtcKit

class Agora {
    static let appID = "cfae6c828f2546a2bcbf7bdce0208b52"
}

extension UIViewController: AgoraRtcEngineDelegate {
    
    func getAgoraEngine() -> AgoraRtcEngineKit {
        return AgoraRtcEngineKit.sharedEngine(withAppId: Agora.appID, delegate: self)
    }
    
    func setAgoraClientRole(withRole role: AgoraClientRole) {
        getAgoraEngine().setClientRole(role)
        if role == .broadcaster {
            getAgoraEngine().startPreview()
        }
    }
    
    func setupAgoraVideo(withUserID userID: UInt = 0) {
        getAgoraEngine().setChannelProfile(.liveBroadcasting)
        getAgoraEngine().enableDualStreamMode(false)
        getAgoraEngine().enableVideo()
        getAgoraEngine().setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: AgoraVideoDimension480x360,
                frameRate: .fps15,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .fixedPortrait
            )
        )
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = userID
        videoCanvas.view = self.view
        videoCanvas.renderMode = .fit
        getAgoraEngine().setupLocalVideo(videoCanvas)
    }
    
    func setAgoraMute(withMuteValue value: Bool) {
        getAgoraEngine().muteLocalAudioStream(value)
    }
    
    func joinAgoraChannel(withChannelName channelName: String, withUserToken token: String?, withUserID userID: UInt = 0) {
        let code = getAgoraEngine().joinChannel(byToken: token, channelId: channelName, info: nil, uid: userID) { (channelName, userID, elapsed) in
            print("Connected channel name = \(channelName), UserID=\(userID), Elapsed=\(elapsed)")
        }
        if code == 0 {
            getAgoraEngine().setEnableSpeakerphone(true)
        }
    }
    
    func switchAgoraChannel(withChannelName channelName: String, withUserToken token: String?) {
        getAgoraEngine().switchChannel(byToken: token, channelId: channelName) { (channelName, userID, elapsed) in
            print("Connected channel name = \(channelName), UserID=\(userID), Elapsed=\(elapsed)")
        }
    }
    
    func leaveAgoraChannel() {
        getAgoraEngine().leaveChannel(nil)
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        if errorCode == .invalidChannelId {
            print("no broadcasting found")
        }
        print("didOccurError = \(errorCode)")
    }
    
    public func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        
    }

    public func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        
    }
}
