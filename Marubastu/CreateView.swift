//
//  CreateView.swift
//  Marubastu
//
//  Created by 田中康志 on 2025/02/15.
//

import SwiftUI

struct CreateView: View {
    @Binding var quizzesArray:[Quiz]//回答画面で読み込んだ問題を受け取る
    @State private var questionText = ""//テキストフィールドの文字を受け取る
    @State private var selectedAnswer = "O"//ピッカーで選ばれた解答を受け取る
    let answers = ["O", "X"]//ピッカーの選択肢の一覧
    
    var body: some View {
        VStack{
            Text("問題分と解答を入力して、追加ボタンを押してください。")
                .foregroundStyle(.gray)
                .padding()
            
            // 問題文を入力するテキストフィールド
            TextField(text: $questionText) {
                Text("問題文を入力してください")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            
            Picker("解答", selection: $selectedAnswer) {
                ForEach(answers, id: \.self){ answer in
                    Text(answer)}
                
            }
            .pickerStyle(.segmented)
            .padding()
            //追加ボタン
            Button {
                //追加ボタンが押された時の処理
                addQuiz(question: questionText, answer: selectedAnswer)
            } label: {
                Text("追加")
            }
            .padding()
            
            // 削除ボタン
            Button {
                quizzesArray.removeAll() // 配列を空に
                UserDefaults.standard.removeObject(forKey: "quiz") // 保存されているものを削除
            } label: {
                Text("全削除")
            }
            List {
                ForEach(quizzesArray) { quiz in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("問題:")  // 「問題:」のラベル
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(quiz.question)  // 問題文
                                .font(.headline)
                                .padding(.bottom, 5)
                        }
                        
                        Spacer() // 左右のスペースを開ける
                        
                        VStack(alignment: .trailing) {
                            Text("解答:")  // 「解答:」のラベル
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(quiz.answer ? "◯" : "Ｘ")  // ◯ or X
                                .font(.headline)
                                .foregroundColor(quiz.answer ? .green : .red)  // ◯は緑、Xは赤
                        }
                    }
                    .padding()
                }
                .onMove { indices, newOffset in
                    quizzesArray.move(fromOffsets: indices, toOffset: newOffset)
                    updateUserDefaults() // データを保存
                }
                .onDelete { indexSet in
                    quizzesArray.remove(atOffsets: indexSet) // スワイプで削除
                    updateUserDefaults() // データを保存
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton() // 削除ボタン
                }
            }

            
        }
      
    }
    // 問題追加(保存)の関数
    func addQuiz(question: String, answer: String) {
        //問題文が入力されているかチェック
        if question.isEmpty{
            print("問題文が入力されていません")
            return
        }
        
        var savingAnswer = true //保存するためのtrue/falseを入れる変数
        
        // OかXかで、 true/faseを切り替える
        
        switch answer{
        case"O":
            savingAnswer = true
        case"X":
            savingAnswer = false
        default:
            print("適切な答えが入ってません")
            break
        }
        let newQuiz = Quiz(question: question, answer: savingAnswer)
        
        var array: [Quiz] = quizzesArray//一時的に変数に入れておく
        array.append(newQuiz)//作った問題を配列に追加
        let storekey = "quiz"//UserDefaultsに保存するためのキー
        
        //エンコードができたら保存
        if let encodedQuizzes = try? JSONEncoder().encode(array){
            UserDefaults.standard.setValue(encodedQuizzes, forKey: storekey)
            
            questionText = ""//テキストフィールドを空白に戻す
            quizzesArray = array//既存問題+新問題となった配列に更新
        }
        
    }
}

//#Preview {
//    CreateView()
//}
