#ifndef PGMREADER_H
#define PGMREADER_H

#include <istream>
#include <functional>
#include <string>
#include <vector>

class PGMReader {
public:
  void read(std::istream&,
            std::function<void(std::vector<std::vector<char>>)>,
            std::function<void(std::string)>);
};

#endif
