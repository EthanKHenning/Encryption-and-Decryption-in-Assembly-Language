;Ethan Henning
.386										;32 bit protected mode
.model flat, stdcall						;which memory model we use
.stack 4096									;how much memory is allocated to stack
ExitProcess PROTO dwExitCode:DWORD

;get std handle, read console a, write console a

GetStdHandle PROTO, nStdHandle:DWORD

ReadConsoleA PROTO, hConsoleInput:DWORD, lpBuffer:DWORD, nNumberOfCharsToRead:DWORD, lpNumberOfCharsRead:DWORD, pInputControl:DWORD

WriteConsoleA PROTO, hConsoleOutput:DWORD, lpBuffer:DWORD,  nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:DWORD, lpReserved:DWORD

CreateFileA PROTO, lpFileName:DWORD, dwDesiredAccess:DWORD, dwShareMode:DWORD, lpSecurityAttributes:DWORD, dwCreationDisposition:DWORD, dwFlagsAndAttributes:DWORD, hTemplateFile:DWORD

ReadFile PROTO, hFile:DWORD, lpBuffer:DWORD, nNumberOfBytesToRead:DWORD, lpNumberOfBytesRead:DWORD, lpOverlapped:DWORD

WriteFile PROTO, hFile:DWORD, lpBuffer:DWORD, nNumberOfBytesToWrite:DWORD, lpNumberOfBytesWritten:DWORD, lpOverlapped:DWORD
CloseHandle PROTO, hObject:DWORD

GetLastError PROTO

STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11
GENERIC_READ EQU <80000000h>
GENERIC_WRITE EQU <40000000h>
OPEN_EXISTING EQU <3>
CREATE_ALWAYS EQU <2>
NORMAL_FLAGS EQU <128>

GetStdHandle PROTO, nStdHandle:DWORD  



GENERIC_READ EQU <80000000h>
GENERIC_WRITE EQU <40000000h>
OPEN_EXISTING EQU <3>
CREATE_ALWAYS EQU <2>
NORMAL_FLAGS EQU <128>

.data										;variable declaration
STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11

cout BYTE "Input anything or input q to quite: ", 0
quit BYTE "q", 0
buffer BYTE 300 DUP(?)
bytesRead DWORD ?											;NOT FROM USERS PERSPECTIVE
bytesWritten DWORD ?
inputHandle DWORD ?
outputHandle DWORD ?
coutHandle DWORD ?

outPutFile BYTE "OutPut.txt", 0

numE WORD 0
modulus WORD 0


.code										;running code(put code here)
main PROC									;beginning of main process

INVOKE CreateFileA, addr outPutFile, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, NORMAL_FLAGS, 0
mov outputHandle, EAX

call GetStdHandle
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov coutHandle, EAX

;-------------------------------------------------------------------------------- USED TO WRITE TO CONSOLE
INVOKE WriteConsoleA, coutHandle, addr cout, lengthof cout, addr bytesWritten, 0 

;--------------------------------------- USED TO READ IN FROM USER 
INVOKE GetStdHandle, STD_INPUT_HANDLE
mov inputHandle, EAX



up:

INVOKE ReadConsoleA, inputHandle, addr buffer, lengthof buffer, addr bytesRead, 0



cmp bytesRead, 3
jne body

mov al, 'q'
cmp al, buffer
je over


body:

mov EDX, offset buffer 
mov ecx, bytesRead

getE:
	cmp [EDX], byte PTR 'e'
	jne noE
	add [EDX], byte ptr 8
	INC numE

	sub [EDX], byte ptr 8

	noE:
	INC EDX
loop getE
	

	mov edx, 0
	mov CX, 8
	mov AX, numE
	DIV CX
	mov modulus, DX
	

	mov ECX, bytesRead
	mov EBX, offset buffer
	cmp modulus, 0	
	jne not0

nonE:
	mov DL, BYTE PTR [EBX]
	NOT DL
	mov [EBX], BYTE PTR DL
	INC EBX
loop nonE
	
	jmp write
	
	not0:
hasE:
	mov DL, BYTE PTR [EBX]
	push ecx
	mov cl, byte ptr modulus
	rol DL, cl
	pop ecx
	mov [EBX], BYTE PTR DL
	INC EBX
loop hasE

	write:
	;WRITE TO FILE
	INVOKE WriteFile, outputHandle, addr bytesRead, TYPE bytesRead, 0, 0
	INVOKE WriteFile, outputHandle, addr modulus, TYPE modulus, 0, 0
	INVOKE WriteFile, outputHandle, offset buffer, bytesRead, 0, 0

mov ECX, 0
mov numE, CX
jmp up

over:

INVOKE ExitProcess, 0										;0 is DW exit code
main ENDP ;end of main process
END main

;when you try to read input but nothing is read in you reached the end