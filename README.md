# NCTUCS_Computer_Organization_LAB

此份Repo為吳凱強教授108下的五次LAB

## Grade:

| LAB1 | LAB2 | LAB3 | LAB4 | LAB5 |
| ---- | ---- |:---- | ---- |:---- |
| 110  | 99   | 115  | 100  | 97   |

上述可以發現LAB2的部份有些測資過不了
其他應該四個都是正確的


## LAB4

用C++簡單模擬Cache Directed_map的方式
實做Random與LRU兩種替換方式
助教會提供大部分的架構
需要注意的是助教寫的Log2在不同OS下會產生不同結果
建議使用Linux進行測試或是把Log2 function改掉

## LAB5

拿LAB4的Cache算出Address後看有沒有在Cache裡頭即可

所以重點是模擬MIPS的過程也可以計算Address 

矩陣的計算過程可以直接計算


file:
simulate_caches.cpp
makefile

How to test:

**./sima./simulate_caches a1xb1 output**

**./sima./simulate_caches a2xb2 output**

**./sima./simulate_caches a3xb3 output**

**./sima./simulate_caches a4xb4 output**

the answer of test file:
a1xb1-->smaple_c1

a2xb2-->smaple_c2

a3xb3-->smaple_c3

a4xb4-->smaple_c4

Report:
0711282_0716077.pdf
