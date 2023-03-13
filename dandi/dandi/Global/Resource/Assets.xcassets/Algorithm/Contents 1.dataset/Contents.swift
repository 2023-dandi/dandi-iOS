import Foundation

// 테이프의 최소 개수를 구하는 것
guard
    let line = readLine()?.components(separatedBy: .whitespaces),
    let n = Int(line[0]),
    let l = Int(line[1])
else {
    fatalError()
}

var arr: [Int] = []
var ok: [Bool] = [] // 구멍 막았는지 세어보자

for _ in 0 ... n - 1 {
    arr.append(Int(readLine()!)!)
    ok.append(false)
}

// 테이프 개수 순회
var length = l
var answer = 0 // 정답
for i in 0 ... n - 1 {
    if i == n {
        break
    }
    if length > 0,
       ok[i] == false,
       arr[i] + 1 == arr[i + 1]
    {
        ok[i] = true
        length -= 1
    }
    if length == 0 {
        answer += 1
        length = l
    }
}

print(answer)
