# Keep the session's runtime directory. Use a private fallback only in WSL.
if [[ -n "${WSL_DISTRO_NAME:-}${WSL_INTEROP:-}" ]] ||
   [[ -r /proc/sys/kernel/osrelease && "$(</proc/sys/kernel/osrelease)" == *[Mm]icrosoft* ]]; then
  if [[ ! -d "${XDG_RUNTIME_DIR:-}" || ! -O "$XDG_RUNTIME_DIR" ]] ||
     [[ "$(stat -c %a -- "$XDG_RUNTIME_DIR" 2>/dev/null)" != 700 ]]; then
    runtime_dir="${TMPDIR:-/tmp}/runtime-$UID"
    if [[ ! -e "$runtime_dir" && ! -L "$runtime_dir" ]]; then
      (umask 077; mkdir -- "$runtime_dir")
    fi
    if [[ -d "$runtime_dir" && -O "$runtime_dir" && ! -L "$runtime_dir" ]]; then
      chmod 700 -- "$runtime_dir"
      export XDG_RUNTIME_DIR="$runtime_dir"
    fi
    unset runtime_dir
  fi

  if [[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]] && command -v dbus-launch >/dev/null 2>&1; then
    eval "$(dbus-launch --sh-syntax)"
  fi
fi
