# RepoScan-AI

# 🔍 RepoScan AI — Automated Security Scanner for Git Repositories
RepoScan AI is a unified security scanning framework that automatically analyzes GitHub repositories for:

- 🔐 Hardcoded secrets & exposed credentials (Gitleaks)
- 🧠 Code vulnerabilities (Semgrep)
- 🛡️ Dependency & CVE analysis (Trivy)
- 🔎 Custom regex-based sensitive data discovery (grep engine)
- 🤖 AI-ready structured security reporting (LLM summary pack)

It is designed for:
- Security engineers
- SOC analysts
- DevSecOps pipelines
- OSINT / CTF workflows
- LLM-based security automation

---

# ⚙️ Features

## Core Capabilities

- 📥 Automatic GitHub repository cloning
- 🔐 Secret detection using Gitleaks
- 🧠 Static Application Security Testing (SAST) via Semgrep
- 🛡️ Vulnerability scanning with Trivy
- 🔎 Custom pattern scanning for:
  - passwords
  - tokens
  - API keys
  - CSRF/XSRF values
- 📊 Unified multi-tool reporting
- 🤖 AI-ready structured output (LLM Security Brief)

---

# 📦 Output Structure
Each scan creates a timestamped workspace:


scan_<timestamp>/
├── repo/ # Cloned repository

├── reports/

│ ├── gitleaks.json # Secret scanning results

│ ├── semgrep.json # Code security findings

│ ├── trivy.json # Vulnerabilities (dependencies/OS)

│ ├── grep.txt # Raw pattern matches

│ └── ai_summary_pack.txt # LLM-ready security brief


---

# 🚀 Installation

## 1. Clone this tool


git clone https://github.com/Odys3us/RepoScan-AI.git
cd repo-scan-ai
chmod +x repo_scan.sh
2. Install dependencies

🔐 Gitleaks
brew install gitleaks
# OR
sudo apt install gitleaks

🧠 Semgrep
pip install semgrep

🛡️ Trivy
brew install trivy
# OR
sudo apt install trivy

🧰 Git (required)
sudo apt install git


▶️ Usage
Run a scan against any GitHub repository:

./repo_scan.sh https://github.com/owner/repository.git

Example:

./repo_scan.sh https://github.com/h1lw/xsint.git

---

🧠 AI Summary Output
After execution, the tool generates:

reports/ai_summary_pack.txt

This file is optimized for LLMs and contains:

All security findings (normalized)
Categorized vulnerabilities
Secret exposure detection
Code execution risks
Dependency vulnerabilities
Static grep matches

---

📊 AI Security Brief Format

Example structure:


AI SECURITY BRIEF

REPOSITORY:
<repo url>

FILES SCANNED:
<number>

A) SECRET LEAKS (GITLEAKS)
- API keys
- tokens
- credentials

B) CODE VULNERABILITIES (SEMGREP)
- unsafe imports
- insecure crypto
- injection risks

C) DEPENDENCY RISKS (TRIVY)
- CVEs
- vulnerable packages

D) STATIC PATTERNS (GREP)
- passwords
- auth tokens

LLM TASK
==============================
1. Identify credential exposure risks
2. Identify code execution risks
3. Identify data exfiltration paths
4. Map exploit chains
5. Rate severity (SAFE → CRITICAL)
6. Suggest remediation steps
==============================


🧪 What It Detects
🔐 Secrets & Credentials
API keys (AWS, GCP, custom services)
GitHub tokens
Passwords in source code
CSRF/XSRF tokens
Session cookies
🧠 Code Risks
Dynamic imports (importlib.import_module)
Unsafe URL handling (urllib misuse)
Insecure cryptography (SHA1, MD5)
Injection-prone patterns
🛡️ Supply Chain Risks
Known CVEs in dependencies
Vulnerable OS packages
Outdated libraries
🧩 Configuration
Optional environment variables
export AI_PACK="custom_output_path.txt"

Default:

scan_<timestamp>/reports/ai_summary_pack.txt


⚠️ Safety & Legal Notice
This tool is intended ONLY for:

Authorized security testing
Educational purposes
Defensive cybersecurity analysis
Bug bounty workflows (with permission)



❌ Do NOT scan repositories you do not have permission to analyze.

The author is not responsible for misuse.


---

🧠 Design Philosophy
RepoScan AI is built around:

🔁 Automation over manual review
🧠 LLM-first reporting structure
⚡ Fast triage of large codebases
🧩 Multi-tool correlation (not single-signal detection)



---

🛠️ Roadmap
Planned improvements:

 Web dashboard (SOC-style UI)
 AI auto-risk scoring engine
 Exploit chain graph builder
 GitHub Action integration
 Dockerized deployment
 Slack/Discord alerts
 Incremental diff scanning (PR-based)
📌 Example Use Cases
Security review of open-source dependencies
OSINT reconnaissance workflows
CTF and red-team tooling
DevSecOps CI/CD integration
Automated bug bounty pre-scan
LLM-powered security auditing pipelines


👤 Author

Built for cybersecurity automation, OSINT workflows, and AI-assisted vulnerability analysis.




⭐ License

MIT License — free to use, modify, and extend.


If you want next-level upgrades, I can help you turn this into:

- 🔥 GitHub Action (auto scan every PR)
- 🌐 Web SOC dashboard (dark mode + graphs)
- 🤖 AI agent that explains vulnerabilities automatically
- 📦 Dockerized one-command scanner
- ⚡ “bug bounty mode” with exploit prioritization

Just tell me.
