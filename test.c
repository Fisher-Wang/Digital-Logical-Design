int x0, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14;
int a, b, c;
const int ADD = 0, SUB = 1;
void func()
{
    x5 = 0;
    x6 = 0;

    /* first num and op */
    do {
        x8 = a;
        x7 = b;
        c = x7;
    } while (x8 == 0);
    do {
        x11 = a;
    } while (x11 == x8);

    x5 = x7;
    x6 = x8;


    for (;;) {
        /* another num and op */
        do {
            x8 = a;
            x7 = b;
        } while (x8 == 0);
        do {
            x11 = a;
        } while (x11 == x8);
        /* calculate */
        if (x6 == ADD)
            x5 = x5 + x7;
        else if (x6 == SUB)
            x5 = x5 - x7;
        /* ready for next loop */
        x6 = x8;
    }
}