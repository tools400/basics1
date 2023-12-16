
BASICS1 - A Tools/400 Service Program
-------------------------------------

BASICS1 is a core service program that offers services that are used
by almost all Tools/400 utilities.

Compile members with the following PDM option:
                                                                          
   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO) 
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)          
     USER1(*LIST) USER2(*FULL)                                            

Members of type MAKPGM or BND are used for linking programs (MAKPGM) 
and service programs (BND).

2018, Thomas Raddatz

-----------------------
      History
-----------------------


Version 1.16.2
--------------

Added:   Test iRPGUnit test suite TEST_R3_15.


Version 1.16.1
--------------

Fixed:   Fixed handling optional parameter i_wildcard in f_genStrCmp().
Changed: Replaced RPG memory functions with xalloc(), xrealloc() and
         xdealloc() to get a single point of control.


Version 1.16.0
--------------

Added:   Test program TEST_R8_02.
Fixed:   Fixed exports of:
            BASICS1RF_f_rtvSysVal_char()
            BASICS1RF_f_rtvSysVal_num()
Fixed:   Fixed 'index out of range' check in:
            BasicMap_getSizeByIndex()              
            BasicMap_getKeyByIndex()               
            BasicMap_getValueByIndex()
Fixed:   Reference fields in BasicProperties_remove().
Fixed:   Upper case key in BasicProperties_remove().
         Now the key is lower case. 
Added:   Test cases to program TEST_RC_01.
             

Changed: Target release to 7.1.


Version 1.15.3
--------------

Fixed:   Broken member BASICS1R7. (broken with v1.15.1)


Version 1.15.2
--------------

Changed: Added installation program A_INSTALL.


Version 1.15.1
--------------

Changed: Added installation program A_INSTALL.
Bug:     Broke member BASICS1R7 because of a bug in the source code
         formatter.


Version 1.15
------------

Added:   Procedures:
            f_mid()
            f_cvtEpochTS()
            f_cvtTSEpoch()
            f_cvtMiTimeTS()
            f_cvtTSMiTime()
            f_cvtQSYSObjNameToPath()
            f_cvtPathToQSYSObjName()
Fixed:   Replaced f_genStrCmp() with a more reliable approach.
Changed: Removed if/endif markers.


Version 1.14.4
--------------

Fixed:   Fixed compile errors because of usage of '*' instead of
         '*omit'.


Version 1.14.3
--------------

Changed: Changed Signature_new() to use ftime() instead of time().
Changed: Removed if/endif markers.
Changed: Changed compiler directives to keep the custom lf_bit*
         functions for V5R3 instead of V5R2.


Version 1.14.2
--------------

Changed: Changed BasicList to store up to 1.044.473 items.
Changed: Added error message 'Failed to allocate memory' which is sent
         when BasicList could not allocate/reallocate memory.
Added:   Added BasicList_getTotalSize() to return the total size of
         memory used by a given BasicList.


Version 1.14.1
--------------

Changed: Updated member CLIB.


Version 1.14
------------

Added:   Procedures :
            BasicProperties_*
            f_setErrno()
            MemoryReader_*
            MemoryWriter_*
Changed: Renamed the BasicMap_KeySet_* procedures and type templates to:
            BasicMap_newKeySet()
            BasicKeySet_getFirst()
            BasicKeySet_getNext()
            BasicKeySet_delete()
            BasicKeySet_handle_t


Version 1.13.2
--------------

Added:   Procedure f_startsWithIgnoreCase().


Version 1.13.1
--------------

Fixed:   Now passing the right length to f_genSHA1() in order to
         generate a SHA-1 hash from a buffer. (TEST_R7_05)
