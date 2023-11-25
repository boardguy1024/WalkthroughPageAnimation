//
//  OnBoardingScreen.swift
//  WalkthroughPageAnimation
//
//  Created by paku on 2023/11/25.
//

import SwiftUI
import Lottie

struct OnBoardingScreen: View {
    
    @State var onboardingItems: [OnboardingItem] = [
        .init(title: "Request Pickup",
              subTitle: "Tell us who you're sending it to, what you're sending and when it's best to pickup the package and we will pick it up at the most convenient time",
              lottieView: .init(name: "Pickup",bundle: .main)),
        .init(title: "Track Delivery",
              subTitle: "The best part starts when our courier is on the way to your location, as you will get real time notifications as to the exact location of the courier",
              lottieView: .init(name: "Transfer",bundle: .main)),
        .init(title: "Receive Package",
              subTitle: "The journey ends when your package get to it's location. Get notified immediately your package is received at its intended location",
              lottieView: .init(name: "Delivery",bundle: .main))
    ]
    
    @State var currentIndex: Int = 0
    

    var body: some View {
        
        GeometryReader {
            let size = $0.size
            let isLastSlide = currentIndex == onboardingItems.count - 1

            HStack(spacing: 0) {
                ForEach($onboardingItems) { $item in
                    
                    VStack(spacing: 15) {
                        
                        HStack {
                            Button {
                                if currentIndex > 0 {
                                    // currentLottieはpauseさせる
                                    onboardingItems[currentIndex].lottieView.pause()
                                    
                                    currentIndex -= 1
                                    
                                    playAnimation()
                                }
                            } label: {
                                Text("Back")
                                    .opacity(currentIndex == 0 ? 0 : 1)
                                    .animation(.easeInOut, value: currentIndex)
                            }
                            
                            Spacer()
                            
                            Button {
                                currentIndex = onboardingItems.count - 1
                                playAnimation()
                            } label: {
                                Text("Skip")
                                    .opacity(isLastSlide ? 0 : 1)
                                    .animation(.easeInOut, value: currentIndex)
                            }
                    
                        }
                        .tint(Color("Green"))
                        .fontWeight(.bold)
                        
                        VStack(spacing: 15) {
                            
                            let offset = -size.width * CGFloat(currentIndex)
                            
                            ResizableLottieView(onboardingItem: $item)
                                .frame(height: size.height / 2)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                .onAppear {
                                    if currentIndex == indexOf(item) {
                                        item.lottieView.play()
                                    }
                                }
                            
                            Text(item.title)
                                .font(.title.bold())
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.3).delay(0.1), value: currentIndex)
                            
                            Text(item.subTitle)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                                .offset(x: offset)
                                .animation(.easeInOut(duration: 0.3).delay(0.2), value: currentIndex)
                        }
                       
                        Spacer()
                        
                        VStack(spacing: 15) {
                            
                            Button {
                                if currentIndex < onboardingItems.count - 1 {
                                    
                                    // currentLottieはpauseさせる
                                    onboardingItems[currentIndex].lottieView.pause()
                                    
                                    currentIndex += 1
                                    playAnimation()
                                }
                            } label: {
                                Text(isLastSlide ? "LogIn" : "Next")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        Capsule()
                                            .fill(Color("Green"))
                                    )
                                    .padding(.horizontal, isLastSlide ? 30 : 100)
                            }
                            
                            HStack {
                                Text("Terms of Service")
                                
                                Text("Privacy Policy")
                            }
                            .font(.caption2)
                            .underline(true, color: .primary)
                        }
                    }
                    .animation(.easeInOut, value: isLastSlide)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
                }
            }
            .frame(width: size.width * CGFloat(onboardingItems.count), alignment: .leading )
        }
    }
    
    func indexOf(_ item: OnboardingItem) -> Int {
        onboardingItems.firstIndex(of: item) ?? 0
    }
    
    func playAnimation() {
        // 次のLottieViewは0からAnimationをStartさせる
        onboardingItems[currentIndex].lottieView.currentProgress = 0
        
        // toProgress:6 にする理由は loopingAnimationなので 1をしてしまうと
        // StartProgressに戻ってしまうため（ちょうど良いタイミングでanimationを止めたい）
        onboardingItems[currentIndex].lottieView.play(toProgress: 0.6)
    }
}

#Preview {
    ContentView()
}

struct ResizableLottieView: UIViewRepresentable {
    
    @Binding var onboardingItem: OnboardingItem
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        setupLottieView(view)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func setupLottieView(_ to: UIView) {
        let lottieView = onboardingItem.lottieView
        lottieView.backgroundColor = .clear
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        let constrains = [
            lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
            lottieView.heightAnchor.constraint(equalTo: to.heightAnchor)
        ]
        
        to.addSubview(lottieView)
        to.addConstraints(constrains)
    }
}
