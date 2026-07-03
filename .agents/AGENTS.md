# Agents.md — HelixScale: Hybrid HPC Platform

## Project Identity
**Name:** HelixScale — Hybrid HPC Platform
**Type:** Production-grade portfolio project demonstrating full-stack HPC platform engineering
**Goal:** Prove ability to design, automate, and operate GPU-accelerated HPC infrastructure for computational biology workloads (BioNeMo-class)

## Architecture Philosophy

| Tier | Environment | GPU | Scheduler | Infra |
|------|-------------|-----|-----------|-------|
| Local | node1 apple silicon 64GB (M-series) and node2 apple silicon 36GB | Simulated (CPU fallback) | Mini-Slurm (orbstack) | Docker Compose + UV |
| Cloud | AWS GPU instances | Real (A100/H100) | slinky or K8s | Terraform-provisioned |
| HPC Cluster | On-prem or cloud HPC | Real (multi-node) | slinky | Ansible-configured |

## Tech Stack

### Core Languages
- **Python 3.11+**: Primary language for orchestration, API, and computational workflows.
- **Bash**: Shell scripting for automation and CI/CD wrappers.
- **HCL (HashiCorp Configuration Language)**: Infrastructure as Code (Terraform).
- **YAML**: Configuration for Ansible, Kubernetes, and CI/CD.

### Infrastructure & Orchestration
- **Docker & Docker Compose**: Containerization and local T0 tier execution.
- **Apptainer (Singularity)**: HPC-native container workload execution.
- **Terraform**: Cloud infrastructure provisioning (AWS GPU instances).
- **Ansible**: Configuration management and HPC cluster setup.
- **Helm**: Kubernetes package manager for deploying platform services.
- **Slurm**: HPC workload scheduling.
- **Kubernetes (K8s)**: Cloud-native orchestration (optional tier).

### GPU & Compute
- **NVIDIA CUDA Ecosystem**: Base GPU acceleration.
- **PyTorch / BioNeMo**: Deep learning and computational biology frameworks.
- **Ray**: Distributed computing for scaling ML workloads.

### DevOps & CI/CD
- **Make**: Task automation (GNU Make).
- **GitHub Actions**: Continuous integration and deployment workflows.
- **pre-commit**: Git hook scripts to enforce code quality.

### Monitoring & Observability
- **Prometheus & Grafana**: Metrics collection and dashboarding.
- **ELK / Loki**: Log aggregation and analysis.
- **Weights & Biases (W&B) / MLflow**: ML experiment tracking.

### Python Toolchain
- **uv**: Extremely fast Python package installer and resolver.
- **FastAPI & Pydantic**: API development and data validation.
- **Typer**: CLI application framework.
- **pytest**: Testing framework.
- **Ruff**: Fast Python linter and code formatter.

## Directory Structure

```text
HelixScale/
├── .agents/                 # Agent rules and customizations
├── .github/                 # CI/CD workflows
├── docs/                    # Architecture and tradeoff documentation
├── infrastructure/          # Infrastructure as Code
│   ├── terraform/           # Terraform modules and environments (AWS)
│   ├── ansible/             # Ansible playbooks and roles (HPC)
│   └── helm/                # Helm charts for Kubernetes deployments
├── src/                     # Core application source code
│   ├── api/                 # API endpoints and routers (FastAPI)
│   ├── cli/                 # Command-line interface (Typer)
│   ├── core/                # Core orchestration and compute logic
│   ├── db/                  # Database models and adapters
│   ├── jobs/                # Slurm/SGE job submission templates
│   └── utils/               # Shared utilities
├── tests/                   # Unit and integration tests
├── scripts/                 # Utility shell scripts
├── docker-compose.yml       # Local T0 environment definition
├── Makefile                 # Automation targets
├── pyproject.toml           # Python dependencies (uv)
└── README.md                # Project entrypoint
```

## Coding Conventions

- Type hints on all function signatures
- Google-style docstrings (brief)
- Never swallow exceptions; log + re-raise or handle
- Pydantic Settings for config; tier-aware defaults
- Typer CLI with `--dry-run` on every destructive command
- Secrets via env vars or cloud secret managers only
- All IaC must be idempotent and re-runnable
- Unit tests mock externals; integration tests use T0 Docker stack

# Agent Rules

## Unified Project Structure
- **No Phase-Based Documentation**: Do not organize documentation, tasks, or folders by "phases" (e.g., Phase 1, Phase 2).
- **Wholesome Unit**: Treat the project as a single, unified, wholesome unit. Organize directories and documentation functionally (e.g., core, api, db, infrastructure, environment) rather than chronologically or incrementally.
- Check which tier (T0/T1/T2) every change affects
-  Run `make lint` before committing
- Use `--dry-run` on Terraform plans and Ansible runs
- Document tradeoffs in `docs/tradeoffs.md`
- Pin all container image versions; never `:latest`
- GPU code paths always have CPU fallback with clear logging
