import SwiftUI

extension View {
    func readHeight() -> some View {
        self
            .modifier(ReadHeightModifier())
    }
}

struct UILottieView: View {
    var lottieName: String
    var playOnce: Bool = false
    var animationSpeed: Double = 1.0
    
    var body: some View {
        if let fileURL = Bundle.main.url(forResource: lottieName, withExtension: "lottie"){
            LottieView(url: fileURL, playOnce: playOnce, animationSpeed: animationSpeed)
        }
        else{
            Text("Lottie not found")
        }
    }
}

struct summuryBox: View {
    var title: String = "total xp"
    var earnedXP: Int = 0
    let frameHeight: Double = 85
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 17)
                .frame(height: frameHeight)
                .foregroundColor(.lgPinkButton)
            
            VStack{
                Text(title)
                    .textCase(.uppercase)
                    .font(Font.custom("DINNextRoundedLTPro-Bold", size: 14))
                    .foregroundColor(.lgBackground)
                    .padding(.top, 6)
                
                Spacer()
            }
            .frame(maxHeight: frameHeight)
            
            VStack{
                Spacer()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 60)
                        .foregroundColor(.lgBackground)
                    
                    HStack(spacing: 5){
                        LightningIcon()
                            .frame(width: 15,height: 18)
                            .foregroundColor(.lgPinkButton)
                        
                        Text("\(earnedXP)")
                            .textCase(.uppercase)
                            .font(Font.custom("DINNextRoundedLTPro-Bold", size: 20))
                            .foregroundColor(.lgPinkButton)
                    }
                }
            }
            .padding(.all, 2)
            .frame(maxHeight: frameHeight)
        }
    }
}

struct leaderboardParticipant: View {
    var nickname: String = "example"
    var xpAmount: Int = 0
    var place: Int = 0
    var isHighlighted: Bool = false
    
    var body: some View {
        ZStack{
            Rectangle()
                .padding(.horizontal, -50)
                .ignoresSafeArea()
                .frame(height: 65)
                .foregroundColor(.lgLeaderboardHighlight)
                .opacity(isHighlighted ? 1 : 0)
            
            HStack(spacing: 10){
                Text("\(place)")
                    .font(Font.custom("DINNextRoundedLTPro-Bold", size: 16))
                    .frame(width: 18, alignment: .leading)
                
                ZStack{
                    Circle()
                        .frame(height: 45)
                    
                    Text(nickname.prefix(1))
                        .textCase(.uppercase)
                        .font(Font.custom("DINNextRoundedLTPro-Bold", size: 24))
                        .foregroundColor(.lgBackground)
                        .padding(.top, 4.5)
                }
                .padding(.trailing, 5)
                
                Text("@\(nickname)")
                    .font(Font.custom("DINNextRoundedLTPro-Bold", size: 18))
                
                Spacer()
                
                Text("\(xpAmount) XP")
                    .font(Font.custom("DINNextRoundedLTPro-regular", size: 18))
                    .frame(alignment: .trailing)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Place \(place) - \(nickname). \(xpAmount) XP")
    }
}

struct ExtendedDevider: View {
    var body: some View {
        Rectangle()
            .frame(height: 3)
            .foregroundColor(.lgLeaderboardHighlight)
            .padding(.horizontal, -50)
    }
}

struct dropButtonCustomStyle {
    var mainColor: Color
    var dropColor: Color
    var textColor: Color
    var symbolColor: Color
}

enum Style: String, CaseIterable {
    case standart
    case mistake
    case correct
    case disabled
    case completed
    
    var color: dropButtonCustomStyle {
        switch self {
        case .standart, .completed: return dropButtonCustomStyle(mainColor: .lgPinkButton, dropColor: .lgDropPinkButton, textColor: .lgBackground, symbolColor: .white)
        case .mistake: return dropButtonCustomStyle(mainColor: .lgRedButton, dropColor: .lgDropRedButton, textColor: .lgBackground, symbolColor: .lgBackground)
        case .correct: return dropButtonCustomStyle(mainColor: .lgGreenButton, dropColor: .lgDropGreenButton, textColor: .lgBackground, symbolColor: .lgBackground)
        case .disabled: return dropButtonCustomStyle(mainColor: .lgDisabledButton, dropColor: .lgDropDisabledButton, textColor: .lgDisabledTitle, symbolColor: .lgDisabledTitle)
        }
    }
}

struct dropButton: View {
    var title: String
    var action: () -> Void
    var style: Style
    
    struct dropButtonStyle: ButtonStyle {
        var title: String
        let buttonHeight: Double = 45
        let shadowHeight: Double = 4
        var style: Style
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack(alignment: .top){
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: buttonHeight)
                        .foregroundColor(style.color.dropColor)
                        .padding(.top, !configuration.isPressed ? shadowHeight : 0)
                    
                    Spacer()
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: buttonHeight)
                        .foregroundColor(style.color.mainColor)
                    
                    Text(title)
                        .textCase(.uppercase)
                        .font(Font.custom("DINNextRoundedLTPro-Bold", size: 16))
                        .foregroundColor(style.color.textColor)
                }
            }
            .frame(height: buttonHeight+shadowHeight)
        }
    }
    
    var body: some View {
        Button(action: style != Style.disabled ? action : {}){}
            .buttonStyle(
                dropButtonStyle(title: title, style: style)
            )
            .accessibilityHidden(style == Style.disabled)
    }
}

