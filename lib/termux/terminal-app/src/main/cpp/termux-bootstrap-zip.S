     .global blob
     .global blob_size
     .section .rodata
 blob:
 #if defined __aarch64__
     .incbin "resources/bootstrap/bootstrap-aarch64.zip"
 #elif defined __arm__
     .incbin "resources/bootstrap/bootstrap-arm.zip"
 #else
 # error Unsupported arch
 #endif
 1:
 blob_size:
     .int 1b - blob
