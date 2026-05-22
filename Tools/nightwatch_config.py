"""Legacy compatibility wrappers for NightWatch configuration helpers."""

from nightwatch.gateway import patch_openclaw_config, setup_docker_symlinks
from nightwatch.permissions import elevate_agent_permissions, restore_agent_permissions
from nightwatch.shell import run_command

