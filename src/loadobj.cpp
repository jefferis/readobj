#include <Rcpp.h>
using namespace Rcpp;

#include "tiny_obj_loader.h"

// [[Rcpp::export]]
List loadobj(std::string thefile, std::string basepath="") {

  std::vector<tinyobj::shape_t> shapes;
  std::vector<tinyobj::material_t> materials;
  tinyobj::attrib_t attrib;
  std::string warn, err;
  bool ok = tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err,
                              thefile.c_str(), basepath.c_str());

  if (!ok) {
    std::string warnstr="WARN: ";
    if(err.compare(0, warnstr.length(), warnstr)==0) {
      // it's a warning
      Function warning("warning");
      warning(err);
    } else {
      // it's an error
      stop(err);
    }
  }

#define MNAME(X) Named(#X, m.X)
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
    if((positions.size() % 3) !=0) {
      stop ("Number of vertices is not a multiple of 3 for object", i);
    }
    const size_t nv = positions.size() / 3L;
    const size_t nn = normals.size() / 3L;

    const size_t nfaces=m.material_ids.size();
    // number of vertices per face
    const size_t nv_face=m.indices.size()/nfaces;

    if((m.indices.size() % nv_face) != 0) {
      stop("Number of vertices / mesh face is not constant in object", i);
    }
    List sli;
    sli["positions"]=NumericMatrix(3L, nv, positions.begin());
    sli["normals"]=NumericMatrix(3L, nn, normals.begin());
    sli["texcoords"]=texcoords;
    sli["indices"]=NumericMatrix(nv_face, nfaces, m.indices.begin());
    sli["material_ids"]=m.material_ids;
    sl[shapes[i].name]=sli;
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
    ml[m.name]=List::create(Named("ambient", NumericVector::create(m.ambient[0], m.ambient[1], m.ambient[2])),
                            Named("diffuse", NumericVector::create(m.diffuse[0], m.diffuse[1], m.diffuse[2])),
                            Named("specular", NumericVector::create(m.specular[0], m.specular[1], m.specular[2])),
                            Named("transmittance", NumericVector::create(m.transmittance[0], m.transmittance[1], m.transmittance[2])),
                            Named("emission", NumericVector::create(m.emission[0], m.emission[1], m.emission[2])),
                            MNAME(shininess),
                            MNAME(ior), MNAME(dissolve), MNAME(illum),
                            MNAME(ambient_texname), MNAME(diffuse_texname),
                            MNAME(specular_texname), MNAME(normal_texname));
  }
  List r;
  r["shapes"]=sl;
  r["materials"]=ml;
  return r;
}
