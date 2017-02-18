#include <iostream>
#include <string>
#include <vector>

#include "PGMReader.hpp"

void read() {
  std::cout << "give me a pgm!\n";
  PGMReader reader;
  reader.read(
      std::cin,
      [](std::vector<std::vector<char>> image) { std::cout << "complete!\n"; },
      [](std::string error) { std::cout << error << "\n"; });
}

int main() {
  read();
  return 0;
}
