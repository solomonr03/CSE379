

/**
 * main.c
 */
extern int evaluate (int a, int b);

int main(void)
{
    int x=9;
    int y=5;
    int result;

    result = evaluate(x,y);
    result = result + 10;
	return 0;
}
