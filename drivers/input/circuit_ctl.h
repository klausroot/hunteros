#ifndef _CIRCUIT_CTL_H_
#define _CIRCUIT_CTL_H_

#define PORT_KEYDAT				0x0060
#define PORT_KEYSTA				0x0064
#define PORT_KEYCMD				0x0064

void wait_KBC_sendready(void);
#endif
