      *===============================================================*
      *    CALL PGM(TEST_RC_03)                                       *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/BASICS1) +         *
      *                              BNDDIR(QC2LE) +                  *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_RC_03')
      *
     D main...
     D                 PR
      *
     D getOutstandingHeapAllocations...
     D                 PR            20I 0
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Returns the number of outstanding heap allocations.
      *===============================================================*
     P getOutstandingHeapAllocations...
     P                 B
      *
     D getOutstandingHeapAllocations...
     D                 PI            20I 0
      *
      *  Return value
     D outAllocs       S             20I 0 inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D tplSize         S             10I 0 inz
     D MAGP_AG_Attr    DS                  likeds(MAGP_Template_t  ) inz
     D heapIdTpl       DS                  likeds(heapIdTpl_t     ) inz
     D MAGP_AG_Heap_List...
     D                 DS                  likeds(MAGP_Template_t )
     D                                     based(pMAGP_AG_Heap_List)
     D Heap_List_Buffer...
     D                 S           1024A   inz(*ALLx'00')
     D MAGP_Heap_Space_Attr...
     D                 DS                  likeds(MAGP_Heap_Space_Attr_t) inz
     D Heap_List_Entry...
     D                 S                   like(MAGP_Template_t.Heap_List_1)
     D                                     based(pHeap_List_Entry)
      *
      *  Reference fields
     D MAGP_Template_t...
     D                 DS                  qualified               based(pDummy)
     D  bytPrv                 1      4I 0
     D  bytAvl                 5      8I 0
     D  reserved_1             9     16A
      *  union:
     D  Basic_Attr                         likeds(MAGP_AG_Attr_t)
     D  Heap_List_1                  10I 0 overlay(Basic_Attr)
     D  Act_List_1                   20U 0 overlay(Basic_Attr)
      *
     D MAGP_actGrpMark_t...
     D                 S             20U 0                         based(pDummy)
      *
     D MAGP_AG_Attr_t...
     D                 DS                  qualified               based(pDummy)
     D  rootProgram            1     16*
     D  reserved_1            17     32A
     D  stgAdrRclKey          33     48*
     D  actGrpName            49     78A
     D  reserved_2            79     80A
     D  actGrpMark            81     84U 0
     D  reserved_3            85     88A
     D  heapSpcCnt            89     92U 0
     D  actCnt                93     96U 0
     D  staticStgSize         97    100U 0
     D  autoStgSize          101    104U 0
     D  attrs                105    105A
     D  pagMbrShpAdvA        106    106A
     D  reserved_7           107    112A
     D  actGrpMark2          113    120U 0
      *
     D cMATAGPAT_ATTR_BASIC_ACTGRP_ATTR...
     D                 C                   x'00'
     D cMATAGPAT_ATTR_BASIC_ACTGRP_HEAP_LIST...
     D                 C                   x'01'
      *
      *  Materialize Activation Group Attributes (MATAGPAT)
     D matagpat2...
     D                 PR                  extproc('_MATAGPAT2')
     D  o_rcvVar                       *   value
     D  i_actGrpMark                       const  like(MAGP_actGrpMark_t)
     D  i_attrSlc                     3U 0 const
      *
     D heapIdTpl_t     DS                  qualified   align       based(pDummy)
     D  actGrpMark                         like(MAGP_actGrpMark_t)
     D  reserved_1                    4A
     D  heapID                       10U 0
      *
     D MAGP_Heap_Space_Attr_t...
     D                 DS                  qualified   align       based(pDummy)
     D  bytPrv                 1      4I 0
     D  bytAvl                 5      8I 0
     D  maxSnglAlc             9     12U 0
     D  minBndryReq           13     16U 0
     D  crtSize               17     20U 0
     D  extSize               21     24U 0
     D  domain                25     26I 0
     D  heapCrtOpts           27     32A
     D  reserved_1            33     96A
     D  curNbrOutAlc          97    100U 0
     D  totNbrRealloc        101    104U 0
     D  totNbrFrees          105    108U 0
     D  totNbrAllocs         109    112U 0
     D  maxNbrOutAlc         113    116U 0
     D  sizeHeapSpace        117    120U 0
     D  nbrOutMarks          121    124U 0
     D  totNbrExt            125    128U 0
      *
     D cMATHSAT_ATTR...
     D                 C                   x'00'
      *
      *  Materialize Activation Group-Based Heap Space Attributes (MATHSAT)
     D mathsat2...
     D                 PR                  EXTPROC('_MATHSAT2')
     D  o_rcvVar                       *   value
     D  i_heapIdTpl                        const  likeds(heapIdTpl_t)
     D  i_attrSlc                     3U 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         MAGP_AG_Attr.bytPrv = %size(MAGP_AG_Attr);
         matagpat2(%addr(MAGP_AG_Attr)
                   : 0
                   : cMATAGPAT_ATTR_BASIC_ACTGRP_ATTR);

         // ... materialize activation group heap list
         tplSize = 16 + MAGP_AG_Attr.Basic_Attr.heapSpcCnt *
                        %size(MAGP_AG_Heap_List.Heap_List_1);
         pMAGP_AG_Heap_List = %addr(Heap_List_Buffer);
         MAGP_AG_Heap_List.bytPrv = tplSize;

         p_assert(tplSize <= %size(Heap_List_Buffer));

         matagpat2(%addr(MAGP_AG_Heap_List)
                   : MAGP_AG_Attr.Basic_Attr.actGrpMark2
                   : cMATAGPAT_ATTR_BASIC_ACTGRP_HEAP_LIST);

         for x = 1 to MAGP_AG_Attr.Basic_Attr.heapSpcCnt;
            pHeap_List_Entry = %addr(MAGP_AG_Heap_List.Heap_List_1) +
                                (x-1) * %size(MAGP_AG_Heap_List.Heap_List_1);
            clear MAGP_Heap_Space_Attr;
            MAGP_Heap_Space_Attr.bytPrv = %size(MAGP_Heap_Space_Attr);
            clear heapIdTpl;
            heapIdTpl.actGrpMark = MAGP_AG_Attr.Basic_Attr.actGrpMark2;
            heapIdTpl.heapID     = Heap_List_Entry;
            mathsat2(%addr(MAGP_Heap_Space_Attr)
                     : heapIdTpl
                     : cMATHSAT_ATTR);
            outAllocs = outAllocs + MAGP_Heap_Space_Attr.curNbrOutAlc;
         endfor;

         return outAllocs;

      /END-FREE
      *
     P getOutstandingHeapAllocations...
     P                 E
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0                           inz
     D hMap            S                   like(BasicMap_handle_t  ) inz
     D startAllocs     S             20I 0 inz
     D endAllocs       S             20I 0 inz
     D tmpAllocs       S             20I 0 inz
      *
     D hKeySet1        S                   like(BasicKeySet_handle_t) inz
     D hKeySet2        S                   like(BasicKeySet_handle_t) inz
      *
     D msg             DS                  likeds(msg_t      )  inz
      *
     D refArray        S             20A   varying dim(32)  ascend
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         startAllocs = getOutstandingHeapAllocations();

         hMap = BasicMap_new();

         for x = 1 to 32;
            BasicMap_put(hMap: %char(x): 'Hello World!');
            refArray(x) = %char(x);
         endfor;

         sorta refArray;

         hKeySet1 = BasicMap_newKeySet(hMap);
         hKeySet2 = BasicMap_newKeySet(hMap);

         for x = 1 to 5;
            if (x = 1);
               p_assert(refArray(x) = BasicKeySet_getFirst(hKeySet1)
                        : 'Invalid return value from +
                           BasicKeySet_getFirst()');
            else;
               p_assert(refArray(x) = BasicKeySet_getNext(hKeySet1)
                        : 'Invalid return value from +
                           BasicKeySet_getNext()');
            endif;
         endfor;

         for x = 1 to 20;
            if (x = 1);
               p_assert(refArray(x) = BasicKeySet_getFirst(hKeySet2)
                        : 'Invalid return value from +
                           BasicKeySet_getFirst()');
            else;
               p_assert(refArray(x) = BasicKeySet_getNext(hKeySet2)
                        : 'Invalid return value from +
                           BasicKeySet_getNext()');
            endif;
         endfor;

         for x = 6 to 32;
            p_assert(refArray(x) = BasicKeySet_getNext(hKeySet1)
                     : 'Invalid return value from +
                        BasicKeySet_getNext()');
         endfor;

         for x = 21 to 32;
            p_assert(refArray(x) = BasicKeySet_getNext(hKeySet2)
                     : 'Invalid return value from +
                        BasicKeySet_getNext()');
         endfor;

         BasicKeySet_delete(hKeySet1);

         tmpAllocs = getOutstandingHeapAllocations();

         BasicKeySet_delete(hKeySet2);

         BasicMap_delete(hMap);

         endAllocs = getOutstandingHeapAllocations();

         p_assert(startAllocs = endAllocs
                  : 'Out of expected memory utilization');

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
