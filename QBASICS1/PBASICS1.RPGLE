      /IF NOT DEFINED(D_BASIC)
      /DEFINE D_BASIC
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   const(*on )
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   const(*off)
      /ENDIF
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R1                   Messages
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      /COPY QBASICS1,PBASICS1R3                   Strings
      /COPY QBASICS1,PBASICS1R4                   Assert/This
      /COPY QBASICS1,PBASICS1R5                   Objects
      /COPY QBASICS1,PBASICS1R6                   Commands
      /COPY QBASICS1,PBASICS1R7                   Mathematics
      /COPY QBASICS1,PBASICS1R8                   Handle/Memory
      /COPY QBASICS1,PBASICS1R9                   Display Information
      /COPY QBASICS1,PBASICS1RA                   BasicList
      /COPY QBASICS1,PBASICS1RB                   BasicStack
      /COPY QBASICS1,PBASICS1RC                   BasicMap
      /COPY QBASICS1,PBASICS1RD                   Url
      /COPY QBASICS1,PBASICS1RE                   Date and Time
      /COPY QBASICS1,PBASICS1RF                   System Values
      /COPY QBASICS1,PBASICS1RG                   BasicProperties
      /COPY QBASICS1,PBASICS1RH                   MemoryBufferRdrWtr
      *
      /ENDIF
