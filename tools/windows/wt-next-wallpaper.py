#!/usr/bin/env python
import os
import json


CONFIG_PATH = "/mnt/c/Users/lenovo/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"
WALLPAPERS_PATH = "/mnt/e/wallpapers/"


content = ''
with open(CONFIG_PATH, 'r') as file:
    content = file.read()
j = json.loads(content)
image_path = j["profiles"]["defaults"]["backgroundImage"]
image_filename = image_path[image_path.rfind('\\')+1:]
images = os.listdir(WALLPAPERS_PATH)
i = images.index(image_filename)
j["profiles"]["defaults"]["backgroundImage"] = image_path[:image_path.rfind('\\')+1] + images[(i + 1) % len(images)]
with open(CONFIG_PATH, 'w') as file:
    file.write(json.dumps(obj=j, indent=4))
