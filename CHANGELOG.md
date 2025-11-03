# Changelog

All notable changes to the EEG Sleep Stage Analysis repository.

## [2.0.0] - 2025-11-03

### Major Reorganization and Documentation Update

This release represents a complete reorganization and documentation overhaul of the repository to make it more professional, maintainable, and user-friendly.

### Added
- **Comprehensive Documentation**:
  - Enhanced `README.md` with complete project overview, installation instructions, and usage examples
  - New `DATA_FORMAT.md` explaining required data structure and where to obtain public EEG datasets
  - New `FUNCTIONS.md` providing detailed reference for all functions with examples
  - Added README files in `src/` and `data/` directories
  
- **Main Pipeline Script**:
  - Created `main_pipeline.m` - a complete, well-commented script that runs the entire analysis pipeline
  - Includes progress reporting and execution timing
  - Clear step-by-step workflow with detailed comments
  
- **Function Documentation**:
  - Added comprehensive header comments to all MATLAB functions
  - Each function now includes:
    - Purpose and description
    - Input/output parameters with types
    - Usage examples
    - Implementation notes
  
- **Project Infrastructure**:
  - Added `.gitignore` to exclude temporary files, data files, and outputs
  - Created proper directory structure with `src/` and `data/` folders
  - Added `.gitkeep` in data directory

### Changed
- **Repository Structure Reorganization**:
  - Moved `Sgnal/Functions/` → `src/` (clearer naming)
  - Moved `Sgnal/data.mat` → `data/data.mat` (organized by type)
  - Renamed `Sgnal/Copy_of_exercise_2.mlx` → `original_analysis.mlx` (clearer purpose)
  - Removed `Sgnal/` directory (consolidated structure)
  
- **Improved File Organization**:
  - Separated source code from data
  - Better naming conventions throughout
  - Logical directory hierarchy

### Removed
- **PDF Papers**:
  - Removed `Sgnal/Huang2014 (1).pdf` 
  - Removed `Sgnal/CYCLIC_1 (1).PDF`
  - Added proper citations and references to README instead
  
- **Cluttered Structure**:
  - Eliminated nested `Sgnal/` directory
  - Cleaned up confusing file naming

### Scientific References Added
Added proper citations to README for the scientific methods used:
1. Huang et al. (2014) - Sleep stage identification using EEG
2. Rechtschaffen & Kales (1968) - Standard sleep stage scoring manual
3. Richman & Moorman (2000) - Sample Entropy methodology

### Migration Guide

If you have existing code using the old structure:

**Old paths** → **New paths**:
- `addpath('Sgnal/Functions')` → `addpath('src')`
- `file_name = "Sgnal/data.mat"` → `file_name = "data/data.mat"`
- Functions remain the same, only their location changed

### Breaking Changes
- Directory structure has changed
- Path references need to be updated in existing scripts
- PDF papers are no longer in the repository (references available in README)

## [1.0.0] - Initial Release

### Features
- Basic EEG sleep stage analysis pipeline
- Signal filtering and segmentation
- PSD calculation and feature extraction
- Sleep stage classification
- Hypnogram generation

---

**Note**: This project follows semantic versioning. Given the major structural changes, this is version 2.0.0.
