import psutil
import math
import sys

def get_cpu_animation(frame):
    cpu_percent = psutil.cpu_percent()
    direction = 1 if cpu_percent > 50 else -1

    chars = [' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
    index = int((math.sin(frame) + 1) * 4)
    return f"CPU: {chars[index] * direction}"

if __name__ == "__main__":
    frame = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    print(get_cpu_animation(frame))

