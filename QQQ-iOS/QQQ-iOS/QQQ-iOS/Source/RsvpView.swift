//
//  RsvpView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-25.
//

import SwiftUI
import Prism

struct RsvpViewModel {
	enum State: String {
		case firstLoad
		case failedToLoad
		case loaded
		case waitingForResponse

		var descriptuion: String {
			"\(self)"
		}
	}

	var state = State.firstLoad
	var lessonName = "Computer Science 101"
	var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00:00+03:00")
	var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30:00+03:00")
	var professorName = "Читающий Нам Лекторович"
	var onlineUrl: URL? = URL(string: "https://google.com")
	var response = ""

	mutating func load() async {
		self.state = .waitingForResponse
		self.response = ""

		do {
			let current = try await API.Request.current()

			self.lessonName = current.lessonName ?? "Лекция"
			self.start = current.from
			self.end = current.to
			self.onlineUrl = URL(string: current.url ?? "")
			self.professorName = current.professorName ?? ""

			self.state = .loaded
		} catch {
			self.response = error.localizedDescription

			self.state = .failedToLoad
		}
	}

	mutating func participate() async {
		self.response = ""
		self.state = .waitingForResponse

		do {
			try await API.Request.participate()
			self.state = .loaded
		} catch {
			self.response = error.localizedDescription
			self.state = .failedToLoad
		}
	}

}

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
	@State private var vm = RsvpViewModel()

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
			prismConfiguration.extrusion = 0.0
		}

		Task {
			await vm.participate()
			prismConfiguration.extrusion = 20.0
		}
	}

	private func makeTimeTitleString() -> String {
		let dt = DateFormatter()
		dt.dateStyle = .none
		dt.timeStyle = .short

		let start = dt.string(from: self.vm.start ?? .now)
		let end = dt.string(from: self.vm.end ?? .now)

		return "\(start) - \(end)"
	}

	private func makeOnlineLint() -> AnyView {
		if let onlineUrl = vm.onlineUrl {
			return AnyView(erasing: Link("Онлайн", destination: onlineUrl))
		} else {
			return AnyView(erasing: Text("Аудитория"))
		}
	}

	private func makeInfoSection() -> some View {
		return VStack {
			Text(vm.lessonName).font(.title)
			Text(makeTimeTitleString()).font(.subheadline)
			Text("")
			Text("Преподаватель")
			Text(vm.professorName).font(.title2)
			Text("")
			Text("Где проходит").font(.title2)
			makeOnlineLint()
		}
	}

	private func makeStatusLabel() -> some View {
		Text("State: \(vm.state.rawValue)\n").font(.headline).foregroundColor(.gray)

	}

	private func makeResonse() -> some View {
		Text(vm.response)
	}

	private func makeLoadingView() -> some View {
		VStack {
			makeStatusLabel()
			Text("Загружаем данные\nПожалуйста подождите")
			ProgressView()
		}
	}

	private func makeFailedView() -> some View {
		VStack {
			makeStatusLabel()
			Text("Произошла ошибка")
			Button("Обновить") {
				Task { await vm.load() }
			}
			ScrollView {
				makeResonse()
			}
		}
	}

	private func makeLoadedView() -> some View {
		VStack {
			Spacer()
			makeStatusLabel()
			makeInfoSection()
			Spacer()
			if vm.state == .loaded {
				makePrismView()
			} else {
				ProgressView()
			}
			Spacer()
		}
	}

	var body: some View {
		switch vm.state {
		case .firstLoad:
			makeLoadingView()
				.onAppear { Task { await vm.load() } }
		case .loaded:
			makeLoadedView()
		case .failedToLoad:
			makeFailedView()
		case .waitingForResponse:
			makeLoadingView()
		}
	}
}

struct RsvpView_Previews: PreviewProvider {
	static var previews: some View {
		RsvpView()
	}
}
