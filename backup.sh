#!/bin/bash
# í·‚ï¸ Automated Backup Script

# === CONFIG ===
SOURCE_DIR="${1:-$HOME/test_source}"
#!/bin/bash
# Automated Backup Script with Logging (writes logs into backups/ folder)

# === Configuration ===
BACKUP_SRC=${1:-"$HOME/test_source"}
BACKUP_DIR="$HOME/backup-system/backups"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"
EXCLUDES=(.git node_modules .cache)

# === Ensure backup directory exists ===
mkdir -p "$BACKUP_DIR"

# === Logging function ===
log() {
    local LEVEL="$1"
    local MSG="$2"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $LEVEL: $MSG" | tee -a "$LOG_FILE"
}

# === Start backup ===
log "INFO" "Starting backup of $BACKUP_SRC"

# === Create archive ===
tar_args=()
for e in "${EXCLUDES[@]}"; do
    tar_args+=(--exclude="$e")
done

if tar -czf "$BACKUP_FILE" "${tar_args[@]}" -C "$(dirname "$BACKUP_SRC")" "$(basename "$BACKUP_SRC")"; then
    log "INFO" "Backup created successfully â†’ $BACKUP_FILE"

    # Create SHA256 checksum
    sha256sum "$BACKUP_FILE" > "$BACKUP_FILE.sha256"
    log "INFO" "SHA256 checksum created â†’ $BACKUP_FILE.sha256"

    log "INFO" "Backup process completed successfully."
else
    log "ERROR" "Backup failed to create archive."
    exit 1
fi
BACKUP_DIR="$HOME/backup-system/backups"
LOG_FILE="$BACKUP_DIR/backup.log"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# === FUNCTIONS ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# === MAIN ===
mkdir -p "$BACKUP_DIR"

if [[ "$1" == "--list" ]]; then
    log "INFO: Listing available backups in $BACKUP_DIR"
    ls -lh "$BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 0
fi

log "INFO: Starting backup of $SOURCE_DIR"

# Create the tar archive and log output
tar --exclude=".git" --exclude="node_modules" --exclude=".cache" -czf "$ARCHIVE_PATH" -C "$SOURCE_DIR" . 2>>"$LOG_FILE"

if [[ $? -eq 0 ]]; then
    log "INFO: Backup created successfully â†’ $ARCHIVE_PATH"
    sha256sum "$ARCHIVE_PATH" > "$ARCHIVE_PATH.sha256"
    log "INFO: SHA256 checksum created â†’ $ARCHIVE_PATH.sha256"
else
    log "ERROR: Backup failed during compression!"
    exit 1
fi

log "INFO: Backup process completed successfully."

#!/bin/bash
# í·‚ï¸ Automated Backup Script

# === CONFIG ===
SOURCE_DIR="${1:-$HOME/test_source}"
BACKUP_DIR="$HOME/backup-system/backups"
LOG_FILE="$BACKUP_DIR/backup.log"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"

# === FUNCTIONS ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# === MAIN ===
mkdir -p "$BACKUP_DIR"

if [[ "$1" == "--list" ]]; then
    log "INFO: Listing available backups in $BACKUP_DIR"
    ls -lh "$BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 0
fi

log "INFO: Starting backup of $SOURCE_DIR"

# Create the tar archive and log output
tar --exclude=".git" --exclude="node_modules" --exclude=".cache" -czf "$ARCHIVE_PATH" -C "$SOURCE_DIR" . 2>>"$LOG_FILE"

if [[ $? -eq 0 ]]; then
    log "INFO: Backup created successfully â†’ $ARCHIVE_PATH"
    sha256sum "$ARCHIVE_PATH" > "$ARCHIVE_PATH.sha256"
    log "INFO: SHA256 checksum created â†’ $ARCHIVE_PATH.sha256"
else
    log "ERROR: Backup failed during compression!"
    exit 1
fi

