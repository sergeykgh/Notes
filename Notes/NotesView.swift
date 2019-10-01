//
//  ContentView.swift
//  Notes
//
//  Created by Sergey Korotkevich on 28/09/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import SwiftUI

struct NotesView: View {
    @EnvironmentObject var model: Model

    var addButton: some View {
        Button(action: {
            self.addNotePressed()
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
    }
    
    func addNotePressed() {
        self.model.pushed = true
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List (model.notes) { note in
                    NoteCell(note: note)
                }
                .navigationBarTitle(Text("Notes"))
                .navigationBarItems(trailing: addButton)
                
                .alert(isPresented: $model.showError) {
                    return Alert(title: Text("Error"),
                                 message: Text(model.errorMessage),
                                 dismissButton: .default(Text("Ok"), action: {
                        self.model.showError = false
                    }))
                }
                
                if self.model.pushed {
                    NavigationLink(destination: NoteDetailView(isNewNote: true, id: 0), isActive: $model.pushed) {
                        EmptyView()
                    }
                }
            }.onAppear() {
                self.model.loadNotes()
            }
        }
    }
}

struct NoteCell: View {
    let note: Note
    var body: some View {
        return NavigationLink(destination: NoteDetailView(isNewNote: false, id: note.id)) {
            Text(note.title)
                .frame(height: 60)
                .lineLimit(2)
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
