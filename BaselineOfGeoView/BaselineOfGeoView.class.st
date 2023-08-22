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
	spec baseline: 'OpenSmock' with: [	spec loads: #('Core'); repository: 'github://OpenSmock/OpenSmock' ].
		
	"GeoTools"
	spec baseline: 'GeoTools' with: [	spec repository: 'github://OpenSmock/GeoTools:main' ].
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	spec
		package: 'GeoView' with:[ spec requires: #('OpenSmock' 'GeoTools') ];
		package: 'GeoView-GeoObjects' with:[ spec requires: #('GeoView') ];
		package: 'GeoView-Examples' with:[ spec requires: #('GeoView' 'GeoView-GeoObjects') ].
		
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
