//
//  CSLINEOpener.h
//
//  Created by griffin_stewie on 2013/02/01.
//  Copyright (c) 2013 griffin_stewie
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import <Foundation/Foundation.h>

/**
 LINE アプリに対し、テキストもしくは画像を渡して起動させるためのクラス。
 「LINEで送るボタン」機能
 
 */

@interface CSLINEOpener : NSObject

/**
 LINE アプリがインストールされているかどうかを判定
 
 @return "line://" スキームに対応していれば YES, そうでなければ NO を返す
 */
+ (BOOL)canOpenLINE;

/**
 text を LINE アプリに渡して起動
 
 @param text LINE アプリに渡したい文字列
 
 @return LINE アプリが起動できれば YES、出来なければ NO を返す
 
 */
+ (BOOL)openLINEAppWithText:(NSString *)text;

/**
 image を LINE アプリに渡して起動
 
 @param image LINE アプリに渡したい `UIImage`
 
 @return LINE アプリが起動できれば YES、出来なければ NO を返す
 */
+ (BOOL)openLINEAppWithImage:(UIImage *)image;

/**
 AppStore でLINE アプリのページを開く

 @return AppStore アプリが起動できれば YES、出来なければ NO を返す
 */
+ (BOOL)openAppStore;

@end
