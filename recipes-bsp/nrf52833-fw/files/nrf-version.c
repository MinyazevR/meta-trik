/*
 * nrf-version - read the nRF52833 coprocessor firmware version.
 *
 * The nrf-usb driver exposes the standard device file /dev/nrf0. We send a
 * message to the controller endpoint through it (NRF_IO_CTRL ioctl) to query
 * the running application version, then print the returned string.
 *
 * TODO: perhaps replace this helper with the standard i2cget utility once the
 *       I2C path can be tested properly.
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <linux/nrf-usb.h>

#define DEVICE_PATH "/dev/nrf0"

int main(int argc, char **argv)
{
	uint8_t req = 0x01;

	if (argc >= 2)
		req = (uint8_t)strtoul(argv[1], NULL, 0);

	int fd = open(DEVICE_PATH, O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "nrf-version: open %s: %s\n",
			DEVICE_PATH, strerror(errno));
		return 1;
	}

	struct nrf_ctrl ctrl = {
		.bmRequestType = 0xC1,
		.bRequest = req,
		.wValue = 0,
		.wIndex = 0,
		.wLength = sizeof(ctrl.data),
		.timeout = 5000,
	};

	if (ioctl(fd, NRF_IO_CTRL, &ctrl) < 0) {
		perror("NRF_IO_CTRL");
		close(fd);
		return 1;
	}

	size_t len = strnlen((const char *)ctrl.data, ctrl.wLength);
	fwrite(ctrl.data, 1, len, stdout);
	fputc('\n', stdout);
	close(fd);
	return 0;
}