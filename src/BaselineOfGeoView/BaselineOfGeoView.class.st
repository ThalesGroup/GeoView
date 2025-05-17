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

{ #category : #baselines }
BaselineOfGeoView >> baselineForCore: spec [
	<baseline>
	
	self coreDependencies: spec.
	
	spec 
   			project: 'OpenSmock'
  			with: [
        		spec
            		className: 'BaselineOfOpenSmock';
            		repository: 'github://OpenSmock/OpenSmock:main/src';
            		loads: #('OpenSmock-Alexandrie' 'OpenSmock-Bloc' 'OpenSmock-Bloc-Alexandrie') ]
]

{ #category : #baselines }
BaselineOfGeoView >> baselineForFull: spec [
	<baseline>
	
	self fullDependencies: spec.	

	spec
			baseline: 'OpenSmock'
			with: [ spec repository: 'github://OpenSmock/OpenSmock:main/src' ]
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
