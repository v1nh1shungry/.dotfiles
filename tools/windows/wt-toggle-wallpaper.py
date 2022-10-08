#!/usr/bin/env python
import json


CONFIG_PATH = "/mnt/c/Users/lenovo/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json"


content = ""
with open(CONFIG_PATH, 'r') as file:
    content = file.read()
j = json.loads(content)
opacity = j["profiles"]["defaults"]["backgroundImageOpacity"]
if opacity == 0.0:
    j["profiles"]["defaults"]["backgroundImageOpacity"] = 0.5
else:
    j["profiles"]["defaults"]["backgroundImageOpacity"] = 0.0
with open(CONFIG_PATH, 'w') as file:
    file.write(json.dumps(obj=j, indent=4))
