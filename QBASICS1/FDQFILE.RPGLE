**free
/if NOT DEFINED(qFile_t   )
/define qFile_t
// ============================================================= *
//   Qualified file name                                         *
//===============================================================*

dcl-ds qFile_t qualified based(pDummy);
  name char(10);
  lib  char(10);
  mbr  char(10);
end-ds;

/endif