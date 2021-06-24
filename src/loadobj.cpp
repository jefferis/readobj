#include <Rcpp.h>
using namespace Rcpp;

#include "tiny_obj_loader.h"

// [[Rcpp::export]]
List loadobj(std::string thefile, std::string basepath="", bool triangulate=true) {

  std::vector<tinyobj::shape_t> shapes;
  std::vector<tinyobj::material_t> materials;
  tinyobj::attrib_t attrib;
  std::string warn, err;
  bool ok = tinyobj::LoadObj(&attrib, &shapes, &materials, &warn, &err,
                              thefile.c_str(), basepath.c_str(), triangulate);

  if (!ok) {
    stop(err);
  } else {
    // check for any warnings
    if(warn.length()>0) {
      Function warning("warning");
      warning(warn);
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

    const size_t maxfaces=*std::max_element(m.num_face_vertices.begin(), m.num_face_vertices.end());
    const size_t minfaces=*std::min_element(m.num_face_vertices.begin(), m.num_face_vertices.end());
    const bool mixedfaces = maxfaces!=minfaces;
    const bool havetex = attrib.texcoords.size()>0;
    const bool havenorm = nn > 0;

    if(maxfaces>4 || minfaces<3) {
      stop("I only accept objects with triangular or quad faces!");
    }

    IntegerMatrix indices(maxfaces, nfaces);
    IntegerMatrix texindices(maxfaces, havetex?nfaces:0L);
    IntegerMatrix normindices(maxfaces, havenorm?nfaces:0L);

    size_t index_offset = 0;
    for (size_t f = 0; f < m.num_face_vertices.size(); f++) {
      const int fv = m.num_face_vertices[f];
      for (size_t v = 0; v < fv; v++) {
        // access to vertex
        tinyobj::index_t idx = m.indices[index_offset + v];
        indices(v, f) = idx.vertex_index;
        if(havetex) {
          texindices(v, f) = idx.texcoord_index;
        }
        if(havenorm) {
          normindices(v, f) = idx.normal_index;
        }
      }
      index_offset += fv;
    }

    List sli;
    sli["positions"]=NumericMatrix(3L, nv, attrib.vertices.begin());
    sli["indices"]=indices;
    if(havenorm) {
      sli["normals"]=NumericMatrix(3L, nn, attrib.normals.begin());
      sli["normindices"]=normindices;
    }
    if(havetex) {
      sli["texcoords"]=NumericMatrix(2L, nt, attrib.texcoords.begin());
      sli["texindices"]=texindices;
    }
    if(mixedfaces) {
      sli["nvfaces"]=m.num_face_vertices;
    }
    if(materials.size()>0) {
      sli["material_ids"]=m.material_ids;
    }
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
