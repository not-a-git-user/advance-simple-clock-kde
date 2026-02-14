# Advanced Simple Clock

A KDE Plasma 6 taskbar clock widget with:

- auto vertical/horizontal layout
- optional seconds and AM/PM
- horizontal separator options
- taskbar-aware auto scaling
- per-part font size and bold controls
- mode-aware horizontal/vertical padding controls

## Plugin ID

`org.amritinfonet.advclock`

## Install (local)

```bash
kpackagetool6 -t Plasma/Applet -i .
```

To upgrade after changes:

```bash
kpackagetool6 -t Plasma/Applet -u .
```

To remove:

```bash
kpackagetool6 -t Plasma/Applet -r org.amritinfonet.advclock
```

## Project Structure

- `metadata.json` - package metadata
- `contents/ui/main.qml` - widget UI and behavior
- `contents/ui/configGeneral.qml` - settings UI
- `contents/config/main.xml` - config schema
- `contents/config/config.qml` - settings category wiring

## License

MIT (see `LICENSE`).
