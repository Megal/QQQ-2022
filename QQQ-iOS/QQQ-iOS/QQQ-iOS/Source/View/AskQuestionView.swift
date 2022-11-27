//
//  AskQuestionView.swift
//  QQQ-iOS
//
//  Created by Svyatoshenko "Megal" Misha on 2022-11-27.
//

import SwiftUI

struct AskQuestionView: View {

	var body: some View {
		Text("Задать вопрос")
		.navigationTitle("Задать вопрос")
	}
}

@available(iOS 16.0, *)
struct AskQuestionView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			AskQuestionView()
				.navigationTitle("Задать вопрос")
		}
	}
}
