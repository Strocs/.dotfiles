# Playwright CLI on Arch Linux (WSL2)

System: Arch Linux on WSL2. Installing `chromium` with pacman is typically enough — WSLg (default in newer WSL) provides the display server, so the browser UI renders inside Windows automatically.

## Dependencies

```bash
# System libraries required by Chromium
sudo pacman -S chromium

# Playwright bundled browser (optional — only if system Chromium is not used)
npx playwright install chromium
```

Browser cache location (managed by Playwright, do not touch): `~/.cache/ms-playwright/`

## Configuration

Default config path: `~/.playwright/cli.config.json`

```json
{
  "browser": {
    "browserName": "chromium",
    "launchOptions": {
      "executablePath": "/usr/bin/chromium"
    }
  }
}
```

This avoids downloading a second Chromium binary and uses the system-installed one.

## Dashboard support

The `show` command (Dashboard UI) locates Chromium by channel at a hardcoded path.
Create a symlink so it finds the system Chromium:

```bash
sudo mkdir -p /opt/google/chrome
sudo ln -s /usr/bin/chromium /opt/google/chrome/chrome
```

## Verification

```bash
playwright-cli open       # opens browser, uses system Chromium
playwright-cli show       # opens Dashboard UI
```

## Connect to Windows Chrome via CDP (alternative)

If using the Windows host browser instead:

1. Launch Chrome on Windows with remote debugging:
   ```
   chrome.exe --remote-debugging-port=9222 --user-data-dir="C:\pw-profile"
   ```

2. Get Windows IP from WSL:
   ```bash
   WINDOWS_IP=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
   ```

3. Attach:
   ```bash
   playwright-cli attach --cdp=http://$WINDOWS_IP:9222
   ```

## Notes

- `--with-deps` flag does not work on Arch (uses apt-get). Use `pacman -S chromium` instead.
- The config file `~/.playwright/cli.config.json` is auto-discovered by playwright-cli.
- Chromium version from pacman (`/usr/bin/chromium`) is used instead of Playwright's bundled binary.
- Installing `chromium` with pacman pulls all shared libraries needed by Playwright's bundled browser too.
- If WSLg is not available (old WSL or disabled), an X server like VcXsrv on Windows + `DISPLAY` env var is needed for headed mode.
