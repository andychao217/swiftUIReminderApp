//
//  MyListView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI

struct MyListView: View {
    @Environment(\.colorScheme) private var colorScheme

    let myLists: FetchedResults<MyList>

    var body: some View {
        NavigationStack {
            if myLists.isEmpty {
                Spacer()
                Text("No reminders found")
            } else {
                ForEach(myLists) { myList in
                    NavigationLink(value: myList) {
                        VStack {
                            MyListCellView(myList: myList)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading], 10)
                                .font(.title3)
								.foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
                            Divider()
                        }
					}.listRowBackground(colorScheme == .dark ? Color.darkGray : Color.offWhite)
                }.scrollContentBackground(.hidden)
                    .navigationDestination(for: MyList.self) { myList in
                        MyListDetailView(myList: myList)
                            .navigationTitle(myList.name)
                    }
            }
        }
    }
}

// #Preview {
//    MyListView()
// }
