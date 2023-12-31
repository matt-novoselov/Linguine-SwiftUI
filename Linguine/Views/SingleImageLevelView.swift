import SwiftUI

struct SingleImageLevelView: View {
    @State private var showingCredits = false
    @State var detentHeight: CGFloat = 0
    @Binding var path: [Int]
    let count: Int
    var selectedLevel: Imagelevel
    @Binding var totalScore: Int
    @State private var inputFieldText: String = ""
    @FocusState var isFocused : Bool
    
    init(path: Binding<[Int]>, count: Int, selectedLevel: Imagelevel, totalScore: Binding<Int>) {
        self._path = path
        self.count = count
        self.selectedLevel = selectedLevel
        self._totalScore = totalScore
        
        let randomImageLevelCard = selectedLevel.imageLevelCards.randomElement()
        _randomImageLevelCard = State(initialValue: randomImageLevelCard)
    }
    
    @State private var randomImageLevelCard: ImagelevelCard?
    
    var body: some View {        
        VStack{
            VStack(alignment: .leading ,spacing: 20){
                Spacer()
                
                ZStack{
                    let borderSize: Double = 180
                    VStack(spacing: 20){
                        UILottieView(lottieName: randomImageLevelCard!.lottie, playOnce: true)
                            .frame(height: 100)
                        
                        Text(randomImageLevelCard!.english)
                            .font(Font.custom("DINNextRoundedLTPro-Regular", size: 20))
                            .accessibilitySortPriority(1)
                            .accessibilityLabel("Type in italian: \(randomImageLevelCard!.english)")
                    }.frame(maxHeight: borderSize)
                                        
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.lgDisabledButton, lineWidth: 2)
                        .frame(width: borderSize, height: borderSize)
                }
                
                TextField(
                    "Type in Italian",
                    text: $inputFieldText
                )
                .focused($isFocused)
                .textFieldStyle(WhiteBorder())
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onTapGesture {
                    isFocused = true
                }
                
                Spacer()
                
                dropButton(title: "check", action: {showingCredits.toggle(); isFocused = false}, style: inputFieldText != "" ? .standart : .disabled)
                    .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .onTapGesture {
                hideKeyboard()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.lgBackground.ignoresSafeArea())
        .sheet(isPresented: $showingCredits) {
            let isAnswerCorrect = isAnswerCorrect(correctAnswer: randomImageLevelCard!.italian, selectedAnswer: inputFieldText.lowercased())
            
            levelResult(correctAnswer: randomImageLevelCard!.italian, action: {
                if isAnswerCorrect{
                    totalScore+=20
                }
                path.append(count + 1)
            }, isCorrect: isAnswerCorrect)
                .readHeight()
                .onPreferenceChange(HeightPreferenceKey.self) { height in
                    if let height {
                        self.detentHeight = height
                    }
                }
                .frame(maxHeight: .infinity)
                .presentationDetents([.height(self.detentHeight)])
                .background(.lgLeaderboardHighlight)
                .interactiveDismissDisabled()
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

#Preview {
    SingleImageLevelView(path: .constant([]), count: 0, selectedLevel: ImageLevelLibrary().levels[0], totalScore: .constant(0)
    )
}
