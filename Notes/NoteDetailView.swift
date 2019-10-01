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
	@State var title: String
	@Environment(\.presentationMode) var presentation
	@EnvironmentObject var model: Model
	
	func donePressed() {
		hideKeyboard()
		
		if isNewNote {
			model.addNote(title: title) {
				self.dismiss()
			}
		}
		else {
			model.updateNote(id: id, title: title)
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
		VStack {
			EditableText(text: $title, fontSize: 18, showKeyboard: isNewNote)
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
				
			.alert(isPresented: $model.showError) {
				return Alert(title: Text("Error"),
							 message: Text(model.errorMessage),
							 dismissButton: .default(Text("Ok"), action: {

					self.model.showError = false
				}))
			}
			
			if !isNewNote {
				ToolBar(actionDelete: deletePressed)
			}
		}
		
	}
}

struct NoteDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NoteDetailView(isNewNote: false, id: 1, title: "some text")
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
