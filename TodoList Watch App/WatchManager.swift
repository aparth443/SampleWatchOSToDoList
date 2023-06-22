//
//  WatchManager.swift
//  TodoList Watch App
//
//  Created by Cumulations Technology on 22/06/23.
//

import Foundation
import WatchConnectivity

class WatchManager:NSObject,ObservableObject,WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState{
        case .activated:
            print("WatchOS Session activated successfully.")
        case .notActivated:
            print("WatchOS Session is not activated.")
        case .inactive:
            print("WatchOS Session is inactive currently.")
        @unknown default:
            print("WatchOS Session unknown activation state.")
        }
        
        if let error = error{
            print("WatchOS session activation error: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    }
    
}
