import SwiftUI
import Auth0

struct LevelsSelectionView: View {
    @Binding var user: User?
    @State var current_score: Int
    var selected_user: User
    let levelsLibrary: [LevelImage] = LevelImageLibrary().levels
    let levels_completed: Int = 3
    var lessonBuilderModel: LessonBuilderModel = LessonBuilderModel()
    @State private var path: [Int] = []
    @State var totalScore: Int = 0
    @State var selectedLevelIndex: Int?
    var wavePattern: [Int] = generateWavePattern(length: 12 + 1)
    
    func lesson_type(index:Int) -> Style {
        switch index {
        case levels_completed:
            return .standart
        case _ where index > levels_completed:
            return .disabled
        case _ where index < levels_completed:
            return .completed
        default:
            return .standart
        }
    }
    
    var body: some View {
        VStack{
            NavigationStack(path: $path) {
                VStack{
                    LevelsUpBar(action: self.logout, current_score: current_score)
                        .padding(.top)
                    
                    Text(selectedLevelIndex?.description ?? "No level selected").hidden().frame(width: 0,height: 0).frame( maxWidth: 0, maxHeight: 0)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading){
                            ForEach(Array(levelsLibrary.enumerated()), id: \.element.id) { index, levels in
                                dropButtonRound(titleSymbol: levels.sfSymbol, action: {
                                    selectedLevelIndex = index
                                    path.append(0)
                                    totalScore = 0
                                }, style: lesson_type(index: index))
                                .padding(.top)
                                .padding(.leading, CGFloat(wavePattern[index]))
                            }
                        }
                    }
                    .navigationDestination(for: Int.self) { int in
                        LevelContainer(path: $path, count: int, selected_level: lessonBuilderModel.lessons[selectedLevelIndex!], selected_user: selected_user, totalScore: $totalScore, current_score: $current_score)
                    }
                }
                .padding(.horizontal)
                .background(Color.lgBackground.ignoresSafeArea())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func logout() {
        let credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    _ = credentialsManager.clear()
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

#Preview {
    LevelsSelectionView(
        user: Bootstrap().$user, current_score: 0,
        selected_user: User(
            id: "auth1|6552867564e79113efcb65f7",
            email: "example@gmail.com",
            nickname: "example")
    )
}
