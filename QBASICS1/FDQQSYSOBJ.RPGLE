**FREE
/IF NOT DEFINED(qQSYSObj_t)
/DEFINE qQSYSObj_t
// ============================================================= *
//   Qualified QSYS object name                                  *
//===============================================================*

dcl-ds qQSYSObj_t qualified           based(pDummy);
  name            char(10);
  lib             char(10);
  mbr             char(10);
  type            char(10);
end-ds;

/ENDIF
