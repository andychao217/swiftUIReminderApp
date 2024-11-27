//
//  MyListDetailView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI

struct MyListDetailView: View {
	let myList : MyList
	@State private var openAddReminder: Bool = false
	@State private var title: String = ""
	@State private var notes: String = ""
	
	@FetchRequest(sortDescriptors: [])
	private var reminderResults: FetchedResults<Reminder>
	
	private var isFormValid : Bool {
		!title.isEmpty
	}
	
	init(myList: MyList) {
		self.myList = myList
		_reminderResults = FetchRequest(fetchRequest: ReminderService.getRemindersByList(myList: myList))
	}
	
    var body: some View {
		VStack {
			// Display list of reminders
			ReminderListView(reminders: reminderResults)
			
			HStack {
				Button {
					openAddReminder = true
					title = ""
					notes = ""
				} label: {
					Image(systemName: "plus.circle.fill")
					Text("New Reminder")
				}
			}.foregroundColor(.blue)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding()
			
			Spacer()
		}.alert("New Reminder", isPresented: $openAddReminder) {
			TextField("Title", text: $title)
			TextField("Notes", text: $notes)
			Button("Cancel", role: .cancel) {}
			Button("Done") {
				do {
					try ReminderService.saveReminderToMyList(myList: myList, reminderTitle: title, reminderNotes: notes)
				} catch {
					print(error.localizedDescription)
				}
			}.disabled(!isFormValid)
		}
    }
}

#Preview {
	MyListDetailView(myList: PreviewData.myList)
}