Changed: Added CCSID(*CHAR: *JOBRUN) to member H_SPEC as recommended
         by Barbara Morris. (RPG Cafe: 'An H spec keyword that you
         might be missing')


Version 1.13
------------

Added:   Procedures BasicMap_getKeys() and BasicMap_getValues().
Added:   Procedure f_getSndInfOfRcvMsg().
Added:   Procedures f_rtvSysVal_char() and f_rtvSysVal_num().
Added:   Procedure f_cvtPtrToHexString().
Added:   Added parameter 'i_heapID' to BasicList_new(), BasicStack_new() and
         BasicMap_new().
Added:   MemoryManager.
Added:   Procedures BasicList_getHeapID(), BasicStack_getHeapID() and BasicMap_getHeapID().


Version 1.12.1
--------------

Fixed:   Changed passing mode of parameter i_followLnk of prototype Qp0lGetAttr
         from 'const' to 'value'.


Version 1.12
------------

Fixed:   Fixed problem in f_genStrCmp() that does not properly
         compare strings that contain multiple dots.


Version 1.11
------------

Changed: Added prompter action support to f_execute().
Changed: Moved declaration of user space APIs to member QUSRSPC.
Changed: Renamed f_getDisplayMode() to Display_getMode().
Fixed:   Fixed problem in f_wordwrap() that caused a runtime error
         in case that the last character of the input string is an
         EOP escape character.
Added:   Test program TEST_R5_04 to check user space procedures.
Added:   Test program TEST_R3_13 to check date formatter and parser.
Added:   Test program TEST_R3_14 to check f_formatMemSize().
Added:   Procedures: f_chgUsrSpcSize()
                     f_getUsrSpcSize()
                     f_chgUsrSpcAutoExt()
                     f_getUsrSpcAutoExt()
                     f_chgUsrSpcInitValue()
                     f_getUsrSpcInitValue()
                     f_rplUnPrtChars()
                     f_formatDate()
                     f_parseDate()
                     f_formatMemSize()
                     Display_supportsDS4()
                     Display_supportsGUI()
                     Display_getRows()
                     Display_getColumns()
                     p_wait()
                     f_dateSerial()

Procedures with V1.11                          Program:
----------------------------------------       ----------------------------------------
BASICS1R5_f_chgUsrSpcSize                      TEST_R5_04
BASICS1R5_f_getUsrSpcSize                      TEST_R5_04
BASICS1R5_f_chgUsrSpcAutoExt                   TEST_R5_04
BASICS1R5_f_getUsrSpcAutoExt                   TEST_R5_04
BASICS1R5_f_chgUsrSpcInitValue                 TEST_R5_04
BASICS1R5_f_getUsrSpcInitValue                 TEST_R5_04


Version 1.10
------------

Fixed:   Changed size of parameter 'i_text' or f_crtUsrSpc() from 10A to 50A.
Added:   Procedures: f_getObjLib()
                     f_objName()
                     f_rcvPgmMsgObj()


Version 1.9
-----------

Changed: Enabled BasicMap to store NULL values.
Changed: Added optional parameter 'offset' to f_caller().
         (Needed for the Log4rpg stub module.)
Added:   Procedures: BasicList_clone()
                     BasicMap_clone()


Version 1.8.1
-------------

Changed: Enabled BasicMap_KeySet_new() to be called more than once.
         Introduced a real KeySet handle.


Version 1.8
-----------

Changed: Changed internal structure of Map object. Introduced a real handle for the Map.
Changed: Changed internal structure of Stack object. Introduced a real handle for the Stack.
Changed: Enabled BasicList to store NULL values.
Added:   Procedures: BasicList_isSorted()
                     BasicList_addNull()
                     BasicList_setNull()
                     BasicList_isNullValue()
                     BasicMap_KeySet_new()
                     BasicMap_KeySet_getFirst()
                     BasicMap_KeySet_getNext()
                     BasicMap_KeySet_delete()
Added:   BasicList   Check type of handle restrictively.
         BasicStack  Check type of handle restrictively.
         BasicMap    Check type of handle restrictively.


Version 1.7.2
-------------

Fixed:   Error in FDMBRD0100. Invalid length of MBRD0100.SRCFILE. Renamed sub field
         'srcFile' to 'isSrcFile'.


Version 1.7.1
-------------

Fixed:   Memory leak in BasicMap. BasicMap_remove() did not properly
         free the memory used by the map entry data.


Version 1.7
-----------

Fixed:   Now BasicStack_pop() correctly removes the list entry
         for NULL pointer returned by BasicList_get(). That happens
         if a NULL string was pushed onto the stack.
Changed: Changed f_execute() to receive an error message directly
         rather that trying to get it from the errorCode parameter.
Changed: Added assert() to BasicMap_put() to ensure that the 'i_key'
         contains a value greater than 0.
Changed: Enhanced f_cvtApiErrCodeToMsg() to
         receive the original error message from the previous call
         stack entry, if possible.
Added:   Procedures: f_endsWith()
                     f_containsInvalidCharAt()
                     f_containsStringAt()
Added:   Procedures: BasicMap_getSizeByIndex()
                     BasicMap_putString()
                     BasicMap_getString()
                     BasicMap_putInteger()
                     BasicMap_getInteger()
Added:   Procedures: Url_new()
                     Url_getFile()
                     Url_getHost()
                     Url_getPath()
                     Url_getPort()
                     Url_getProtocol()
                     Url_getQuery()
                     Url_getMbr()
                     Url_toString()
                     Url_setFile()
                     Url_setHost()
                     Url_setPath()
                     Url_setPort()
                     Url_setProtocol()
                     Url_setQuery()


Version 1.6.3
-------------

Added:   Procedure f_cvtRcvMsgToMsg().


Version 1.6.2
-------------

Fixed:   Fixed problem in f_cvtErrnoToMsg(). Now errors without
         corresponding message description in QC2MSGF are
         returned as CPF9898 message.
Added:   Procedure BasicStack_peek().
Added:   Procedure BasicStack_clear().
Added:   Procedure BasicList_clear().
Added:   Procedure BasicMap_clear().
Changed: Removed external data structures from distribution package.


Version 1.6.1
-------------

Changed: Changed BasicList_get() to initialize only that bytes of
         the return buffer that are beyond the length of the list entry.
Fixed:   Changed f_getEnvVarByIndex to respect the length of the
         environment variable.


Version 1.6
-----------

Procedures with V1.6                           Program:
----------------------------------------       ----------------------------------------
BASICS1R8_MEMORY_allocate                      TEST_R8_02
BASICS1R8_MEMORY_freeAll                       TEST_R8_02
BASICS1R8_MEMORY_free                          TEST_R8_02
BASICS1R5_f_activateSrvPgm                     LOG4RPG
BASICS1R5_f_getProcPtrByName                   LOG4RPG
BASICS1RA_BasicList_add                        TEST_RA_01
BASICS1RA_BasicList_addPointer
BASICS1RA_BasicList_addString                  TEST_RA_01
BASICS1RA_BasicList_delete                     TEST_RA_01
BASICS1RA_BasicList_find                       TEST_RA_01
BASICS1RA_BasicList_findString                 TEST_RA_01
BASICS1RA_BasicList_get                        TEST_RA_01
BASICS1RA_BasicList_getListType                TEST_RA_01
BASICS1RA_BasicList_getNumE                    TEST_RA_01
BASICS1RA_BasicList_getPointer
BASICS1RA_BasicList_getSize                    TEST_RA_01
BASICS1RA_BasicList_getString                  TEST_RA_01
BASICS1RA_BasicList_getType                    TEST_RA_01
BASICS1RA_BasicList_isListTypeOf               TEST_RA_01
BASICS1RA_BasicList_isNull                     TEST_RA_01
BASICS1RA_BasicList_isTypeOf                   TEST_RA_01
BASICS1RA_BasicList_new                        TEST_RA_01
BASICS1RA_BasicList_null
BASICS1RA_BasicList_remove
BASICS1RA_BasicList_set
BASICS1RA_BasicList_setAutoSort
BASICS1RA_BasicList_setPointer
BASICS1RA_BasicList_setString
BASICS1RA_BasicList_sort
BASICS1RB_BasicStack_delete                    TEST_RB_01
BASICS1RB_BasicStack_getNumE                   TEST_RB_01
BASICS1RB_BasicStack_getSize                   TEST_RB_01
BASICS1RB_BasicStack_isNull                    TEST_RB_01
BASICS1RB_BasicStack_new                       TEST_RB_01
BASICS1RB_BasicStack_null                      TEST_RB_01
BASICS1RB_BasicStack_pop                       TEST_RB_01
BASICS1RB_BasicStack_push                      TEST_RB_01
BASICS1RC_BasicMap_containsKey                 TEST_RC_01
BASICS1RC_BasicMap_delete                      TEST_RC_01
BASICS1RC_BasicMap_get                         TEST_RC_01
BASICS1RC_BasicMap_getKeyByIndex
BASICS1RC_BasicMap_getValueByIndex             TEST_RC_01
BASICS1RC_BasicMap_getNumE                     TEST_RC_01
BASICS1RC_BasicMap_getSize                     TEST_RC_01
BASICS1RC_BasicMap_isNull                      TEST_RC_01
BASICS1RC_BasicMap_new                         TEST_RC_01
BASICS1RC_BasicMap_null                        TEST_RC_01
BASICS1RC_BasicMap_put                         TEST_RC_01
BASICS1RC_BasicMap_remove                      TEST_RC_01, TEST_RC_02
BASICS1R3_f_startsWith

Fixed:   Fixed problem in f_wordwrap() that EOL-character was not found
         when it was the last character in the string.
Changed: Changed p_assert(), f_this() and f_caller() to use a static
         buffer of 2048 byte to receive the test message for better
         performance.
Changed: Changed procedure f_caller() to return the statement ID
         as the next optional parameter.
Changed: Changed procedure f_this() to return the statement ID
         as the next optional parameter.
Changed: Changed procedure HANDLE_isTypeOf() to return "invalid handle"
         instead of throwing an exception when the pointer of the handle
         is *NULL.
Added:   Procedures MEMORY_allocate(), MEMORY_free() and MEMORY_freeAll()
         to ease working with dynamic memory allocation.
Added:   Procedure f_activateSrvPgm().
Added:   Procedure f_getProcPtrByName().
Added:   Procedures BasicList_* to enable dynamic lists.
Added:   Procedures BasicStack_* to enable stack support.
Added:   Procedures BasicMap_* to enable map support.
Added:   Procedure f_startsWith.


Version 1.5
-----------

Procedures with V1.5                           Program:
----------------------------------------       ----------------------------------------
BASICS1R9_f_getDisplayMode
BASICS1R6_f_getNumEnvVar                       TEST_R6_02
BASICS1R6_f_getEnvVarByIndex                   TEST_R6_02
BASICS1R7_f_genCRC32                           TEST_R7_08, TEST_R7_09

Changed: Changed BASICS1 to get a clear compile for V5R1M0.
Fixed:   Changed return value of procedure f_ebcdic() from 3I0 to 3U0 to
         avoid negative values.
Added:   Added procedure f_getDisplayMode() to the current display mode.
         This procedure uses the Retrieve Display Mode (QsnRtvMod) API.
Added:   Added procedure f_getNumEnvVar() get the number of environment
         variables.
Added:   Added procedure f_getEnvVarByIndex() get the value of an
         environment variable. The variable is addressed by its index.
Added:   Added procedure f_genCRC32() to calculate a CRC-32 check sum.
         Use the C compiler whenever it is possible because of great
         performance advantages.

Performance measurement results of f_genCRC32() with a 8.517 kByte file:

  iSeries:
  --------
  Model  . . . . :  820
  Main storage . :  System    Pool
                    Pool   Size (M)
                      1      820,60
                      2     1847,79
                      3      679,19
                      4       33,81

  w/o code optimization                   with maximum code optimization
  C_COMPILER    V5R3       V5R2           C_COMPILER    V5R3       V5R2
  ----------   ------     ------          ----------   ------     ------
     636        2970       4496             129         1225       2853
     572        3036       4140             186         1239       3627
     596        2526       4248             124         1343       3465
     714        2506       4896             204         1255       3220
     650        2540       4424             180         1708       2865
     570        2457       4363             173         1231       3017
     606        2506       5115             177         1397       2816
     592        2569       4327             142         1240       2718
     699        2880       4274             146         1231       2885
     628        2479       4308             177         1383       2860
  ----------   ------     ------          ----------   ------     ------
     626,3      2646,9     4459,1           163,8       1325,2     3032,6

  Speed factors:
  --------------
  C to V5R3:      4,2                     C to V5R3:      8,1
  C to V5R2:      7,1                     C to V5R2:     18,5
  V5R3 to V5R2:   1,7                     V5R3 to V5R2:   2,3


Version 1.4
-----------

Procedures with V1.3                           Program:
----------------------------------------       ----------------------------------------
BASICS1R3_f_cvtBufferToHexString               TEST_R3_11
BASICS1R3_f_cvtHexStringToBuffer               TEST_R3_11
BASICS1R7_f_genUUID                            TEST_R7_03
BASICS1R7_f_genMd5                             TEST_R7_04, TEST_R7_06
BASICS1R7_f_genSHA1                            TEST_R7_05, TEST_R7_07
BASICS1R2_f_cvtErrnoToMsg                      TEST_R2_01

Changed: Enhanced f_wordWrap() to support end-of-paragraph markers.
Added:   Added prototype of C-function time() to member CLIB.
Added:   Added procedure f_cvtBufferToHexString() to convert a memory
         buffer to a readable string of hex values.
Added:   Added procedure f_cvtHexStringToBuffer() to convert a
         a readable string of hex values to a buffer.
Added:   Added procedure f_genUUID() to generate a Universal Unique
         Identifier.
Added:   Added procedure f_genMD5() to generate a MD5 fingerprint.
Added:   Added procedure f_genSHA1() to generate a SHA-1 fingerprint.
Added:   Added procedure f_cvtErrnoToMsg() to convert a C error number
         to a message.


Version 1.3.1:
--------------

Changed: Added parameter TGTRLS(*CURRENT) to all creation commands.
Changed: Removed '#' from member names.


Version 1.3:
------------

Procedures with V1.3                           Program:
----------------------------------------       ----------------------------------------
BASICS1R1_f_rtvMsgTextRaw
BASICS1R1_f_rtvMsgHelpTextRaw
BASICS1R3_f_center                             TEST_R3#08
BASICS1R3_f_alignR                             TEST_R3#08
BASICS1R3_f_genStrCmp                          TEST_R3#09
BASICS1R3_f_genStrCmpIgnCase                   TEST_R3#09
BASICS1R1_f_scanR

Changed: Removed useless copy books PBASICS1R2, PBASICS1R4 and PBASICS1R6
         from copy book PBASICS1R5. Added copy book PBASICS1R1 instead.
Changed: Changed f_space() to accept a 0 length.
Changed: Changed f_addQuotes() to add quotes only in case it is not yet
         a quoted string. A quoted string is a string that starts and ends
         with a quote.
Changed: Changed f_rmvQuotes() to removes quotes only in case it is a
         a quoted string. A quoted string is a string that starts and ends
         with a quote.
Added:   Added procedure f_rtvMsgTextRaw() to retrieve the message text
         without replacing substitution variables.
Added:   Added procedure f_rtvMsgHelpTextRaw() to retrieve the message help text
         without replacing substitution variables.
Added:   Added procedure f_center() to center a given string.
Added:   Added procedure f_alignR() to right align a given string.
Added:   Added procedure f_genStrCmp() to perform string compare
         using wildcard characters.
Added:   Added procedure f_genStrCmpIgnCase() to perform string compare
         using wildcard characters. (Ignore case)
Added:   Added procedure f_scanR reverse scan a given string for
         a search argument.
Added:   Added data type definition rtvm0400_t.


Version 1.2:
------------

Procedures with V1.2                           Program:
----------------------------------------       ----------------------------------------
BASICS1R3_f_rmvKeyword                         TEST_R3#07
BASICS1R3_f_rmvQuotes
BASICS1R3_f_addQuotes
BASICS1R5_f_crtUsrSpc                          -+
BASICS1R5_f_rtvUsrSpcPtr                        ]
BASICS1R5_f_dltUsrSpc                           ]
BASICS1R8_HANDLE_new                            ]- Used by my list service programs
BASICS1R8_HANDLE_null                           ]
BASICS1R8_HANDLE_isNull                         ]
BASICS1R8_HANDLE_isTypeOf                       ]
BASICS1R8_HANDLE_getPointer                     ]
BASICS1R8_HANDLE_delete                        -+

