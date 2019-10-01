//
//  ToolBar.swift
//  Notes
//
//  Created by Sergey Korotkevich on 01/10/2019.
//  Copyright © 2019 Sergey Korotkevich. All rights reserved.
//

import SwiftUI

struct ToolBar: View {
    let actionDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                self.actionDelete()
            }) {
                Image(systemName: "trash")
                    .imageScale(.large)
            }
            Spacer()
        }.padding()
    }
}

struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
        ToolBar(actionDelete: {})
    }
}
