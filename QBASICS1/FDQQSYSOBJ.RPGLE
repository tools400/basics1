**free
/if NOT DEFINED(qQSYSObj_t)
/define qQSYSObj_t
// ============================================================= *
//   Qualified QSYS object name                                  *
//===============================================================*

dcl-ds qQSYSObj_t qualified based(pDummy);
  name char(10);
  lib  char(10);
  mbr  char(10);
  type char(10);
end-ds;

/endif