Changed: Removed useless parameter i_rtnCtrlChr from f_rtvMsgText()
         procedure!
Changed: Replaced external data structures XD* by copy books FD*.
         External data structures are still shipped until 30.06.2005.
Changed: Changed f_val to use self-written code instead of MI function
         cvtefnd(). cvtefnd() crashes when it encounters an invalid
         digit. Usually VAL() functions just stop when they hit an
         invalid character.
Added:   Added procedure f_rmvKeyword(). The procedures removes a keyword
         from a given string. E.g.: DFT('This is a screen constant') is
         translated to 'This is a screen constant'.
Added:   Added procedure f_rmvQuotes(). The procedure removes quotes from
         a given string. E.g. the quotes string 'Programmer''s guide' is
         translated to Programmer's guide.
Added:   Added procedure f_addQuotes(). The procedure adds quotes to
         a given string. E.g. the string Programmer's guide is
         translated to 'Programmer''s guide'.
Added:   Added procedures to manage user spaces:
         f_crtUsrSpc()       - Creates a user space
         f_rtvUsrSpcPtr()    - Retrieves a pointer to the user space.
         f_dltUsrSpc()       - Deletes a user space.
Added:   Added procedures to manage user handles:
         HANDLE_new()        - Creates a new handle.
         HANDLE_null()       - Returns a NULL handle.
         HANDLE_isNull()     - Checks a handle for a NULL value.
         HANDLE_isTypeOf()   - Checks the type of a given handle.
         HANDLE_getPointer() - Retrieves a pointer to the handle data from
                               a given handle.
         HANDLE_delete()     - Deletes a given handle.


