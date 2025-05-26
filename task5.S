.include "my-macro"

.data
    Smatrix: .long 11, 12, 13, 14, 15, 16
             .long 21, 22, 23, 24, 25, 26
             .long 31, 32, 33, 34, 35, 36
             .long 41, 42, 43, 44, 45, 46
             .long 51, 52, 53, 54, 55, 42
             .long 61, 62, 63, 64, 65, 66
    vector: .long 0, 0, 0, 0, 0, 0
    k: .long 0 # хранит адрес в памяти k
    l: .long 0 # хранит адрес в памяти l
    c: .byte 0 # хранит символ с stdin
    length: .long 0 # хранит длинну числа для вывода
    output_line: .ascii "           " # хранит строку вывода
    ten: .long 10 # десять

.text

.global _start
_start:
    Puts_auto "Введите k (строка от 0 до 5): "

    Getchar $c
    movb c, %al
    mov %eax, %eax

    cmpl $0, %eax
    je stop
    cmpb $'5', c        # код больше кода символа '5' ?
    ja print_err_msg    # ДА - на вывод сообщения об ошибке
    cmpb $'0', c        # код меньше кода символа '0' ?
    jb print_err_msg    # ДА - на вывод сообщения об ошибке

    # обрабатывает k (умножает индекс строки на 6*4 байт и прибавляет адрес матрицы)
    movl $24, %ecx
    subl $48, %eax
    mul %ecx
    addl $Smatrix, %eax
    movl %eax, k

    Getchar $c # пропуск '\n'

    Puts_auto "Введите l (столбец от 0 до 5): "

    Getchar $c
    movb c, %al
    mov %eax, %eax

    cmpl $0, %eax
    je stop
    cmpb $'5', c        # код больше кода символа '5' ?
    ja print_err_msg    # ДА - на вывод сообщения об ошибке
    cmpb $'0', c        # код меньше кода символа '0' ?
    jb print_err_msg    # ДА - на вывод сообщения об ошибке

    movl $4, %ecx
    subl $48, %eax
    mul %ecx
    addl $Smatrix, %eax
    movl %eax, l

    subl %ecx, %ecx

    loop1:
        movl k, %eax
        movl (%eax), %edx
        movl l, %eax
        addl (%eax), %edx

        movl %edx, vector(, %ecx, 4)

        addl $4, k
        addl $24, l

        incl %ecx

        cmpl $7, %ecx
        jne loop1


    loop2:
        movl $0, %ecx
        movl vector(, %esi, 4), %eax
        count_length_loop:
            movl $0, %edx
            idivl ten
            incl %ecx
            cmpw $0, %ax
            ja count_length_loop


        movb $32, output_line(%ecx)
        incl %ecx
        movl %ecx, length
        subl $2, %ecx

        movl vector(, %esi, 4), %eax
        output_sum_loop:
            movl $0, %edx
            idivl ten
            addl $48, %edx
            movb %dl, output_line(%ecx)
            decl %ecx
            cmpw $0, %ax
            ja output_sum_loop

        incl %esi

        Puts $output_line, length

        cmpl $6, %esi
        jne loop2

        Puts_auto "\n"
      
