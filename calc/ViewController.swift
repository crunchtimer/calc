//
//  ViewController.swift
//  calc
//
//  Created by Kota Sasaki on 2019/08/26.
//  Copyright © 2019 Crunchtimer Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 計算結果のラベル
    @IBOutlet weak var result: UILabel!
    
    // 四則演算の列挙型
    enum Operation: Int {
        case none = 0        // なし
        case plus = 11       // +
        case minus = 12      // -
        case multi = 13      // ×
        case division = 14   // ÷
        case equal = 15      // =
    }
    
    var num: Double = 0                 // 現在入力中の数値
    var preNum: Double = 0              // 計算前の数値
    var operation:Operation = .none;    //  + , - , × , ÷ , =
    var preTapButton: Int = 0           // 前回タップしたボタン
    
    // 画面表示前に呼ばれるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 計算結果を表示
        self.display(data: self.num)
    }
    
    /// 数字ボタンタップ
    /// 1〜9がタップされた時に呼ばれるメソッドです。
    /// どのボタンがタップされたかはtagを参照します
    @IBAction func numbers(_ sender: UIButton) {
        // タップしたボタンを記録
        preTapButton = sender.tag
        // ボタンが連続で入力されると1桁づつあげる
        num = num * 10 + Double(sender.tag)
        // 表示
        self.display(data: self.num)
    }
    
    /// 演算ボタンタップ
    /// + - × ÷ がタップされた時に呼ばれるメソッドです。
    /// どのボタンがタップされたかはtagを参照します（列挙型に紐づく）
    @IBAction func calc(_ sender: UIButton) {
        
        // 計算中かをチェック
        if self.operationCheck() {
            // 計算
            self.calculation()
            // 計算結果を表示
            self.display(data: self.num)
        }
        
        // タップした四則演算を次回の計算用に設定
        switch sender.tag {
            // +
            case Operation.plus.rawValue:
                operation = .plus
            // -
            case Operation.minus.rawValue:
                operation = .minus
            // ×
            case Operation.multi.rawValue:
                operation = .multi
            // ÷
            case Operation.division.rawValue:
                operation = .division
            // ÷
            case Operation.equal.rawValue:
            operation = .equal
            default:
                break
        }
        
        // 入力中の数字を退避
        preNum = num
        // 入力データのクリア
        num = 0
        
        // タップしたボタンを記録
        preTapButton = sender.tag
    }
    
    // 小数点（ドット）タップ
    @IBAction func dot(_ sender: UIButton) {
        
        // TODO: 時間がある人はやってみよう！
    }
    
    /// ACボタンタップ
    /// ACがタップされた時に呼ばれるメソッドです。
    /// 計算途中の情報などすべてをクリアします。
    @IBAction func clear(_ sender: UIButton) {
        // データクリア
        num = 0
        preNum = 0
        operation = .none
        preTapButton = 0
        // 表示
        self.display(data: self.num)
    }
    
    /// 計算します
    /// 入力した数値と前回までに入力された数値を指定した四則演算で計算します
    private func calculation() {
        
        switch operation {
        case .plus:
            num = preNum + num
        case .minus:
            num = preNum - num
        case .multi:
            num = preNum * num
        case .division:
            num = preNum / num
        default:
            break
        }
    }
    
    /// 計算中かを調べる
    ///
    /// ret: Bool (true: 計算中、false: 計算中ではない)
    ///
    private func operationCheck() -> Bool {

        // 結果返却用変数
        var ret = false
        
        // 前回タップしたボタンが四則演算なら計算しない
        switch preTapButton {
        // +, -, ×, ÷
        case Operation.plus.rawValue,
             Operation.minus.rawValue,
             Operation.multi.rawValue,
             Operation.division.rawValue:
            return false
        default:
            break
        }
        
        // 四則演算チェック
        switch operation {
            // +, -, ×, ÷
            case .plus , .minus , .multi , .division:
                ret = true
                break
            // 該当なし
            default:
                break
        }
        
        return ret
    }
    
    /// ラベルに計算結果を表示します
    /// 整数の場合は小数点を表示せず、計算結果は3桁のカンマ付きで表示しています。
    private func display(data: Double) {
    
        // 文字格納用変数
        var numString = ""

        // 数字フォーマット
        let formatter = NumberFormatter()
        // 小数を指定
        formatter.numberStyle = .decimal
        
        // 整数かチェック
        if floor(data) == data {
            // 整数に変換
            let d = Int(data)
            // 3桁カンマ付き数字文字列を取得
            numString = formatter.string(from: d as NSNumber)!
        }
        // 少数値
        else {
            // 3桁カンマ付き数字文字列を取得
            numString = formatter.string(from: data as NSNumber)!
        }
        // ラベルに数字文字を設定
        result.text = numString
    }
}

