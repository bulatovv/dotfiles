#include "../scripts.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <wchar.h>


#define URGENT_VALUE 10
#define MSGID 7070

typedef enum {
    FULL = 'F' % 4,
    CHARGING = 'C' % 4,
    DISCHARGING = 'D' % 4,
    URGENT = 'U' % 4
} battery_state;

const char *color_level[4] = {
    "color9", "color3", "color11", "color10"
};

const char *str_battery_state[] = {
    [FULL] = "Full",
    [CHARGING] = "Charging",
    [DISCHARGING] = "Discharging",
    [URGENT] = "Urgent"
};

const char *pretty_battery_state[] = {
    [FULL] = "Полный заряд",
    [CHARGING] = "Питание подключено",
    [DISCHARGING] = "Питание отключено",
    [URGENT] = "Заряд на исходе"
};

const char *notify_color[] = {
    [FULL] = "color2",
    [CHARGING] = "color2",
    [DISCHARGING] = "color8",
    [URGENT] = "color1"
};

const char *urgency_level[] = {
    [FULL] = "LOW",
    [CHARGING] = "LOW",
    [DISCHARGING] = "NORMAL",
    [URGENT] = "CRITICAL",
};

const char *icons[] = {
    [FULL] = "battery_green.png",
    [CHARGING] = "battery_green.png",
    [DISCHARGING] = "battery_low.png",
    [URGENT] = "battery_critical.png"
};

#define str_to_state(str) str[0] % 4
#define state_to_str(state) str_battery_state[state]
#define prettify_state(state) pretty_battery_state[state]

const char *NOTIFY_FMT = 
    "dunstify \"%s\""
    " --appname=\"Батарея\""
    " --replace=%d"
    " --urgency=%s"
    " --hints=string:frcolor:%s"
    " --hints=string:fgcolor:%s"
    " --hints=string:bgcolor:%s"
    " --icon=~/.icons/i/%s";

int get_capacity() {
    FILE *capacity_file;
    char buf[4];
    
    capacity_file = fopen("/sys/class/power_supply/BAT1/capacity", "r");
    fgets(buf, 4, capacity_file);
    fclose(capacity_file);

    return atoi(buf);
}

battery_state get_state() { 
    FILE *state_file;
    FILE *cache_file;
    char buf[32];
    battery_state state;

    state_file = fopen("/sys/class/power_supply/BAT1/status", "r");
    fgets(buf, 32, state_file);
    fclose(state_file);
    state = str_to_state(buf);
    
    return state;
}

battery_state get_last_state() {
    FILE *cache_file;
    char buf[32];
    
    cache_file = fopen("/tmp/bat_last_state", "r");
    
    if (cache_file == NULL)
        return CHARGING;
    
    fgets(buf, 32, cache_file);
    fclose(cache_file);
    return str_to_state(buf);
}

void print_status(int capacity, battery_state state) {
    const char* color_name;
    char* color;

    if ( (capacity < URGENT_VALUE) && (state == DISCHARGING) )
        state = URGENT;

    switch (state) {
        case CHARGING:
        case FULL:
            color_name = "color2"; break;
        case URGENT:
            color_name = "color1"; break;
        default:
            color_name = color_level[(capacity - 1) / 25];
    }
    
    if (state == CHARGING) {
        setlocale(LC_ALL, "en_US.utf8");
        printf("%lc%d%%\n", (wchar_t) 0x26A1, capacity);
        printf("%lc%d%%\n", (wchar_t) 0x26A1, capacity);
    }
    else {
        printf("%d%%\n", capacity);
        printf("%d%%\n", capacity);
    
    }
    
    color = get_color(color_name);
    printf("%s\n", color);
    free(color);
}

void save_last_state(state) {
    FILE *cache_file;

    cache_file = fopen("/tmp/bat_last_state", "w");
    fputs(state_to_str(state), cache_file);
    
    fclose(cache_file);
}

void send_notify(battery_state state) {
    char notify_command[256];
    char *bgcolor;
    char *color;
    bgcolor = get_color("background");
    color = get_color(notify_color[state]);

    snprintf(
        notify_command, 256,
        NOTIFY_FMT,
        pretty_battery_state[state],
        MSGID, urgency_level[state],
        color, color, bgcolor,
        icons[state]
    );

    system(notify_command);

    free(color);
    free(bgcolor);
}

int main() {    
    int capacity;
    battery_state state;
    battery_state last_state;

    capacity = get_capacity();
    state = get_state();
    last_state = get_last_state();
    
    print_status(capacity, state);

    if (state != last_state) {
        send_notify(state);
        save_last_state(state);
    }
}
