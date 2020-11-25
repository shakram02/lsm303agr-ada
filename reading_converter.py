import sys
import re
import time
digits = re.compile("\d+")
new_line_chars = re.compile(r"\r|\n")


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


def twos_bitwise(high, low):
    out = 0
    out |= high << 2
    out |= ((low >> 6) & 0b11)
    # 1100001111000000but
    neg = out & (1 << 9)

    if neg:
        # 1101100010
        # -158  <- expected
        out = out ^ 0b1111111111    # Python has no bitwise negation
        out = out + 1
        out *= -1

    return out


def read_stream():
    axis_max = [0, 0, 0]
    while True:
        try:
            line = ""
            line = sys.stdin.readline()
            line = new_line_chars.sub("", line)
            print(line)
            if not line:
                continue
            line = [int(x) for x in digits.findall(line)]

            if not line or len(line) != 6:
                print("skip:", line)
                # time.sleep(0.3)
                continue

            for i in range(0, len(line), 2):
                high = line[i]
                low = line[i+1]

                num = "{:08b}{:08b}".format(high, low)
                print(num, end=" ")
                parsed_num = twos(num[:10])

                axis_index = i // 2
                axis_max[axis_index] = max(axis_max[axis_index], parsed_num)

                out = twos_bitwise(high, low)
                print(f"[{out:04}]", end=" ")
                print(f"{parsed_num:04}", end=" | ")

            print()

        except KeyboardInterrupt:
            print("\n\nMAXS:", axis_max)
            break
        except Exception as e:
            print("EXC", e)
            exit(-1)


def test_parse():
    samples = [
        ("1101110010", ["11011100", "10000000"]),
        ("0000001001", ["00000010", "01000000"]),
    ]
    sample_index = 0
    x = twos(samples[sample_index][0])
    y = twos_bitwise(int(samples[sample_index][1][0], 2),
                     int(samples[sample_index][1][1], 2)
                     )
    print(x, y)


def main():
    read_stream()
    # test_parse()


if __name__ == "__main__":
    main()