log "INFO: Backup process completed successfully."


#!/bin/bash

# ==========================================
# í³¦ Automated Backup Script (Updated)
# ==========================================

# --- Configuration ---
BACKUP_SRC="$1"
BACKUP_DIR="$HOME/backups"
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_NAME"
LOGFILE="$BACKUP_DIR/backup.log"
EXCLUDES=(".git" "node_modules" ".cache")

# --- Create backup folder if not exists ---
mkdir -p "$BACKUP_DIR"

# --- Logging function ---
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOGFILE"
}

# --- Check for arguments ---
if [[ -z "$BACKUP_SRC" ]]; then
  log "ERROR: No source directory provided."
  echo "Usage: $0 <source_folder>"
  exit 1
fi

# --- Handle special commands ---
case "$1" in
  --list)
    log "INFO: Listing available backups in $BACKUP_DIR"
    ls -lh "$BACKUP_DIR" | tee -a "$LOGFILE"
    exit 0
    ;;
  --restore)
    shift
    BACKUP_FILE="$1"
    shift
    if [[ "$1" == "--to" ]]; then
      RESTORE_DIR="$2"
      mkdir -p "$RESTORE_DIR"
      log "INFO: Restoring $BACKUP_FILE to $RESTORE_DIR"
      tar -xzf "$BACKUP_DIR/$BACKUP_FILE" -C "$RESTORE_DIR"
      log "INFO: Restore complete."
      exit 0
    else
      log "ERROR: Missing '--to <destination>' argument."
      exit 1
    fi
    ;;
  --dry-run)
    shift
    BACKUP_SRC="$1"
    log "INFO: Dry run mode ON"
    log "INFO: Would back up $BACKUP_SRC to $BACKUP_DIR"
    log "INFO: Excluding: ${EXCLUDES[*]}"
    exit 0
    ;;
esac

# --- Run backup ---
log "INFO: Starting backup of $BACKUP_SRC"

# Build exclude options
EXCLUDE_OPTS=()
for pattern in "${EXCLUDES[@]}"; do
  EXCLUDE_OPTS+=(--exclude="$pattern")
done

# Create tar archive
tar -czf "$ARCHIVE_PATH" "${EXCLUDE_OPTS[@]}" -C "$(dirname "$BACKUP_SRC")" "$(basename "$BACKUP_SRC")" 2>>"$LOGFILE"

if [[ $? -eq 0 ]]; then
  log "INFO: Backup created successfully â†’ $ARCHIVE_PATH"
else
  log "ERROR: Failed to create backup archive"
  exit 1
fi

# Generate checksum
sha256sum "$ARCHIVE_PATH" > "$ARCHIVE_PATH.sha256"
log "INFO: SHA256 checksum created â†’ $ARCHIVE_PATH.sha256"

log "INFO: Backup process completed successfully."
#!/bin/bash
# ============================================
# í·  Automated Backup Script
# Works on Linux / macOS / Git Bash for Windows
# ============================================

# === CONFIGURATION ===
BACKUP_DIR="$HOME/backups"
LOG_FILE="$HOME/backup.log"
EXCLUDES=(".git" "node_modules" ".cache")

# === FUNCTIONS ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

show_help() {
    echo "Usage:"
    echo "  ./backup.sh [OPTIONS] <source_folder>"
    echo
    echo "Options:"
    echo "  --dry-run        Show what would be done without creating backup"
    echo "  --list           List existing backups"
    echo "  --restore <file> --to <destination>  Restore backup"
    echo
    exit 0
}

# === PARSE ARGUMENTS ===
DRY_RUN=false
RESTORE_FILE=""
RESTORE_DEST=""
LIST=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --list) LIST=true; shift ;;
        --restore) RESTORE_FILE="$2"; shift 2 ;;
        --to) RESTORE_DEST="$2"; shift 2 ;;
        -h|--help) show_help ;;
        *) SOURCE="$1"; shift ;;
    esac
