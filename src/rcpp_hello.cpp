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

  List sl, ml;
  for(unsigned int i=0; i<shapes.size(); i++) {
    tinyobj::mesh_t m=shapes[i].mesh;
    /* typedef struct {
      std::vector<float> positions;
      std::vector<float> normals;
      std::vector<float> texcoords;
      std::vector<unsigned int> indices;
      std::vector<int> material_ids; // per-mesh material ID
    } mesh_t; */
    sl[shapes[i].name]=List::create(m.positions, m.normals, m.texcoords,
                                   m.indices, m.material_ids);
  }
  for(unsigned int i=0; i<materials.size(); i++) {
    tinyobj::material_t m=materials[i];
    /* typedef struct {
        std::string name;

        float ambient[3];
        float diffuse[3];
        float specular[3];
        float transmittance[3];
        float emission[3];
        float shininess;
        float ior;      // index of refraction
        float dissolve; // 1 == opaque; 0 == fully transparent
        // illumination model (see http://www.fileformat.info/format/material/)
        int illum;

        std::string ambient_texname;
        std::string diffuse_texname;
        std::string specular_texname;
        std::string normal_texname;
        std::map<std::string, std::string> unknown_parameter;
      } material_t; */
    ml[m.name]=List::create(NumericVector::create(m.ambient[0], m.ambient[1], m.ambient[2]),
                            NumericVector::create(m.diffuse[0], m.diffuse[1], m.diffuse[2]),
                            NumericVector::create(m.specular[0], m.specular[1], m.specular[2]),
                            NumericVector::create(m.transmittance[0], m.transmittance[1], m.transmittance[2]),
                            NumericVector::create(m.emission[0], m.emission[1], m.emission[2]),
                            m.shininess, m.ior, m.dissolve, m.illum,
                            m.ambient_texname, m.diffuse_texname,
                            m.specular_texname, m.normal_texname);
  }
  List r;
  r["shapes"]=sl;
  r["materials"]=ml;
  return r;
}
