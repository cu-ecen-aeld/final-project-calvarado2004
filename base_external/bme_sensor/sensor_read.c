#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  // For the sleep() function

#define TEMP_FILE "/sys/bus/i2c/devices/i2c-1/1-0076/iio:device0/in_temp_input"
#define HUMIDITY_FILE "/sys/bus/i2c/devices/i2c-1/1-0076/iio:device0/in_humidityrelative_input"
#define PRESSURE_FILE "/sys/bus/i2c/devices/i2c-1/1-0076/iio:device0/in_pressure_input"

void read_sensor_data(const char *file_path, float *value, int scale) {
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    int raw_value;
    if (fscanf(file, "%d", &raw_value) != 1) {
        perror("Error reading value");
        fclose(file);
        exit(EXIT_FAILURE);
    }
    fclose(file);
    *value = (float)raw_value / scale;
}

void read_pressure_data(const char *file_path, float *value) {
    FILE *file = fopen(file_path, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    if (fscanf(file, "%f", value) != 1) {
        perror("Error reading value");
        fclose(file);
        exit(EXIT_FAILURE);
    }
    fclose(file);
}

int main() {
    float temperature, humidity, pressure;

    while (1) {
        read_sensor_data(TEMP_FILE, &temperature, 1000);
        read_sensor_data(HUMIDITY_FILE, &humidity, 1000);
        read_pressure_data(PRESSURE_FILE, &pressure);  // No scaling needed for pressure

        printf("Sensor BME-280 data:\n");
        printf("Temperature: %.3f °C\n", temperature);
        printf("Humidity: %.3f %%\n", humidity);
        printf("Pressure: %.2f hPa\n", pressure);

        sleep(10);  // Wait for 10 seconds before reading the data again
    }

    return 0;
}
