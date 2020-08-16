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
     std::vector<index_t> indices;
     std::vector<unsigned char> num_face_vertices;  // The number of vertices per
     // face. 3 = polygon, 4 = quad,
     // ... Up to 255.
     std::vector<int> material_ids;                 // per-face material ID
     std::vector<unsigned int> smoothing_group_ids;  // per-face smoothing group
     // ID(0 = off. positive value
     // = group id)
     std::vector<tag_t> tags;                        // SubD tag
    } mesh_t;*/

    const size_t nv = attrib.vertices.size() / 3L;
    const size_t nn = attrib.normals.size() / 3L;
    const size_t nt = attrib.texcoords.size() / 2L;

    const size_t nfaces=m.num_face_vertices.size();
    // number of vertices per face
    const size_t nv_face=m.indices.size()/nfaces;

    IntegerMatrix indices(nv_face, nfaces);
    IntegerMatrix texindices(nv_face, nfaces);

    size_t index_offset = 0;
    for (size_t f = 0; f < m.num_face_vertices.size(); f++) {
      const int fv = m.num_face_vertices[f];
      if(fv!=3L) {
        stop("I only accept objects with triangular faces!");
      }
      for (size_t v = 0; v < fv; v++) {
        // access to vertex
        tinyobj::index_t idx = m.indices[index_offset + v];
        indices(v, f) = idx.vertex_index;
        texindices(v, f) = idx.texcoord_index;
      }
      index_offset += fv;
    }

    List sli;
    sli["positions"]=NumericMatrix(3L, nv, attrib.vertices.begin());
    sli["normals"]=NumericMatrix(3L, nn, attrib.normals.begin());
    sli["texcoords"]=NumericMatrix(2L, nt, attrib.texcoords.begin());
    sli["indices"]=indices;
    sli["texindices"]=texindices;
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
