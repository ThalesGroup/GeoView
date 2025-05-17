[![Pharo 11](https://img.shields.io/badge/Pharo-11-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 12](https://img.shields.io/badge/Pharo-12-%23aac9ff.svg)](https://pharo.org/download)
[![Pharo 13](https://img.shields.io/badge/Pharo-13-%23aac9ff.svg)](https://pharo.org/download)

[![License](https://img.shields.io/github/license/OpenSmock/GeoView.svg)](./LICENSE)
[![Unit tests](https://github.com/OpenSmock/GeoView/actions/workflows/CI.yml/badge.svg)](https://github.com/OpenSmock/GeoView/actions/workflows/CI.yml)

# GeoView

![image](https://github.com/user-attachments/assets/81bdfd1b-23ce-46d4-bbf1-670f5142cfc8)

Views to display and interact with geographical objects and cartographic layers for UI.

GeoView is build to be implemented and available in different display backends, for examples in Bloc, Alexandrie, Woden, Web-based UI, etc.

Actually there is an experimental Bloc backend. 
This backend was made for developping GeoView and have a basic display, but this backend is too high level. 
We are working now on a full Alexandrie canvas for better performances. 
This canvas can be wrapped into a Bloc element for display on a Bloc/Toplo application.

### Latest version

To install GeoView on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'GeoView';
   repository: 'github://OpenSmock/GeoView:main/src';
   load.
```

## Dependencies

- [OpenSmock](https://github.com/OpenSmock/OpenSmock)
- [GeoTools](https://github.com/OpenSmock/GeoTools)
- [Molecule](https://github.com/OpenSmock/Molecule)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
