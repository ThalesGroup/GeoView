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
		
	"GeoTools"
	spec 
		baseline: 'GeoTools' 
		with: [	spec repository: 'github://OpenSmock/GeoTools:main' ].
			
	"OpenSmock Full"
	spec 
		baseline: 'OpenSmock' 
		with: [	spec repository: 'github://OpenSmock/OpenSmock:main' ]
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	"Core and graphical backend packages"
	spec
		package: 'GeoView' with:[ spec requires: #('GeoTools' 'OpenSmock') ].
		
	"Examples packages"
	spec
		package: 'GeoView-Examples' with:[ spec requires: #('GeoView') ].

	"Molecule integration packages"
	spec
		package: 'GeoView-Molecule' with:[ spec requires: #('GeoView') ].
		
	"Tests packages"
	spec
		package: 'GeoView-Tests' with: [ spec requires: #('GeoView') ].
		
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
