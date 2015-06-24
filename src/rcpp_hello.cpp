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
List loadobj(std::vector< std::string > objfile) {
  int num_strings = objfile.size();
  if(num_strings!=1) {
    stop("I can only read exactly one file!");
  }
  std::string thefile=objfile[0];

  std::vector<tinyobj::shape_t> shapes;
  std::vector<tinyobj::material_t> materials;
  std::string err = tinyobj::LoadObj(shapes, materials, thefile.c_str(), NULL);

  if (!err.empty()) {
    stop(err);
  }

  CharacterVector shapenames(shapes.size());
  List z;
  for(unsigned int i=0; i<shapes.size(); i++) {
    shapenames[i]=shapes[i].name;
    tinyobj::mesh_t m=shapes[i].mesh;
    /* typedef struct {
      std::vector<float> positions;
      std::vector<float> normals;
      std::vector<float> texcoords;
      std::vector<unsigned int> indices;
      std::vector<int> material_ids; // per-mesh material ID
    } mesh_t; */
    z[shapes[i].name]=List::create(m.positions, m.normals, m.texcoords, m.indices, m.material_ids);
  }
  return z;
}
