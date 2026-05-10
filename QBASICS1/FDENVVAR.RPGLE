**free
/if NOT DEFINED(envVar_t  )
/define envVar_t
// ============================================================= *
//   Environment variable.                                       *
// ============================================================= *

dcl-ds envVar_t qualified based(pDummy);
  name  varchar(128);
  value varchar(1024);
end-ds;

/endif