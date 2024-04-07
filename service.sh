#!/bin/bash
SERVICE_NAME="nextcloud"
SERVICE_VERSION="v0.1"

set -e

SERVICE_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
echo "[$SERVICE_NAME] $SERVICE_VERSION ($(git rev-parse --short HEAD))"
cd $SERVICE_DIR

# CORE
source ./core/core.sh
# BORG
source ./borg/borg.sh


# VARIABLES
set -o allexport
# set variables for docker or other services here
set +o allexport

# COMMANDS

commands+=([remove-skeleton]=":remove nextcloud skeleton files for new users")
cmd_remove-skeleton() {
  sudo rm -r $SERVICE_DIR/volumes/data/core/skeleton/* &>/dev/null || true
  echo "Removed nextcloud skeleton files for new users"
}

commands+=([occ]="<command>:run occ command")
cmd_occ() {
  # check if nextcloud is running
  docker compose ps nextcloud &>/dev/null || { echo "Nextcloud is not running"; return 1; }

  docker compose exec -u www-data nextcloud ./occ $@
}

# ATTACHMENTS

# MAIN
main "$@"
