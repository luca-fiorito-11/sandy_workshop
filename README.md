
# SANDY Workshop

This repository contains materials for a hands‑on workshop focused on **neutron‑induced reaction data**, **uncertainty quantification**, and **Monte Carlo simulation workflows** using **SANDY**, **NJOY**, **OpenMC**, and related tools. It includes exercises, sample data, environment setups, and configurations for running everything fully reproducibly.

---

## 🎯 1. Purpose of the Workshop

The workshop teaches participants to:

### 🔧 Using SANDY
- Process nuclear data evaluations
- Generate random nuclear data samples
- Propagate uncertainties to integral benchmarks
- Visualize and compare evaluated nuclear data

### 🔬 Using OpenMC
- Run criticality calculations for the GODIVA benchmark
- Use sampled cross sections from SANDY
- Quantify nuclear data uncertainty effects on reactor physics

---

## 🧪 2. Exercises Overview

### **CASE 1 — GODIVA & Nuclear Data Sampling**
- Generate random samples via SANDY
- Run OpenMC with sampled cross sections
- Determine impact on \( k_	ext{eff} \)

### **CASE 2 — Cross Section sampling via the sandy API**
 - Process and extract cross sections
 - Process and extract covariance data
 - Draw random samples

### **CASE 3 — Fission Yield sampling via the sandy API**
 - Process and extract fission yields
 - Draw random samples
 - Use fission yield covariance data

---

## 🚀 3. Where to run this workshop

This repository provides a fully configured **.devcontainer** environment to ensure consistent, reproducible development across all systems.

### 🔄 Codespaces Prebuilds

A **GitHub Codespaces prebuild** is enabled. This means:
- The full environment is **prebuilt on GitHub's servers**.
- All heavy dependencies (SANDY, OpenMC, Python libs) are already installed.
- Starting a Codespace takes **seconds** instead of minutes.
- Participants avoid setup issues related to OS, compilers, or package versions.

### 🧱 What the Devcontainer Includes

The `.devcontainer/` directory configures:
- A Linux‑based environment.
- Preinstalled scientific Python stack.
- SANDY + NJOY + OpenMC ready to use.
- VS Code extensions (Python, Jupyter, YAML, etc.).
- Automatic environment activation when opening the workspace.

This ensures all users run the **exact same environment**, making exercises smooth and avoiding technical issues.

### ▶️ How to Use the Devcontainer

1. Click **Code** (top-right green or blue box) → **Open with Codespaces** → **New Codespace**.
2. Wait a few seconds for the prebuild to load.
3. Start working immediately.

---

## 📁 4. Repository Structure

```
├── .devcontainer/            # Development container for VS Code / Codespaces
├── .github/workflows/        # CI workflows for testing and automation
│
├── Exercises/
│   ├── CASE1/
│   │   ├── godiva/           # GODIVA benchmark-related SANDY datasets
│   │   ├── u234_samples/     # SANDY-generated samples
│   │
│   ├── CASE2/
│   │
│   └── CASE3/
│
└── openmc_data/
    └── jeff40_xs/            # OpenMC HDF5 cross sections based on JEFF-4.0
```

---

## 🙌 5. Credits
Developed as part of the SANDY nuclear data training workshop, originally given at PHYSOR 2026.

