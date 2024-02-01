#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

#define PI 3.14159265358979323846

// Placeholder function to simulate fetching CPU usage
int get_cpu_usage() {
    return rand() % 100;
}

void generate_wave(int amplitude, int length) {
    for (int x = 0; x < length; x++) {
        int y = amplitude * sin(2 * PI * x / length) + amplitude;
        for (int i = 0; i < y; i++) {
            printf(" ");
        }
        printf("*");
        printf("\n");
    }
}

int main() {
    int length = 20; // Number of points in one oscillation

    while (1) {
        int cpu_usage = get_cpu_usage();
        int amplitude = (cpu_usage * 10) / 100;  // Scale the amplitude

        // Clear console
        printf("\033[H\033[J");

        // Generate and print wave
        generate_wave(amplitude, length);

        sleep(1);  // Refresh rate (1 second)
    }

    return 0;
}

