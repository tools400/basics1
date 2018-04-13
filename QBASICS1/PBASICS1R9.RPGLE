      /IF NOT DEFINED(BASICS1R9)
      /DEFINE BASICS1R9
      *
      *  Reference Fields
     D display_mode_t  S              4A   based(pDummy)
      *
      *  Constants
     D cDISPLAY_MODE_DS3...
     D                 C                   const('*DS3')
     D cDISPLAY_MODE_DS4...
     D                 C                   const('*DS4')
      *
      *  Returns the current display mode.
     D Display_getMode...
     D                 PR                         like(display_mode_t)
     D                                     extproc('BASICS1R9+
     D                                     _Display_getMode+
     D                                     ')
      *
      *  Returns cTrue if the display device support 27x132 mode.
     D Display_supportsDS4...
     D                 PR              N
     D                                     extproc('BASICS1R9+
     D                                     _Display_supportsDS4+
     D                                     ')
      *
      *  Returns cTrue if the display device supports GUI characters.
     D Display_supportsGUI...
     D                 PR              N
     D                                     extproc('BASICS1R9+
     D                                     _Display_supportsGUI+
     D                                     ')
      *
      *  Returns the number of rows that can be displayed on the screen.
     D Display_getRows...
     D                 PR             5I 0
     D                                     extproc('BASICS1R9+
     D                                     _Display_getRows+
     D                                     ')
     D  i_dspMode                          const  like(display_mode_t)
     D                                            options(*nopass)
      *
      *  Returns the number of columns that can be displayed on the screen.
     D Display_getColumns...
     D                 PR             5I 0
     D                                     extproc('BASICS1R9+
     D                                     _Display_getColumns+
     D                                     ')
     D  i_dspMode                          const  like(display_mode_t)
     D                                            options(*nopass)
      *
      * -----------------------------------------
      *  Deprecated procedure names
      * -----------------------------------------
      *
      *  Ermittelt den aktuellen Bildschirmmodus: *DS3 oder *DS4
     D f_getDisplayMode...
     D                 PR                         like(display_mode_t)
     D                                     extproc('BASICS1R9+
     D                                     _Display_getMode+
     D                                     ')
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      *
      /ENDIF
