**free
/if NOT DEFINED(D_BASIC)
/define D_BASIC

// -----------------------------------------
//  Constants
// -----------------------------------------
/if NOT DEFINED(cTrue)
/define cTrue
dcl-c cTrue *on;
/endif

/if NOT DEFINED(cFalse)
/define cFalse
dcl-c cFalse *off;
/endif

// -----------------------------------------
//  Reference fields
// -----------------------------------------

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R1                   Messages
/copy QBASICS1,PBASICS1R2                   API Error Handling
/copy QBASICS1,PBASICS1R3                   Strings
/copy QBASICS1,PBASICS1R4                   Assert/This
/copy QBASICS1,PBASICS1R5                   Objects
/copy QBASICS1,PBASICS1R6                   Commands
/copy QBASICS1,PBASICS1R7                   Mathematics
/copy QBASICS1,PBASICS1R8                   Handle/Memory
/copy QBASICS1,PBASICS1R9                   Display Information
/copy QBASICS1,PBASICS1RA                   BasicList
/copy QBASICS1,PBASICS1RB                   BasicStack
/copy QBASICS1,PBASICS1RC                   BasicMap
/copy QBASICS1,PBASICS1RD                   Url
/copy QBASICS1,PBASICS1RE                   Date and Time
/copy QBASICS1,PBASICS1RF                   System Values
/copy QBASICS1,PBASICS1RG                   BasicProperties
/copy QBASICS1,PBASICS1RH                   MemoryBufferRdrWtr

/endif