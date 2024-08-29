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
		
	"GeoTools"
	spec 
		baseline: 'GeoTools' 
		with: [	spec repository: 'github://OpenSmock/GeoTools:main' ].
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	"Core and graphical backend packages"
	spec
		package: 'GeoView' with:[ spec requires: #('OpenSmock' 'GeoTools') ];
		package: 'GeoView-GeoObjects' with:[ spec requires: #('GeoView') ];
		package: 'GeoView-Bloc' with:[ spec requires: #('GeoView') ];
		package: 'GeoView-Bloc-Alexandrie' with:[ spec requires: #('GeoView-Bloc') ].
		
	"Molecule integration packages"
	spec
		package: 'GeoView-Molecule' with:[ spec requires: #('GeoView' 'GeoView-GeoObjects') ];
		package: 'GeoView-Bloc-Alexandrie-Molecule' with:[ spec requires: #('GeoView-Bloc-Alexandrie') ].
		
	"examples packages"
	spec
		package: 'GeoView-Examples' with:[ spec requires: #('GeoView' 'GeoView-GeoObjects') ];
		package: 'GeoView-Examples-Bloc' with:[ spec requires: #('GeoView-Examples') ].
		
	"examples with Molecule packages"
	spec
		package: 'GeoView-Examples-Bloc-Molecule' with:[ spec requires: #('GeoView-Molecule' 'GeoView-Bloc-Alexandrie-Molecule') ].
		
	"Tests packages"
	spec
		package: 'GeoView-Tests' with: [ spec requires: #('GeoView' 'GeoView-GeoObjects') ].
		
	"Tests with Molecule packages"
	spec
		package: 'GeoView-Molecule-Tests' with: [ spec requires: #('GeoView-Molecule') ].
	
]

{ #category : #baselines }
BaselineOfGeoView >> postload: loader package: packageSpec [

	"do nothing"
]

{ #category : #baselines }
BaselineOfGeoView >> preload: loader package: packageSpec [

	"do nothing"
]
