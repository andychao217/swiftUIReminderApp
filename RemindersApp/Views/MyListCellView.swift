//
//  MyListCellView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI

struct MyListCellView: View {
	let myList : MyList
    var body: some View {
		HStack {
			Image(systemName: "line.3.horizontal.circle.fill")
				.foregroundStyle(Color(myList.color))
			Text(myList.name)
			Spacer()
			Image(systemName: "chevron.right")
				.foregroundStyle(.gray)
				.opacity(0.4)
				.padding([.trailing], 10)
		}
    }
}

#Preview {
	MyListCellView(myList: PreviewData.myList)
}
