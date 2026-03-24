
# CASE1 – Sampling Workflow (U‑234 and GODIVA Model)

This folder contains two complete sequences:
1. **U‑234 nuclear data sampling** using SANDY and OpenMC
2. **GODIVA criticality model sampling** using OpenMC with perturbed nuclear data

Folder structure:
```
Exercise/CASE1/
├── u234_samples/          # U‑234 sampling workflow
├── godiva/                # GODIVA model and sampling workflow
└── README.md
```

---
## 1. U‑234 Sampling Workflow
Located in: `Exercise/CASE1/u234_samples/`

This workflow generates, converts, and analyzes 20 perturbed U‑234 nuclear data samples.

### 1.1 Sample Generation
Script: `get_samples.sh`
- Uses SANDY to generate perturbed ENDF6, PENDF, and ACE files.
- Temperature: 293.15 K
- Output folders: `ACEFILES/`, `ENDF6/`, `PENDF/`

### 1.2 ACE → HDF5 Conversion
Script: `get_h5file.sh`
- Converts ACE files to HDF5 using `openmc-ace-to-hdf5`.
- Produces: `H5FILES/` containing `U234_*.h5`
- Generates sample‑specific `cross_sections_*.xml`

### 1.3 Post‑Processing
Notebook: `xs_samples_analysis.ipynb`
- Computes means, standard deviations
- Visualizes reaction‑dependent variations

---
## 2. GODIVA Criticality Sampling Workflow
Located in: `Exercise/CASE1/godiva/`

This workflow runs a series of GODIVA criticality calculations for perturbed nuclear data.

### 2.1 Model Definition
Notebook: `create_godiva_model.ipynb`

Model input files:
- `geometry.xml`
- `materials.xml`
- `settings_template.xml`
- `settings.xml`

These files define geometry, materials, and OpenMC settings for the GODIVA configuration.

### 2.2 Running the GODIVA Samples
Script: `run_samples_godiva.sh`
- Runs 20 Monte Carlo simulations (default)
- Each sample uses its own `cross_sections_*.xml`
- A unique random seed is applied per sample
- Each run produces `statepoint.100_*.h5`

### 2.3 Pre‑generated GODIVA Sample Sets
These folders contain prepared OpenMC sample outputs for additional U‑235 uncertainties:
```
u235_fiss_capt/   # Fission + capture samples
u235_nubar/       # nubar samples
u235_alldata/     # all nuclear data varied
u235_pfns/        # prompt fission neutron spectra samples
```

### 2.4 Post‑Processing of GODIVA Outputs
Notebook: `post_processing_godiva_samples.ipynb`
- Loads all statepoint files pregenerated from U-235 uncertainties
- Computes k‑eff distributions
- Produces statistical summaries and plots

---
## 3. Quick Start

### U‑234 workflow
```
cd u234_samples
bash get_samples.sh
bash get_h5file.sh
jupyter lab
```

### GODIVA workflow
```
cd godiva
bash run_samples_godiva.sh
jupyter lab
```

---
## Purpose
These workflows support:
- Nuclear data uncertainty propagation
- Criticality safety analysis
- Benchmark training and demonstration
