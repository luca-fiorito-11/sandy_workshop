
# SANDY Workshop

This repository contains materials for a hands‑on workshop focused on **neutron‑induced reaction data**, **uncertainty quantification**, and **Monte Carlo simulation workflows** using **SANDY**, **NJOY**, **OpenMC**, and related tools. It includes exercises, sample data, environment setups, and configurations for running everything fully reproducibly.

---

## 📁 Repository Structure

```
├── .devcontainer/            # Development container for VS Code / Codespaces
├── .github/workflows/        # CI workflows for testing and automation
│
├── binder/                   # Lightweight Binder environment (small datasets)
├── binder_heavy/             # Heavy Binder env with large datasets & OpenMC data
│
├── Exercises/
│   ├── CASE1/
│   │   ├── godiva/           # GODIVA benchmark-related SANDY datasets
│   │   │   ├── u235_alldata/
│   │   │   ├── u235_fiss_capt/
│   │   │   ├── u235_nubar/
│   │   │   └── u235_pfns/
│   │   ├── u234_samples/     # SANDY-generated samples
│   │   └── u235_samples/
│   │
│   ├── CASE2/
│   │
│   └── CASE3/
│
└── openmc_data/
    └── jeff40_xs/            # OpenMC HDF5 cross sections based on JEFF-4.0
```

---

## 🚀 Development Container & Codespaces Support

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

1. Click **Code** (top-right green box) → **Open with Codespaces** → **New Codespace**.
2. Wait a few seconds for the prebuild to load.
3. Start working immediately.


---

## 🎯 Purpose of the Workshop

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

### 📓 Through Jupyter Notebooks
- Load and explore nuclear data
- Use the SANDY API
- Run Monte Carlo uncertainty propagation
- Plot and interpret outputs

---

## 📦 Data Included

### 🔹 JEFF‑4.0 Cross Sections
Preprocessed into OpenMC‑compatible HDF5 format:
```
openmc_data/jeff40_xs/
```
Only U-234, U-25 and U-238 are available, being the only data needed to run GODIVA.

### 🔹 SANDY Sample Libraries
Pregenerated random samples for:
- U‑235

### 🔹 GODIVA Benchmark Inputs
Reference data and SANDY datasets used in CASE1.

---

## 🧪 Exercises Overview

### **CASE 1 — GODIVA & U‑235 Nuclear Data Sampling**
- Explore U‑235 evaluated data
- Generate random samples via SANDY
- Run OpenMC with sampled cross sections
- Determine impact on \( k_	ext{eff} \)

### **CASE 2 — (extension slot)**
Notebook skeleton available.

### **CASE 3 — (extension slot)**
For optional sensitivity or additional benchmark studies.

---

## 🙌 Credits
Developed as part of the SANDY nuclear data training workshop, originally given at PHYSOR 2026.

