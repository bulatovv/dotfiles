#!/bin/env python3

import os
from PIL import Image
from collections import Counter


def inspect(img, ignore):
    width, height = img.size
    pix = img.load()
    pix_counter = Counter()
    for y in range(width):
        for x in range(height):
            if pix[x, y] != ignore:
                pix_counter.update([pix[x, y]])
    return pix_counter


def convert_pix(ref, to, color):
    delta = (
        ref[0] - color[0],
        ref[1] - color[1],
        ref[2] - color[2],
        ref[3] - color[3],
    )

    return (
        to[0] - delta[0],
        to[1] - delta[1],
        to[2] - delta[2],
        to[3] - delta[3],
    )


def convert_colors(ref, to, ignore, img):
    width, height = img.size
    pix = img.load()

    out = Image.new("RGBA", (width, height))
    pix_out = out.load()
    for y in range(height):
        for x in range(width):
            if pix[x, y] != ignore:
                pix_out[x, y] = convert_pix(
                    ref,
                    to,
                    pix[x, y]
                )
            else:
                pix_out[x, y] = ignore

    return out


def palette(**kwargs):
    for color in kwargs:
        kwargs[color] = to_triplet(kwargs[color]) + (255,)
    return kwargs


def to_triplet(hx: str) -> (int, int, int):
    h1 = hx[1:3]
    h2 = hx[3:5]
    h3 = hx[5:7]
    return (int(h1, 16), int(h2, 16), int(h3, 16))


def convert_img(name, theme, colors):
    img = Image.open(f"Reference/{name}").convert("RGBA")
    print(f"\t{name}:", end="\033[1m ")
    ignore = (0, 0, 0, 0)
    pixels = inspect(img, ignore)
    ref = pixels.most_common(1)[0][0]
    for to in colors:
        if to in theme.palette:
            termcolor = "\033[38;2;{};{};{}m".format(*theme.palette[to])
            print(termcolor, to, sep='', end=" ")
            new = convert_colors(ref, theme.palette[to], ignore, img)
            if not os.path.exists(os.path.join(os.getcwd(), theme.name)):
                os.mkdir(f"{os.getcwd()}/{theme.name}")
            new.save(f"{theme.name}/"
                     + name.replace('.png', '')
                     + f'_{to}.png')
    print("\033[0;m")


class Theme:
    def __init__(self, name, **colors):
        self.name = name
        self.palette = palette(**colors)


if __name__ == "__main__":
    themes = (
        Theme(
            name="Nord",
            low="#4C566A",
            normal="#81A1C1",
            critical="#BF616A",
            green="#A3BE8C",
            yellow="#EBCB8B"
        ),
        Theme(
            name="Dracula",
            low="#4D4D4D",
            normal="#BD93F9",
            critical="#FF5555",
            green="#50FA7B",
            yellow="#F1FA8C"
        ),
        Theme(
            name="Gruvbox",
            low="#928374",
            normal="#458588",
            critical="#cc241d",
            green="#98971a",
            yellow="#d79921"
        )
    )
    images = {
        "battery.png": {"critical", "green", "low"},
        "eye.png": {"low", "normal"},
        "lan.png": {"critical", "green", "yellow", "low"},
        "music_note.png": {"low", "normal"},
        "screenshot.png": {"low", "normal"},
        "sitting.png": {"low", "normal"},
        "wifi.png": {"critical", "green", "yellow", "low"},
        "brightness.png": {"low"}
    }

    for theme in themes:
        print(f"\033[1mConverting to {theme.name} theme:\033[0m")
        for image in images:
            convert_img(image, theme, images[image])

