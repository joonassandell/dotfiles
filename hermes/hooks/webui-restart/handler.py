"""Restart hermes-webui when the gateway starts.

Hermes updates restart the gateway but not hermes-webui, which then keeps
running stale code. The restart is detached so the gateway never waits on it.
"""
import logging
import os
import subprocess
from pathlib import Path

logger = logging.getLogger(__name__)

CTL = Path.home() / "Repositories" / "hermes-webui" / "ctl.sh"
# hermes-webui needs Python 3.11+; without this it falls back to system 3.9.
WEBUI_PYTHON = "/opt/homebrew/bin/python3"
LOG = Path.home() / ".hermes" / "logs" / "webui-restart-hook.log"


def handle(event_type: str, context: dict):
    if not CTL.exists():
        logger.warning("[webui-restart] %s not found, skipping", CTL)
        return
    env = dict(os.environ, HERMES_WEBUI_PYTHON=WEBUI_PYTHON)
    try:
        LOG.parent.mkdir(parents=True, exist_ok=True)
        with open(LOG, "ab") as log:
            subprocess.Popen(
                [str(CTL), "restart", "--no-browser"],
                env=env,
                stdin=subprocess.DEVNULL,
                stdout=log,
                stderr=log,
                start_new_session=True,
            )
    except Exception:
        logger.exception("[webui-restart] failed to start restart")
