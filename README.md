[![License](https://img.shields.io/github/license/openSmock/GeoView.svg)](./LICENSE)

# GeoView

Views to display and interact with geographical objects and cartographic layers for UI.

GeoView is build to be implemented and available in different display backends, for examples in Bloc, Alexandrie, Woden, Web-based UI, etc.

Actually there is an experimental Bloc backend. This backend was made for developping GeoView and have a basic display, but this backend is too high level. We are working now on a full Alexandrie canvas for better performances. This canvas can be wrapped into a Bloc element for display on a Bloc/Toplo application.

## Installation

To install GeoView on your Pharo image you can just execute the following script:

```smalltalk
Metacello new
   baseline: 'GeoView';
   repository: 'github://OpenSmock/GeoView:main';
   load.
```

## Dependencies

- [OpenSmock core packages and dependencies](https://github.com/OpenSmock/OpenSmock)
- [GeoTools](https://github.com/OpenSmock/GeoTools)
