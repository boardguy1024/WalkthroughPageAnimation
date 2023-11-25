//
//  OnBoardingItem.swift
//  WalkthroughPageAnimation
//
//  Created by paku on 2023/11/25.
//

import SwiftUI
import Lottie

struct OnboardingItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var lottieView: LottieAnimationView = .init()
}
