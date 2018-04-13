      /IF NOT DEFINED(fileInfDS_t)
      /DEFINE fileInfDS_t
      *===============================================================*
      *  File information data structure                              *
      *===============================================================*
     D fileInfDS_t     DS                  based(pDummy)   qualified
      * Reserved 01
     D  reserved_01            1      8A
      * Open indication 1=open
     D  isOpen                 9      9A
      * End of file 1=EOF
     D  isEOF                 10     10A
      * Status
     D  status                11     15S 0
      * Operation code, first 5 pos.
     D  opCode                16     20A
      * IO-Type:
      *   F=The last operation was specified for a file name
      *   R=The last operation was specified for a record
      *   I=The last operation was an implicit file operation.
     D  IO_type               21     21A
      * Routine of operation code
     D  routine               22     29A
      * RPG source listing line nbr
     D  srcSeq                30     37A
      * Record format
     D  rcdFormat             38     45A
      * System message number
     D  sysMsgNbr             46     52A
      * Reserved 02
     D  reserved_02           53     66A
      *
      * Valid after post:
      *    Screen size (product of the number of rows
      *    and the number of columns on the device screen).
     D  screenSize            67     70S 0
      *    The display's keyboard type.
      *       00 = alphanumeric or katakana
      *       10 = ideographic
     D  kbdType               71     72S 0
      *    The display type.
      *       00 = alphanumeric or katakana
      *       10 = ideographic
      *       20 = DBCS
     D  displayType           73     74S 0
      *    Always set to 00.
     D  mode                  75     76S 0
      * Reserved_03
     D  reserved_03           77     80A
      *
      *  -------------------------------
      *    Open Feedback
      *  -------------------------------
     D  openFeedback                       likeds(openFeedback_t)
      *
      *  -------------------------------
      *    Input/Output Feedback
      *  -------------------------------
     D  IO_feedback                        likeds(IO_feedback_t )
      *
      *  -------------------------------
      *    I/O Feedback, File specific
      *  -------------------------------
     D  IO_feedback_file...
     D                              256A
      *    I/O Feedback Database File
     D  IO_feedback_DB...
     D                                     likeds(IO_feedback_DB_t)
     D                                     overlay(IO_feedback_file)
      *
      *  -------------------------------
      *    Open Feedback
      *  -------------------------------
     D openFeedback_t...
     D                 DS           160    qualified
      * DS=Display DB=File SP=Spooled File
     D  ODP_type               1      2A
      * File name
     D  file                   3     12A
      * Library
     D  lib                   13     22A
      * Spool file name
     D  spoolFile             23     32A
      * Spool file library
     D  spoolLib              33     42A
      * Spool file number
     D  spoolNbr              43     44I 0
      * Record length
     D  maxRcdLength          45     46I 0
      * Key length
     D  maxKeyLength          47     48I 0
      * Member
     D  mbr                   49     58A
      * Reserved
     D  reserved_01           59     62I 0
      * Reserved
     D  reserved_02           63     66I 0
      * File type
      *     1  =  Display
      *     2  =  Printer
      *     4  =  Diskette
      *     5  =  Tape
      *     9  =  Save
      *    10  =  DDM
      *    11  =  ICF
      *    20  =  Inline data
      *    21  =  Database
     D  fileType              67     68I 0
      * Reserved
     D  reserved_03           69     71A
      * Number of lines on a display screen or       (Display, printer)
      * number of lines on a printed page.
     D  rows                  72     73I 0
      * Length of the null field byte map.           (Database)
     D  lenNullFldMap         72     73I 0
      * Number of positions on a display screen or   (Display, printer)
      * number of characters on a printed line.
     D  columns               74     75I 0
      * Length of the null key field byte map.       (Database)
     D  lenKeyFldMap          74     75I 0
      * Number of records in the member at open
      * at open time.
     D numRcdsAtOpen          76     79I 0
      * Access type
     D accessType             80     81A
      * Duplicate key?
     D isDupKey               82     82A
      * Source file?
     D isSrcFile              83     83A
      * Reserved
     D reserved_04            84     93A
      * Reserved
     D reserved_05            94    103A
      * Offset to volume label fields of open
      * feedback area.
     D ofsVolLblFld          104    105I 0
      * Max rcds in blk
     D maxBlkRcds            106    107I 0
      * Overflow line
     D overflow              108    109I 0
      * Blk increment
     D blkInc                110    111I 0
      * Reserved
     D reserved_06           112    115A
      * Miscellaneous flags
     D flags1                116    116A
      * Requester name
     D requester             117    126A
      * Open count
     D openCount             127    128I 0
      * Reserved
     D reserved_07           129    129A
      * Num based mbrs
     D numBasedMbrs          131    132I 0
      * Miscellaneous flags
     D flags2                133    133A
      * Open identifier
     D openID                134    135A
      * Max rcd fmt length
     D maxRcdFmtLen          136    137I 0
      * Database CCSID
     D CCSID                 138    139I 0
      * Miscellaneous flags
     D flags3                140    140A
      * Reserved
     D reserved_08           141    146A
      * Num devs defined
     D numDevices            147    148I 0
      *
      *  -------------------------------
      *    Input/Output Feedback
      *  -------------------------------
     D IO_feedback_t...
     D                 DS           126    qualified
      * Offset to file dependant feedback
     D ofsFileDepFB            1      2I 0
      * Write count
     D writeCount              3      6I 0
      * Read count
     D readCount               7     10I 0
      * Write/read count
     D writeReadCount         11     14I 0
      * Other I/O count
     D otherCount             15     18I 0
      * Reserved
     D reserved_01            19     19A
      * Current operation
      *   hex 01 =  Read or read block or read from invited devices
      *   hex 02 =  Read direct
      *   hex 03 =  Read by key
      *   hex 05 =  Write or write block
      *   hex 06 =  Write-read
      *   hex 07 =  Update
      *   hex 08 =  Delete
      *   hex 09 =  Force-end-of-data
      *   hex 0A =  Force-end-of-volume
      *   hex 0D =  Release record lock
      *   hex 0E =  Change end-of-data
      *   hex 0F =  Put deleted record
      *   hex 11 =  Release device
      *   hex 12 =  Acquire device
     D operation              20     20A
      * Rcd format name
     D IO_rcdFmt              21     30A
      * Device class
     D deviceClass            31     32A
      * Pgm device name
     D IO_pgmDevice           33     42A
      * Rcd len of I/O
     D IO_rcdLength           43     46I 0
      * Reserved
     D reserved_02            47    126A
      *
      *  -------------------------------
      *    I/O Feedback Database File
      *  -------------------------------
     D IO_feedback_DB_t...
     D                 DS                  qualified
      * Number of locked records
     D  numLckRcds            11     12I 0
      * Maximum number of fields
     D  maxNumFlds            13     14I 0
      * Nbr of key fields
     D  nbrOfKeyFlds          21     22I 0
      * Key length
     D  keyLength             27     28I 0
      * Data member number.
     D  dtaMbrNum             29     30I 0
      * Relative record number in data member.
     D  rcdNbr                31     34U 0
      *
      /ENDIF
