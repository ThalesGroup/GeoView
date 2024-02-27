Class {
	#name : #BaselineOfGeoView,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeoView
}

{ #category : #baselines }
BaselineOfGeoView >> baseline: spec [

	<baseline>
	"Common baseline for all Pharo versions"
	spec for: #common do: [ self baselineForCommon: spec ]
]

{ #category : #baselines }
BaselineOfGeoView >> baselineForCommon: spec [
	<baseline>
	
	spec preLoadDoIt: #'preload:package:'.
	spec postLoadDoIt: #'postload:package:'.
		
	"Dependencies"
	self coreDependencies: spec.

	"Packages"
	self corePackages: spec

]

{ #category : #dependencies }
BaselineOfGeoView >> coreDependencies: spec [

	"OpenSmock core workshop"
	spec 
		baseline: 'OpenSmock' 
		with: [	spec repository: 'github://OpenSmock/OpenSmock' ].

	"Bloc"
	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:master/src' ].
		
	"GeoTools"
	spec 
		baseline: 'GeoTools' 
		with: [	spec repository: 'github://OpenSmock/GeoTools:main' ].
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	spec
		package: 'GeoView' with:[ spec requires: #('OpenSmock' 'GeoTools') ];
		package: 'GeoView-GeoObjects' with:[ spec requires: #('GeoView') ];
		package: 'GeoView-Bloc' with:[ spec requires: #('GeoView' 'Bloc') ];
		package: 'GeoView-Bloc-Alexandrie' with:[ spec requires: #('GeoView-Bloc') ].
		
	"examples packages"
	spec
		package: 'GeoView-Examples' with:[ spec requires: #('GeoView' 'GeoView-GeoObjects') ];
		package: 'GeoView-Examples-Bloc' with:[ spec requires: #('GeoView-Examples') ].
		
	"Tests packages"
	spec
		package: 'GeoView-Tests' with: [ spec requires: #('GeoView' 'GeoView-GeoObjects') ].
]

{ #category : #baselines }
BaselineOfGeoView >> postload: loader package: packageSpec [

	"do nothing"
]

{ #category : #baselines }
BaselineOfGeoView >> preload: loader package: packageSpec [

	"do nothing"
]
