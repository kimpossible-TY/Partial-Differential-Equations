import os
import sys

# Add Tools to path
sys.path.append(os.path.join(os.getcwd(), 'Tools'))

from nightwatch_config import patch_openclaw_config

gemini_api_key = "dummy-key"
tag = "WORKER"
token = "dummy-token"

# Run patching for a test file
patch_openclaw_config(gemini_api_key, tag, token)

# The function patches .openclaw_config/openclaw.json in the current working directory.
# Since I'm in /workspace, it will be /workspace/.openclaw_config/openclaw.json.
