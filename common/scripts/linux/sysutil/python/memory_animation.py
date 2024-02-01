import psutil
import math
import sys

def get_memory_animation(frame):
    mem = psutil.virtual_memory().percent
    direction = 1 if mem > 50 else -1

    chars = [' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
    index = int((math.cos(frame) + 1) * 4)
    return f"Mem: {chars[index] * direction}"

if __name__ == "__main__":
    frame = int(sys.argv[1]) if len(sys.argv) > 1 else 0
    print(get_memory_animation(frame))

