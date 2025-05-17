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
	self fullDependencies: spec.

	"Packages"
	self corePackages: spec.
	self fullPackages: spec.

	"Groups"
	spec group: 'default' with: #('Core' 'Full'). "complete version"
	spec group: 'Core' with: self corePackagesNames. "only core"
	spec group: 'Full' with: self fullPackagesNames. "all"
]

{ #category : #dependencies }
BaselineOfGeoView >> coreDependencies: spec [

	spec
		baseline: 'Alexandrie'
		with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:master/src' ].

	"GeoTools is loading OpenSmock core without Molecule"
	spec
		baseline: 'GeoTools'
		with: [ spec repository: 'github://OpenSmock/GeoTools:main' ]
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	"Core and graphical backend packages"
	spec
		package: 'GeoView' with:[ spec requires: #('Alexandrie' 'Bloc' 'GeoTools') ].
		
	"Examples packages"
	spec
		package: 'GeoView-Examples' with:[ spec requires: #('GeoView') ].
		
	"Tests packages"
	spec
		package: 'GeoView-Tests' with: [ spec requires: #('GeoView') ].

]

{ #category : #packages }
BaselineOfGeoView >> corePackagesNames [

	^ #(
	'GeoView'
	'GeoView-Examples'
	'GeoView-Tests'
	)

]

{ #category : #dependencies }
BaselineOfGeoView >> fullDependencies: spec [

	"OpenSmock is loading Molecule"
	spec
		baseline: 'OpenSmock'
		with: [ spec repository: 'github://OpenSmock/OpenSmock:main' ].
]

{ #category : #packages }
BaselineOfGeoView >> fullPackages: spec [

	"Molecule integration packages"
	spec
		package: 'GeoView-Molecule' with:[ spec requires: #('GeoView' 'OpenSmock') ].

	"Tests with Molecule packages"
	spec
		package: 'GeoView-Molecule-Tests' with: [ spec requires: #('GeoView-Molecule') ].
	
]

{ #category : #packages }
BaselineOfGeoView >> fullPackagesNames [

	^ #(
	'GeoView-Molecule'
	'GeoView-Molecule-Tests'
	)

]

{ #category : #baselines }
BaselineOfGeoView >> postload: loader package: packageSpec [

	"do nothing"
]

{ #category : #baselines }
BaselineOfGeoView >> preload: loader package: packageSpec [

	"do nothing"
]
