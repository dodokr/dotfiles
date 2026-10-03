# Customizing CachyOS Login Screen (PLM) with Animated Video Wallpaper

CachyOS uses **Plasma Login Manager (PLM)** by default instead of traditional SDDM. Because PLM runs under a secure root system user (`plasmalogin`), it cannot naturally see plugins or videos stored in your home directory (`~/`). 

This guide outlines how to migrate the **Smart Video Wallpaper Reborn** plugin and target video loops to system-wide paths.

---

## Prerequisites

* Smart video wallpaper reborn

---

## 1. Move Plugin to Global System Path
When installed via the KDE System Settings GUI, the plugin is isolated inside your user profile. Copy it to the global directory and assign read permissions:

```bash
# 1. Copy the plugin directory
sudo cp -r ~/.local/share/plasma/wallpapers/luisbocanegra.smart.video.wallpaper.reborn /usr/share/plasma/wallpapers/

# 2. Give the login manager user permission to execute/read it
sudo chmod -R 755 /usr/share/plasma/wallpapers/luisbocanegra.smart.video.wallpaper.reborn
```

---

## 2. Deploy the Video File Globally
Move your desired `.mp4` or `.webm` wallpaper file to a system directory outside of your encrypted or locked user home directory:

```bash
# 1. Copy video file
sudo cp /path/to/your/video.mp4 /usr/share/wallpapers/login-video.mp4

# 2. Mark it globally readable
sudo chmod 644 /usr/share/wallpapers/login-video.mp4
```

---

## 3. Configure the Login Manager Back-end

```bash
sudo -E vim /etc/plasmalogin.conf
```

Add following (add own login video):

```ini
[Greeter]
WallpaperPluginId=luisbocanegra.smart.video.wallpaper.reborn

[Greeter][Wallpaper][luisbocanegra.smart.video.wallpaper.reborn][General]
VideoUrls=[{"filename":"file:///usr/share/wallpapers/login-video.mp4","enabled":true,"duration":0,"customDuration":0,"playbackRate":0,"alternativePlaybackRate":0,"loop":false}]
```

---

## Troubleshooting
* **Black Screen with UI:** If the screen stays black but the user profile picture and text box show up, check your `/etc/plasmalogin.conf` file pathing. Ensure the video file has 3 forward slashes (`file:///`).
* **Frozen First Frame:** If the animation does not loop, check your local plugin configuration settings gear in *System Settings -> Wallpaper* to ensure *"Pause video when out of focus"* is toggled off.