Version 1.1:
------------

Procedures with V1.1                           Program:
----------------------------------------       ----------------------------------------
BASICS1R3_f_editCode                           TEST_R3#06
BASICS1R3_f_editWord                           TEST_R3#06
BASICS1R3_f_getLengthEditCode                  TEST_R3#06
BASICS1R3_f_getLengthEditWord                  TEST_R3#06
BASICS1R7_f_log10                              TEST_R7#02 via f_clcLengthOfRPGIntFieldFromBufSize
BASICS1R7_f_clcLengthOfRPGIntFieldFromBufSize  TEST_R7#02


Version 1.0:
------------

Procedure:                                     Program:
----------------------------------------       ----------------------------------------
BASICS1R1_p_setAppMsgFile                      TEST_R1#02
BASICS1R1_f_newMsg                             TEST_R1#02
BASICS1R1_f_sndPgmMsg                          TEST_R1#01/TEST_R1#02
BASICS1R1_f_rcvPgmMsg                          TEST_R1#02
BASICS1R1_p_rmvPgmMsg                          TEST_R1#02
BASICS1R1_f_rtvMsgText                         TEST_R1#01
BASICS1R1_f_rtvMsgHelpText                     TEST_R1#01
BASICS1R2_f_newApiErrCode                      all programs using APIs
BASICS1R2_f_isApiError                         BASICS1R6.f_execute() ==> TEST_R6#01
BASICS1R2_f_cvtApiErrCodeToMsg                 BASICS1R6.f_execute() ==> TEST_R6#01
BASICS1R2_f_errno                              TEST_R2#01
BASICS1R2_f_strerror                           TEST_R2#01
BASICS1R3_f_left                               TEST_R3#03
BASICS1R3_f_right                              TEST_R3#03
BASICS1R3_f_space                              TEST_R3#03
BASICS1R3_f_replace                            TEST_R3#04
BASICS1R3_f_lcase                              TEST_R3#05
BASICS1R3_f_ebcdic                             BASICS1R3.f_space()   ==> TEST_R3#03
BASICS1R3_f_val                                TEST_R3#01
BASICS1R3_f_wordWrap                           TEST_R3#02
BASICS1R4_p_assert                             TEST_R4#01
BASICS1R4_f_this                               TEST_R4#01
BASICS1R5_f_exist                              TEST_R5#01 (object)
BASICS1R5_f_exist                              TEST_R5#02 (member)
BASICS1R5_f_getTmpName                         TEST_R5#03
BASICS1R5_f_getUniqueName                      TEST_R5#03
BASICS1R6_f_execute                            TEST_R6#01
BASICS1R7_f_isBitOn                            TEST_R7#01

