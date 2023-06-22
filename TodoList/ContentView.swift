//
//  ContentView.swift
//  TodoList
//
//  Created by Cumulations Technology on 22/06/23.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    
    @EnvironmentObject var watchManager : WatchManager
    @State private var notes: [Note] = [Note]()
    @State private var text: String = ""
    
    
    func update(with note: Note){
        DispatchQueue.main.async {
            if let index = notes.firstIndex(where: { $0.id == note.id }) {
                notes.remove(at: index)
            } else if !note.text.isEmpty {
                notes.append(note)
            }
        }
    }
    
    func delete(offsets: IndexSet) {
        withAnimation {
            let deletedNotes = offsets.map { notes[$0] }
            deletedNotes.forEach { deletedNote in
                if let index = notes.firstIndex(of: deletedNote) {
                    notes.remove(at: index)
                }
                watchManager.sendNoteToWatch(deletedNote)
            }
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
                        watchManager.sendNoteToWatch(note)
                        text = ""
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
                watchManager.activateWCSession()
            })
            .onReceive(watchManager.$messageFromWatch){
                note in
                update(with: note)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

