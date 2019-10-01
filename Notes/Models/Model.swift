//
//  Model.swift
//  Notes
//
//  Created by Sergey Korotkevich on 29/09/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import Foundation

class Model: ObservableObject {
    @Published var pushed = false;
    @Published var notes:[Note] = [];
    @Published var note:Note = Note(id: 0, title: "");
    @Published var showError:Bool = false;
    var errorMessage:String = "";
    
    func publishError(error:String) {
        DispatchQueue.main.async {
            self.errorMessage = error
            self.showError = true
        }
    }
    
    func loadNotes() {
        NotesAPI.getNotes() { (notes, error) in
            if notes != nil {
                DispatchQueue.main.async {
                    self.notes = notes!
                }
                return
            }
            
            if error != nil {
                self.publishError(error: error!)
            }
        }
    }
    
    func loadNote(id: Int) {
        NotesAPI.getNote(id: id) { (note, error) in
            if note != nil {
                DispatchQueue.main.async {
                    self.note = note!
                }
                return
            }
            
            if error != nil {
                self.publishError(error: error!)
            }
        }
    }
    
    func addNote(title: String, notifySuccess: @escaping () -> ()) {
        NotesAPI.addNote(title: title) { (error) in
            guard let error = error else {
                DispatchQueue.main.async {
                    notifySuccess()
                }
                self.loadNotes()
                return
            }
            
            self.publishError(error: error)
        }
    }
    
    func deleteNote(id: Int, notifySuccess: @escaping () -> ()) {
        NotesAPI.deleteNote(id: id) { (error) in
            guard let error = error else {
                DispatchQueue.main.async {
                    notifySuccess()
                }
                self.loadNotes()
                return
            }
            
            self.publishError(error: error)
        }
    }
    
    func updateNote(id: Int, title: String) {
        NotesAPI.updateNote(id: id, title: title) { (error) in
            if error != nil {
                self.publishError(error: error!)
                return
            }
            self.loadNotes()
        }
    }
}
