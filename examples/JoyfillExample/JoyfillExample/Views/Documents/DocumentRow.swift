//
//  DocumentRow.swift
//  JoyfillExample
//
//  Created by Jeremy Pagley on 11/6/23.
//

import SwiftUI

struct DocumentRow: View {
    var doc: Document
    
    var body: some View {
        HStack {
            Image(systemName: "doc")
                .resizable()
                .frame(width: 50, height: 50)
            Text(doc.name).font(.headline)
        }
    }
}

#Preview {
    DocumentRow(doc: <#Document#>)
}
