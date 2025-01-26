;Ethan Henning
.386																		;32 bit protected mode
.model flat, stdcall														;which memory model we use
.stack 4096																	;how much memory is allocated to stack
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

.data																		;variable declaration
STD_INPUT_HANDLE EQU -10
STD_OUTPUT_HANDLE EQU -11

buffer BYTE 300 DUP(?)
bytesRead DWORD ?															;NOT FROM USERS PERSPECTIVE
bytesWritten DWORD ?
inputHandle DWORD ?
outputHandle DWORD ?
coutHandle DWORD ?

modulus WORD ?		
numBytes DWORD ?

readIn byte ?

filename BYTE "OutPut.txt", 0

.code																		;running code(put code here)
main PROC																	;beginning of main process

;call GetStdHandle
INVOKE GetStdHandle, STD_OUTPUT_HANDLE
mov outputHandle, EAX


; open the file to read from
INVOKE CreateFileA, addr filename, GENERIC_READ, 0, 0, OPEN_EXISTING, 128, 0
mov inputHandle, eax



notYet:


INVOKE ReadFile, inputHandle, addr numBytes, type numBytes, addr readIn, 0

INVOKE ReadFile, inputHandle, addr modulus, type modulus, addr readIn, 0

INVOKE ReadFile, inputHandle, addr buffer, numBytes, addr readIn, 0

cmp readIn, 0
je yet

mov ecx, numBytes
mov edx, offset buffer 



cmp modulus, 0
jne hasE
nonE:
	mov BL, BYTE PTR [EDX]
	NOT BL
	mov [EDX], BYTE PTR BL
	INC EDX
loop nonE

jmp write


hasE:

decryptwE:
	mov BL, BYTE PTR [EDX]
	push ecx
	mov cl, byte ptr modulus
	ror BL, cl
	pop ecx
	mov [EDX], BYTE PTR BL
	INC EDX
loop decryptwE


write:



INVOKE WriteConsoleA, outputHandle, addr buffer, numBytes, addr bytesWritten, 0 

jmp notYet

yet:

INVOKE ExitProcess, 0														;0 is DW exit code
main ENDP																	;end of main process
END main