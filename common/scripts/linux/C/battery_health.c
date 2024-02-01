#include <stdio.h>
#include <stdlib.h>

int main() {
    long power_now, energy_now;
    FILE *fp;

    // Read the current rate of power consumption
    fp = fopen("/sys/class/power_supply/BAT1/power_now", "r");
    if (fp == NULL) {
        printf("Could not open power_now file. Make sure the path is correct.\n");
        return 1;
    }
    fscanf(fp, "%ld", &power_now);
    fclose(fp);

    // Read the remaining energy in the battery
    fp = fopen("/sys/class/power_supply/BAT1/energy_now", "r");
    if (fp == NULL) {
        printf("Could not open energy_now file. Make sure the path is correct.\n");
        return 1;
    }
    fscanf(fp, "%ld", &energy_now);
    fclose(fp);

    // Calculate and display the time remaining
    if (power_now > 0) {
        double time_remaining = (double)energy_now / (double)power_now;
        printf("Time Remaining: %.2f hours\n", time_remaining);
    } else {
        printf("Battery is not discharging, can't calculate time until dead.\n");
    }

    return 0;
}

