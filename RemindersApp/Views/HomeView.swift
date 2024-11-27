//
//  ContentView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/15.
//

import SwiftUI

struct HomeView: View {
    @FetchRequest(sortDescriptors: [])
    private var myListResults: FetchedResults<MyList>

    @FetchRequest(sortDescriptors: [])
    private var searchResults: FetchedResults<Reminder>
	
	@FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .today))
	private var todayResults: FetchedResults<Reminder>
	
	@FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .scheduled))
	private var scheduledResults: FetchedResults<Reminder>
	
	@FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .all))
	private var allResults: FetchedResults<Reminder>
	
	@FetchRequest(fetchRequest: ReminderService.remindersByStatType(statType: .completed))
	private var completedResults: FetchedResults<Reminder>

    @State private var isPresented: Bool = false
    @State private var searchText: String = ""
    @State private var searching: Bool = false

    private var reminderStatsBuilder = ReminderStatsBuilder()
    @State private var reminderStatsValues = ReminderStatsValues()

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
						NavigationLink {
							ReminderListView(reminders: todayResults)
						} label: {
							ReminderStatsView(icon: "calendar", title: NSLocalizedString("Today", comment: ""), count: reminderStatsValues.todayCount, iconColor: .blue)
						}
						
						NavigationLink {
							ReminderListView(reminders: allResults)
						} label: {
							ReminderStatsView(icon: "tray.circle.fill", title: NSLocalizedString("All", comment: ""), count: reminderStatsValues.allCount, iconColor: .red)
						}
                    }

                    HStack {
						NavigationLink {
							ReminderListView(reminders: scheduledResults)
						} label: {
							ReminderStatsView(icon: "clock", title: NSLocalizedString("Scheduled", comment: ""), count: reminderStatsValues.scheduledCount, iconColor: .secondary)
						}
						
						NavigationLink {
							ReminderListView(reminders: completedResults)
						} label: {
							ReminderStatsView(icon: "checkmark.circle.fill", title: NSLocalizedString("Completed", comment: ""), count: reminderStatsValues.completedCount, iconColor: .primary)
						}
                    }

					Text("My Lists")
						.frame(maxWidth: .infinity, alignment: .leading)
						.font(.largeTitle)
						.bold()
						.padding()
					
                    MyListView(myLists: myListResults)

                    Button {
                        isPresented = true
                    } label: {
                        Text("Add List")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.headline)
                    }.padding()
                }
            }
            .sheet(isPresented: $isPresented, content: {
                NavigationView {
                    AddNewListView { name, color in
                        do {
                            try ReminderService.saveMyList(name, color)
                        } catch {
                            print(error)
                        }
                    }
                }
            })
            .listStyle(.plain)
            .onChange(of: searchText, { _, newValue in
                searching = !newValue.isEmpty ? true : false
                searchResults.nsPredicate = ReminderService.getRemindersBySearchTerm(newValue).predicate
            })
            .overlay(alignment: .center, content: {
                ReminderListView(reminders: searchResults)
                    .opacity(searching ? 1.0 : 0.0)
            })
            .onAppear {
                reminderStatsValues = reminderStatsBuilder.build(myListResults: myListResults)
            }
            .padding()
            .navigationTitle("Reminders")
        }.searchable(text: $searchText)
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.persistentContainer.viewContext)
}
