# TeHyButton

A battery powered, latching WiFi button on an ESP8285. Pressing the button
powers the device on, it joins your WiFi, reports the press (HTTP GET,
HTTP POST and/or MQTT) and cuts its own power again — no standby drain
between presses.

- single click, double click and long press are reported as
  `click` / `double click` / `long click` via the `%state%` placeholder
- each device has a unique key (`%key%` placeholder), usable with
  [tehybug.com](https://tehybug.com) or your own service
- WiFi setup through a captive portal, configuration through a built-in
  web dashboard, firmware updates over the air

## Dashboard

![Dashboard](docs/screenshots/main.png)

## Data serving settings

![Data serving settings](docs/screenshots/settings.png)

## System settings

![System settings](docs/screenshots/setsystem.png)

## About & buttons cheat sheet

![About & buttons](docs/screenshots/about.png)

## First start

![First start](docs/screenshots/firststart.png)

## Building

```sh
./build.sh            # release build (DEBUG=0) for esp8285 + generic
./build.sh debug      # debug build with serial logging (-DDEBUG=1)
./build.sh all        # both
```

Binaries land in `build/<board>/<mode>/`; the release esp8285 binary also
refreshes the shipped `tehybutton.ino.esp8285.bin`. Requires
[arduino-cli](https://arduino.github.io/arduino-cli/) with the
`esp8266:esp8266` core (2.7.4) installed.

## Flashing

[BugZapper](https://github.com/gumslone/bugzapper) is bundled (as a submodule
under `tools/bugzapper/`) to flash the firmware and watch the serial output in
one place — no NodeMCU PyFlasher or CoolTerm needed. esptool is vendored
(pure Python), so a plain `python3` is enough; the GUI additionally needs Tk
(`brew install python-tk@3.10`).

```sh
./bugzapper.sh        # GUI: pick port / firmware / baud, flash and monitor
./flash.sh            # CLI: flash the shipped tehybutton.ino.esp8285.bin
./flash.sh -e         # erase all flash, then write
./flash.sh -l         # list detected serial ports
./flash.sh -h         # full option help
```

Both default to the shipped `tehybutton.ino.esp8285.bin`; pass `-f` (CLI) or
**Browse…** (GUI) to flash a different build. Clone with
`git clone --recurse-submodules`, or run `git submodule update --init` in an
existing checkout, to fetch `tools/bugzapper/`.

## Web UI development

The dashboard pages under `tehybutton/v1/` are served from tehybug.com and
loaded by the device's embedded start page. To preview them locally with
simulated device data:

```sh
php -S 127.0.0.1:8123 -t tehybutton/v1
# open http://127.0.0.1:8123/preview.html            (dashboard)
# open http://127.0.0.1:8123/preview.html?page=about (any other page)
```

`preview.html` stubs the device websocket and feeds realistic sample data
through the UI's real message handling, so all pages render without
hardware. The README screenshots are captured from exactly this harness:

```sh
"Google Chrome" --headless=new --screenshot=docs/screenshots/main.png \
  --window-size=1280,800 --force-device-scale-factor=2 \
  --virtual-time-budget=12000 --hide-scrollbars \
  "http://127.0.0.1:8123/preview.html?page=main"
```
