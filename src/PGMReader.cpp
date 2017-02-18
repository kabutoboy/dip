#include <functional>
#include <istream>
#include <string>
#include <vector>

#include "PGMReader.hpp"

void PGMReader::read(
    std::istream &s,
    std::function<void(std::vector<std::vector<char>>)> onComplete,
    std::function<void(std::string)> onError) {
  std::string header;
  s >> header;
  if (header != "P5") {
    onError("wrong header; given " + header);
    return;
  }

  unsigned width;
  unsigned height;
  s >> width;
  s >> height;

  std::vector<std::vector<char>> image(height, std::vector<char>(width, 0));
  for (unsigned i = 0; i < height; i++) {
    for (unsigned j = 0; j < width; j++) {
      s >> image.at(i).at(j);
    }
  }

  onComplete(image);
}
