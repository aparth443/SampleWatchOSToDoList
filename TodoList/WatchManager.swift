//
//  WatchManager.swift
//  TodoList
//
//  Created by Cumulations Technology on 22/06/23.
//

import Foundation
import WatchConnectivity

class WatchManager:NSObject,ObservableObject,WCSessionDelegate{
    
    @Published var messageFromWatch: [Note] = [
        Note(id: UUID().uuidString, text: "Sample")
    ]
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState{
        case .activated:
            print("iOS Session activated successfully.")
        case .notActivated:
            print("iOS Session is not activated.")
        case .inactive:
            print("iOS Session is inactive currently.")
        @unknown default:
            print("iOS Session unknown activation state.")
        }
        
        if let error = error{
            print("iOS session activation error: \(error.localizedDescription)")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let data = message["note"] as? Data{
                do{
                    self.messageFromWatch = try JSONDecoder().decode([Note].self, from: data)
                }
                catch{
                    print("Error fetching data from watch: \(error)")
                }
            }
        }
    }
}
