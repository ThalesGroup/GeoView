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
		
	"Dependencies"
	self commonDependencies: spec.

	"Packages"
	self corePackages: spec.
	self moleculePackages: spec.
	
	"Groups"
    spec group: 'default' with: (#('OpenSmock' 'GeoTools'), self corePackagesNames , self moleculePackagesNames).
    spec group: 'Core' with: (#('OpenSmockCoreWithBloc' 'GeoTools'), self corePackagesNames).
]

{ #category : #dependencies }
BaselineOfGeoView >> commonDependencies: spec [
		
	"GeoTools"
	spec 
		baseline: 'GeoTools' 
		with: [	spec repository: 'github://OpenSmock/GeoTools:main' ].
			
	"OpenSmock"
	spec 
		baseline: 'OpenSmock' with: [	spec repository: 'github://OpenSmock/OpenSmock:main' ].
	
	"Enrich version of OpenSmock depending the targeted group"
	spec project: 'OpenSmockCoreWithBloc' copyFrom: 'OpenSmock' with:[ spec loads: #('CoreWithBloc') ]
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	"Core and graphical backend packages"
	spec
		package: 'GeoView'.
		
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

{ #category : #packages }
BaselineOfGeoView >> moleculePackages: spec [

	"Molecule integration packages"
	spec
		package: 'GeoView-Molecule' with:[ spec requires: #('GeoView') ].
		
	"Tests with Molecule packages"
	spec
		package: 'GeoView-Molecule-Tests' with: [ spec requires: #('GeoView-Molecule') ].
	
]

{ #category : #packages }
BaselineOfGeoView >> moleculePackagesNames [

	^ #(
	'GeoView-Molecule'
	'GeoView-Molecule-Tests'
	)

]
