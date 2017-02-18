#ifndef PGMREADER_H
#define PGMREADER_H

#include <istream>

class PGMReader {
public:
  void read(std::istream s,
            std::function<void(std::vector<std::vector<char>>)>,
            std::function<void(std::string)>);
}

#endif
