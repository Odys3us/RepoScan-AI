#!/usr/bin/env bash

set -euo pipefail

############################################
# CONFIG
############################################

REPO_URL="$1"
WORKDIR="scan_$(date +%s)"
BASE_DIR="$(pwd)/$WORKDIR"
REPO_DIR="$BASE_DIR/repo"
REPORT_DIR="$BASE_DIR/reports"

############################################
# SAFETY FIX (no unbound variables)
############################################

SUDO_USER="${SUDO_USER:-$USER}"
AI_PACK="${AI_PACK:-$REPORT_DIR/ai_summary_pack.txt}"

############################################
# CREATE WORKSPACE
############################################

echo "[+] Creating workspace: $WORKDIR"

mkdir -p "$REPO_DIR"
mkdir -p "$REPORT_DIR"

############################################
# CLONE REPO
############################################

echo "[+] Cloning repo..."

git clone --depth=1 "$REPO_URL" "$REPO_DIR" >/dev/null 2>&1 || {
    echo "[!] Git clone failed"
    exit 1
}

FILE_COUNT=$(find "$REPO_DIR" -type f | wc -l)
echo "[+] Repo files detected: $FILE_COUNT"

############################################
# GITLEAKS
############################################

echo "[+] Running Gitleaks..."

gitleaks detect \
  -s "$REPO_DIR" \
  -r "$REPORT_DIR/gitleaks.json" \
  --report-format json \
  --no-git >/dev/null 2>&1 || true

############################################
# SEMGREP
############################################

echo "[+] Running Semgrep..."

if command -v semgrep >/dev/null 2>&1; then
    semgrep scan \
      --config=auto \
      --json \
      --output "$REPORT_DIR/semgrep.json" \
      "$REPO_DIR" >/dev/null 2>&1 || true
else
    echo "[!] Semgrep not installed (skipping)"
    echo "[]" > "$REPORT_DIR/semgrep.json"
fi

############################################
# TRIVY
############################################

echo "[+] Running Trivy..."

if command -v trivy >/dev/null 2>&1; then
    trivy fs "$REPO_DIR" \
      --quiet \
      --format json \
      --output "$REPORT_DIR/trivy.json" || true
else
    echo "[!] Trivy not installed (skipping)"
    echo "[]" > "$REPORT_DIR/trivy.json"
fi

############################################
# GREP ANALYSIS
############################################

echo "[+] Running static grep analysis..."

grep -RIn --binary-files=without-match \
  "password|token|secret|api_key|csrf|auth|key" \
  "$REPO_DIR" > "$REPORT_DIR/grep.txt" || true

############################################
# AI SUMMARY PACK (FIXED + STABLE)
############################################

echo "[+] Generating AI summary pack..."

GITLEAKS_FINDINGS=$(cat "$REPORT_DIR/gitleaks.json" 2>/dev/null || echo "[]")
SEMGREP_FINDINGS=$(cat "$REPORT_DIR/semgrep.json" 2>/dev/null || echo "[]")
TRIVY_FINDINGS=$(cat "$REPORT_DIR/trivy.json" 2>/dev/null || echo "[]")
GREP_FINDINGS=$(cat "$REPORT_DIR/grep.txt" 2>/dev/null || echo "No matches")

cat > "$AI_PACK" <<EOF
==============================
AI SECURITY BRIEF (LLM READY)
==============================

REPOSITORY:
$REPO_URL

FILES SCANNED:
$FILE_COUNT

A) GITLEAKS FINDINGS
==============================
$GITLEAKS_FINDINGS

B) SEMGREP FINDINGS
==============================
$SEMGREP_FINDINGS

C) TRIVY FINDINGS
==============================
$TRIVY_FINDINGS

D) STATIC GREP FINDINGS
==============================
$GREP_FINDINGS

==============================
LLM INSTRUCTIONS
==============================
1. Identify credential exposure risks
2. Identify code execution risks
3. Identify data exfiltration paths
4. Identify exploit chains
5. Summarize severity (SAFE / LOW / MEDIUM / HIGH / CRITICAL)
6. Suggest fixes
7. Is this normal for this type of github?
8. Is this safe to use?

END OF REPORT
EOF

############################################
# FINAL OUTPUT
############################################

echo ""
echo "=============================="
echo "SCAN COMPLETE"
echo "=============================="
echo "Reports:"
echo " - $REPORT_DIR/gitleaks.json"
echo " - $REPORT_DIR/semgrep.json"
echo " - $REPORT_DIR/trivy.json"
echo " - $REPORT_DIR/grep.txt"
echo " - $AI_PACK"
echo "=============================="
