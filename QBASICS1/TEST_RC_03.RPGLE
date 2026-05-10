**free
//===============================================================*
//    CALL PGM(TEST_RC_03)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              BNDDIR(QC2LE) +                  *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RC_03');
end-pr;

dcl-pr main;
end-pr;

dcl-pr getOutstandingHeapAllocations int(20);
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Returns the number of outstanding heap allocations.
//===============================================================*
dcl-proc getOutstandingHeapAllocations;
  dcl-pi *n int(20);
  end-pi;

  //  Return value
  dcl-s outAllocs int(20) inz;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s tplSize int(10) inz;
  dcl-ds MAGP_AG_Attr likeds(MAGP_Template_t) inz;
  dcl-ds heapIdTpl likeds(heapIdTpl_t) inz;
  dcl-ds MAGP_AG_Heap_List likeds(MAGP_Template_t) based(pMAGP_AG_Heap_List);
  dcl-s Heap_List_Buffer char(1024) inz(*ALLx'00');
  dcl-ds MAGP_Heap_Space_Attr likeds(MAGP_Heap_Space_Attr_t) inz;
  dcl-s Heap_List_Entry like(MAGP_Template_t.Heap_List_1) based(pHeap_List_Entry);

  //  Reference fields
  dcl-ds MAGP_Template_t qualified based(pDummy);
    bytPrv      int(10) pos(1);
    bytAvl      int(10) pos(5);
    reserved_1  char(8) pos(9);
    //  union:
    Basic_Attr  likeds(MAGP_AG_Attr_t);
    Heap_List_1 int(10) overlay(Basic_Attr);
    Act_List_1  uns(20) overlay(Basic_Attr);
  end-ds;

  dcl-s MAGP_actGrpMark_t uns(20) based(pDummy);

  dcl-ds MAGP_AG_Attr_t qualified based(pDummy);
    rootProgram   pointer;
    reserved_1    char(16);
    stgAdrRclKey  pointer;
    actGrpName    char(30);
    reserved_2    char(2);
    actGrpMark    uns(10);
    reserved_3    char(4);
    heapSpcCnt    uns(10);
    actCnt        uns(10);
    staticStgSize uns(10);
    autoStgSize   uns(10);
    attrs         char(1);
    pagMbrShpAdvA char(1);
    reserved_7    char(6);
    actGrpMark2   uns(20);
  end-ds;

  dcl-c cMATAGPAT_ATTR_BASIC_ACTGRP_ATTR x'00';
  dcl-c cMATAGPAT_ATTR_BASIC_ACTGRP_HEAP_LIST x'01';

  //  Materialize Activation Group Attributes (MATAGPAT)
  dcl-pr matagpat2 extproc('_MATAGPAT2');
    o_rcvVar     pointer value;
    i_actGrpMark like(MAGP_actGrpMark_t) const;
    i_attrSlc    uns(3) const;
  end-pr;

  dcl-ds heapIdTpl_t qualified align based(pDummy);
    actGrpMark like(MAGP_actGrpMark_t);
    reserved_1 char(4);
    heapID     uns(10);
  end-ds;

  dcl-ds MAGP_Heap_Space_Attr_t qualified align based(pDummy);
    bytPrv        int(10) pos(1);
    bytAvl        int(10) pos(5);
    maxSnglAlc    uns(10) pos(9);
    minBndryReq   uns(10) pos(13);
    crtSize       uns(10) pos(17);
    extSize       uns(10) pos(21);
    domain        int(5) pos(25);
    heapCrtOpts   char(6) pos(27);
    reserved_1    char(64) pos(33);
    curNbrOutAlc  uns(10) pos(97);
    totNbrRealloc uns(10) pos(101);
    totNbrFrees   uns(10) pos(105);
    totNbrAllocs  uns(10) pos(109);
    maxNbrOutAlc  uns(10) pos(113);
    sizeHeapSpace uns(10) pos(117);
    nbrOutMarks   uns(10) pos(121);
    totNbrExt     uns(10) pos(125);
  end-ds;

  dcl-c cMATHSAT_ATTR x'00';

  //  Materialize Activation Group-Based Heap Space Attributes (MATHSAT)
  dcl-pr mathsat2 extproc('_MATHSAT2');
    o_rcvVar    pointer value;
    i_heapIdTpl likeds(heapIdTpl_t) const;
    i_attrSlc   uns(3) const;
  end-pr;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s hMap like(BasicMap_handle_t) inz;
  dcl-s startAllocs int(20) inz;
  dcl-s endAllocs int(20) inz;
  dcl-s tmpAllocs int(20) inz;

  dcl-s hKeySet1 like(BasicKeySet_handle_t) inz;
  dcl-s hKeySet2 like(BasicKeySet_handle_t) inz;

  dcl-ds msg likeds(msg_t) inz;

  dcl-s refArray varchar(20) dim(32) ascend;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc main;
