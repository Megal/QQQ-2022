//
//  ProfessorLessonView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-26.
//

import SwiftUI
import Prism

struct ProfessorLessonViewModel {
	enum State: String {
		case firstLoad
		case loading
		case failedToLoad
		case loaded

		var descriptuion: String {
			"\(self)"
		}
	}

	var state = State.loaded
	var lessonName = "Computer Science 101"
	var start = ISO8601DateFormatter().date(from: "2022-11-27T15:00:00+03:00")
	var end = ISO8601DateFormatter().date(from: "2022-11-27T16:30:00+03:00")
	var professorName = "Читающий Нам Лекторович"
	var groupName = "A-77"
	var onlineUrl: URL? = URL(string: "https://google.com")
	var response = ""

	mutating func load() async {
		self.state = .loading
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

	mutating func askQuestion() async {}
	
}

struct ProfessorLessonView: View {
	@State var prismConfiguration = PrismConfiguration(
		tilt: 0.5,
		size: CGSize(width: 240, height: 80),
		extrusion: 20.0,
		levitation: 0.0,
		shadowColor: .black,
		shadowOpacity: 0.15
	)
	@State private var opacity = 0.35
	@State private var vm = ProfessorLessonViewModel()

	private func makePrismView() -> some View {
		let color = Color.accentColor

		return PrismView(configuration: prismConfiguration) {
				Text("Задать вопрос")
				.frame(minWidth: 240.0)
				.font(.title)
				.frame(minHeight: 80.0)
				.background(.ultraThinMaterial)
				.background(color.opacity(opacity - 0.3))
		} left: {
			color.brightness(-0.1)
				.opacity(opacity - 0.1)
		} right: {
			color.brightness(-0.3)
				.opacity(opacity)
		}
		.onTapGesture(perform: onAskButton)
	}

	private func onAskButton() {
		withAnimation {
			prismConfiguration.extrusion = 0.0
		}

		Task {
			await vm.askQuestion()
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

	private func makeOnlineLink() -> AnyView {
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
			Text("Группа")
			Text(vm.professorName).font(.title2)
			Text("")
			Text("Где проходит").font(.title2)
			makeOnlineLink()
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
		case .loading:
			makeLoadingView()
		case .loaded:
			makeLoadedView()
		case .failedToLoad:
			makeFailedView()
		}
	}
}

@available(iOS 16.0, *)
struct ProfessorLessonView_Previews: PreviewProvider {
	static var previews: some View {
		ProfessorLessonView()
	}
}
