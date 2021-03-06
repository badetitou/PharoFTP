Class {
	#name : #FTPNlstCommand,
	#superclass : #FTPListingCommand,
	#category : 'FTP-Command'
}

{ #category : #accessing }
FTPNlstCommand class >> command [
	^ 'NLST'
]

{ #category : #accessing }
FTPNlstCommand >> padding [
	^ #( none ).
]

{ #category : #accessing }
FTPNlstCommand >> selectors [
	^ #( nameOf: ).
]
