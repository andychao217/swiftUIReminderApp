//
//  ReminderListView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI

struct ReminderListView: View {
    let reminders: FetchedResults<Reminder>
    @State private var selectedReminder: Reminder?
    @State private var showReminderDetail: Bool = false

    private func reminderCheckedChanged(reminder: Reminder, isCompleted: Bool) {
        var editConfig = ReminderEditConfig(reminder: reminder)
        editConfig.isCompleted = isCompleted
        do {
            _ = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
        } catch {
            print(error)
        }
    }

    private func isReminderSeleced(_ reminder: Reminder) -> Bool {
        selectedReminder?.objectID == reminder.objectID
    }

	private func deleteReminder(_ indexSet: IndexSet) {
		indexSet.forEach { index in
			let reminder = reminders[index]
			do {
				let _ = try ReminderService.deleteReminder(reminder: reminder)
			} catch {
				print(error)
			}
		}
	}
	
    var body: some View {
        VStack {
			List {
				ForEach(reminders) { reminder in
					ReminderCellView(reminder: reminder, isSelected: isReminderSeleced(reminder)) { event in
						switch event {
						case let .onSelect(reminder):
							selectedReminder = reminder
						case let .onCheckedChange(reminder, isCompleted):
							reminderCheckedChanged(reminder: reminder, isCompleted: isCompleted)
						case .onInfo:
							showReminderDetail = true
						}
					}
				}.onDelete(perform: deleteReminder)
			}
        }.sheet(isPresented: $showReminderDetail) {
            ReminderDetailView(reminder: Binding($selectedReminder)!)
        }
    }
}

struct ReminderListViewContainer: View {
	@FetchRequest(sortDescriptors: [])
	private var reminderResults: FetchedResults<Reminder>

	var body: some View {
		ReminderListView(reminders: reminderResults)
	}
}

struct PreviewProvider: View {
	var body: some View {
		ReminderListViewContainer()
			.environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
	}
}

#Preview {
	PreviewProvider()
}
