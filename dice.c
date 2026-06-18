#define BTN_REG (*(volatile int*)0x40000000)
#define SEG_REG (*(volatile int*)0x40000004)

void main()
{
    int dice = 1;

    while (1)
    {
        dice++;
        if (dice > 6)
            dice = 1;

        if (BTN_REG)
            SEG_REG = dice;
    }
}