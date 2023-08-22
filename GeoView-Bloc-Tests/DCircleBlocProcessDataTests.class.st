"
A ProcessDCircleBlocTest is a test class for testing the behavior of ProcessDCircleBloc
"
Class {
	#name : #DCircleBlocProcessDataTests,
	#superclass : #GeoAbstractDShapeBlocProcessDataTests,
	#category : #'GeoView-Bloc-Tests-Cases - ProcessData'
}

{ #category : #running }
DCircleBlocProcessDataTests >> dShape [

	^ DCircle new
		key: 1;
		radius: 25;
		fillColor: Color red;
		yourself.
]

{ #category : #running }
DCircleBlocProcessDataTests >> processData [

	^ DCircleBlocProcessData 
]

{ #category : #tests }
DCircleBlocProcessDataTests >> testProcessCUDDataIncomingWithContext [
	| blElement dCircle |
	dCircle := self dShape. 
	blElement := process processCreatedData: dCircle key incoming: dCircle with: nil context: nil.
	self assert: blElement background paint color equals: Color red.
	self assert: blElement geometry class equals: BlCircleGeometry .
	
	dCircle fillColor: Color blue.
	blElement := process processUpdatedData: dCircle key incoming: dCircle with: blElement context: nil.
	self assert: blElement background paint color equals: Color blue.
	self assert: blElement geometry class equals: BlCircleGeometry.
		
	blElement := process processDeletedData: dCircle key incoming: dCircle with: blElement context: nil.
	self assert: blElement notNil.
]
