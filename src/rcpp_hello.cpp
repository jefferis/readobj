#include <Rcpp.h>
using namespace Rcpp;

#include "tiny_obj_loader.h"

// This is a simple function using Rcpp that creates an R list
// containing a character vector and a numeric vector.
//
// Learn more about how to use Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//
// and browse examples of code using Rcpp at:
//
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
List loadob(std::vector< std::string > objfile) {
  int num_strings = objfile.size();
  if(num_strings!=1) {
    stop("I can only read exactly one file!");
  }
  std::string thefile=objfile[0];

  CharacterVector x = CharacterVector::create("foo", "bar");
  NumericVector y   = NumericVector::create(0.0, 1.0);
  List z            = List::create(x, y);
  return z;
}
