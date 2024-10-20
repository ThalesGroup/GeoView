Class {
	#name : #GeoViewTaskHandler,
	#superclass : #Object,
	#instVars : [
		'handler'
	],
	#category : #'GeoView-Core'
}

{ #category : #'API -- tasks' }
GeoViewTaskHandler >> enqueueTaskAndRequestRepaint: aBlockClosure [

	| task action |
	aBlockClosure ifNil: [ ^ self ].
	aBlockClosure isBlock ifFalse: [ ^ self ].

	"wrap the block into another one to refresh the view"
	action := [
	          aBlockClosure value.
	          self handler requestRepaint ].

	task := BlTaskAction new.
	task action: action.
	self handler enqueueTask: task
]

{ #category : #accessing }
GeoViewTaskHandler >> handler [

	^ handler
]

{ #category : #accessing }
GeoViewTaskHandler >> handler: anObject [

	handler := anObject
]
