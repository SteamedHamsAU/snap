#!/bin/bash
set -euo pipefail
# Generates an xcconfig that sets CURRENT_PROJECT_VERSION to YYMMDD.HHMM.SHA.
# Runs as a scheme pre-action so the value is resolved into Info.plist during
# the normal build — no post-build plist patching required.
SRCROOT="${SRCROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
XCCONFIG="${SRCROOT}/Config/GeneratedBuildNumber.xcconfig"
BUILD_NUMBER=$(date +"%y%m%d.%H%M")
SHORT_SHA=$(git -C "${SRCROOT}" rev-parse --short HEAD 2>/dev/null || echo "unknown")
FULL_BUILD="${BUILD_NUMBER}.${SHORT_SHA}"
mkdir -p "$(dirname "${XCCONFIG}")"
echo "CURRENT_PROJECT_VERSION = ${FULL_BUILD}" > "${XCCONFIG}"
echo "Build number xcconfig set to ${FULL_BUILD}"
