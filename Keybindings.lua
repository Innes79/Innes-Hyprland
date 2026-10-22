hl.bind("SUPER + H", hl.dsp.exec_cmd("$HOME/.config/hypr/show-desktop.sh"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))


hl.bind("SUPER + ALT + Right", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/innes/scripts/wallpaper.sh next"))
hl.bind("SUPER + ALT + Left",  hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/innes/scripts/wallpaper.sh prev"))


hl.exec_cmd(os.getenv("HOME") .. "/.config/innes/scripts/wallpaper.sh")
