Class {
	#name : #BaselineOfGeoView,
	#superclass : #BaselineOf,
	#category : #BaselineOfGeoView
}

{ #category : #baselines }
BaselineOfGeoView >> baseline: spec [
	"Common baseline for all Pharo versions"

	<baseline>
	spec for: #common do: [ self baselineForCommon: spec ].

	"Need to load Alexandrie and Bloc packages of OpenSmock"
	spec for: 'Core' do: [ self baselineForCore: spec ].

	"OpenSmock is loading Molecule"
	spec for: 'Full' do: [ self baselineForFull: spec ]
]

{ #category : #baselines }
BaselineOfGeoView >> baselineForCommon: spec [
	<baseline>
	
	spec preLoadDoIt: #'preload:package:'.
	spec postLoadDoIt: #'postload:package:'.
	
	"Packages"
	self corePackages: spec.
	self fullPackages: spec.

	"Groups"
	spec group: 'default' with: #('Core' 'Full'). "complete version"
	spec group: 'Core' with: self corePackagesNames. "only core"
	spec group: 'Full' with: self fullPackagesNames. "all"
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

	spec
		baseline: 'Alexandrie'
		with: [ spec repository: 'github://pharo-graphics/Alexandrie:master/src' ].

	spec
		baseline: 'Bloc'
		with: [ spec repository: 'github://pharo-graphics/Bloc:master/src' ].

	"GeoTools is loading OpenSmock core without Molecule"
	spec
		baseline: 'GeoTools'
		with: [ spec repository: 'github://OpenSmock/GeoTools:main' ].
]

{ #category : #packages }
BaselineOfGeoView >> corePackages: spec [

	"Core and graphical backend packages"
	spec
		package: 'GeoView' with:[ spec requires: #('Alexandrie' 'Bloc' 'GeoTools' 'OpenSmock') ].
		
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
