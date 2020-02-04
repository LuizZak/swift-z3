// Automatically generated file
#ifndef __NLA_PARAMS_HPP_
#define __NLA_PARAMS_HPP_
#include "util/params.h"
#include "util/gparams.h"
struct nla_params {
  params_ref const & p;
  params_ref g;
  nla_params(params_ref const & _p = params_ref::get_empty()):
     p(_p), g(gparams::get_module("nla")) {}
  static void collect_param_descrs(param_descrs & d) {
    d.insert("order", CPK_BOOL, "run order lemmas", "true","nla");
    d.insert("tangents", CPK_BOOL, "run tangent lemmas", "true","nla");
    d.insert("horner", CPK_BOOL, "run horner's heuristic", "true","nla");
    d.insert("horner_subs_fixed", CPK_UINT, "0 - no subs, 1 - substitute, 2 - substitute fixed zeros only", "2","nla");
    d.insert("horner_frequency", CPK_UINT, "horner's call frequency", "4","nla");
    d.insert("horner_row_length_limit", CPK_UINT, "row is disregarded by the heuristic if its length is longer than the value", "10","nla");
    d.insert("grobner", CPK_BOOL, "run grobner's basis heuristic", "true","nla");
    d.insert("grobner_eqs_growth", CPK_UINT, "grobner's number of equalities growth ", "10","nla");
    d.insert("grobner_expr_size_growth", CPK_UINT, "grobner's maximum expr size growth", "2","nla");
    d.insert("grobner_expr_degree_growth", CPK_UINT, "grobner's maximum expr degree growth", "2","nla");
    d.insert("grobner_max_simplified", CPK_UINT, "grobner's maximum number of simplifications", "10000","nla");
    d.insert("grobner_cnfl_to_report", CPK_UINT, "grobner's maximum number of conflicts to report", "1","nla");
    d.insert("gr_q", CPK_UINT, "grobner's quota", "10","nla");
    d.insert("grobner_subs_fixed", CPK_UINT, "0 - no subs, 1 - substitute, 2 - substitute fixed zeros only", "2","nla");
  }
  /*
     REG_MODULE_PARAMS('nla', 'nla_params::collect_param_descrs')
  */
  bool order() const { return p.get_bool("order", g, true); }
  bool tangents() const { return p.get_bool("tangents", g, true); }
  bool horner() const { return p.get_bool("horner", g, true); }
  unsigned horner_subs_fixed() const { return p.get_uint("horner_subs_fixed", g, 2u); }
  unsigned horner_frequency() const { return p.get_uint("horner_frequency", g, 4u); }
  unsigned horner_row_length_limit() const { return p.get_uint("horner_row_length_limit", g, 10u); }
  bool grobner() const { return p.get_bool("grobner", g, true); }
  unsigned grobner_eqs_growth() const { return p.get_uint("grobner_eqs_growth", g, 10u); }
  unsigned grobner_expr_size_growth() const { return p.get_uint("grobner_expr_size_growth", g, 2u); }
  unsigned grobner_expr_degree_growth() const { return p.get_uint("grobner_expr_degree_growth", g, 2u); }
  unsigned grobner_max_simplified() const { return p.get_uint("grobner_max_simplified", g, 10000u); }
  unsigned grobner_cnfl_to_report() const { return p.get_uint("grobner_cnfl_to_report", g, 1u); }
  unsigned gr_q() const { return p.get_uint("gr_q", g, 10u); }
  unsigned grobner_subs_fixed() const { return p.get_uint("grobner_subs_fixed", g, 2u); }
};
#endif
