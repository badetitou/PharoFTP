Class {
	#name : #FTPFileSystemDirectory,
	#superclass : #FTPFileSystem,
	#instVars : [
		'children'
	],
	#category : #'FTP-FileSystem'
}

{ #category : #'instance-creation' }
FTPFileSystemDirectory class >> default [
	^ self on: FileDirectory default.
]

{ #category : #'instance-creation' }
FTPFileSystemDirectory class >> on: aDirectory [
	^ self new
		setDirectory: aDirectory;
		yourself.
]

{ #category : #accessing }
FTPFileSystemDirectory >> children [
	^ children ifNil: [
		children := self directory entries collect: [ :each |
			(each fourth
				ifTrue: [ self directoryClass parent: self ]
				ifFalse: [ self fileClass parent: self ])
					setOwner: self directory;
					setEntry: each;
					yourself ] ].
]

{ #category : #conveniance }
FTPFileSystemDirectory >> createFileNamed: aString [
	^ (self fileClass parent: self)
		setOwner: self directory;
		setEntry: { aString. 0. 0. 0. 0. 0 };
		yourself.
]

{ #category : #accessing }
FTPFileSystemDirectory >> directory [
	^ self owner directoryNamed: self name.
]

{ #category : #accessing }
FTPFileSystemDirectory >> entry [
	^ super entry ifNil: [ entry := self directory ].
]

{ #category : #testing }
FTPFileSystemDirectory >> isDirectory [
	^ true
]

{ #category : #initialization }
FTPFileSystemDirectory >> setDirectory: aDirectory [
	self setOwner: aDirectory containingDirectory.
	self setEntry: (self owner entryAt: aDirectory localName).
]
