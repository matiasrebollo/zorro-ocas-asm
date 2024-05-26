%macro mPuts 0
    sub     rsp, 8
    call    puts 
    add     rsp, 8
%endmacro

%macro get_input 0
    sub     rsp, 8
    call    gets 
    add     rsp, 8
%endmacro

extern puts
extern gets