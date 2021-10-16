#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>
#include <limits.h>

static int write_stdout(const char *token, int length)
{
    int rc;
    int bytes_written = 0;

    do {
        rc = write(1, token + bytes_written, length - bytes_written);
        if (rc < 0)
            return rc;

        bytes_written += rc;
    } while (bytes_written < length);

    return bytes_written;
}

static void reverseString(char *s, int len) {
    int i, j;
    char aux;

    for (i = 0, j = len - 1; i < j; ++i, --j) {
        aux = *(s + i);
        *(s + i) = *(s + j);
        *(s + j) = aux;
    }
}

/**
 * n - the number to be converted
 * s - the string in which to convert
 * b - base to be used (10 / 16 here)
 */
static void myItoa(int n, char *s, int b) {
    int l = 0, r;
    /* Check the negativity / INT_MIN */
    int neg = 0;

    if (n == 0) {
        s[l++] = '0';
        s[l] = '\0';
        return;
    }

    /* Special case for INT_MIN */
    if (n == INT_MIN) {
        neg = 2;
        /* Convert -(n + 1) to string */
        n++;
        n = -n;
    } else if (n < 0) {
        neg = 1;
        n = -n;
    }

    while (n) {
        r = n % b;
        /* Convert the remainder depending on the base */
        s[l++] = (r > 9) ? ((r - 10) + 'a') : (r + '0');
        n /= b;
    }

    if (neg == 1) {
        s[l++] = '-';
    } else if (neg == 2) {
        s[l++] = '-';
        s[0]++;
    }

    s[l] = '\0';

    /* Reverse the characters */
    reverseString(s, l);
}

static void myItoaUsigned(unsigned int n, char *s, int b) {
    int l = 0, r;

    if (n == 0) {
        s[l++] = '0';
        s[l] = '\0';
        return;
    }

    while (n) {
        r = n % b;
        /* Convert the remainder depending on the base */
        s[l++] = (r > 9) ? ((r - 10) + 'a') : (r + '0');
        n /= b;
    }

    s[l] = '\0';

    /* Reverse the characters */
    reverseString(s, l);
}

int iocla_printf(const char *format, ...)
{
    va_list args;
    int v_int;
    char v_char;
    char *v_string;
    unsigned int v_uint;

    /* Convert each data we parse in *conv */
    char *conv;
    int lconv;

    int len = strlen(format);
    int i = 0;

    /* The number of characters that are printed */
    int res = 0;

    conv = (char *)calloc(len, sizeof(char));
    lconv = 0;

    va_start(args, format);

    while (i < len) {
        if (format[i] != '%') {
            conv[lconv++] = format[i];
        } else {
            if (lconv != 0) {
                res += lconv;

                write_stdout(conv, lconv);
                lconv = 0;
            }
            /**
             * format[i] == '%' 
             *     --> check the next character 
             */
            i++;
            /* "%%" --> "%" */
            if (format[i] == '%') {
                res++;

                write_stdout("%", 1);
            } else {
                /* Check data type to be parsed */
                if (format[i] == 'c') {
                    res++;

                    v_char = va_arg(args, int);
                    conv[lconv++] = v_char;
                    write_stdout(conv, lconv);
                    lconv = 0;
                } else if (format[i] == 's') {
                    int ls;

                    v_string = va_arg(args, char*);
                    ls = strlen(v_string);
                    write_stdout(v_string, ls);

                    res += ls;
                } else if (format[i] == 'd') {
                    v_int = (int)va_arg(args, int);
                    myItoa(v_int, conv, 10);
                    lconv = strlen(conv);
                    
                    res += lconv;

                    write_stdout(conv, lconv);
                    lconv = 0;
                } else if (format[i] == 'x') {
                    /**
                     * Number has to be printed in hex
                     *        --> parse it as u_int
                     */
                    v_uint = va_arg(args, unsigned int);
                    myItoaUsigned(v_uint, conv, 16);
                    lconv = strlen(conv);

                    res += lconv;

                    write_stdout(conv, lconv);
                    lconv = 0;
                } else if (format[i] == 'u') {
                    v_uint = va_arg(args, unsigned int);
                    myItoaUsigned(v_uint, conv, 10);
                    lconv = strlen(conv);

                    res += lconv;

                    write_stdout(conv, lconv);
                    lconv = 0;
                }
            }
        }
        i++;
    }

    /* Check if there is any more data left in *format to be printed */
    if (lconv != 0) {
        res += lconv;
        write_stdout(conv, lconv);
    }

    /* Free(s) */
    free(conv);
    va_end(args);

    return res;
}
