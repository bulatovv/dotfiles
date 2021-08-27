#include "../scripts.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <locale.h>
#include <wchar.h>
#include <X11/Xlib.h>
#include <X11/Xresource.h>


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

char *get_color(const char *color) { /* returned string must be freed */
    XrmValue result;
    char* color_value;
    char* type;

    Display* display = XOpenDisplay(0);
    XrmDatabase xrdb = XrmGetStringDatabase(XResourceManagerString(display));
    
    XrmGetResource(xrdb, color, "String", &type, &result);
    color_value = (char *) malloc(result.size * sizeof(char));
    strncpy(color_value, result.addr, result.size);

    XCloseDisplay(display);
    XrmDestroyDatabase(xrdb);

    return color_value;
}

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

int main() {
    
    int capacity;
    battery_state state;
    battery_state last_state;
    char *color;
    const char *color_name;
    FILE *cache_file;
    char buf[32];

    capacity = get_capacity();
    state = get_state();
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
    
    color = get_color(color_name);
    if (state == CHARGING) {
        setlocale(LC_ALL, "en_US.utf8");
        printf("%lc%d%%\n", (wchar_t) 0x26A1, capacity);
        printf("%lc%d%%\n", (wchar_t) 0x26A1, capacity);
    }
    else {
        printf("%d%%\n", capacity);
        printf("%d%%\n", capacity);
    
    }
    printf("%s\n", color);
    free(color);
   
    cache_file = fopen("/tmp/bat_last_state", "r");
    if (cache_file == NULL) {
        last_state = CHARGING;
    }
    else {
        fgets(buf, 32, cache_file);
        last_state = str_to_state(buf);
        fclose(cache_file);
    }

    if (state != last_state) {
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
        
        cache_file = fopen("/tmp/bat_last_state", "w");
        fputs(state_to_str(state), cache_file);
        
        fclose(cache_file);
        free(color);
        free(bgcolor);
    }
}
