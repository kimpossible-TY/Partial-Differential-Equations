# OpenClaw Discord Setup and Patching

## 1. Discord Bot Connection
OpenClaw is integrated with Discord using the `@openclaw/plugin-discord` plugin.
Configuration includes setting up the appropriate `discord.token` and `discord.applicationId` within the OpenClaw configuration file (`config.yaml`).

## 2. Configuration Patching (`patch_openclaw_config.py`)
To dynamically configure the multi-agent setup, we use `patch_openclaw_config.py`.
This script injects specific agent paths, plugin settings, and environment variables into the main OpenClaw config structure, enabling our designated personas.

- **Operation:** Merges dictionary mappings containing `agents` list and plugin specifics into `~/.openclaw/config.yaml`.
- **Purpose:** Avoids manual editing and prevents overriding existing local keys unknowingly.
