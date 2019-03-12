#!/usr/bin/env python3

def illuminabin(q):
    if q <= 1: return 'N'
    elif 2 <= q <= 9: return 6
    elif 10 <= q <= 19: return 15
    elif 20 <= q <= 24: return 27
    elif 25 <= q <= 29: return 27
    elif 30 <= q <= 34: return 33
    elif 35 <= q <= 39: return 37
    else: return 40

def q_to_p(q):
    return 10.0**-(q/10.0)

def main():
    print(f"\\bfseries Quality Score & \\bfseries Illumina Bin & \\bfseries $P(error)$ \\\\")
    print("\\hline")
    [print(f"\\bfseries {q} & \\bfseries {illuminabin(q)} & \\bfseries {q_to_p(q):4.1} \\\\") if q % 10 == 0 else print(f"{q} & {illuminabin(q)} & {q_to_p(q):4.1} \\\\") for q in list(range(1,21)) + [30,40]]

if __name__ == '__main__':
    main()
