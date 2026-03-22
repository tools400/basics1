**FREE
/IF NOT DEFINED(BASICS1RH)
/DEFINE BASICS1RH

/COPY QBASICS1,CLIB                          C Runtime Library

dcl-s memWtr_handle_t
      int(10) based(pDummy);
dcl-s memRdr_handle_t
      int(10) based(pDummy);

//  Creates a memory buffer writer.
dcl-pr MemoryWriter_new
       like(memWtr_handle_t)
       extproc('BASICS1RH+
       _MemoryWriter_new+
       ');
  i_pBuffer       pointer value;
  i_maxSize       value  like(size_t         );
end-pr;

//  Write to a given memory buffer descriptor.
dcl-pr MemoryWriter_write
       like(ssize_t       )                                              // = ssize_t
       extproc('BASICS1RH+
       _MemoryWriter_write+
       ');
  i_fd            value  like(memWtr_handle_t);                          // = int
  i_pBuffer       pointer value;                                         // = *buf
  i_buflen        value  like(size_t         );                          // = size_t
end-pr;

//  Deletes a given memory buffer writer.
dcl-pr MemoryWriter_delete
       extproc('BASICS1RH+
       _MemoryWriter_delete+
       ');
  io_fd           like(memWtr_handle_t);
end-pr;

//  Returns the 'write' procedure of a MemoryWriter.
dcl-pr MemoryWriter_writeProc
       pointer(*proc)
       extproc('BASICS1RH+
       _MemoryWriter_writeProc+
       ');
end-pr;

//  Creates a memory buffer reader.
dcl-pr MemoryReader_new
       like(memRdr_handle_t)
       extproc('BASICS1RH+
       _MemoryReader_new+
       ');
  i_pBuffer       pointer value;
  i_size          value  like(size_t         );
end-pr;

//  Reads from a given memory buffer descriptor.
dcl-pr MemoryReader_read
       like(ssize_t        )                                             // = ssize_t
       extproc('BASICS1RH+
       _MemoryReader_read+
       ');
  i_fd            value  like(memRdr_handle_t);                          // = int
  i_pBuffer       pointer value;                                         // = *buf
  i_nByte         value  like(size_t    );                               // = size_t
end-pr;

//  Deletes a given memory buffer Reader.
dcl-pr MemoryReader_delete
       extproc('BASICS1RH+
       _MemoryReader_delete+
       ');
  io_fd           like(memRdr_handle_t);
end-pr;

//  Returns the 'read' procedure of a MemoryReader.
dcl-pr MemoryReader_readProc
       pointer(*proc)
       extproc('BASICS1RH+
       _MemoryReader_readProc+
       ');
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/ENDIF
