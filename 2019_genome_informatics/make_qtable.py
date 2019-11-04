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

def print_table(numbers, filename):
    with open(filename, 'w') as fh:
        print(f"Score & Bin & $P(error)$ \\\\", file = fh)
        print("\\midrule", file = fh)
        for q in numbers:
            #if q % 10 == 0:
               #print(f"\\textbf{{{q}}} & \\textbf{{{illuminabin(q)}}} & \\textbf{{{q_to_p(q):.3f}}} \\\\", file = fh)
            #else:
            print(f"{q} & {illuminabin(q)} & {q_to_p(q):.4f} \\\\", file = fh)
        print("\\bottomrule", file = fh)

def main():
    print_table([0,10,20,30,40], 'qtable1.tex')

if __name__ == '__main__':
    main()
