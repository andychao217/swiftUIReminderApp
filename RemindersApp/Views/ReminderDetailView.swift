//
//  ReminderDetailView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/18.
//

import SwiftUI

struct ReminderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var reminder: Reminder
    @State var editConfig: ReminderEditConfig = ReminderEditConfig()

	private var isFormValid: Bool {
		!editConfig.title.isEmpty
	}
	
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("Title", text: $editConfig.title)
                        // 对 notes 使用非可选类型
                        TextField("Notes", text: $editConfig.notes ?? "")
                    }

                    Section {
                        Toggle(isOn: $editConfig.hasDate) {
                            Image(systemName: "calendar")
                                .foregroundColor(.red)
                        }

                        if editConfig.hasDate {
                            DatePicker("Select Date", selection: $editConfig.reminderDate ?? Date(), displayedComponents: .date)
                        }

                        Toggle(isOn: $editConfig.hasTime) {
                            Image(systemName: "clock")
                                .foregroundColor(.blue)
                        }

                        if editConfig.hasTime {
                            // Ensure reminderTime is handled correctly
							DatePicker("Select Time", selection: $editConfig.reminderTime ?? Date(), displayedComponents: .hourAndMinute)
                        }

                        Section {
                            NavigationLink {
								SelectListView(selectedList: $reminder.list)
                            } label: {
                                HStack {
                                    Text("List")
                                    Spacer()
                                    // 使用安全解包来避免隐式解包崩溃
                                    if let listName = reminder.list?.name {
                                        Text(listName)
                                    } else {
                                        Text("No List Assigned") // 提供默认文本以处理 nil 情况
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
					}.onChange(of: editConfig.hasDate) { oldValue, newValue in
						if newValue {
							editConfig.reminderDate = Date()
						} else {
							editConfig.reminderDate = nil
						}
					}.onChange(of: editConfig.hasTime) { oldValue, newValue in
						if newValue {
							editConfig.reminderTime = Date()
						} else {
							editConfig.reminderTime = nil
						}
					}
                }.listStyle(.insetGrouped)
            }.onAppear {
                editConfig = ReminderEditConfig(reminder: reminder)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Details")
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
						do {
							let updated = try ReminderService.updateReminder(reminder: reminder, editConfig: editConfig)
							if updated {
								if reminder.reminderDate != nil || reminder.reminderTime != nil {
									let userData = UserData(title: reminder.title, body: reminder.notes, date: reminder.reminderDate, time: reminder.reminderTime)
									NotificationManager.scheduleNotification(userData: userData)
								}
							}
						} catch {
							print(error)
						}
						dismiss()
					}.disabled(!isFormValid)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ReminderDetailView(reminder: .constant(PreviewData.reminder))
}
