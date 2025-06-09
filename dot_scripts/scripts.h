#include <stdlib.h>
#include <string.h>
#include <X11/Xlib.h>
#include <X11/Xresource.h>

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
