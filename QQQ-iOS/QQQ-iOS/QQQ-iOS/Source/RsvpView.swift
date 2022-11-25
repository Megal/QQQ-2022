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
		size: CGSize(width: 240, height: 80),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	@State private var opacity = 0.35

	@State private var lessonName = "Computer Science 101"
	@State private var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00:00+03:00")
	@State private var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30:00+03:00")
	@State private var professorName = "Читающий Нам Лекторович"
	@State private var onlineUrl: URL? = URL(string: "https://google.com")

	@State var response = ""

	private func makePrismView() -> some View {
		let color = Color.accentColor

		return PrismView(configuration: prismConfiguration) {
				Text("Я участвую")
				.frame(minWidth: 240.0)
				.font(.title)
				.frame(minHeight: 80.0)
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

		self.response = ""
		Task {
			do {
				let current = try await API.Request.current()
				self.lessonName = current.lessonName ?? "Лекция"
				self.start = current.from
				self.end = current.to
				self.onlineUrl = URL(string: current.url ?? "")
				self.professorName = current.professorName ?? ""
			} catch {
				self.response = error.localizedDescription
			}
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

	private func makeOnlineLint() -> AnyView {
		if let onlineUrl = onlineUrl {
			return AnyView(erasing: Link("Онлайн", destination: onlineUrl))
		} else {
			return AnyView(erasing: Text("Аудитория"))
		}
	}

	private func makeInfoSection() -> some View {
		return VStack {
			Text(lessonName).font(.title)
			Text(makeTimeTitleString()).font(.subheadline)
			Text("")
			Text("Преподаватель")
			Text(professorName).font(.title2)
			Text("")
			Text("Где проходит").font(.title2)
			makeOnlineLint()
		}
	}

	private func makeResonse() -> some View {
		Text(response)
	}

	var body: some View {
		return VStack {
			Spacer()
			makeInfoSection()
			Spacer()
			makePrismView()
			Spacer()
			ScrollView {
				makeResonse()
			}
			.frame(maxHeight: 200.0)
			Spacer()
		}
	}
}

struct RsvpView_Previews: PreviewProvider {
	static var previews: some View {
		RsvpView()
	}
}
