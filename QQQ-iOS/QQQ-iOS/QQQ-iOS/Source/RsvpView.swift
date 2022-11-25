//
//  RsvpView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import SwiftUI
import Prism

struct RsvpView: View {
	@State var prismConfiguration = PrismConfiguration(
		tilt: 0.5,
		size: CGSize(width: 240, height: 120),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	@State private var opacity = 0.35
	var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00+3:00")
	var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30+3:00")
	var proffessorName = "Читающий Нам Лекторович"

	private func makePrismView() -> some View {
		let color = Color.accentColor

		return PrismView(configuration: prismConfiguration) {
				Text("Я участвую")
				.frame(minWidth: 240.0)
				.font(.title)
				.frame(minHeight: 120.0)
				.background(.ultraThinMaterial)
				.background(color.opacity(opacity - 0.3))
		} left: {
			color.brightness(-0.1)
				.opacity(opacity - 0.1)
//					.background(.thinMaterial)
		} right: {
			color.brightness(-0.3)
				.opacity(opacity)
//					.background(.thinMaterial)
		}
		.onTapGesture(perform: reactRsvpButton)
	}

	private func reactRsvpButton() {
		withAnimation {
			prismConfiguration.extrusion = 20.0 - prismConfiguration.extrusion
		}
	}

	private func makeTimeTitleString() -> String {
		let dt = DateFormatter()
		dt.dateStyle = .none
		dt.timeStyle = .short

		let start = dt.string(from: self.start ?? .now)
		let end = dt.string(from: self.end ?? .now)

		return "\(start) - \(end)"
	}

	private func makeOnlineLint() -> some View {
		let url = URL(string: "https://google.com")!

		return Link("Онлайн", destination: url)
	}

	private func makeInfoSection() -> some View {
		return VStack {
			Text("Computer Science 101").font(.title)
			Text(makeTimeTitleString()).font(.subheadline)
			Text("")
			Text("Преподаватель")
			Text(proffessorName).font(.title2)
			Text("")
			Text("Где проходит").font(.title2)
			makeOnlineLint()
		}
	}

	var body: some View {
		return VStack {
			Spacer()
			makeInfoSection()
			Spacer()
			makePrismView()
			Spacer()
		}
	}
}

struct RsvpView_Previews: PreviewProvider {
	static var previews: some View {
		RsvpView()
	}
}
