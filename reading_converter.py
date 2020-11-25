import sys
import re
digits = re.compile("\d+")


def twos(binary):
    if binary[0] == "1":
        out = ""
        for bit in binary:
            if bit == "1":
                out += "0"
            else:
                out += "1"
        binary = int(out, 2) + 1
        n = binary * -1
    else:
        n = int(binary, 2)
    return n


axis_max = [0, 0, 0]

while True:
    try:
        line = sys.stdin.readline().strip()
        print(line)
        line = [int(x) for x in digits.findall(line)]

        if not line or len(line) != 6:
            line = ""
            print("skip")
            continue

        for i in range(0, len(line), 2):
            num = "{:08b}{:08b}".format(line[i], line[i+1])
            print(num, end=" ")
            parsed_num = twos(num[:10])

            axis_index = i // 2
            axis_max[axis_index] = max(axis_max[axis_index], parsed_num)
            print(f"({parsed_num})", end=" | ")

        print()

    except KeyboardInterrupt:
        print("\n\nMAXS:", axis_max)
        break
    except Exception as e:
        print("EXC", e)
        continue
