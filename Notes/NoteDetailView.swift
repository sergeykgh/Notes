//
//  NoteDetailView.swift
//  Notes
//
//  Created by Sergey Korotkevich on 28/09/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import SwiftUI

struct NoteDetailView: View {
    let isNewNote: Bool
    let id: Int
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var model: Model
    
    func donePressed() {
        hideKeyboard()
        
        if isNewNote {
            model.addNote(title: model.note.title) {
                self.dismiss()
            }
        }
        else {
            model.updateNote(id: id, title: model.note.title)
        }
    }
    
    func deletePressed() {
        model.deleteNote(id: id) {
            self.dismiss()
        }
    }
    
    func dismiss() {
        if isNewNote {
            self.model.pushed = false
        } else {
            self.presentation.wrappedValue.dismiss()
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
    }

    var body: some View {
        LoadingView(isShowing: $model.detailActivityIndicatorAnimating) {
            VStack {
                EditableText(text: self.$model.note.title, fontSize: 18, showKeyboard: self.isNewNote)
                    .padding(4)
                    
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading:
                        BackButton(label: "Notes") {
                            self.dismiss()
                        },
                    trailing:
                        Button(action: {
                            self.donePressed()
                        }) {
                            Text("Done")
                        }
                )
                    
                .alert(isPresented: self.$model.showError) {
                    return Alert(title: Text("Error"),
                                 message: Text(self.model.errorMessage),
                                 dismissButton: .default(Text("Ok"), action: {

                        self.model.showError = false
                    }))
                }
                
                if !self.isNewNote {
                    ToolBar(actionDelete: self.deletePressed)
                }
            }.onAppear() {
                self.model.note.title = ""
                if !self.isNewNote {
                    self.model.loadNote(id: self.id)
                }
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailView(isNewNote: false, id: 1)
    }
}

struct BackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}
