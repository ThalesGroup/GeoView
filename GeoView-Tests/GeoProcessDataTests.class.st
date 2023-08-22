Class {
	#name : #GeoProcessDataTests,
	#superclass : #TestCase,
	#category : #'GeoView-Tests-Cases - ProcessData'
}

{ #category : #tests }
GeoProcessDataTests >> testConstructor [

	| processData |
	processData := GeoProcessData processor: nil.
	 
	self assert: processData processor equals: nil.
]

{ #category : #tests }
GeoProcessDataTests >> testInitialize [

	| processData |
	processData := GeoProcessData new.
	
	self assert: processData processor equals: nil.
	self assert: processData properties isEmpty.
]

{ #category : #tests }
GeoProcessDataTests >> testProperties [

	| processData |
	processData := GeoProcessData new.
	
	processData setProperty: #propertyA value: 1.
	processData setProperty: #propertyB value: #value.
	processData setProperty: #propertyC value: true.
	
	self assert: processData properties size equals: 3.
	self assert: (processData getProperty: #propertyA) equals: 1.
	self assert: (processData getProperty: #propertyB) equals: #value.
	self assert: (processData getProperty: #propertyC) equals: true.
	self assert: (processData getProperty: #propertyD) equals: nil.
	self assert: (processData isPropertyExist: #propertyA) equals: true.
	self assert: (processData isPropertyExist: #propertyB) equals: true.
	self assert: (processData isPropertyExist: #propertyC) equals: true.
	self assert: (processData isPropertyExist: #propertyD) equals: false.
	
	processData setProperty: #propertyA value: 2.

	self assert: processData properties size equals: 3.
	self assert: (processData getProperty: #propertyA) equals: 2.
	self assert: (processData getProperty: #propertyB) equals: #value.
	self assert: (processData getProperty: #propertyC) equals: true.
	self assert: (processData getProperty: #propertyD) equals: nil.
	self assert: (processData isPropertyExist: #propertyA) equals: true.
	self assert: (processData isPropertyExist: #propertyB) equals: true.
	self assert: (processData isPropertyExist: #propertyC) equals: true.
	self assert: (processData isPropertyExist: #propertyD) equals: false.
	
	processData removeProperty: #propertyB.
	
	self assert: processData properties size equals: 2.
	self assert: (processData getProperty: #propertyA) equals: 2.
	self assert: (processData getProperty: #propertyB) equals: nil.
	self assert: (processData getProperty: #propertyC) equals: true.
	self assert: (processData getProperty: #propertyD) equals: nil.
	self assert: (processData isPropertyExist: #propertyA) equals: true.
	self assert: (processData isPropertyExist: #propertyB) equals: false.
	self assert: (processData isPropertyExist: #propertyC) equals: true.
	self assert: (processData isPropertyExist: #propertyD) equals: false.
]
