//
//  ReminderStatsView.swift
//  RemindersApp
//
//  Created by Andy Chao on 2024/11/19.
//

import SwiftUI

struct ReminderStatsView: View {
	
	@Environment(\.colorScheme) private var colorScheme
	
	let icon: String
	let title: String
	let count: Int?
	let iconColor: Color
	
    var body: some View {
		VStack {
			HStack {
				VStack(alignment: .leading, spacing: 10) {
					Image(systemName: icon)
						.foregroundColor(iconColor)
						.font(.title)
					Text(title)
						.opacity(0.8)
				}
				Spacer()
				if let count {
					Text("\(count)")
						.font(.largeTitle)
				}
			}.padding()
				.frame(maxWidth: .infinity)
				.background(colorScheme == .dark ? Color.darkGray : Color.offWhite)
				.foregroundColor(colorScheme == .dark ? Color.offWhite : Color.darkGray)
				.clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
		}
    }
}

#Preview {
	ReminderStatsView(icon: "calendar", title: "All", count: 9, iconColor: .blue)
}
