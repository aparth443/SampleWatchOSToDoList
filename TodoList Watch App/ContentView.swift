//
//  ContentView.swift
//  TodoList Watch App
//
//  Created by Cumulations Technology on 22/06/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    @StateObject private var watchManager = WatchManager()
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    
    func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func sendMessageToPhone(data: Data){
        let session = WCSession.default
        if session.isReachable{
            let message = ["note": data]
            session.sendMessage(message, replyHandler: nil) { error in
                print("Error sending data to phone: \(error.localizedDescription)")
            }
        }
    }
    
    func save(){
        do{
            //Convert the notes array to data using JSONEncoder
            let data = try JSONEncoder().encode(notes)
            //Create a new URL to save the file using the getDocumentDirectory()
            let url = getDocumentDirectory().appendingPathComponent("notes")
            try data.write(to: url)
            //Write the data to the given URL
            sendMessageToPhone(data: data)
        }catch{
            print("Saving data has failed!")
        }
    }
    
    func load(){
        DispatchQueue.main.async {
            do{
                //Get the notes url path
                let url = getDocumentDirectory().appendingPathComponent("notes")
                //create a new property for the data
                let data = try Data(contentsOf: url)
                //decode the data
                notes = try JSONDecoder().decode([Note].self, from: data)
            }catch{
                print("Loading data has failed!")
            }
        }
    }
    
    func delete(offsets: IndexSet){
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    var body: some View {
        NavigationStack{
            VStack {
                HStack(alignment: .center, spacing: 6){
                    TextField("Add New Note", text: $text)
                    Button{
                        guard text.isEmpty == false else{
                            return
                        }
                        let note = Note(id: UUID().uuidString, text: text)
                        notes.append(note)
                        text = ""
                        save()
                        
                    }label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 42, weight: .semibold))
                    }
                    .fixedSize()
                    .buttonStyle(PlainButtonStyle())
                    .foregroundColor(.accentColor)
                }
                Spacer()
                
                if notes.count>=1 {
                    List{
                        ForEach(0..<notes.count, id: \.self) { i in
                            NavigationLink(destination: DetailView(note: notes[i], count: notes.count, index: i)) {
                                HStack{
                                    Capsule()
                                        .frame(width: 4)
                                        .foregroundColor(.accentColor)
                                    Text(notes[i].text)
                                        .lineLimit(1)
                                        .padding(.leading, 5)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                    }
                } else {
                    Spacer()
                    Image(systemName: "note.text")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .opacity(0.25)
                        .padding(25)
                    Spacer()
                }
            }
            .navigationTitle("Notes")
            .onAppear(perform: {
                if WCSession.isSupported() {
                    let session = WCSession.default
                    session.delegate = watchManager
                    session.activate()
                }
                load()
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