done

# === MAIN LOGIC ===
mkdir -p "$BACKUP_DIR" 2>/dev/null

# --- List existing backups ---
if [ "$LIST" = true ]; then
    log "INFO: Listing available backups in $BACKUP_DIR"
    ls -lh "$BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 0
fi

# --- Restore backup ---
if [ -n "$RESTORE_FILE" ] && [ -n "$RESTORE_DEST" ]; then
    if [ ! -f "$BACKUP_DIR/$RESTORE_FILE" ]; then
        log "ERROR: Backup not found: $RESTORE_FILE"
        exit 1
    fi
    mkdir -p "$RESTORE_DEST"
    log "INFO: Restoring $RESTORE_FILE â†’ $RESTORE_DEST"
    tar -xzf "$BACKUP_DIR/$RESTORE_FILE" -C "$RESTORE_DEST" 2>>"$LOG_FILE" \
        && log "INFO: Restore completed successfully" \
        || log "ERROR: Restore failed"
    exit 0
fi

# --- Create backup ---
if [ -z "$SOURCE" ]; then
    show_help
fi

TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
DEST_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
log "INFO: Starting backup of $SOURCE"

# Prepare exclude parameters
EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(--exclude="$e")
done

if [ "$DRY_RUN" = true ]; then
    log "INFO: Dry run mode ON"
    log "INFO: Would create archive: $DEST_FILE"
    exit 0
fi

# Actual tar command (fixed order for Git Bash)
if (cd "$SOURCE" && tar -czf "$DEST_FILE" "${EXCLUDE_ARGS[@]}" .) 2>>"$LOG_FILE"; then
    log "INFO: Backup created successfully â†’ $DEST_FILE"
else
    log "ERROR: Failed to create backup archive"
fi
#!/bin/bash
# ============================================
# í·  Automated Backup Script
# Works on Linux / macOS / Git Bash for Windows
# ============================================

# === CONFIGURATION ===
BACKUP_DIR="$HOME/backups"
LOG_FILE="$HOME/backup.log"
EXCLUDES=(".git" "node_modules" ".cache")

# === FUNCTIONS ===
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

show_help() {
    echo "Usage:"
    echo "  ./backup.sh [OPTIONS] <source_folder>"
    echo
    echo "Options:"
    echo "  --dry-run        Show what would be done without creating backup"
    echo "  --list           List existing backups"
    echo "  --restore <file> --to <destination>  Restore backup"
    echo
    exit 0
}

# === PARSE ARGUMENTS ===
DRY_RUN=false
RESTORE_FILE=""
RESTORE_DEST=""
LIST=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --list) LIST=true; shift ;;
        --restore) RESTORE_FILE="$2"; shift 2 ;;
        --to) RESTORE_DEST="$2"; shift 2 ;;
        -h|--help) show_help ;;
        *) SOURCE="$1"; shift ;;
    esac
done

# === MAIN LOGIC ===
mkdir -p "$BACKUP_DIR" 2>/dev/null

# --- List existing backups ---
if [ "$LIST" = true ]; then
    log "INFO: Listing available backups in $BACKUP_DIR"
    ls -lh "$BACKUP_DIR" | tee -a "$LOG_FILE"
    exit 0
fi

# --- Restore backup ---
if [ -n "$RESTORE_FILE" ] && [ -n "$RESTORE_DEST" ]; then
    if [ ! -f "$BACKUP_DIR/$RESTORE_FILE" ]; then
        log "ERROR: Backup not found: $RESTORE_FILE"
        exit 1
    fi
    mkdir -p "$RESTORE_DEST"
    log "INFO: Restoring $RESTORE_FILE â†’ $RESTORE_DEST"
    tar -xzf "$BACKUP_DIR/$RESTORE_FILE" -C "$RESTORE_DEST" 2>>"$LOG_FILE" \
        && log "INFO: Restore completed successfully" \
        || log "ERROR: Restore failed"
    exit 0
