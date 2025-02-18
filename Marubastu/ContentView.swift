//
//  ContentView.swift
//  Marubastu
//
//  Created by 田中康志 on 2025/02/15.
//

import SwiftUI

struct Quiz: Identifiable, Codable {
    var id = UUID()       // それぞれの設問を区別するためのID
    var question: String  // 問題文
    var answer: Bool      // 解答
}
struct ContentView: View {
    // 問題
    let quizeExamples: [Quiz] = [
        Quiz(question: "iPhoneアプリを開発する統合環境はZcodeである", answer: false),
        Quiz(question: "Xcode画面の右側にはユーティリティーズがある", answer: true),
        Quiz(question: "Textは文字列を表示する際に利用する", answer: true)
    ]
    
    
    
    @AppStorage("quiz") var quizzesData = Data() // UserDafaultsから問題を読み込む(Data型)
    @State var quizzesArray: [Quiz] = []//問題を入れておく配列
    @State var currentQuestionsNum = 0 //今、何問目の数字
    @State var showingAlert = false //アラートの表示・非表示を制御
    @State var alertTitle = "" //”正解"か"不正解"の文字を入れるための変数
    
    func updateUserDefaults() {
        if let encoded = try? JSONEncoder().encode(quizzesArray) {
            quizzesData = encoded
        }
    }//削除や並び替え後に UserDefaults に保存
    
    //エラー原因?    init(){
    //        if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData){
    //           _quizzesArray = State(initialValue: decodedQuizzes)
    //        }
    //    }
    
    var body: some View {
        GeometryReader{ geometry in
            NavigationStack{
                VStack {
                    
                    
                    
                    Text(showQestion())
                        .padding()   // 余白を外側に追加
                        .frame(width: geometry.size.width * 0.85, alignment: .leading) // 横幅を250、左寄せに
                        .font(.system(size: 25)) // フォントサイズを25に
                        .fontDesign(.rounded)    // フォントを丸みのあるものに
                        .background(.yellow)     // 背景を黄色に
                    
                    Spacer()//問題文とボタンの間を広げるための余白を追加
                    
                    // ◯Ｘボタンを横並びに表示するのでHStackを使う
                    HStack {
                        // ◯ボタン
                        Button {
                            print("◯") // ボタンが押されたときの動作
                            checkAnswer(yourAnswer: true)
                        } label: {
                            Text("◯")  // ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4)//幅と高さを親ビュー幅の0.4倍に
                        .font(.system(size: 100, weight: .bold)) // フォントサイズ: 100 ,太字
                        .background(.red) // 背景色: 赤
                        .foregroundStyle(.white) // 文字の色: 白
                        // Xボタン
                        Button {
                            print("Ｘ") // ボタンが押されたときの動作
                            checkAnswer(yourAnswer: false)
                        } label: {
                            Text("Ｘ")  // ボタンの見た目
                        }
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4)//幅と高さを親ビュー幅の0.4倍に
                        .font(.system(size: 100, weight: .bold)) // フォントサイズ: 100 ,太字
                        .background(.blue) // 背景色: 青
                        .foregroundStyle(.white) // 文字の色: 白
                        
                        
                    }
                    
                    
                    
                }
                .padding()
                .navigationTitle("マルバツクイズ")//ナビゲーションバーにタイトル設定
                //回答のアラート
                .alert(alertTitle, isPresented: $showingAlert) {
                    Button("OK", role: .cancel){}
                }
                //問題作成画面へ遷移するためのボタンを設置
                .toolbar {
                    //配置する場所を画面最上部のバーの右端に設定
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink{
                            CreateView(quizzesArray: $quizzesArray,currentQuestionNum: $currentQuestionsNum)//遷移先の画面
                                .navigationTitle("問題を作ろう")
                        }label:{
                            Image(systemName: "plus")
                                .font(.title)
                        }
                    }
                }
                .onAppear {
                    if let decodedQuizzes = try? JSONDecoder().decode([Quiz].self, from: quizzesData) {
                        quizzesArray = decodedQuizzes
                    }
                    currentQuestionsNum = 0 //超えるときは0に戻す
                }
            }
            
        }
    }
    //問題文を表示するための関数
    func showQestion() -> String{
        
        var question = "問題がありません"
        // 問題があるかどうかのチェック
        if !quizzesArray.isEmpty{
            let quiz = quizzesArray[currentQuestionsNum]
            question = quiz.question
        }
        return question
    }
    //回答をチェックする関数、正解なら次の問題を表示
    func checkAnswer(yourAnswer: Bool){
        if quizzesArray.isEmpty { return } // 問題が無いときは回答チェックしない
        let quiz = quizzesArray[currentQuestionsNum]
        
        let ans = quiz.answer
        if yourAnswer == ans {//正解の時
            alertTitle = "正解"
            
            
            if currentQuestionsNum + 1 < quizzesArray.count  {
                
                currentQuestionsNum += 1//次の問題に進む
            } else{
                //超えるときは0に戻す
                currentQuestionsNum = 0
            }
            
        }else{ //不正解のとき
            alertTitle = "不正解"
            
        }
        showingAlert = true //アラートを表示
    }
    
}




#Preview {
    ContentView()
}
