#!/bin/bash
set -e

# ============================================
# Linux AI CLI — .deb Package Build Script
# ============================================
# Builds in /tmp to avoid WSL/NTFS permission
# issues, then copies .deb back here.
# ============================================

PKG_NAME="linux-ai-cli"
PKG_VERSION="3.0.0"
BUILD_DIR="/tmp/${PKG_NAME}_${PKG_VERSION}"
OUTPUT_DEB="${PKG_NAME}_${PKG_VERSION}.deb"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Building ${PKG_NAME} v${PKG_VERSION} ==="

# -----------------------------------------------
# 1. Clean previous builds
# -----------------------------------------------
rm -rf "$BUILD_DIR" "/tmp/${OUTPUT_DEB}"

# -----------------------------------------------
# 2. Create directory structure
# -----------------------------------------------
mkdir -p "${BUILD_DIR}/DEBIAN"
mkdir -p "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/providers"
mkdir -p "${BUILD_DIR}/etc/linux-ai-cli"

# -----------------------------------------------
# 3. Copy DEBIAN control files + fix permissions
# -----------------------------------------------
cp "${SCRIPT_DIR}/debian/control"   "${BUILD_DIR}/DEBIAN/control"
cp "${SCRIPT_DIR}/debian/postinst"  "${BUILD_DIR}/DEBIAN/postinst"
cp "${SCRIPT_DIR}/debian/prerm"     "${BUILD_DIR}/DEBIAN/prerm"
cp "${SCRIPT_DIR}/debian/conffiles" "${BUILD_DIR}/DEBIAN/conffiles"

chmod 0755 "${BUILD_DIR}/DEBIAN"
chmod 0755 "${BUILD_DIR}/DEBIAN/postinst"
chmod 0755 "${BUILD_DIR}/DEBIAN/prerm"
chmod 0644 "${BUILD_DIR}/DEBIAN/control"
chmod 0644 "${BUILD_DIR}/DEBIAN/conffiles"

# -----------------------------------------------
# 4. Copy application files
# -----------------------------------------------

# Entry point
cp "${SCRIPT_DIR}/ai" "${BUILD_DIR}/usr/lib/linux-ai-cli/ai"
chmod +x "${BUILD_DIR}/usr/lib/linux-ai-cli/ai"

# Python package
cp "${SCRIPT_DIR}/ai_cli/__init__.py"          "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"
cp "${SCRIPT_DIR}/ai_cli/main.py"              "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"
cp "${SCRIPT_DIR}/ai_cli/commands.py"          "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"
cp "${SCRIPT_DIR}/ai_cli/provider_router.py"   "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"
cp "${SCRIPT_DIR}/ai_cli/utils.py"             "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"
cp "${SCRIPT_DIR}/ai_cli/system_inspector.py"  "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/"

# Providers
cp "${SCRIPT_DIR}/ai_cli/providers/__init__.py"        "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/providers/"
cp "${SCRIPT_DIR}/ai_cli/providers/ollama_provider.py"  "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/providers/"
cp "${SCRIPT_DIR}/ai_cli/providers/openai_provider.py"  "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/providers/"
cp "${SCRIPT_DIR}/ai_cli/providers/claude_provider.py"  "${BUILD_DIR}/usr/lib/linux-ai-cli/ai_cli/providers/"

# Config → /etc (editable by user, preserved on upgrade)
cp "${SCRIPT_DIR}/ai_cli/config.py" "${BUILD_DIR}/etc/linux-ai-cli/config.py"

# Requirements (used by postinst)
cp "${SCRIPT_DIR}/requirements.txt" "${BUILD_DIR}/usr/lib/linux-ai-cli/requirements.txt"

# -----------------------------------------------
# 5. Build the .deb package
# -----------------------------------------------
dpkg-deb --build "$BUILD_DIR" "/tmp/${OUTPUT_DEB}"

# Copy .deb back to project directory
cp "/tmp/${OUTPUT_DEB}" "${SCRIPT_DIR}/${OUTPUT_DEB}"

echo ""
echo "=== Package built: ${OUTPUT_DEB} ==="
echo ""
echo "Install:  sudo dpkg -i ${OUTPUT_DEB}"
echo "Remove:   sudo dpkg -r ${PKG_NAME}"

# -----------------------------------------------
# 6. Lint (optional, if lintian is installed)
# -----------------------------------------------
if command -v lintian &>/dev/null; then
    echo ""
    echo "=== Running lintian ==="
    lintian "${SCRIPT_DIR}/${OUTPUT_DEB}" || true
fi