struct dropButtonRound: View {
    var titleSymbol: String
    var action: () -> Void
    var style: Style
    
    struct dropButtonStyle: ButtonStyle {
        var titleSymbol: String
        let buttonHeight: Double = 59
        let shadowHeight: Double = 7
        var style: Style
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack(alignment: .top){
                VStack{
                    Ellipse()
                        .frame(width: 71, height: buttonHeight)
                        .foregroundColor(style.color.dropColor)
                        .padding(.top, !configuration.isPressed ? shadowHeight : 0)
                    
                    Spacer()
                }
                
                ZStack{
                    Ellipse()
                        .frame(width: 71, height: buttonHeight)
                        .foregroundColor(style.color.mainColor)
                    
                    Image(systemName: style == Style.completed ? "checkmark" : titleSymbol)
                        .font(.system(size: 26))
                        .foregroundColor(style.color.symbolColor)
                        .fontWeight(.black)
                }
            }
            .frame(height: buttonHeight+shadowHeight)
            .overlay(style == Style.standart ? ProgressBar() : nil, alignment: .center)
        }
    }
    
    
    var body: some View {
        Button(action: style != Style.disabled ? {action(); lightHaptic()}: {}){}
            .buttonStyle(
                dropButtonStyle(titleSymbol: titleSymbol, style: style)
            )
            .accessibilityLabel("Level")
    }
}

struct cardButton: View {
    var title: String
    var iconName: String?
    var action: () -> Void
    var style: Style
    
    struct dropButtonStyle: ButtonStyle {
        var title: String
        var iconName: String?
        var buttonHeight: Double {
            return iconName != nil ? 260 : 45
        }
        let shadowHeight: Double = 4
        var style: Style
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack(alignment: .top){
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: buttonHeight)
                        .foregroundColor(style.color.dropColor)
                        .padding(.top, !configuration.isPressed ? shadowHeight : 0)
                    
                    Spacer()
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: buttonHeight)
                        .foregroundColor(style != Style.disabled ? .lgSelectedCardButton : .lgBackground)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style.color.mainColor, lineWidth: 2)
                        .frame(height: buttonHeight)
                    
                    VStack(){
                        if let unwrappedIconName = iconName {
                            Spacer()
                            UILottieView(lottieName: unwrappedIconName, playOnce: true)
                                .frame(height: 100)
                            Spacer()
                        }
                        
                        Text(title)
                            .textCase(.lowercase)
                            .font(Font.custom("DINNextRoundedLTPro-Regular", size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, iconName != nil ? 10 : 0)
                    }
                    .frame(maxHeight: buttonHeight)
                }
            }
            .frame(height: buttonHeight+shadowHeight)
        }
    }
    
    var body: some View {
        Button(action: action){}
            .buttonStyle(
                dropButtonStyle(title: title, iconName: iconName, style: style)
            )
    }
}

struct levelResult: View {
    let completionMessages: [String] = [
        "Great job!",
        "Well done!",
        "Awesome!",
        "Good work!",
        "Fantastic!",
        "Super!",
        "Nice job!",
        "Outstanding!",
        "Wonderful!",
        "Amazing!",
        "Superb!",
        "Impressive!",
        "Good going!",
        "Perfect!",
        "Excellent!",
    ]
    
    let incorrectMessages: [String] = [
        "Incorrect",
        "Oops, try next time",
        "Not quite right",
        "Uh-oh, that's not it",
        "Keep trying",
        "Wrong answer",
        "Almost there, but not quite",
        "Try again",
        "Not the correct solution",
        "Close, but not there yet",
        "Incorrect, give it another shot",
        "That's a miss",
        "Wrong move",
        "Not the right answer",
        "You'll get it next time",
        "Incorrect choice"
    ]

    var correctAnswer: String
    @State var size: CGSize = .zero
    @Environment(\.dismiss) var dismiss
    @State private var completionMessage: String = ""
    @State private var incorrectMessage: String = ""
    var showExplanation: Bool = true
    var action: () -> Void
    var isCorrect: Bool

