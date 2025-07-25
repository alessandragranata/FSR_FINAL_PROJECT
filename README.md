# FSR_FINAL_PROJECT -Field and Service Robotics 2025  
Master’s in Automation and Robotics Engineering  
Lidia Marotta & Alessandra Granata

This repository contains the Simulink models and MATLAB scripts developed for the final project of the *Field and Service Robotics* course (academic year 2025). The project focuses on the simulation and evaluation of different control strategies for a quadrotor UAV (QUAV) following a predefined trajectory.

## Repository Structure

###  Control Implementations

- `geometric_control.slx`  
  Contains two geometric control schemes for the quadrotor:  
  - One with ground effect compensation  
  - One without ground effect

- `hierarchical_control.slx`  
  Implements a hierarchical control strategy for the UAV trajectory tracking.

- `passivity_control.slx`  
  Implements a passivity-based control method, applied to the same trajectory used in the hierarchical control.

- `passivity_control_estimator.slx`  
  Extends the passivity-based controller by incorporating a state estimator, maintaining the same reference trajectory.

###  Animation Scripts

- `animationhierarchical.m`  
  Animates and exports the trajectory followed under hierarchical control.

- `animationpassivity.m`  
  Animates and exports the trajectory followed under passivity-based control.

- `animationpassivityestimator.m`  
  Animates and exports the trajectory followed under passivity-based control with estimator.

Each script generates and optionally saves a video visualization of the drone’s behavior.

###  Utility and Support Files

- `filtro.m`  
  Contains the filter used for the *filter and derivative* blocks in the Simulink controllers. The filter logic has been embedded directly into the InitFcn of each Simulink model where necessary.

- Plotting Scripts  
  MATLAB scripts used to generate and save plots for analysis and comparison of the different control methods. Output figures are saved in dedicated folders within the repository.

##  Project Summary

This project explores and compares three main control strategies for UAV flight:

- Geometric Control (with and without ground effect)
- Hierarchical Control
- Passivity-Based Control (with and without estimator)


## Requirements

- MATLAB R2023b or later  
- Simulink  


## How to Use

1. Open the desired .slx Simulink model.
2. Run the simulation to observe the behavior.
3. Use the corresponding animation*.m script to visualize or export the trajectory animation.
4. Run the plotting scripts to generate performance plots.

---
