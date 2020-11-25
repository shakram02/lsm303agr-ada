import sys
import re
import time
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
        line = [int(x) for x in digits.findall(line)]

        if not line or len(line) != 6:
            line = ""
            print("skip")
            time.sleep(0.3)
            continue

        for i in range(0, len(line), 2):
            high = line[i]
            low = line[i+1]

            num = "{:08b}{:08b}".format(high, low)
            print(num, end=" ")
            parsed_num = twos(num[:10])

            axis_index = i // 2
            axis_max[axis_index] = max(axis_max[axis_index], parsed_num)

            out = 0
            out |= high << 8
            out |= low
            out >>= 6  # 1100001111000000
            neg = out & (1 << 9)

            if neg:
                # 1101100010
                # 0866  <- out
                # -158  <- expected
                out = out ^ 0b1111111111    # Python has no bitwise negation
                out = out + 1
                out *= -1
            print(f"[{out:04}]", end=" ")
            print(f"{parsed_num:04}", end=" | ")

        print()

    except KeyboardInterrupt:
        print("\n\nMAXS:", axis_max)
        break
    except Exception as e:
        print("EXC", e)
        exit(-1)
