#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <kernel/tty.h>

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_initialize() {
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = make_color(COLOR_LIGHT_GREY, COLOR_BLACK);
  terminal_buffer = VGA_MEMORY;

  // TODO - extract this
  uint8_t terminal_default_color = make_vgaentry(' ', terminal_color);

  for (size_t y = 0; y < VGA_HEIGHT; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t index = y * VGA_WIDTH + x;
      terminal_buffer[index] = terminal_default_color;
    }
  }
}

void terminal_setcolor(uint8_t color) {
  terminal_color = color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
  const size_t index = y * VGA_WIDTH + x;
  terminal_buffer[index] = make_vgaentry(c, color);
}

static void terminal_scroll_up() {
  // TODO - extract this
  uint8_t terminal_default_color = make_vgaentry(' ', terminal_color);

  for (size_t y = 0; y < VGA_HEIGHT - 1; y++) {
    for (size_t x = 0; x < VGA_WIDTH; x++) {
      const size_t index = y * VGA_WIDTH + x;
      terminal_buffer[index] = terminal_buffer[index + VGA_WIDTH];
    }
  }

  for (size_t x = 0; x < VGA_WIDTH; ++x) {
    const size_t index = (VGA_HEIGHT - 1) * VGA_WIDTH + x;
    terminal_buffer[index] = make_vgaentry(' ', terminal_default_color);
  }
}

void terminal_putchar(char c) {
  if (c == '\n') {
    terminal_column = 0;

    if (terminal_row == VGA_HEIGHT - 1) {
      terminal_scroll_up();
    } else {
      ++terminal_row;
    }

    return;
  }

  terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

  if (++terminal_column == VGA_WIDTH) {
    terminal_column = 0;

  }
}

void terminal_write(const char* data, size_t size) {
  for (size_t i = 0; i < size; ++i)
    terminal_putchar(data[i]);
}

void terminal_writestring(const char* data) {
  terminal_write(data, strlen(data));
}