fi

# --- Create backup ---
if [ -z "$SOURCE" ]; then
    show_help
fi

TIMESTAMP=$(date '+%Y-%m-%d-%H%M')
DEST_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
log "INFO: Starting backup of $SOURCE"

# Prepare exclude parameters
EXCLUDE_ARGS=()
for e in "${EXCLUDES[@]}"; do
    EXCLUDE_ARGS+=(--exclude="$e")
done

if [ "$DRY_RUN" = true ]; then
    log "INFO: Dry run mode ON"
    log "INFO: Would create archive: $DEST_FILE"
    exit 0
fi

# Actual tar command (fixed order for Git Bash)
if (cd "$SOURCE" && tar -czf "$DEST_FILE" "${EXCLUDE_ARGS[@]}" .) 2>>"$LOG_FILE"; then
    log "INFO: Backup created successfully â†’ $DEST_FILE"
else
    log "ERROR: Failed to create backup archive"
fi

exit_with_lock_cleanup() {
  local code=$1
  [[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
  exit $code
}

# load config (or defaults)
load_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck disable=SC1090
    source "$CONFIG_FILE"
  else
    echo "Warning: config file not found at $CONFIG_FILE. Using defaults."
    BACKUP_DESTINATION="$SCRIPT_DIR/backups"
    EXCLUDE_PATTERNS=('.git' 'node_modules' '.cache')
    DAILY_KEEP=7
    WEEKLY_KEEP=4
    MONTHLY_KEEP=3
    LOG_FILE="$SCRIPT_DIR/backup.log"
    MAIL_TO=""
  fi

  # turn comma string into array if necessary
  if [[ -n "$EXCLUDE_PATTERNS" && ! $(declare -p EXCLUDE_PATTERNS 2>/dev/null) =~ "declare -a" ]]; then
    IFS=',' read -r -a EXCLUDE_PATTERNS <<< "$EXCLUDE_PATTERNS"
  fi

  : ${DAILY_KEEP:=7}
  : ${WEEKLY_KEEP:=4}
  : ${MONTHLY_KEEP:=3}
  : ${LOG_FILE:="$SCRIPT_DIR/backup.log"}
}

ensure_destination() {
  if [[ ! -d "$BACKUP_DESTINATION" ]]; then
    if (( DRY_RUN )); then
      log INFO "Would create backup destination: $BACKUP_DESTINATION"
    else
      mkdir -p "$BACKUP_DESTINATION" || { log ERROR "Cannot create destination $BACKUP_DESTINATION"; exit_with_lock_cleanup 1; }
      log INFO "Created backup destination: $BACKUP_DESTINATION"
    fi
  fi
}

check_space() {
  local needed_kb=$1
  local avail_kb
  avail_kb=$(df --output=avail -k "$BACKUP_DESTINATION" 2>/dev/null | tail -n1)
  if [[ -z "$avail_kb" ]]; then
    log WARN "Could not determine available disk space"
    return 0
  fi
  if (( avail_kb < needed_kb )); then
    log ERROR "Not enough disk space: need ${needed_kb}KB, available ${avail_kb}KB"
    return 1
  fi
  return 0
}

create_checksum() {
  local file="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$file" | awk '{print $1}' > "$file.sha256"
  else
    md5sum "$file" | awk '{print $1}' > "$file.md5"
  fi
}

verify_checksum() {
  local file="$1"
  if [[ -f "$file.sha256" ]]; then
    local sum expected
    sum=$(sha256sum "$file" | awk '{print $1}')
    expected=$(cat "$file.sha256")
    [[ "$sum" == "$expected" ]]
    return $?
  elif [[ -f "$file.md5" ]]; then
    local sum expected
    sum=$(md5sum "$file" | awk '{print $1}')
    expected=$(cat "$file.md5")
    [[ "$sum" == "$expected" ]]
    return $?
  else
    log WARN "No checksum file for $file"
    return 1
  fi
}

extract_test() {
  local archive="$1"
  local tmpdir
  tmpdir=$(mktemp -d 2>/dev/null || mktemp -d -t tmp)
  local sample
  sample=$(tar -tzf "$archive" 2>/dev/null | head -n1)
  if [[ -z "$sample" ]]; then
    log WARN "Archive $archive appears empty"
    rm -rf "$tmpdir"
    return 1
  fi
  if tar -xzf "$archive" -C "$tmpdir" "$sample" >/dev/null 2>&1; then
    rm -rf "$tmpdir"
    return 0
  else
    rm -rf "$tmpdir"
    return 1
  fi
}

create_backup() {
  local src="$1"
  [[ -d "$src" ]] || { log ERROR "Source folder not found: $src"; exit_with_lock_cleanup 1; }
  [[ -r "$src" ]] || { log ERROR "Cannot read folder (permission denied): $src"; exit_with_lock_cleanup 1; }

  local ts name dest
  ts=$(date +"%Y-%m-%d-%H%M")
  name="backup-${ts}.tar.gz"
  dest="$BACKUP_DESTINATION/$name"

  local exclude_args=()
  for p in "${EXCLUDE_PATTERNS[@]}"; do
    exclude_args+=(--exclude="$p")
  done

  log INFO "Starting backup of $src"

  if (( DRY_RUN )); then
    log INFO "Would create archive: $dest (excluding: ${EXCLUDE_PATTERNS[*]})"
    return 0
  fi

  local est_kb
  est_kb=$(du -sk "$src" 2>/dev/null | awk '{print $1}')
  check_space $(( (est_kb>0?est_kb:1) * 2 )) || { log ERROR "Not enough disk space for backup"; exit_with_lock_cleanup 1; }

  if tar -czf "$dest" -C "$(dirname "$src")" "$(basename "$src")" "${exclude_args[@]}" 2>>"$LOG_FILE"; then

    log SUCCESS "Backup created: $name"
  else
    log ERROR "Failed to create backup archive"
    [[ -f "$dest" ]] && rm -f "$dest"
    exit_with_lock_cleanup 1
  fi

  create_checksum "$dest"
  if verify_checksum "$dest"; then
    log INFO "Checksum verified successfully"
  else
    log ERROR "Checksum verification failed"
    exit_with_lock_cleanup 1
  fi

  if extract_test "$dest"; then
    log INFO "Archive test extract OK"
    log SUCCESS "SUCCESS: Backup $name verified"
  else
    log ERROR "FAILED: Archive $name failed extract test"
    exit_with_lock_cleanup 1
  fi
}

rotate_backups() {
  IFS=$'\n' read -r -d '' -a files < <(find "$BACKUP_DESTINATION" -maxdepth 1 -type f -name 'backup-*.tar.gz' -printf '%f\n' | sort -r && printf '\0')

  declare -A keep_day
  declare -A keep_week
  declare -A keep_month

  for f in "${files[@]}"; do
    [[ -z "$f" ]] && continue
    if [[ ! $f =~ backup-([0-9]{4})-([0-9]{2})-([0-9]{2})-([0-9]{4})\.tar\.gz ]]; then
      log WARN "Skipping unknown file: $f"
      continue
    fi
    local year=${BASH_REMATCH[1]}
    local month=${BASH_REMATCH[2]}
    local day=${BASH_REMATCH[3]}
    local daykey="$year-$month-$day"
    local weekkey
    weekkey=$(date -d "$daykey" +"%Y-W%V" 2>/dev/null || echo "$daykey")
    local monthkey="$year-$month"

    if [[ -z "${keep_day[$daykey]}" && ${#keep_day[@]} -lt $DAILY_KEEP ]]; then
      keep_day[$daykey]=1
      continue
    fi
    if [[ -z "${keep_week[$weekkey]}" && ${#keep_week[@]} -lt $WEEKLY_KEEP ]]; then
      keep_week[$weekkey]=1
      continue
    fi
    if [[ -z "${keep_month[$monthkey]}" && ${#keep_month[@]} -lt $MONTHLY_KEEP ]]; then
      keep_month[$monthkey]=1
      continue
    fi

    if (( DRY_RUN )); then
      log INFO "Would delete old backup: $f"
    else
      rm -f "$BACKUP_DESTINATION/$f" && log INFO "Deleted old backup: $f"
      [[ -f "$BACKUP_DESTINATION/$f.sha256" ]] && rm -f "$BACKUP_DESTINATION/$f.sha256"
      [[ -f "$BACKUP_DESTINATION/$f.md5" ]] && rm -f "$BACKUP_DESTINATION/$f.md5"
    fi
  done
}

list_backups() {
  echo "Available backups in $BACKUP_DESTINATION:"
  ls -lh "$BACKUP_DESTINATION"/backup-*.tar.gz 2>/dev/null || echo "(none)"
}

restore_backup() {
  local archive="$1"
  local to="$2"
  if [[ ! -f "$BACKUP_DESTINATION/$archive" ]]; then
    log ERROR "Backup not found: $archive"
    exit_with_lock_cleanup 1
  fi
  if (( DRY_RUN )); then
    log INFO "Would restore $archive to $to"
    return 0
  fi
  mkdir -p "$to" || { log ERROR "Cannot create restore dir $to"; exit_with_lock_cleanup 1; }
  if tar -xzf "$BACKUP_DESTINATION/$archive" -C "$to"; then
    log SUCCESS "Restored $archive to $to"
  else
    log ERROR "Restore failed"
    exit_with_lock_cleanup 1
  fi
}

# parse args
if [[ $# -lt 1 ]]; then
  echo "Usage: $0 [--dry-run] [--list] [--restore <archive> --to <dir>] [--config <file>] <source_folder>"
  exit 1
fi

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --list) LIST=1; shift ;;
    --restore) RESTORE=1; RESTORE_ARCHIVE="$2"; shift 2 ;;
    --to) RESTORE_TARGET="$2"; shift 2 ;;
    --config) CONFIG_FILE="$2"; shift 2 ;;
    --help) echo "See README.md for usage"; exit 0 ;;
    --) shift; break ;;
    -*|--*) echo "Unknown option $1"; exit 1 ;;
    *) POSITIONAL+=("$1"); shift ;;
  esac
done
set -- "${POSITIONAL[@]}"

load_config
LOG_FILE=${LOG_FILE:-"$SCRIPT_DIR/backup.log"}
ensure_destination

if [[ -f "$LOCK_FILE" ]]; then
  log ERROR "Another instance is running (lock file exists: $LOCK_FILE)"
  exit 1
fi
if (( DRY_RUN )); then
  log INFO "Dry run mode ON"
else
  touch "$LOCK_FILE"
  trap 'exit_with_lock_cleanup 1' INT TERM EXIT
fi

if (( LIST )); then
  list_backups
  [[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
  exit 0
fi

if (( RESTORE )); then
  if [[ -z "$RESTORE_ARCHIVE" || -z "$RESTORE_TARGET" ]]; then
    echo "Usage: $0 --restore <archive> --to <dir>"
    exit_with_lock_cleanup 1
  fi
  restore_backup "$RESTORE_ARCHIVE" "$RESTORE_TARGET"
  [[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
  exit 0
fi

SRC_DIR="$1"
if [[ -z "$SRC_DIR" ]]; then
  echo "Error: No source folder specified"
  exit_with_lock_cleanup 1
fi

create_backup "$SRC_DIR"
rotate_backups

[[ -f "$LOCK_FILE" ]] && rm -f "$LOCK_FILE"
trap - INT TERM EXIT

exit 0
