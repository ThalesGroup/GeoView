[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 13](https://img.shields.io/badge/Pharo-13-%23aac9ff.svg)](https://pharo.org/download)

[![License](https://img.shields.io/github/license/ThalesGroup/GeoView.svg)](./LICENSE)
[![Unit tests](https://github.com/ThalesGroup/GeoView/actions/workflows/CI.yml/badge.svg)](https://github.com/ThalesGroup/GeoView/actions/workflows/CI.yml)

# GeoView

![image](https://github.com/user-attachments/assets/81bdfd1b-23ce-46d4-bbf1-670f5142cfc8)

GeoView is a library for displaying and interacting with geographical objects and cartographic layers in a user interface.

GeoView’s architecture is designed to support multiple graphics backends. Currently, the default and only supported backend is Bloc, using the Alexandrie library.
Thanks to its integration with Bloc, GeoView also works within Toplo UI views.

## 🔧 Key Architectural Features

- **Graphics backend agnostic**  
  GeoView is designed to be independent of any specific graphics backend. The default implementation uses **Bloc/Alexandrie**.

- **Multiple levels of user-facing APIs**  
  GeoView provides several API layers to suit different abstraction levels:
  - **High-level API**  
    Work directly with geographic data using real-world units like latitude/longitude and meters.
  - **Intermediate-level API**  
    Provides access to cartesian coordinates (`x`, `y`, `z`) for spatial logic and control.
  - **Low-level API**  
    Works in display/device coordinates (pixels, points), ideal for low-level rendering customization.

- **Fully customizable rendering**  
  Visual appearance is completely decoupled from rendering technology, allowing flexible styling.

## 🧩 Built-in Geographic Components

GeoView includes a library of ready-to-use geographic objects, such as:
- Circles
- Lines
- Points
- Polygons
- Labels
- And more (non-exhaustive list)

These built-in components are designed to cover common geospatial visualization needs and can be extended or customized.

In addition, GeoView provides a **layer-based system** to organize and manage rendering. Layers are a flexible mechanism that:
- Allow grouping of any kind of geographic or custom object
- Control visibility, rendering order, and interactions independently
- Are not limited to built-in objects — you can use layers for custom components or specialized rendering logic
- Support splitting the rendering of a single object type across multiple layers  
  _(e.g., you can render position icons in one layer and their corresponding labels in another, to better manage z-order or interaction logic)_

This approach gives developers fine-grained control over how geographical content is displayed and interacted with.

## ✨ Others features

- **Simplified symbology management**  
  Define and apply visual styles (e.g., color, icons) to geographic objects easily and consistently.

- **Support for multiple map projections**  
  Allows working with different geographic projections.  
  _Note: The map data provider must support the selected projection._

- **Picking API**  
  Enable object selection and interaction through pointer events.

- **Optional integration with Molecule**  
  Seamlessly plug into the Molecule component framework if desired.

## 📦 Status

GeoView is in active development but already powers many UI applications and prototypes involving geospatial data.

---

## Prerequisites

Make sure your Bloc backend uses Alexandrie, as other backends are not yet supported.

## Getting Started

### Full version installation

To install **GeoView** with all features and dependencies, simply execute the following script in your Pharo image:

```smalltalk
Metacello new
   baseline: 'GeoView';
   repository: 'github://ThalesGroup/GeoView:main/src';
   load.
```

### Minimal version (Core) installation

If you prefer to install only the core version of GeoView (without Molecule component framework integration), use the following script:

```smalltalk
Metacello new
   baseline: 'GeoView';
   repository: 'github://ThalesGroup/GeoView:main/src';
   load: 'Core'.
```

## Dependencies

Core : 

- [Alexandrie](https://github.com/pharo-graphics/alexandrie)
- [Bloc](https://github.com/pharo-graphics/bloc)
- [OpenSmock(Core)](https://github.com/OpenSmock/OpenSmock)
- [GeoTools](https://github.com/ThalesGroup/GeoTools)
- [PharoOWS](https://github.com/ThalesGroup/PharoOWS)

Default/Full adding :

- [Molecule](https://github.com/OpenSmock/Molecule)
- [OpenSmock](https://github.com/OpenSmock/OpenSmock)

Note: Bloc and Alexandrie will soon be integrated into Pharo, at which point this dependency will be removed.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