    var body: some View {
        VStack(alignment: .leading ,spacing: 20){
            if isCorrect{
                Group{
                    HStack{
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .accessibilityHidden(true)
                        
                        Text(completionMessage)
                            .font(Font.custom("DINNextRoundedLTPro-Bold", size: 24))
                    }
                }
                .foregroundColor(.lgGreenButton)
                .onAppear(){
                    haevyHaptic()
                }
            }
            else{
                Group{
                    HStack{
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .accessibilityHidden(true)
                        
                        Text(incorrectMessage)
                            .font(Font.custom("DINNextRoundedLTPro-Bold", size: 24))
                    }
                    
                    if showExplanation{
                        HStack(spacing:0){
                            Text("Correct Answer: ")
                                .font(Font.custom("DINNextRoundedLTPro-Bold", size: 20))
                            
                            Text(correctAnswer)
                                .font(Font.custom("DINNextRoundedLTPro-Regular", size: 20))
                        }
                    }
                }
                .foregroundColor(.lgRedButton)
            }
            
            dropButton(title: isCorrect ? "continue" : "got it", action: {self.dismiss(); action()}, style: isCorrect ? .correct : .mistake)
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear(){
            completionMessage=completionMessages.randomElement()!
            incorrectMessage=incorrectMessages.randomElement()!
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?
    
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct ReadHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

struct LevelsUpBar: View {
    var action: () -> Void
    var currentScore: Int?
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 0){
                ItalianFlag()
                
                Spacer()
                
                HStack(spacing: 6){
                    LightningIcon()
                        .frame(width: 15,height: 18)
                        .foregroundColor(.lgBlueIcon)
                    
                    Text("\(currentScore == nil ? 0 : currentScore!) XP")
                        .font(Font.custom("DINNextRoundedLTPro-Bold", size: 18))
                        .foregroundColor(.lgBlueIcon)
                        .accessibilitySortPriority(0)
                }
                
                Spacer()
                
                Button(action: action){
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                        .foregroundColor(.lgDropRedButton)
                        .accessibilityLabel("Logout")
                        .accessibilitySortPriority(0)
                }
            }
        }
    }
}

struct ProgressBar: View {
    var body: some View {
        ZStack {
            Ellipse()
                .stroke(lineWidth: 7.0)
                .foregroundColor(.lgDisabledButton)
            
            Ellipse()
                .trim(from: 0.75, to: 1.0)
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.lgBackground)
            
            Ellipse()
                .trim(from: 0.75, to: 1.0)
                .stroke(style: StrokeStyle(lineWidth: 7.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.lgPinkButton)
        }
        .frame(width: 90, height: 85)
        .padding(.bottom, 8)
    }
}

struct ItalianFlag: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.white)
                .frame(width: 39, height: 25)
            
            HStack{
                RoundedRectangle(cornerRadius: 3)
                    .fill(.green)
                    .frame(width: 12, height: 20)
                    .padding(.leading, 3)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(.lgRedButton)
                    .frame(width: 12, height: 20)
                    .padding(.trailing, 3)
            }
            
            Rectangle()
                .fill(.white)
                .frame(width: 12, height: 20)
            
        }
        .frame(width: 30)
    }
}

struct WhiteBorder: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(Font.custom("DINNextRoundedLTPro-Regular", size: 18))
            .foregroundColor(.white)
            .padding()
            .background(.lgLeaderboardHighlight)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.lgDisabledButton, lineWidth:2)
            )
    }
}

struct LevelprogressBar: View {
    @State private var size: CGSize = .zero
    @State var progress: Double
    
    var body: some View {
        ZStack (alignment: .leading){
            RoundedRectangle(cornerRadius: 90)
                .frame(height: 20)
                .foregroundColor(.lgDisabledButton)
                
            ZStack{
                RoundedRectangle(cornerRadius: 90)
                    .frame(height: 20)
                    .foregroundColor(.lgGreenButton)
                
                RoundedRectangle(cornerRadius: 90)
                    .frame(height: 5)
                    .foregroundColor(.white)
                    .opacity(0.2)
                    .padding(.horizontal)
                    .padding(.bottom, 6)
            }
            .frame(width: CGFloat(size.width) * CGFloat(progress==0 ? 0.1 : progress))
        
            
            

            
            GeometryReader { proxy in
                HStack {}
                    .onAppear {
                        size = proxy.size
                    }
            }
        }
    }
}

#Preview {
    VStack{
        Spacer()
        
        LevelprogressBar(progress: 0.5)
        
        Spacer()
    }
    .padding(.horizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.lgBackground.ignoresSafeArea())
}
