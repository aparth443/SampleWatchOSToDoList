//
//  WatchManager.swift
//  TodoList
//
//  Created by Cumulations Technology on 22/06/23.
//

import Foundation
import WatchConnectivity

class WatchManager:NSObject,ObservableObject,WCSessionDelegate{
    
    @Published var messageFromWatch: Note = Note(id: UUID().uuidString, text: "")
    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        return
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        return
    }
    
    override init(){
        super.init()
        activateWCSession()
    }
    
    func activateWCSession(){
        if WCSession.isSupported(){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
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
    
    func sendNoteToWatch(_ note: Note) {
        if WCSession.default.isReachable {
            let noteDict: [String: Any] = ["id": note.id, "text": note.text]
            let message = ["note": noteDict]
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending message to Watch app: \(error.localizedDescription)")
            }
        } else {
            print("Watch app is not reachable")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let noteDict = message["note"] as? [String: Any], let id = noteDict["id"] as? String, let text = noteDict["text"] as? String
        {
            let receivedNote = Note(id: id, text: text)
            DispatchQueue.main.async {
                self.messageFromWatch = receivedNote
            }
        }
    }
}
