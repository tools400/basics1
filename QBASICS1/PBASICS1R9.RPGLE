**FREE
/IF NOT DEFINED(BASICS1R9)
/DEFINE BASICS1R9

//  Reference Fields
dcl-s display_mode_t  char(4) based(pDummy);

//  Constants
dcl-c cDISPLAY_MODE_DS3
      const('*DS3');
dcl-c cDISPLAY_MODE_DS4
      const('*DS4');

//  Returns the current display mode.
dcl-pr Display_getMode
       like(display_mode_t)
       extproc('BASICS1R9+
       _Display_getMode+
       ');
end-pr;

//  Returns cTrue if the display device support 27x132 mode.
dcl-pr Display_supportsDS4
       ind
       extproc('BASICS1R9+
       _Display_supportsDS4+
       ');
end-pr;

//  Returns cTrue if the display device supports GUI characters.
dcl-pr Display_supportsGUI
       ind
       extproc('BASICS1R9+
       _Display_supportsGUI+
       ');
end-pr;

//  Returns the number of rows that can be displayed on the screen.
dcl-pr Display_getRows
       int(5)
       extproc('BASICS1R9+
       _Display_getRows+
       ');
  i_dspMode       const  like(display_mode_t)
       options(*nopass);
end-pr;

//  Returns the number of columns that can be displayed on the screen.
dcl-pr Display_getColumns
       int(5)
       extproc('BASICS1R9+
       _Display_getColumns+
       ');
  i_dspMode       const  like(display_mode_t)
       options(*nopass);
end-pr;

// -----------------------------------------
//  Deprecated procedure names
// -----------------------------------------

//  Ermittelt den aktuellen Bildschirmmodus: *DS3 oder *DS4
dcl-pr f_getDisplayMode
       like(display_mode_t)
       extproc('BASICS1R9+
       _Display_getMode+
       ');
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R2                   API Error Handling

/ENDIF
