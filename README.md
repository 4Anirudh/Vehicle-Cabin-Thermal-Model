# Vehicle Cabin Thermal Model

A MATLAB-based lumped-parameter thermal model for simulating transient temperature evolution inside a parked vehicle cabin under solar heat-soak conditions.

The model represents major vehicle components as interconnected thermal nodes and accounts for solar radiation, conduction, convection, long-wave radiation, ambient conditions, ventilation, and phase change material (PCM) thermal storage.

The project is intended as a modular framework for studying vehicle cabin heating and evaluating passive and active thermal-management strategies.

---

## Overview

Vehicle cabins can reach significantly higher temperatures than the surrounding ambient air when exposed to solar radiation. This model simulates the transient thermal behaviour of the cabin by solving coupled energy balances for individual vehicle components.

The model uses a lumped-parameter approach in which each major component is represented by a thermal node with defined properties such as:

- Surface area
- Mass
- Specific heat capacity
- Solar absorptivity
- Thermal emissivity
- Thermal resistance
- Convective heat-transfer coefficients

The resulting system of coupled ordinary differential equations is solved numerically in MATLAB.

---

## Heat Transfer Mechanisms

The model considers the major heat-transfer mechanisms responsible for vehicle cabin heating.

### Solar Heat Transfer

Solar radiation is absorbed by exposed vehicle surfaces and can also enter the cabin through glazing.

Solar irradiance can be represented using either predefined conditions or weather-based inputs.

Relevant calculations are handled primarily by:

- `SolarIntensity.m`
- `SolarHeat.m`

---

### Convection

Convective heat transfer is considered between:

- Exterior vehicle surfaces and ambient air
- Interior surfaces and cabin air
- Cabin air and ventilation airflow

The model includes configurable interior convection calculations.

Relevant files include:

- `ConvectionHeat.m`
- `InteriorConvection.m`
- `VentilationHeat.m`

---

### Conduction

Heat conduction between connected material layers is calculated using thermal resistances.

This allows components consisting of multiple layers to be represented as separate thermal nodes.

The conduction calculations are handled by:

`ConductionHeat.m`

---

### Long-Wave Radiation

Interior surfaces exchange thermal radiation with other cabin surfaces.

Radiative heat transfer is calculated using surface temperatures, emissivities, and radiative relationships defined within the model.

The radiation calculations are handled by:

`RadiationHeat.m`

---

## Weather-Dependent Boundary Conditions

The model includes functionality for using weather-dependent environmental conditions instead of fixed values.

The weather module can provide time-dependent inputs such as:

- Ambient temperature
- Solar irradiance

Relevant files include:

- `LoadWeatherData.m`
- `AmbientTemperature.m`
- `SolarIntensity.m`
- `WeatherDataPreview.m`

This allows the simulation to reproduce realistic daytime heating conditions for a selected location and date.

---

## Cabin Thermal Model

The central thermal model is defined in:

`CabinODE.m`

This function calculates the energy balance for each thermal node and returns the corresponding temperature derivatives.

Conceptually, the energy balance for each node is:

\
mC_p  dT/dt=∑Q_"in" -∑Q_"out" 

The exact heat-transfer terms included depend on the component represented by the node.

MATLAB's numerical ODE solver is then used to calculate the transient temperature response of the complete cabin system.

---

## Phase Change Material Model

The project includes functionality for investigating the effect of phase change materials on cabin thermal behaviour.

PCM thermal storage is represented using an effective heat-capacity approach.

The PCM model is implemented in:

`PCMEffectiveCp.m`

During the phase-change temperature range, the effective heat capacity increases to account for latent heat storage. This allows the PCM to absorb additional thermal energy while undergoing phase transition.

The model can therefore be used to investigate parameters such as:

- PCM mass
- Phase-change temperature
- Latent heat
- Sensible heat capacity
- PCM operating temperature range

---

## Ventilation and Blower Model

Cabin ventilation is included through:

- `VentilationHeat.m`
- `BlowerControl.m`

The ventilation model represents heat removal or addition caused by air exchange between the cabin and the incoming airflow.

This allows the model to investigate scenarios involving forced cabin ventilation and different blower operating conditions.

---

## Technology Comparison

The project also contains:

`TechnologyComparison.m`

This module is intended for comparing different thermal-management technologies or parameter configurations within the cabin model.

The modular structure allows parameters such as solar absorptivity, thermal properties, and additional thermal-management technologies to be modified without changing the complete model architecture.

---

## Project Structure

```text
Vehicle-Cabin-Thermal-Model/
│
├── main.m
├── parameters.m
├── CabinODE.m
│
├── SolarHeat.m
├── SolarIntensity.m
├── AmbientTemperature.m
├── LoadWeatherData.m
├── WeatherDataPreview.m
│
├── ConductionHeat.m
├── ConvectionHeat.m
├── InteriorConvection.m
├── RadiationHeat.m
├── VentilationHeat.m
│
├── BlowerControl.m
├── PCMEffectiveCp.m
├── TechnologyComparison.m
│
└── CarCabinThermalModel.prj
